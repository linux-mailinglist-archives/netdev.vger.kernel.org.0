Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2D627CFD8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgI2Nty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730546AbgI2Ntx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:49:53 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4579C061755;
        Tue, 29 Sep 2020 06:49:53 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so4587824pfn.9;
        Tue, 29 Sep 2020 06:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=DEGAv+/TL4OwKmD7pxgq0o5h8o/m1hgKFquGraoWa10=;
        b=Od+22kLyLfZGF1lUP20MY0VPBN51cMfn9C2QJiJBRbjnHnyOfDceh8eZvVzrDEPxxg
         AeCDj+MJ0YGbI7c/jBa9V2cjUUMgU8YP4ydnffWoQGhjBL3Oku2Y0zL3BGqudhdUugS3
         OAnng6Ushsx6cBWFAtCmWdgQ0DvLRNo0KLwPpvSkMhGdQRBn+w3q3dkjfTT5P6u7qfys
         UHogQsR4qq84QJ6wMnG4fD/MFKIEi/U4N0+0Om7izRLfxkNXYx+sUPJwW6a0omVyP/BW
         TPvzEwFRwawHCW3a15WctmN93LJtxhtxqrA+iMZAS+2s4GB31CCMKsBBIT75ozjbsR68
         /MVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=DEGAv+/TL4OwKmD7pxgq0o5h8o/m1hgKFquGraoWa10=;
        b=muLz4iDmulW4VlMo+32ajPaq5zv0X+uUyiu4xO35Esyvgo0vcu/0KJnVM9EZVDdCIC
         AtnTbOEasTInCoOSYM+zOx2FqPOro5PslBbOsda8hx0bk997RQHP3Znpa+7dXcdbboEC
         95ZLCGnXS0N95c/pj0YXxw8XBh9B01fJDah8g8ZiyRmlr/+Jy0N9x9BIWrijPKe8ee9m
         qIhzOiPuBcB+Je8UIrYmZsw0xDnCUp/SHQq2haKFC2qz8JMUvWGjNYPz9QVQP2PCPyr+
         FlHbpySMFpVgGAe6OuhibC+mxEDpcTGRnDqhhB9OtDi0cZR7vUdTX8SXbX7IllDfgY93
         ls3Q==
X-Gm-Message-State: AOAM531E+y3TTXdBsQ/HQdpt4NbyA1p7Co5BM7SRPJtM5aZErcy/hMfT
        qdbaYDtOtM06kjeEQLJCCiTFjkscWu0=
X-Google-Smtp-Source: ABdhPJxHR7k0IzIpzEzM2dHN/rE7gpjlXoELLo37dLXPL5/Wi9D6ymrLEjlZq2RgKt2Sqbrfhx/ZTQ==
X-Received: by 2002:a63:e252:: with SMTP id y18mr3334454pgj.93.1601387392947;
        Tue, 29 Sep 2020 06:49:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gm17sm4672531pjb.46.2020.09.29.06.49.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:49:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 04/15] udp: support sctp over udp in skb_udp_tunnel_segment
Date:   Tue, 29 Sep 2020 21:48:56 +0800
Message-Id: <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To call sctp_gso_segment() properly in skb_udp_tunnel_segment() for sctp
over udp packets, we need to set transport_header to sctp header. When
skb->ip_summed == CHECKSUM_PARTIAL, skb_crc32c_csum_help() should be
called for the inner sctp packet.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp_offload.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index c0b010b..a484405 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -49,6 +49,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	__skb_pull(skb, tnl_hlen);
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb_inner_network_offset(skb));
+	skb_set_transport_header(skb, skb_inner_transport_offset(skb));
 	skb->mac_len = skb_inner_network_offset(skb);
 	skb->protocol = new_protocol;
 
@@ -131,8 +132,12 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 		uh->check = ~csum_fold(csum_add(partial,
 				       (__force __wsum)htonl(len)));
 
-		if (skb->encapsulation)
-			skb_checksum_help(skb);
+		if (skb->encapsulation) {
+			if (skb->csum_not_inet)
+				skb_crc32c_csum_help(skb);
+			else
+				skb_checksum_help(skb);
+		}
 
 		if (offload_csum) {
 			skb->ip_summed = CHECKSUM_PARTIAL;
-- 
2.1.0

