Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECEE43A650
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhJYWHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:07:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:43472 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhJYWHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:07:21 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mf85N-0009q2-Q7; Tue, 26 Oct 2021 00:04:53 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mf85N-0003xz-Kj; Tue, 26 Oct 2021 00:04:53 +0200
Subject: Re: [PATCH bpf v2] bpf: fix potential race in tail call compatibility
 check
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211025130809.314707-1-toke@redhat.com>
 <YXa/A4eQhlPPsn+n@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c1244c73-bc61-89b8-dca3-f06dca85f64e@iogearbox.net>
Date:   Tue, 26 Oct 2021 00:04:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YXa/A4eQhlPPsn+n@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26333/Mon Oct 25 10:29:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 4:28 PM, Lorenzo Bianconi wrote:
>> Lorenzo noticed that the code testing for program type compatibility of
>> tail call maps is potentially racy in that two threads could encounter a
>> map with an unset type simultaneously and both return true even though they
>> are inserting incompatible programs.
>>
>> The race window is quite small, but artificially enlarging it by adding a
>> usleep_range() inside the check in bpf_prog_array_compatible() makes it
>> trivial to trigger from userspace with a program that does, essentially:
>>
>>          map_fd = bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, 4, 4, 2, 0);
>>          pid = fork();
>>          if (pid) {
>>                  key = 0;
>>                  value = xdp_fd;
>>          } else {
>>                  key = 1;
>>                  value = tc_fd;
>>          }
>>          err = bpf_map_update_elem(map_fd, &key, &value, 0);
>>
>> While the race window is small, it has potentially serious ramifications in
>> that triggering it would allow a BPF program to tail call to a program of a
>> different type. So let's get rid of it by protecting the update with a
>> spinlock. The commit in the Fixes tag is the last commit that touches the
>> code in question.
>>
>> v2:
>> - Use a spinlock instead of an atomic variable and cmpxchg() (Alexei)
>>
>> Fixes: 3324b584b6f6 ("ebpf: misc core cleanup")
>> Reported-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> ---
>>   include/linux/bpf.h   |  1 +
>>   kernel/bpf/arraymap.c |  1 +
>>   kernel/bpf/core.c     | 14 ++++++++++----
>>   kernel/bpf/syscall.c  |  2 ++
>>   4 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 020a7d5bf470..98d906176d89 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -929,6 +929,7 @@ struct bpf_array_aux {
>>   	 * stored in the map to make sure that all callers and callees have
>>   	 * the same prog type and JITed flag.
>>   	 */
>> +	spinlock_t type_check_lock;
> 
> I was wondering if we can use a mutex instead of a spinlock here since it is
> run from a syscall AFAIU. The only downside is mutex_lock is run inside
> aux->used_maps_mutex critical section. Am I missing something?

Hm, potentially it could work, but then it's also 32 vs 4 extra bytes. There's
also poke_mutex or freeze_mutex, but feels to hacky to 'generalize for reuse',
so I think the spinlock in bpf_array_aux is fine.

>>   	enum bpf_prog_type type;
>>   	bool jited;
>>   	/* Programs with direct jumps into programs part of this array. */
>> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
>> index cebd4fb06d19..da9b1e96cadc 100644
>> --- a/kernel/bpf/arraymap.c
>> +++ b/kernel/bpf/arraymap.c
>> @@ -1072,6 +1072,7 @@ static struct bpf_map *prog_array_map_alloc(union bpf_attr *attr)
>>   	INIT_WORK(&aux->work, prog_array_map_clear_deferred);
>>   	INIT_LIST_HEAD(&aux->poke_progs);
>>   	mutex_init(&aux->poke_mutex);
>> +	spin_lock_init(&aux->type_check_lock);

Just as a tiny nit, I would probably name it slightly different, since type_check_lock
mainly refers to the type property but there's also jit vs non-jit and as pointed out
there could be other extensions that need checking in future as well. Maybe 'compat_lock'
would be a more generic one or just:

         struct {
                 enum bpf_prog_type type;
                 bool jited;
                 spinlock_t lock;
         } owner;

>>   	map = array_map_alloc(attr);
>>   	if (IS_ERR(map)) {
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index c1e7eb3f1876..9439c839d279 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -1823,20 +1823,26 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
>>   bool bpf_prog_array_compatible(struct bpf_array *array,
>>   			       const struct bpf_prog *fp)
>>   {
>> +	bool ret;
>> +
>>   	if (fp->kprobe_override)
>>   		return false;
>>   
>> +	spin_lock(&array->aux->type_check_lock);
>> +
>>   	if (!array->aux->type) {
>>   		/* There's no owner yet where we could check for
>>   		 * compatibility.
>>   		 */
>>   		array->aux->type  = fp->type;
>>   		array->aux->jited = fp->jited;
>> -		return true;
>> +		ret = true;
>> +	} else {
>> +		ret = array->aux->type  == fp->type &&
>> +		      array->aux->jited == fp->jited;
>>   	}
>> -
>> -	return array->aux->type  == fp->type &&
>> -	       array->aux->jited == fp->jited;
>> +	spin_unlock(&array->aux->type_check_lock);
>> +	return ret;
>>   }
>>   
>>   static int bpf_check_tail_call(const struct bpf_prog *fp)
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 4e50c0bfdb7d..955011c7df29 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -543,8 +543,10 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
>>   
>>   	if (map->map_type == BPF_MAP_TYPE_PROG_ARRAY) {
>>   		array = container_of(map, struct bpf_array, map);
>> +		spin_lock(&array->aux->type_check_lock);
>>   		type  = array->aux->type;
>>   		jited = array->aux->jited;
>> +		spin_unlock(&array->aux->type_check_lock);
>>   	}
>>   
>>   	seq_printf(m,
>> -- 
>> 2.33.0
>>

