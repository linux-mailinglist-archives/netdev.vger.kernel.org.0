Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CBB58C476
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbiHHHzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbiHHHzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:55:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BF925FB9
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659945345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oC/JLDjGvWP0iiaK2n12rCrZ705odT+KLXUuwmVFqrk=;
        b=VD5i8DICV9uuIQ4p337s5qSs5ZrdFwhNSS12Unu53uaUeaNOzu7gppLehklQNlidgrSq+H
        pqi4nXSBq9GZ4l9ihTY57jSy70YC39bQZwwC1bTxWcPC+O3LLvy5t2kfbBenAElyprnQ3l
        r61CmLfouA1hhsLvAvJVTqE0AeqTANI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-d5O5as2bOI2LqHD7U5cKjA-1; Mon, 08 Aug 2022 03:55:44 -0400
X-MC-Unique: d5O5as2bOI2LqHD7U5cKjA-1
Received: by mail-qk1-f200.google.com with SMTP id az14-20020a05620a170e00b006b666c4627bso7427111qkb.23
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 00:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oC/JLDjGvWP0iiaK2n12rCrZ705odT+KLXUuwmVFqrk=;
        b=JptOzcexJou1IEkRPSMh2jU7u69Dj6LaJpNjow+uNp3vawiI9SqIGkp4pYQaLe4L7c
         q//P/9SbqCFzNgUE3VEc4w/YfCMbVnieC6v5BE1MUUj/OHIUnnge8UrO/0yQPGmfLrsD
         QHbV0znOJXlChnNOaPlU3SZ9+uAr67OCHg1ECXMChIKIsGF26olkwwaJ3KfNjhtyJ4ma
         C8/ty9Vkz4anzMqDJ0pjJelTyyK815sgxPdumrH/jvWSSVistDsNwNQwCR2mJC4i3REH
         zPy3aG4Vl92z/TqmalTs8iqM56OU5p4iRv/QiCwv0ROLQhqHHRguJRzOgXUbo1FmCO2P
         XjFw==
X-Gm-Message-State: ACgBeo3VAnJgaLLF213R/2kGhE4ZpDU2gmiDJ+DWe6k2FIgzN7CW6nGY
        b9cUpTodX2DFusCR7kSK5fA4zkpTkcWxk5BZwRFC6kw70OL0XnOO4t2wev0rJ0NhPmRUh3QJm06
        0eqjpRZedLayxvJOD
X-Received: by 2002:a05:620a:1706:b0:6b9:234:f735 with SMTP id az6-20020a05620a170600b006b90234f735mr13305783qkb.623.1659945342745;
        Mon, 08 Aug 2022 00:55:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7iWdzerRsas1XKbzpMRoloSe+T09VDPfGvxnYWtJ3xP4fybH8ZIzd+8wJd6v36LUCEu/kjSA==
X-Received: by 2002:a05:620a:1706:b0:6b9:234:f735 with SMTP id az6-20020a05620a170600b006b90234f735mr13305776qkb.623.1659945342506;
        Mon, 08 Aug 2022 00:55:42 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id w20-20020a05620a0e9400b006b8f8e9bd00sm8365097qkm.5.2022.08.08.00.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 00:55:41 -0700 (PDT)
Date:   Mon, 8 Aug 2022 09:55:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        George Zhang <georgezhang@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        Andy King <acking@vmware.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] vsock: Fix memory leak in vsock_connect()
Message-ID: <20220808075533.p7pczlnixb2phrun@sgarzare-redhat>
References: <20220804020925.32167-1-yepeilin.cs@gmail.com>
 <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a02c6e7e3135473d254ac97abc603d963ba8f716.1659862577.git.peilin.ye@bytedance.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 07, 2022 at 02:00:11AM -0700, Peilin Ye wrote:
