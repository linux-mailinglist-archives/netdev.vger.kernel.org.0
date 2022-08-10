Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40B58EFBC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiHJPwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiHJPv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F251552DF0;
        Wed, 10 Aug 2022 08:51:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id q1-20020a05600c040100b003a52db97fffso1192915wmb.4;
        Wed, 10 Aug 2022 08:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=I6HOvD/OHCC6U7VTSloH8Bzb7BhYYX9aNTArIgD6mXg=;
        b=CvZ+o5GyX9Cl58rR5XQmVQ/WnA/GRIRdZxP33Dzgj6r9DPlQRphs6yOhzWqdULKen9
         gMmXHh/unAvJbQnQA9hJTCa2uvfKeDglP05vwYf7ACs1xU/sY79GVh0ja78nBVBuQos9
         At2FAi3HtK9PCPmiPaAo3PGgSrGuJe4zvs8ZzOggBwh7U2mW5q2DaPPvVs8/T9wnfdXz
         94FcpAUm2zJ0X95SveH+CL7kQAQJnVwYQOQrhReSHaP1tz8rIPU18lNRtSV+dGg7djft
         87OokEhFNIW6wyCD9lMh9IYzKCch26fi5GrPIxaxnKIQEuRdYWpJJ4Lz0KAThc69LX2g
         ITgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=I6HOvD/OHCC6U7VTSloH8Bzb7BhYYX9aNTArIgD6mXg=;
        b=JPNyq2yj6MpV1IiFffvq9BmCGwVRPHU7LAqfCAsfawNsW/wD0yH5eiYhp0wpqurYGg
         CwK1a3vk4awqM/tfP4oRtwUGnkC504bC5Tgy6BfesMebMKJ9UlIZ6KUyz1RsH4nu3Nb7
         P0t90kIZoE5LrnQw2jpXhOyBvhBC9nDzBoz+Xp39RQTdAtwug0r89aApV6y/+VuIps5t
         ++NIlvDRlGn4fKnp/suZBSJYr84uRzwbrKOwSuIBGmK3X6lL9BoRno0ViwUeKFRWrhxi
         s8qtnq0OLV3tCjcPJhY7+xBbEhO0auz2Z+MiU9o1IJmWIakpA1GZG2QUybqOXkBTy+zk
         eQiQ==
X-Gm-Message-State: ACgBeo2/r5lwgiNUro3kkCV8765Dgm0nl8ZBna97gcP+fy3+FNFP4rfC
        Ym8YynHN3wXXODR0ZSUP36HavzYC/DE=
X-Google-Smtp-Source: AA6agR45he4dyQKI12poNM8AGSPq8F4/kGUNUT0s11gtoLe3WPA20HuKlateIe0Lr4uUnp3aBCdobA==
X-Received: by 2002:a05:600c:1e05:b0:3a5:b441:e9c with SMTP id ay5-20020a05600c1e0500b003a5b4410e9cmr2221515wmb.24.1660146704771;
        Wed, 10 Aug 2022 08:51:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 06/11] net: add flags for controlling ubuf_info
Date:   Wed, 10 Aug 2022 16:49:14 +0100
Message-Id: <433971d77b5a757b11ce5683ef1d0377efcc8544.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are already skb_flags in ubuf_info, which enhancing skbs. Also add
flags controlling ubuf_info, mainly to hint about various referencing
aspects of it, which will be introduced in later patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 1 +
 io_uring/notif.c       | 1 +
 net/core/skbuff.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e749b5d3868d..2b2e0020030b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -535,6 +535,7 @@ struct ubuf_info {
 			 bool zerocopy_success);
 	refcount_t refcnt;
 	u8 skb_flags;
+	u8 flags;
 };
 
 struct ubuf_info_msgzc {
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 97cb4a7e8849..a2ba1e35a59f 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -66,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
 	nd->uarg.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	nd->uarg.flags = 0;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&nd->uarg.refcnt, 1);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 40bb84986800..7e102373482c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1207,6 +1207,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
 	uarg->ubuf.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	uarg->ubuf.flags = 0;
 	refcount_set(&uarg->ubuf.refcnt, 1);
 	sock_hold(sk);
 
-- 
2.37.0

