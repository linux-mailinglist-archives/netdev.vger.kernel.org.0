Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB7E3CBE21
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhGPVEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:04:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:33142 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbhGPVD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 17:03:59 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m4Ux9-000Bh1-3i; Fri, 16 Jul 2021 23:00:59 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m4Ux8-000Hma-RA; Fri, 16 Jul 2021 23:00:58 +0200
Subject: Re: [PATCH bpf] bpf: fix OOB read when printing XDP link fdinfo
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210716100452.113652-1-lmb@cloudflare.com>
 <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7854fbef-8ea5-5396-6369-99eef1dcccaa@iogearbox.net>
Date:   Fri, 16 Jul 2021 23:00:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26234/Fri Jul 16 10:18:39 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/21 10:43 PM, Andrii Nakryiko wrote:
> On Fri, Jul 16, 2021 at 3:05 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>>
>> We got the following UBSAN report on one of our testing machines:
>>
>>      ================================================================================
>>      UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
>>      index 6 is out of range for type 'char *[6]'
>>      CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
>>      Hardware name: <snip>
>>      Call Trace:
>>       dump_stack+0x7d/0xa3
>>       ubsan_epilogue+0x5/0x40
>>       __ubsan_handle_out_of_bounds.cold+0x43/0x48
>>       ? seq_printf+0x17d/0x250
>>       bpf_link_show_fdinfo+0x329/0x380
>>       ? bpf_map_value_size+0xe0/0xe0
>>       ? put_files_struct+0x20/0x2d0
>>       ? __kasan_kmalloc.constprop.0+0xc2/0xd0
>>       seq_show+0x3f7/0x540
>>       seq_read_iter+0x3f8/0x1040
>>       seq_read+0x329/0x500
>>       ? seq_read_iter+0x1040/0x1040
>>       ? __fsnotify_parent+0x80/0x820
>>       ? __fsnotify_update_child_dentry_flags+0x380/0x380
>>       vfs_read+0x123/0x460
>>       ksys_read+0xed/0x1c0
>>       ? __x64_sys_pwrite64+0x1f0/0x1f0
>>       do_syscall_64+0x33/0x40
>>       entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>      <snip>
>>      ================================================================================
>>      ================================================================================
>>      UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2
>>
>>  From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
>> is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
>> BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
>> and therefore doesn't have an entry in bpf_link_type_strs:
>>
>>      pos:        0
>>      flags:      02000000
>>      mnt_id:     13
>>      link_type:  (null)
>>      link_id:    4
>>      prog_tag:   bcf7977d3b93787c
>>      prog_id:    4
>>      ifindex:    1
>>
>> Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>> ---
> 
> Well, oops. Thanks for the fix!
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> It would be great to have a compilation error for something like this.
> I wonder if we can do something to detect this going forward?
> 
>>   include/linux/bpf_types.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
>> index a9db1eae6796..be95f2722ad9 100644
>> --- a/include/linux/bpf_types.h
>> +++ b/include/linux/bpf_types.h
>> @@ -135,3 +135,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
>>   #ifdef CONFIG_NET
>>   BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
>>   #endif
>> +BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)

Lorenz, does this compile when you don't have CONFIG_NET configured? I would assume
this needs to go right below the netns one depending on CONFIG_NET.. at least the
bpf_xdp_link_lops are in net/core/dev.c which is only built under CONFIG_NET.

Thanks,
Daniel
