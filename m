Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341EC10D7ED
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 16:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfK2Pii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 10:38:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:53462 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfK2Pii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 10:38:38 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iai0b-0000SR-7F; Fri, 29 Nov 2019 16:16:37 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iai0a-00026b-V5; Fri, 29 Nov 2019 16:16:36 +0100
Subject: Re: [PATCH bpf] bpf: force .BTF section start to zero when dumping
 from vmlinux
To:     John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org,
        Andrii Nakryiko <andriin@fb.com>
References: <20191127225759.39923-1-sdf@google.com>
 <5ddf4ef366a69_3c082aca725cc5bcbb@john-XPS-13-9370.notmuch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a727a688-2555-b7e3-ab29-43f46a3c3e52@iogearbox.net>
Date:   Fri, 29 Nov 2019 16:16:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5ddf4ef366a69_3c082aca725cc5bcbb@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25648/Fri Nov 29 10:44:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/19 5:37 AM, John Fastabend wrote:
> Stanislav Fomichev wrote:
>> While trying to figure out why fentry_fexit selftest doesn't pass for me
>> (old pahole, broken BTF), I found out that my latest patch can break vmlinux
>> .BTF generation. objcopy preserves section start when doing --only-section,
>> so there is a chance (depending on where pahole inserts .BTF section) to
>> have leading empty zeroes. Let's explicitly force section offset to zero.
>>
>> Before:
>> $ objcopy --set-section-flags .BTF=alloc -O binary \
>> 	--only-section=.BTF vmlinux .btf.vmlinux.bin
>> $ xxd .btf.vmlinux.bin | head -n1
>> 00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
>>
>> After:
>> $ objcopy --change-section-address .BTF=0 \
>> 	--set-section-flags .BTF=alloc -O binary \
>> 	--only-section=.BTF vmlinux .btf.vmlinux.bin
>> $ xxd .btf.vmlinux.bin | head -n1
>> 00000000: 9feb 0100 1800 0000 0000 0000 80e1 1c00  ................
>>            ^BTF magic
>>
>> As part of this change, I'm also dropping '2>/dev/null' from objcopy
>> invocation to be able to catch possible other issues (objcopy doesn't
>> produce any warnings for me anymore, it did before with --dump-section).
> 
> Agree dropping /dev/null seems like a good choice. Otherwise seems reasonable
> to me.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Could reproduce as well:

root@apoc:~/bpf# xxd .btf.vmlinux.bin.old | head -n1                   (original)
00000000: 9feb 0100 1800 0000 0000 0000 5088 2000  ............P. .

root@apoc:~/bpf# ls -l .btf.vmlinux.bin.old
-rw-r--r-- 1 root root 3439882 Nov 29 15:59 .btf.vmlinux.bin.old


root@apoc:~/bpf# xxd .btf.vmlinux.bin.new-buggy | head -n1             ('bpf: Support pre-2.25-binutils objcopy for vmlinux BTF')
00000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................

root@apoc:~/bpf# ls -l .btf.vmlinux.bin.new-buggy
-rwxr-xr-x 1 root root 45705482 Nov 29 16:01 .btf.vmlinux.bin.new-buggy


root@apoc:~/bpf# xxd .btf.vmlinux.bin.new-fixed | head -n1             ('bpf: Force .BTF section start to zero when dumping from vmlinux')
00000000: 9feb 0100 1800 0000 0000 0000 5088 2000  ............P. .

root@apoc:~/bpf# ls -l .btf.vmlinux.bin.new-fixed
-rwxr-xr-x 1 root root 3439882 Nov 29 16:02 .btf.vmlinux.bin.new-fixed


root@apoc:~/bpf# diff .btf.vmlinux.bin.old .btf.vmlinux.bin.new-buggy
Binary files .btf.vmlinux.bin.old and .btf.vmlinux.bin.new-buggy differ

root@apoc:~/bpf# diff .btf.vmlinux.bin.old .btf.vmlinux.bin.new-fixed
root@apoc:~/bpf#


Applied, thanks!
