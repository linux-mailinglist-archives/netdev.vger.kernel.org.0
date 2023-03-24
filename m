Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCD76C7AC3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbjCXJHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbjCXJHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAABA1420A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679648787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QVH2oh9fpzLQkJXdwpUJ4533V1wJBPoDSclzcYbqRDs=;
        b=JcfmRJa7JAl5IOGs2Fi9/qCxnQQ19wBLpDhTmjjKU5JTespDVA6uTxkURoa2+8HWbmc+4x
        UhnF91etkOQqfB9UFp0awr9/BIlosexl1ChfIAqR1nAL/x594wG0KkgL8CtulEb0SIoifp
        MusLvpxQAtKIVpDurxRRwy5vE4ucgQY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-OeIvHGg6Orq02nhlZQqykw-1; Fri, 24 Mar 2023 05:06:26 -0400
X-MC-Unique: OeIvHGg6Orq02nhlZQqykw-1
Received: by mail-ed1-f71.google.com with SMTP id t14-20020a056402240e00b004fb36e6d670so2268117eda.5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679648785;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QVH2oh9fpzLQkJXdwpUJ4533V1wJBPoDSclzcYbqRDs=;
        b=MlzOSZrO5oGGyFbKD1pa7VitJv5dznHDqsclKvZ/aed/qenyE6EC4FxIQ50DwFKh9F
         bMH+Zd16TmU9cbVxhtSF4LYr9NCvJNQRdnXYgzGMpEdWA3iGyJGhjIBKlDwfZXKWO6Kh
         InuGgsm5FtibQnCoc5Ol78y+wciEh+sVC8ZEQw4IKZDSdRujET9/4iewkosLbN65VSE7
         kO4vuaiqKsECCFyIk4YmQ6Co/lBtUF07kDY5xDZsPwq7V0pC6HsNNwUcou4UOtrjlz4j
         ZW8cQ1H/utXvydal2AR0aQaxRg5L0uN+zS3DNWeZ/9kOZA/nyl53r2QS9Twtn8yJGowe
         6yMg==
X-Gm-Message-State: AAQBX9fLnLgHk+YsbPb/2ao1aDRei56YF3jO/+C1ShdXtWqpuBTxuZWQ
        xtLySu1q1DI0CVnROLBA0UbjxKcCQKOhhgzAoyIN3BgegeT4EyPpJmQfir6Bka9SpmDMa8O8mPk
        +41ANTXtRIBntYk+t
X-Received: by 2002:a17:906:fb08:b0:8b1:2d0e:281 with SMTP id lz8-20020a170906fb0800b008b12d0e0281mr2290905ejb.18.1679648784738;
        Fri, 24 Mar 2023 02:06:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350bQ/0qtXsSzTfWFpJpLAd1O/C8EC/FjGUKHYcG4gtT7IHcXKxrUdWfr7rE+d1abTlAFPGEy4w==
X-Received: by 2002:a17:906:fb08:b0:8b1:2d0e:281 with SMTP id lz8-20020a170906fb0800b008b12d0e0281mr2290873ejb.18.1679648784448;
        Fri, 24 Mar 2023 02:06:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id g8-20020a1709061e0800b0093bd173baa6sm3300977ejj.202.2023.03.24.02.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 02:06:23 -0700 (PDT)
Date:   Fri, 24 Mar 2023 10:06:21 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     syzbot <syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 virtio_transport_purge_skbs
Message-ID: <CAGxU2F7XjdKgdKwfZMT-sdJ+JK10p_2zNdaQeGBwm3jpEe1Xaw@mail.gmail.com>
References: <000000000000708b1005f79acf5c@google.com>
 <CAGxU2F4ZiNEyrZzEJnYjYDz6CxniPGNW7AwyMLPLTxA2UbBWhA@mail.gmail.com>
 <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGxU2F6m4KWXwOF8StjWbb=S6HRx=GhV_ONDcZxCZsDkvuaeUg@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 9:55 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Fri, Mar 24, 2023 at 9:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > Hi Bobby,
> > can you take a look at this report?
> >
> > It seems related to the changes we made to support skbuff.
>
> Could it be a problem of concurrent access to pkt_queue ?
>
> IIUC we should hold pkt_queue.lock when we call skb_queue_splice_init()
> and remove pkt_list_lock. (or hold pkt_list_lock when calling
> virtio_transport_purge_skbs, but pkt_list_lock seems useless now that
> we use skbuff)
>

In the previous patch was missing a hunk, new one attached:

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git fff5a5e7f528

--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -15,7 +15,6 @@
 struct vsock_loopback {
        struct workqueue_struct *workqueue;

-       spinlock_t pkt_list_lock; /* protects pkt_list */
        struct sk_buff_head pkt_queue;
        struct work_struct pkt_work;
 };
@@ -32,9 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
        struct vsock_loopback *vsock = &the_vsock_loopback;
        int len = skb->len;

-       spin_lock_bh(&vsock->pkt_list_lock);
        skb_queue_tail(&vsock->pkt_queue, skb);
-       spin_unlock_bh(&vsock->pkt_list_lock);

        queue_work(vsock->workqueue, &vsock->pkt_work);

@@ -113,9 +110,9 @@ static void vsock_loopback_work(struct work_struct *work)

        skb_queue_head_init(&pkts);

-       spin_lock_bh(&vsock->pkt_list_lock);
+       spin_lock_bh(&vsock->pkt_queue.lock);
        skb_queue_splice_init(&vsock->pkt_queue, &pkts);
-       spin_unlock_bh(&vsock->pkt_list_lock);
+       spin_unlock_bh(&vsock->pkt_queue.lock);

        while ((skb = __skb_dequeue(&pkts))) {
                virtio_transport_deliver_tap_pkt(skb);
@@ -132,7 +129,6 @@ static int __init vsock_loopback_init(void)
        if (!vsock->workqueue)
                return -ENOMEM;

-       spin_lock_init(&vsock->pkt_list_lock);
        skb_queue_head_init(&vsock->pkt_queue);
        INIT_WORK(&vsock->pkt_work, vsock_loopback_work);

@@ -156,9 +152,7 @@ static void __exit vsock_loopback_exit(void)

        flush_work(&vsock->pkt_work);

-       spin_lock_bh(&vsock->pkt_list_lock);
        virtio_vsock_skb_queue_purge(&vsock->pkt_queue);
-       spin_unlock_bh(&vsock->pkt_list_lock);

        destroy_workqueue(vsock->workqueue);
 }

