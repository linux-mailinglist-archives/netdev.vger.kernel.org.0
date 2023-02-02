Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F8568782C
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjBBJDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjBBJDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:03:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D1610FB
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675328566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=De3EEQ1m72Gwo/6RnWtloeFaKS85eTsg/vaPSBwqp1U=;
        b=WAp1Jiw1Et9/pJBJtxioBqs6UVbA22lXI8YZNGFV0sPwqHtfFbEBHK025bytECwel4n9Vw
        Vtj8Y/2FrqhGKyE3y8FhI6RxCNesrb8xktQClGNDM9LRM+qhWFgcmg+tRz2Xfoc8dZKtzz
        YCUttRt9D9VrhAVN52fywjQQ1SlP1qQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-hvoQV0e5NM22nCXJKjPU3w-1; Thu, 02 Feb 2023 04:02:45 -0500
X-MC-Unique: hvoQV0e5NM22nCXJKjPU3w-1
Received: by mail-wm1-f69.google.com with SMTP id bg25-20020a05600c3c9900b003da1f6a7b2dso2492170wmb.1
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=De3EEQ1m72Gwo/6RnWtloeFaKS85eTsg/vaPSBwqp1U=;
        b=xfN8/we6vg0olbJg83eU/6mKUZkIXQXeg4I5UEUvZIMAzkuqtzJdjFz+Ym9Z7SMB4X
         KhJgFgjF2Z1Qi4xSAMU3Ftf8hqCBQL9Pb3Xg6lYQXAGmmSUop85aJHM8LbN1rfIbJO1E
         INCvAX/z5XnjCCVnPdKW285XW0i++f6m4CsH7tUDMUwRK7L1j+AtyThUhVxtowiFn5ET
         AA9QWZEBwSjWygxeOKYeXdzHQBv9FEm8s3X6AG00twAERawcAJ/F4tB+esAC+V/QEwUF
         5RQZLvSUyBnJ7ZGVFBaXH3Gnj/g3pIzowDfM6JQJzW+rxNFwbJOVb3M97hm9/qdNNYY7
         mHuw==
X-Gm-Message-State: AO0yUKWgRUVo3L+RVWHppm+W0ZXSRQmny5iwca77jJDZtGFyNitSS7+0
        b2Xp8auVzRuVRuLkQDqLLQRkh2QJpadG1fEplz16SbV4JO4eNuP8/khCOK25alJgDmaYzH9pWRk
        TcxGMSRdr3GFrjDoD
X-Received: by 2002:a05:600c:5127:b0:3df:e1cc:94ff with SMTP id o39-20020a05600c512700b003dfe1cc94ffmr243170wms.28.1675328564398;
        Thu, 02 Feb 2023 01:02:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+fCz01ItwOkICqUjPGvI9tDwbLemLD7FdONgucCuAKb9cdtz4cX1DC5V0lyMB/NcT5nCtZrQ==
X-Received: by 2002:a05:600c:5127:b0:3df:e1cc:94ff with SMTP id o39-20020a05600c512700b003dfe1cc94ffmr243149wms.28.1675328564119;
        Thu, 02 Feb 2023 01:02:44 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id t1-20020a1c7701000000b003b47b80cec3sm4027759wmi.42.2023.02.02.01.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 01:02:43 -0800 (PST)
Message-ID: <e8065d6a-d2f9-60aa-8541-8dfc8e9b608f@redhat.com>
Date:   Thu, 2 Feb 2023 10:02:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [syzbot] general protection fault in skb_dequeue (3)
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>, jhubbard@nvidia.com
Cc:     syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, hch@lst.de,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
References: <000000000000b0b3c005f3a09383@google.com>
 <822863.1675327935@warthog.procyon.org.uk>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <822863.1675327935@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.02.23 09:52, David Howells wrote:
