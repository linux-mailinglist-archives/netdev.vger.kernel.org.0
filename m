Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B472871DA
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgJHJsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgJHJsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:48:53 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E788C061755;
        Thu,  8 Oct 2020 02:48:53 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a200so3532524pfa.10;
        Thu, 08 Oct 2020 02:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OIF6t/bkwPTd2fAU92sAxQjFTr7embsKbRfu4pfoVNA=;
        b=BCn2JiAF7Th8ob+cehe5PeoWn45+qgdfVzWriehIM37Pjw1qIpHmQ77MV3gEx9o9zG
         DJPClkg8hRekeSRhByjVu4/Olo7kYHf16lgDaZ1s3daBXRecMriAmDS2Wk7p00pYjluL
         WWAoyKHQwKcrTAxmUbwZ6Xzaq+U+hQvSrCGlq2gPZmJlC+0r4RZVDynShpFnlnaQgLHL
         3gHPxjSaCmdFXLIfUYvs253vJhytKbUJNpbK5VlFpB9A7nIbTxXEdEPxVrsSncJ7MmoV
         Z2ydiPanuMpDx0xtTPLOowCwCfc1knZ4R5fkSMdbExhVFgLCVANuq8XIXDuIqofTMmik
         +gxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OIF6t/bkwPTd2fAU92sAxQjFTr7embsKbRfu4pfoVNA=;
        b=RxyEly7gyFIA0pch8bmTQ6J7Z6T4/twr4qwlhZW8GHkqSSiFwIozLbW18xmht7XN4Y
         5OazcNxHdVN4Jtu9LzpVMtz7Tkuu1spvt61ckEiOoTwsukkWk6YO09lsOYsOjWznaxPR
         Y/M8vBntWk0Q0cCgxwf7x08Im7HBLoKrOqhn2ZgGkjBPhPik8cdmvRkbxl8ov1yLDODK
         OrbQn7ACETf+BDPKoWyI6csHdWM0Zw5lKOeQgnoWkjqKJ5SKBe1/INMbIdTaQopVO2pB
         X11LCNGhiS74wxe1qJlHC1epMboyLykSyrmr/T/rGlQuUNBbyONmyZ9DeDwmU+1Y0rBh
         eGpg==
X-Gm-Message-State: AOAM530Uq76b8tMpFrSaIMxd39VdPKlku4H4CzPEAv/Z2t0MR2X2qTGv
        Esx5FV89goJMHAVpFTF7UBsmwODKm6w=
X-Google-Smtp-Source: ABdhPJwt2cXJX1tqOTnQffkOggjjUe+wGndIxTdoz3P7nhTmUKlGXcCN5o+1Hs3LVHtBtwbT25u/vQ==
X-Received: by 2002:a17:90b:384c:: with SMTP id nl12mr7384081pjb.166.1602150532943;
        Thu, 08 Oct 2020 02:48:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h9sm6170652pfh.213.2020.10.08.02.48.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:48:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 04/17] udp: support sctp over udp in skb_udp_tunnel_segment
Date:   Thu,  8 Oct 2020 17:48:00 +0800
Message-Id: <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To call sctp_gso_segment() properly in skb_udp_tunnel_segment() for sctp
over udp packets, we need to set transport_header to sctp header. When
skb->ip_summed == CHECKSUM_PARTIAL, skb_crc32c_csum_help() should be
called for the inner sctp packet.

Cc: Tom Herbert <tom@herbertland.com>
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

