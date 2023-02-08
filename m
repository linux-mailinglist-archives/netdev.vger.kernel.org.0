Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F69F68EA39
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjBHIyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBHIyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:54:41 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6AA9EFD
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:54:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id m2so18539151plg.4
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 00:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sywhCeCLoCNxC9+lbS2SHML0JAw2JSzA4XjicwCTxOQ=;
        b=GFuqlzv2c2yviPTfGTFxE6JBGzruAlU+Z3umUCoDvnFq4Y8CY+Gti+Z6C1ZezvZ9dn
         mDxLtV54WTYFxKVvrOzFr2oNAH24ufd9c+Se30V8YwYu7PTFE7Tc2XBYstF0WWlCQCcf
         73Q7G/N4Iinaa51x93AOlMGIT5BqnYJD04NFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sywhCeCLoCNxC9+lbS2SHML0JAw2JSzA4XjicwCTxOQ=;
        b=XtejlXgcw4FP4vdxg17y6YpNLndHz9syAiHrfyVvKtGzkqCw1VjzXo4acGASzEzvVd
         WNe/2abzcn5/uFAp+S6NWyXZxYmoWlgVxarNQf+te13QDJRpPrwCG2BlDZrXFFAZ66zw
         O+246a8rkNH+8WDTTSYKuisCYNcMJzjwLJLmMSqdCTD5Xw/sYk2nwN0zVdVk+fFgpjPM
         +f/xec0WPzAaCo+l1tpsCU2DRrMR6Whiv7Qttsahbv1rNvqFk8DJpm/MpJfnDcJXHhl7
         xmTv1g1SicAubPFdkgo3xpI3TlCxt/tQfzOu8ku1xaoa2mPg6UOINPmZ+WBHQkrs8Na8
         4amA==
X-Gm-Message-State: AO0yUKWx/S/B6dGkae2uKzhhT3JkjBBDvNkJCCVlb3cgoZeEzPXXqDkq
        mYdYIf1ZaUo4+oiiemdaKuAi6A==
X-Google-Smtp-Source: AK7set/z/6iLyvDTw6tISk7s0GVtsE3PQ7S7HML149KpaViGszVKz+xdmiKd5+372c2GqKMNk2KLdA==
X-Received: by 2002:a17:902:e385:b0:199:4d57:639e with SMTP id g5-20020a170902e38500b001994d57639emr472926ple.50.1675846479682;
        Wed, 08 Feb 2023 00:54:39 -0800 (PST)
Received: from ubuntu ([121.133.63.188])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b001960cccc318sm10287469plb.121.2023.02.08.00.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 00:54:39 -0800 (PST)
Date:   Wed, 8 Feb 2023 00:54:34 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        imv4bel@gmail.com, v4bel@theori.io, netdev@vger.kernel.org
Subject: Re: [PATCH] af_key: Fix heap information leak
Message-ID: <20230208085434.GA2933@ubuntu>
References: <20230204175018.GA7246@ubuntu>
 <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+Hp+0LzvScaUJV0@gondor.apana.org.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 02:04:43PM +0800, Herbert Xu wrote:
> On Sat, Feb 04, 2023 at 09:50:18AM -0800, Hyunwoo Kim wrote:
> > Since x->calg etc. are allocated with kmalloc, information
> > in kernel heap can be leaked using netlink socket on
> > systems without CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> > 
Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com

> > Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> > ---
> >  net/key/af_key.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Please explain exactly what is leaked and how.

ere's the KMSAN report reported by syzbot:
=====================================================
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout+0xbc/0x100 lib/iov_iter.c:169
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 copyout+0xbc/0x100 lib/iov_iter.c:169
 _copy_to_iter+0x4f4/0x1fb0 lib/iov_iter.c:529
 copy_to_iter include/linux/uio.h:179 [inline]
 simple_copy_to_iter+0x64/0xa0 net/core/datagram.c:513
 __skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:419
 skb_copy_datagram_iter+0x53/0x1d0 net/core/datagram.c:527
 skb_copy_datagram_msg include/linux/skbuff.h:3908 [inline]
 netlink_recvmsg+0x504/0x1650 net/netlink/af_netlink.c:1988
 ____sys_recvmsg+0x2c4/0x810
 ___sys_recvmsg+0x217/0x840 net/socket.c:2737
 do_recvmmsg+0x55a/0x1180 net/socket.c:2831
 __sys_recvmmsg net/socket.c:2910 [inline]
 __do_sys_recvmmsg net/socket.c:2933 [inline]
 __se_sys_recvmmsg net/socket.c:2926 [inline]
 __x64_sys_recvmmsg+0x3a7/0x4b0 net/socket.c:2926
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 __nla_put lib/nlattr.c:1006 [inline]
 nla_put+0x1c2/0x230 lib/nlattr.c:1064
 copy_to_user_state_extra+0x115e/0x1aa0 net/xfrm/xfrm_user.c:1101
 dump_one_state+0x2c8/0x7c0 net/xfrm/xfrm_user.c:1169
 xfrm_state_walk+0x727/0x1300 net/xfrm/xfrm_state.c:2308
 xfrm_dump_sa+0x1e6/0x6b0 net/xfrm/xfrm_user.c:1240
 netlink_dump+0xb18/0x1560 net/netlink/af_netlink.c:2286
 __netlink_dump_start+0xa6d/0xc40 net/netlink/af_netlink.c:2391
 netlink_dump_start include/linux/netlink.h:294 [inline]
 xfrm_user_rcv_msg+0x828/0xf70 net/xfrm/xfrm_user.c:3091
 netlink_rcv_skb+0x3f1/0x750 net/netlink/af_netlink.c:2564
 xfrm_netlink_rcv+0x72/0xb0 net/xfrm/xfrm_user.c:3128
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmsg net/socket.c:2559 [inline]
 __do_sys_sendmsg net/socket.c:2568 [inline]
 __se_sys_sendmsg net/socket.c:2566 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2566
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 kmalloc_trace+0x4d/0x1f0 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 pfkey_msg2xfrm_state net/key/af_key.c:1199 [inline]
 pfkey_add+0x3124/0x3b90 net/key/af_key.c:1504
 pfkey_process net/key/af_key.c:2844 [inline]
 pfkey_sendmsg+0x1693/0x1b90 net/key/af_key.c:3695
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xa8e/0xe70 net/socket.c:2476
 ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2530
 __sys_sendmmsg+0x40d/0xa40 net/socket.c:2616
 __do_sys_sendmmsg net/socket.c:2645 [inline]
 __se_sys_sendmmsg net/socket.c:2642 [inline]
 __x64_sys_sendmmsg+0xb8/0x120 net/socket.c:2642
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Bytes 252-311 of 912 are uninitialized
Memory access of size 912 starts at ffff88811c76b000
Data copied to user address 0000000020001580

CPU: 1 PID: 5027 Comm: syz-executor292 Not tainted 6.2.0-rc3-syzkaller-79340-gc9a4e3bf8138 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
=====================================================


After assigning `x->calg = kmalloc(sizeof(*x->calg), GFP_KERNEL);` in
pfkey_msg2xfrm_state(), only part of `x->calg->alg_name` is initialized,
so x->calg contains uninitialized kernel heap data.

Then open a netlink socket and use sendmsg() and recvmsg() to leak this
uninitialized kernel heap data to the user.

That is, the user can obtain the kernel memory address to bypass KASLR.

Of course, this can only be triggered on systems where
CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set.


Regards,
Hyunwoo Kim

> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
