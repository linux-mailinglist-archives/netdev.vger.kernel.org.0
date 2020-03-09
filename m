Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7391417EC5A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgCIW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:57:04 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:43670 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIW5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:57:04 -0400
Received: by mail-vk1-f202.google.com with SMTP id x192so5198442vke.10
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=CyxqwqU/HawUXNIl+Vo5nROfAgnEl4ARWTeRcK3C8nk=;
        b=XCSNKIilTH2gkwMhosZMvZsWJX0OttYGIwolpzwXWBBaAT0jfNP9Ypg6sYBkeubyj3
         Qt3mrBhGKofsXqSb7KfoAPwJyPsQ8r4ezBpstKmO1+mEw3R7Uo07sQFNOEZfUN9hJKev
         /JXdwpPvcGEzwsQdKSZheFvtGyDqhK0fANNu7MEmDKRrD/lFWF/bBYLO7KEl8ca2Jp1a
         Jv+63TtgXOUp4We1Ly+kxyzXOnh3sK9TyEPnbeY2b1LIdrX+lZPp5aiy9W6FmeSuFPhV
         orFsUVhKWSTrE8cy42KpYgJczjl+Sjbg58v2KDx+vvVMdrQSJkZrU9M43M5bVj6J5r7O
         JNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=CyxqwqU/HawUXNIl+Vo5nROfAgnEl4ARWTeRcK3C8nk=;
        b=Lc2wqtAsgEdrfago6lU0GrHT8afA4RWFS6FGTCuihB4bARjeH33gCh9hFHlhC2Ns+v
         450AQ3zgEMLexWV1+Kg/9MJiNvLMhH3vUcwLjiKC6LEpRUeZ5yuOH5RgQ2+u0l/X5un6
         dOr6+rmsxxDJXDOKPVCo3FTsNmc7n9rAIxXlemuY8G0uQmnkEqm+s0sYxE2ZiW5ucP+p
         UErYILJkl417mgHpGOz0dVmQuemD3WCF3ptPLUMweMindF6lSgRFQhMIYSp4+k6NoZaY
         Gmv5zwNusIcqfPma+HLncbFqqrYrSyiP//YP3RIlsMY/vqVnyuO9kUdLi4vcmokJTWRx
         FClw==
X-Gm-Message-State: ANhLgQ2MjLanedOhzSlUn45gCMh4HInv/UIODkz6SgjbLH7H7tlU6EB4
        ytUt+wjwkxI25qGnj1kIhM/ei8nP80gf
X-Google-Smtp-Source: ADFU+vvY2mPO2TMvmldMSXpDYJ7ZVqOTRfU3gtvIcoPuoEP38Iqk8E9Xq8T1U8LY8wELzlhgVjlAgJlO6BQ6
X-Received: by 2002:ab0:7656:: with SMTP id s22mr10500885uaq.79.1583794621452;
 Mon, 09 Mar 2020 15:57:01 -0700 (PDT)
Date:   Mon,  9 Mar 2020 15:56:56 -0700
Message-Id: <20200309225656.61933-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] ipvlan: don't deref eth hdr before checking it's set
From:   Mahesh Bandewar <maheshb@google.com>
To:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPvlan in L3 mode discards outbound multicast packets but performs
the check before ensuring the ether-header is set or not. This is
an error that Eric found through code browsing.

Fixes: 2ad7bf363841 (=E2=80=9Cipvlan: Initial check-in of the IPVLAN driver=
.=E2=80=9D)
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Reported-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_c=
ore.c
index 30cd0c4f0be0..53dac397db37 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -498,19 +498,21 @@ static int ipvlan_process_outbound(struct sk_buff *sk=
b)
 	struct ethhdr *ethh =3D eth_hdr(skb);
 	int ret =3D NET_XMIT_DROP;
=20
-	/* In this mode we dont care about multicast and broadcast traffic */
-	if (is_multicast_ether_addr(ethh->h_dest)) {
-		pr_debug_ratelimited("Dropped {multi|broad}cast of type=3D[%x]\n",
-				     ntohs(skb->protocol));
-		kfree_skb(skb);
-		goto out;
-	}
-
 	/* The ipvlan is a pseudo-L2 device, so the packets that we receive
 	 * will have L2; which need to discarded and processed further
 	 * in the net-ns of the main-device.
 	 */
 	if (skb_mac_header_was_set(skb)) {
+		/* In this mode we dont care about
+		 * multicast and broadcast traffic */
+		if (is_multicast_ether_addr(ethh->h_dest)) {
+			pr_debug_ratelimited(
+				"Dropped {multi|broad}cast of type=3D[%x]\n",
+				ntohs(skb->protocol));
+			kfree_skb(skb);
+			goto out;
+		}
+
 		skb_pull(skb, sizeof(*ethh));
 		skb->mac_header =3D (typeof(skb->mac_header))~0U;
 		skb_reset_network_header(skb);
--=20
2.25.1.481.gfbce0eb801-goog

