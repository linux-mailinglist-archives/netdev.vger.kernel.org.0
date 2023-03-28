Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5F26CC7EB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 18:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjC1Q3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjC1Q3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 12:29:20 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E6ECC2D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:29:18 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id m6so9688557qvq.0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 09:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680020957;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pF7n/Eqo2dEZoKzmZtiE3BnURDQ21G0m3HQyJWfxRsU=;
        b=V3u7TE7LZ8maCIPEsKINGf1if8fTws2/Y7d4jTDkHOvKyU33hdvPtvY9jESgpaWGIF
         0ARloOvRAPwWhd8EhX6QSOxiVDap2H/3cq4bpwwVHjeaUlOPWOm2inUl+oH8OSDMR5M/
         SdaLqA2Ipuvpp+3u7qzn2zoHSP8m+cEOrdfCZaC613Te2whCi7g0YBWEToNwmPcwrkzj
         gfmWX0Rrqrz9dTKco9YZrITp1Rp1BsGmqFkQeVnJTViM0vsaVUd3qrOhs9a2flrtTTXD
         UWm9G8sP18joTGecb8HPnns6+9aqDoHHIU4w0fgb6jJkAvksMVRsNNCF9eTrObnecZRC
         ofNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680020957;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pF7n/Eqo2dEZoKzmZtiE3BnURDQ21G0m3HQyJWfxRsU=;
        b=C42bmGw+syGCeLYI9mXk6kEvzC6MpOYi/hjKR8KKmVa1mjoF3Jm/6Vk45OoUW3x9xC
         wxIpRgRkBZHYeEOoGXkRasNr4VrgGyr4h0vJ92XcQi1Pq1KwzJNT6X7MQCPbutKne8Qk
         ZFY2ishxjniXIFEVnll8g9tXNuiBEoy1qbdGZjE0OsDTMG2Tj8jRlr1oRmII1Kdnn/zU
         ggQ5KDzfD+ZdW9Vp6kfeEnOQJ3E51Rkj7x7NSQXzeKQycZqzSHIs7xz1hhgHXvG1UsCY
         o93+ckkeh22rKOyFM12gh9Ey5yLDLp/Drseij+1B0VLghh+wTwI0K6MJg9GzSTZGdEwG
         TKjA==
X-Gm-Message-State: AAQBX9ejSQfiGZmdY06aVLPl/Ioq7QX46oS+GiXyduU2jbFOZls63SMy
        qYj+Z9NhFDbOU/DaLymm74clgA==
X-Google-Smtp-Source: AKy350YGBbT1TG8n/LqQeEQtBdF+No9E41y7r0rqn3z0VXqcthosfKqjIExYf/RSRKbEbAC9B9vQhQ==
X-Received: by 2002:a05:6214:ac4:b0:56e:a791:37c6 with SMTP id g4-20020a0562140ac400b0056ea79137c6mr31974268qvi.16.1680020957159;
        Tue, 28 Mar 2023 09:29:17 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.215.103])
        by smtp.gmail.com with ESMTPSA id mk5-20020a056214580500b005dd8b93459csm3899644qvb.52.2023.03.28.09.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 09:29:16 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Tue, 28 Mar 2023 16:29:09 +0000
Subject: [PATCH net v2] virtio/vsock: fix leaks due to missing skb owner
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-vsock-fix-leak-v2-1-f6619972dee0@bytedance.com>
X-B4-Tracking: v=1; b=H4sIANQVI2QC/3WOTQ6CMBCFr2Jm7RjaBiGuvIdh0ZapNGhrOqRKC
 He3sHHl8v3lewswJU8Ml8MCibJnH0MR8ngAO+hwJ/R90SArqSolG8wc7YjOf/BBekQjLDlRt1L
 rFsrIaCY0SQc7bLNfm0eD8R0oba1XouLt2BsEmqAr5uB5imner2SxR/+oWaBA5agndW5EVburm
 SfqC5VONj6hW9f1C1Y7DNTbAAAA
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets the skb owner in the recv and send path for virtio.

For the send path, this solves the leak caused when
virtio_transport_purge_skbs() finds skb->sk is always NULL and therefore
never matches it with the current socket. Setting the owner upon
allocation fixes this.

For the recv path, this ensures correctness of accounting and also
correct transfer of ownership in vsock_loopback (when skbs are sent from
one socket and received by another).

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
---
Changes in v2:
- virtio/vsock: add skb_set_owner_r to recv_pkt()
- Link to v1: https://lore.kernel.org/r/20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com
---
 net/vmw_vsock/virtio_transport_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 957cdc01c8e8..900e5dca05f5 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 					 info->op,
 					 info->flags);
 
+	if (info->vsk)
+		skb_set_owner_w(skb, sk_vsock(info->vsk));
+
 	return skb;
 
 out:
@@ -1294,6 +1297,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		goto free_pkt;
 	}
 
+	skb_set_owner_r(skb, sk);
+
 	vsk = vsock_sk(sk);
 
 	lock_sock(sk);

---
base-commit: e5b42483ccce50d5b957f474fd332afd4ef0c27b
change-id: 20230327-vsock-fix-leak-b1cef1582aa8

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

