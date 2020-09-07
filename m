Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ABE2606CF
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 00:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgIGWEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 18:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgIGWEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 18:04:20 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355DC061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 15:04:19 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DFFF8891B0;
        Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1599516254;
        bh=t9kWVwdz3UiadOPYbUab6wnQhbmCb906FDfP3HnvERU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=emT8VmPSwjkWoVPlpkR32uaj6y6asl68EWpHtj5Z0Xew9nbL7F7MpLhU0khGvdJhQ
         ZFaYQlyv9RVwLwmrSyZGqpsalef2iRBXQXu8SeMX8UNbNTffXLqvgRtBJswu7Qi+Us
         eTmonRFXfv1fOdrrMz9jM8xFurLalb79wFJtYqFqnqfDnGFq999m82YdgMkLNWDUUW
         IyXBdW+tWpnbRDziW2bYdllDXbqGWL2DsGinhWtCA27mmg1ctCTCFTruH7En6wr1Fs
         sBoIna176ATZ4zhWepJzo4gyWzM/+Og8DqkB4AHwoJE/Lz2ghcboL8a4A3sf6Il+LV
         8D6e6gGt7/Jgg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f56ae5e0002>; Tue, 08 Sep 2020 10:04:14 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.16])
        by smtp (Postfix) with ESMTP id CABCB13EEBA;
        Tue,  8 Sep 2020 10:04:13 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 7EFC21E3851; Tue,  8 Sep 2020 10:04:14 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>
Subject: [PATCH net-next v2 2/3] ipmr: Add high byte of VIF ID to igmpmsg
Date:   Tue,  8 Sep 2020 10:04:07 +1200
Message-Id: <20200907220408.32385-3-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
References: <20200907220408.32385-1-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the unused3 byte in struct igmpmsg to hold the high 8 bits of the
VIF ID.

If using more than 255 IPv4 multicast interfaces it is necessary to have
access to a VIF ID for cache reports that is wider than 8 bits, the VIF
ID present in the igmpmsg reports sent to mroute_sk was only 8 bits wide
in the igmpmsg header.  Adding the high 8 bits of the 16 bit VIF ID in
the unused byte allows use of more than 255 IPv4 multicast interfaces.

Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
---
 include/uapi/linux/mroute.h | 4 ++--
 net/ipv4/ipmr.c             | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mroute.h b/include/uapi/linux/mroute.h
index 918f1ef32ffe..1a42f5f9b31b 100644
--- a/include/uapi/linux/mroute.h
+++ b/include/uapi/linux/mroute.h
@@ -113,8 +113,8 @@ struct igmpmsg {
 	__u32 unused1,unused2;
 	unsigned char im_msgtype;		/* What is this */
 	unsigned char im_mbz;			/* Must be zero */
-	unsigned char im_vif;			/* Interface (this ought to be a vifi_t!) */
-	unsigned char unused3;
+	unsigned char im_vif;			/* Low 8 bits of Interface */
+	unsigned char im_vif_hi;		/* High 8 bits of Interface */
 	struct in_addr im_src,im_dst;
 };
=20
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 19b2f586319b..4809318f591b 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1038,10 +1038,13 @@ static int ipmr_cache_report(struct mr_table *mrt=
,
 		memcpy(msg, skb_network_header(pkt), sizeof(struct iphdr));
 		msg->im_msgtype =3D assert;
 		msg->im_mbz =3D 0;
-		if (assert =3D=3D IGMPMSG_WRVIFWHOLE)
+		if (assert =3D=3D IGMPMSG_WRVIFWHOLE) {
 			msg->im_vif =3D vifi;
-		else
+			msg->im_vif_hi =3D vifi >> 8;
+		} else {
 			msg->im_vif =3D mrt->mroute_reg_vif_num;
+			msg->im_vif_hi =3D mrt->mroute_reg_vif_num >> 8;
+		}
 		ip_hdr(skb)->ihl =3D sizeof(struct iphdr) >> 2;
 		ip_hdr(skb)->tot_len =3D htons(ntohs(ip_hdr(pkt)->tot_len) +
 					     sizeof(struct iphdr));
@@ -1054,6 +1057,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 		ip_hdr(skb)->protocol =3D 0;
 		msg =3D (struct igmpmsg *)skb_network_header(skb);
 		msg->im_vif =3D vifi;
+		msg->im_vif_hi =3D vifi >> 8;
 		skb_dst_set(skb, dst_clone(skb_dst(pkt)));
 		/* Add our header */
 		igmp =3D skb_put(skb, sizeof(struct igmphdr));
--=20
2.28.0

