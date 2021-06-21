Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24343AED21
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 18:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFUQKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 12:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23928 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230204AbhFUQK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 12:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624291694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wtFz4tplLLk9x2cuMm74LhgASffzGH1Slli/JWzU5O4=;
        b=YHw+yELDk+mmmdCpR7Y1ABWiU6oH8CxwqXZOrFHRkMOmL7ryBFtti8Th4KV8da/0U+Ee85
        Q/B5NYshlrzgtAWBAZh+au+OAlfR/hhAi+++vx5REFf1DqwAmoM1FgoS0bj2x4b0FGFIbI
        U2hFuSNmn0CED0h4tGftSxoEKpjVNxg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-OQqIjSFaMP6NYGdY6o_9dw-1; Mon, 21 Jun 2021 12:08:11 -0400
X-MC-Unique: OQqIjSFaMP6NYGdY6o_9dw-1
Received: by mail-ej1-f71.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso6521698ejn.10
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 09:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wtFz4tplLLk9x2cuMm74LhgASffzGH1Slli/JWzU5O4=;
        b=B9/DvpN1AA32kSAU0Ehv3SP8RkdXUCee45n5r2T4MnvB1y2Mw9IpMiU1WRVqydDFzg
         z22R1C47cpfRnd5SRfoerLwnQC1Kd6YuhFXlR/j7qd0b+QV0XlPbh7TTxu13EFxB3LGH
         kUL1L7oubVciRrxymfsoY99xTVWjHmiclBDGGklNzd7fU/8LgkoThgAPaXY2oRCB19M8
         5jZIR21LQSpli5ZlJH8Z6klBNe3Qsj1I1+ufnVTjd1ShDAZtct+wb4P9gaoGcPiqPLyn
         Pbfl/Toqz37/X2aKsBtiD6Ko07Etz431+L8VKgb1ACeRmTrhiO0KTc7RrHOTTbJnBSpa
         6ngQ==
X-Gm-Message-State: AOAM532LDty2NVbrbwqs4hmuwHMQccNGulPLp+Tq0tosI4lMBUhwpQlJ
        IZoWPYWCtMq3UfA9zm9q1Sb88S/An0O9IqLzNuW3+U56U1rFlHvFK6PLoMPeLbvoR5FcSQwbt2P
        /9KKZCWbSZA9IOBF5
X-Received: by 2002:a05:6402:5143:: with SMTP id n3mr2817065edd.80.1624291689845;
        Mon, 21 Jun 2021 09:08:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9GVQxSxF8ENAKgNqz/ag3BFUzZQBOTOtKqAsYr7Oj/pikcs/14ulPXMpiqBUP+rdpePvrww==
X-Received: by 2002:a05:6402:5143:: with SMTP id n3mr2817027edd.80.1624291689679;
        Mon, 21 Jun 2021 09:08:09 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id i6sm4965916ejr.68.2021.06.21.09.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 09:08:08 -0700 (PDT)
Date:   Mon, 21 Jun 2021 18:08:06 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] virtio/vsock: avoid NULL deref in
 virtio_transport_seqpacket_allow()
Message-ID: <20210621160806.ml7ipwxchwx7l3j5@steredhat>
References: <20210621145348.695341-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210621145348.695341-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 07:53:48AM -0700, Eric Dumazet wrote:
>From: Eric Dumazet <edumazet@google.com>
>
>Make sure the_virtio_vsock is not NULL before dereferencing it.
>
>general protection fault, probably for non-canonical address 0xdffffc0000000071: 0000 [#1] PREEMPT SMP KASAN
>KASAN: null-ptr-deref in range [0x0000000000000388-0x000000000000038f]
>CPU: 0 PID: 8452 Comm: syz-executor406 Not tainted 5.13.0-rc6-syzkaller #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>RIP: 0010:virtio_transport_seqpacket_allow+0xbf/0x210 net/vmw_vsock/virtio_transport.c:503
>Code: e8 c6 d9 ab f8 84 db 0f 84 0f 01 00 00 e8 09 d3 ab f8 48 8d bd 88 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 2a 01 00 00 44 0f b6 a5 88 03 00 00
>RSP: 0018:ffffc90003757c18 EFLAGS: 00010206
>RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 0000000000000000
>RDX: 0000000000000071 RSI: ffffffff88c908e7 RDI: 0000000000000388
>RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>R10: ffffffff88c90a06 R11: 0000000000000000 R12: 0000000000000000
>R13: ffffffff88c90840 R14: 0000000000000000 R15: 0000000000000001
>FS:  0000000001bee300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 0000000020000082 CR3: 000000002847e000 CR4: 00000000001506f0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>Call Trace:
> vsock_assign_transport+0x575/0x700 net/vmw_vsock/af_vsock.c:490
> vsock_connect+0x200/0xc00 net/vmw_vsock/af_vsock.c:1337
> __sys_connect_file+0x155/0x1a0 net/socket.c:1824
> __sys_connect+0x161/0x190 net/socket.c:1841
> __do_sys_connect net/socket.c:1851 [inline]
> __se_sys_connect net/socket.c:1848 [inline]
> __x64_sys_connect+0x6f/0xb0 net/socket.c:1848
> do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>RIP: 0033:0x43ee69
>Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>RSP: 002b:00007ffd49e7c788 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
>RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee69
>RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000003
>RBP: 0000000000402e50 R08: 0000000000000000 R09: 0000000000400488
>R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ee0
>R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>
>Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
>Signed-off-by: Eric Dumazet <edumazet@google.com>
>Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Reported-by: syzbot <syzkaller@googlegroups.com>
>---
> net/vmw_vsock/virtio_transport.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e73ce652bf3c3c291a12e95d26cdbd24747a7467..ed1664e7bd88840c4e336628efa76048e55f37c0 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -498,9 +498,11 @@ static bool virtio_transport_seqpacket_allow(u32 remote_cid)
> 	struct virtio_vsock *vsock;
> 	bool seqpacket_allow;
>
>+	seqpacket_allow = false;
> 	rcu_read_lock();
> 	vsock = rcu_dereference(the_virtio_vsock);
>-	seqpacket_allow = vsock->seqpacket_allow;
>+	if (vsock)
>+		seqpacket_allow = vsock->seqpacket_allow;
> 	rcu_read_unlock();
>
> 	return seqpacket_allow;
>-- 
>2.32.0.288.g62a8d224e6-goog
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