>From: Peilin Ye <peilin.ye@bytedance.com>
>
>An O_NONBLOCK vsock_connect() request may try to reschedule
>@connect_work.  Imagine the following sequence of vsock_connect()
>requests:
>
>  1. The 1st, non-blocking request schedules @connect_work, which will
>     expire after 200 jiffies.  Socket state is now SS_CONNECTING;
>
>  2. Later, the 2nd, blocking request gets interrupted by a signal after
>     a few jiffies while waiting for the connection to be established.
>     Socket state is back to SS_UNCONNECTED, but @connect_work is still
>     pending, and will expire after 100 jiffies.
>
>  3. Now, the 3rd, non-blocking request tries to schedule @connect_work
>     again.  Since @connect_work is already scheduled,
>     schedule_delayed_work() silently returns.  sock_hold() is called
>     twice, but sock_put() will only be called once in
>     vsock_connect_timeout(), causing a memory leak reported by syzbot:
>
>  BUG: memory leak
>  unreferenced object 0xffff88810ea56a40 (size 1232):
>    comm "syz-executor756", pid 3604, jiffies 4294947681 (age 12.350s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      28 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  (..@............
>    backtrace:
>      [<ffffffff837c830e>] sk_prot_alloc+0x3e/0x1b0 net/core/sock.c:1930
>      [<ffffffff837cbe22>] sk_alloc+0x32/0x2e0 net/core/sock.c:1989
>      [<ffffffff842ccf68>] __vsock_create.constprop.0+0x38/0x320 net/vmw_vsock/af_vsock.c:734
>      [<ffffffff842ce8f1>] vsock_create+0xc1/0x2d0 net/vmw_vsock/af_vsock.c:2203
>      [<ffffffff837c0cbb>] __sock_create+0x1ab/0x2b0 net/socket.c:1468
>      [<ffffffff837c3acf>] sock_create net/socket.c:1519 [inline]
>      [<ffffffff837c3acf>] __sys_socket+0x6f/0x140 net/socket.c:1561
>      [<ffffffff837c3bba>] __do_sys_socket net/socket.c:1570 [inline]
>      [<ffffffff837c3bba>] __se_sys_socket net/socket.c:1568 [inline]
>      [<ffffffff837c3bba>] __x64_sys_socket+0x1a/0x20 net/socket.c:1568
>      [<ffffffff84512815>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>      [<ffffffff84512815>] do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>      [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>  <...>
>
>Use mod_delayed_work() instead: if @connect_work is already scheduled,
>reschedule it, and undo sock_hold() to keep the reference count
>balanced.
>
>Reported-and-tested-by: syzbot+b03f55bf128f9a38f064@syzkaller.appspotmail.com
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
>Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
>---
>change since v1:
>  - merged with Stefano's patch [1]
>
>[1] https://gitlab.com/sgarzarella/linux/-/commit/2d0f0b9cbbb30d58fdcbca7c1a857fd8f3110d61
>
>Hi Stefano,
>
>About the Fixes: tag, [2] introduced @connect_work, but all it did was
>breaking @dwork into two and moving some INIT_DELAYED_WORK()'s, so I don't
>think [2] introduced this memory leak?
>
>Since [2] has already been backported to 4.9 and 4.14, I think we can
>Fixes: commit d021c344051a ("VSOCK: Introduce VM Sockets"), too, to make
>backporting easier?

Yep, I think it should be fine!

>
>[2] commit 455f05ecd2b2 ("vsock: split dwork to avoid reinitializations")
>
>Thanks,
>Peilin Ye
>
> net/vmw_vsock/af_vsock.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..fe14f6cbca22 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1391,7 +1391,13 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> 			 * timeout fires.
> 			 */
> 			sock_hold(sk);
>-			schedule_delayed_work(&vsk->connect_work, timeout);
>+
>+			/* If the timeout function is already scheduled,
>+			 * reschedule it, then ungrab the socket refcount to
>+			 * keep it balanced.
>+			 */
>+			if (mod_delayed_work(system_wq, &vsk->connect_work, timeout))
                             ^
Checkpatch warns here about line lenght.
If you have to re-send, please split it.

Anyway, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