> Hi John, David,
> 
> Could you have a look at this?
> 
>> syzbot found the following issue on:
>>
>> HEAD commit:    80bd9028feca Add linux-next specific files for 20230131
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1468e369480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=904dc2f450eaad4a
>> dashboard link: https://syzkaller.appspot.com/bug?extid=a440341a59e3b7142895
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c5d2be480000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11259a79480000
>> ...
>> The issue was bisected to:
>>
>> commit 920756a3306a35f1c08f25207d375885bef98975
>> Author: David Howells <dhowells@redhat.com>
>> Date:   Sat Jan 21 12:51:18 2023 +0000
>>
>>      block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170384f9480000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=148384f9480000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=108384f9480000
>> ...
>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>> CPU: 0 PID: 2838 Comm: kworker/u4:6 Not tainted 6.2.0-rc6-next-20230131-syzkaller-09515-g80bd9028feca #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
>> Workqueue: phy4 ieee80211_iface_work
>> RIP: 0010:__skb_unlink include/linux/skbuff.h:2321 [inline]
>> RIP: 0010:__skb_dequeue include/linux/skbuff.h:2337 [inline]
>> RIP: 0010:skb_dequeue+0xf5/0x180 net/core/skbuff.c:3511
> 
> I don't think this is specifically related to anything networking.  I've run
> it a few times and weird stuff happens in various places.  I'm wondering if
> it's related to FOLL_PIN in some way.
> 
> The syzbot test in question does the following:
> 
>     #{"repeat":true,"procs":1,"slowdown":1,"sandbox":"none","sandbox_arg":0,"netdev":true,"cgroups":true,"close_fds":true,"usb":true,"wifi":true,"sysctl":true,"tmpdir":true}
>     socket(0x0, 0x2, 0x0)
>     epoll_create(0x7)
>     r0 = creat(&(0x7f0000000040)='./bus\x00', 0x9)
>     ftruncate(r0, 0x800)
>     lseek(r0, 0x200, 0x2)
>     r1 = open(&(0x7f0000000000)='./bus\x00', 0x24000, 0x0)  <-- O_DIRECT
>     sendfile(r0, r1, 0x0, 0x1dd00)
> 
> Basically a DIO splice from a file to itself.
> 
> I've hand-written my own much simpler tester (see attached).  You need to run
> at least two copies in parallel, I think, to trigger the bug.  It's possible
> truncate is interfering somehow.
> 
> David
> ---
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/sendfile.h>
> #include <sys/wait.h>
> 
> #define file_size 0x800
> #define send_size 0x1dd00
> #define repeat_count 1000
> 
> int main(int argc, char *argv[])
> {
> 	int in, out, i, wt;
> 
> 	if (argc != 2 || !argv[1][0]) {
> 		fprintf(stderr, "Usage: %s <file>\n", argv[0]);
> 		exit(2);
> 	}
> 
> 	for (i = 0; i < repeat_count; i++) {
> 		switch (fork()) {
> 		case -1:
> 			perror("fork");
> 			exit(1);
> 		case 0:
> 			out = creat(argv[1], 0666);
> 			if (out < 0) {
> 				perror(argv[1]);
> 				exit(1);
> 			}
> 
> 			if (ftruncate(out, file_size) < 0) {
> 				perror("ftruncate");
> 				exit(1);
> 			}
> 
> 			if (lseek(out, file_size, SEEK_SET) < 0) {
> 				perror("lseek");
> 				exit(1);
> 			}
> 
> 			in = open(argv[1], O_RDONLY | O_DIRECT | O_NOFOLLOW);
> 			if (in < 0) {
> 				perror("open");
> 				exit(1);
> 			}
> 
> 			if (sendfile(out, in, NULL, send_size) < 0) {
> 				perror("sendfile");
> 				exit(1);
> 			}
> 			exit(0);

[as raised on IRC]

At first, I wondered if that's related to shared anonymous pages getting 
pinned R/O that would trigger COW-unsharing ... but I don't even see 
where we are supposed to use FOLL_PIN vs. FOLL_GET here? IOW, we're not 
even supposed to access user space memory (neither FOLL_GET nor 
FOLL_PIN) but still end up with a change in behavior.

-- 
Thanks,

David / dhildenb

