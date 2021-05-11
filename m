Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4977379EC1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhEKEog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbhEKEoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:44:32 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B2FC06175F
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:22 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l24-20020a7bc4580000b029014ac3b80020so448352wmi.1
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwaKQDmQQxJQV6OXbMRvBq98650xZ8vtis+SN2tPPHc=;
        b=cUN8rJ9cxcb5J6kh+EpJHFwm6r407tanaasfSpuHrGBM+kNjPeuj+uFStN0RAyeYO2
         G7ZGTP5X4SVe+KtQutvXBZDfqcDiuskFS3LGFUH2BRfM9lRvRLN0hKenJODEmwH3MYSx
         cauxYNlkBpoVwDHMP7d9Kn04PWpufgsktbdx+tXD2qVh7s1mG7xpm4WItZHcC2CXAly/
         UVWK36bjkh2N+7p+DJfuraSMYBSlv+TZLPEXdCcUBZyVhgbCrtnEmTD+CkVLh5ZbYhWI
         BmZhfvJ0CkntkYidpQZApE2hWLUZMQ0OSV70dYLDAgnLX+fGTMG6C36Mxba+O8TpQFqJ
         XEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwaKQDmQQxJQV6OXbMRvBq98650xZ8vtis+SN2tPPHc=;
        b=mbtrrrEtXOyDtzEylVJQcsM8/EZW/T4uzyiPGHDeaOaLV3hYyHqI9ac9XX1zbcZ23m
         xSmacjniIvKfcT4EnQ30K7G+W28K+8sxPMz0jikRDLZTD0ubzpnERwR3w4h/u0HJuQEN
         8QBjxxqQq8kV43JaK1nTC3YRco6+WEzWdqq8zIrmIbVc7ELV6j4CieEAByOck/9jZ3RF
         mVUNXJGn01Lsg9cQUjsHOcmkZmJdhXbCGQ6Vn6UQrCvFv76YlhCXCcsW+xX4YkSziBq1
         Id0S1AKg7aYTbfw69+ustJ7YqKDR4Wfhe4P0l7zFPFI0q4GE64Ej3JTm5F2GTccsC2NT
         4+8Q==
X-Gm-Message-State: AOAM5333Q1WJK6pdIcubabTicppGY8NP77ZO5q9Ztx7jilcrqF7JZEX5
        uLDuI7ZmCr6WuUzbylaLWwD1Qg==
X-Google-Smtp-Source: ABdhPJwHj435BmybraousVJN/rIUlLcWFmieWSwFi/CAKzS4FDUSyjNRR06B441/KbZuzZumpB1OVw==
X-Received: by 2002:a1c:1b49:: with SMTP id b70mr30552226wmb.147.1620708201504;
        Mon, 10 May 2021 21:43:21 -0700 (PDT)
Received: from f1.Home (bzq-79-180-42-161.red.bezeqint.net. [79.180.42.161])
        by smtp.gmail.com with ESMTPSA id a9sm22360520wmj.1.2021.05.10.21.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:43:21 -0700 (PDT)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com
Subject: [PATCH 1/4] virtio-net: add definitions for host USO feature
Date:   Tue, 11 May 2021 07:42:50 +0300
Message-Id: <20210511044253.469034-2-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210511044253.469034-1-yuri.benditovich@daynix.com>
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define feature bit and GSO type according to the VIRTIO
specification.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 include/uapi/linux/virtio_net.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f11..a556ac735d7f 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -57,6 +57,7 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 
+#define VIRTIO_NET_F_HOST_USO     56	/* Host can handle USO packets */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -130,6 +131,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
-- 
2.26.3

