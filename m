Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736F822E867
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgG0JGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgG0JGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED150C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:06:17 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyDZ/wrPkSHROwMI+XHFAkpo76daJjKonwUU6cDdr/o=;
        b=ZwjmGuITOukhNb4sOkN+dbIPWNJnNxnjY8HjLWLIC0gsxrCRMkSdXF+ZBCEYxGsJQdsPCW
        UlE14519Q9fl8A17e8z9jMkpJ/aMqZvnN4JzhX2YN3hHdPwZSkbMMtq5ji4aargZku6BNb
        ugdEyTHFrfFF9OvuTMhlT9m2UqbSFgfEot2rz+HjNLNfihRbHBBgzWlT+hbVbBaB8fuXYE
        N731OHxyUXnLMjUK+4a6YIvhVACanTdwqDEm/2vy4ZdG9AqC6VrxJUYG5+k0VRIbSBakPK
        mEc4S7G9e8Fwq9Qyd2DL6lB//N+U9L7YRJjhZu06YQy70Etfu54MyEPkx6Fgkw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyDZ/wrPkSHROwMI+XHFAkpo76daJjKonwUU6cDdr/o=;
        b=yXHz/WOJgHZy70K9lmQho6DZoCXZ3f0Q/A2xScUCu5SHEj54ojccemCREKlAsvBU5AhHyR
        iYOSWpY043PiIuAg==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
Date:   Mon, 27 Jul 2020 11:05:56 +0200
Message-Id: <20200727090601.6500-5-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to reduce code duplication between ptp drivers, generic helper
functions were introduced. Use them.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 32 ++++---------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 9650562fc0ef..ca8090a28dec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -314,11 +314,9 @@ static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
 			      u8 *p_message_type,
 			      u16 *p_sequence_id)
 {
-	unsigned int offset = 0;
 	unsigned int ptp_class;
-	u8 *data;
+	struct ptp_header *hdr;
 
-	data = skb_mac_header(skb);
 	ptp_class = ptp_classify_raw(skb);
 
 	switch (ptp_class & PTP_CLASS_VMASK) {
@@ -329,30 +327,14 @@ static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
 		return -ERANGE;
 	}
 
-	if (ptp_class & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
-
-	switch (ptp_class & PTP_CLASS_PMASK) {
-	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
-		break;
-	case PTP_CLASS_IPV6:
-		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
-		break;
-	case PTP_CLASS_L2:
-		offset += ETH_HLEN;
-		break;
-	default:
-		return -ERANGE;
-	}
-
-	/* PTP header is 34 bytes. */
-	if (skb->len < offset + 34)
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
 		return -EINVAL;
 
-	*p_message_type = data[offset] & 0x0f;
-	*p_domain_number = data[offset + 4];
-	*p_sequence_id = (u16)(data[offset + 30]) << 8 | data[offset + 31];
+	*p_message_type	 = ptp_get_msgtype(hdr, ptp_class);
+	*p_domain_number = hdr->domain_number;
+	*p_sequence_id	 = be16_to_cpu(hdr->sequence_id);
+
 	return 0;
 }
 
-- 
2.20.1

