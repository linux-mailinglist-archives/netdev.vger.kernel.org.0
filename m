Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E508F2348F4
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgGaQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:13:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:33688 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgGaQNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:13:02 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1XeL-0001cu-Ql; Fri, 31 Jul 2020 18:12:49 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1XeL-0004t0-HN; Fri, 31 Jul 2020 18:12:49 +0200
Subject: Re: pull-request: bpf 2020-07-31
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        jolsa@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200731135145.15003-1-daniel@iogearbox.net>
 <20200731152432.GA4296@krava>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <03545f38-c01a-faeb-adab-a0a471ff9fc3@iogearbox.net>
Date:   Fri, 31 Jul 2020 18:12:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200731152432.GA4296@krava>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25890/Fri Jul 31 17:04:57 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 5:24 PM, Jiri Olsa wrote:
> On Fri, Jul 31, 2020 at 03:51:45PM +0200, Daniel Borkmann wrote:
>> Hi David,
>>
>> The following pull-request contains BPF updates for your *net* tree.
>>
>> We've added 5 non-merge commits during the last 21 day(s) which contain
>> a total of 5 files changed, 126 insertions(+), 18 deletions(-).
>>
>> The main changes are:
>>
>> 1) Fix a map element leak in HASH_OF_MAPS map type, from Andrii Nakryiko.
>>
>> 2) Fix a NULL pointer dereference in __btf_resolve_helper_id() when no
>>     btf_vmlinux is available, from Peilin Ye.
>>
>> 3) Init pos variable in __bpfilter_process_sockopt(), from Christoph Hellwig.
>>
>> 4) Fix a cgroup sockopt verifier test by specifying expected attach type,
>>     from Jean-Philippe Brucker.
>>
>> Please consider pulling these changes from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
>>
>> Thanks a lot!
>>
>> Note that when net gets merged into net-next later on, there is a small
>> merge conflict in kernel/bpf/btf.c between commit 5b801dfb7feb ("bpf: Fix
>> NULL pointer dereference in __btf_resolve_helper_id()") from the bpf tree
>> and commit 138b9a0511c7 ("bpf: Remove btf_id helpers resolving") from the
>> net-next tree.
>>
>> Resolve as follows: remove the old hunk with the __btf_resolve_helper_id()
>> function. Change the btf_resolve_helper_id() so it actually tests for a
>> NULL btf_vmlinux and bails out:
>>
>> int btf_resolve_helper_id(struct bpf_verifier_log *log,
>>                            const struct bpf_func_proto *fn, int arg)
>> {
>>          int id;
>>
>>          if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID || !btf_vmlinux)
>>                  return -EINVAL;
>>          id = fn->btf_id[arg];
>>          if (!id || id > btf_vmlinux->nr_types)
>>                  return -EINVAL;
>>          return id;
>> }
>>
>> Let me know if you run into any others issues (CC'ing Jiri Olsa so he's in
>> the loop with regards to merge conflict resolution).
> 
> we'll loose the bpf_log message, but I'm fine with that ;-) looks good

Checking again on the fix, even though it was only triggered by syzkaller
so far, I think it's also possible if users don't have BTF debug data set
in the Kconfig but use a helper that expects it, so agree, lets re-add the
log in this case:

int btf_resolve_helper_id(struct bpf_verifier_log *log,
                           const struct bpf_func_proto *fn, int arg)
{
         int id;

         if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID)
                 return -EINVAL;
         if (!btf_vmlinux) {
                 bpf_log(log, "btf_vmlinux doesn't exist\n");
                 return -EINVAL;
         }
         id = fn->btf_id[arg];
         if (!id || id > btf_vmlinux->nr_types)
                 return -EINVAL;
         return id;
}

Thanks,
Daniel
