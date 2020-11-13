Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C492B27A2
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgKMWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgKMWAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 17:00:14 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58533C0613D1;
        Fri, 13 Nov 2020 14:00:03 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id s13so11900383wmh.4;
        Fri, 13 Nov 2020 14:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJDHbVxmljjr/AYsCXc9o3KZG1HvW/C1qabfSaGvuZE=;
        b=qOuQECzspQpufTvB4CLOXuQzlwR9my/1nZMJs/MAhADk1sMxYRP+lUMdtkVt8Izxei
         +brev/+TdJwoW4HO7ChQ7fxKcmVn6FNqlzHFYockXCoktSGq6LoN4hqpZFeVFP8EQkwB
         osNz1BqVu56/EKJFaeQDRhZzllbJQN/4M9mb87SMGj38OtrbnN3yq+VB0UbxWRpdAOQA
         dRgtrGeakkYoM2t6L9QalhjMdCFlkEotHfb3HixPq6U+Gy1kVb8zg90jargz75jjlAgN
         WdgzynUGLbeGrgRyTZqTZ5eDTd/ozpWI21hxMVyOuyunUqG9LSG+lPdhGehvp86y/86P
         cr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJDHbVxmljjr/AYsCXc9o3KZG1HvW/C1qabfSaGvuZE=;
        b=ttTibj1HePu9MEtn1QlURD0YbHL7p/dX7BbCLuxgziCcDy4qHtQQebufe2OC+znXGn
         ABa4mo/5o09hnbOPjc0XFGBAHSUqyizvz+NEaJoovf6OYJdZN8LMI3uCOiKqX0xBUqO1
         tHJNupL9bi8oBbYRBChz4Cs3nCupErWe9h5UiiaKjp8gycDuc5oIlXSpuJQWho1yupr7
         pOH/psONiPNhL1iH8uDMhJsmRDQXyeOdZG1ToZCs2zpnYo6TMb77bkWHx2M/NqBBXNZ3
         Kr7nkNNPBKU6Wc3ytjlCm8ZT4BTmPjHY0LwLuOiniDmfZVa4ny69QOnOBAApqT0foa5+
         QLqw==
X-Gm-Message-State: AOAM533arSO8uXzQo8qr9ikekvYiuYD9qCVOQe1Rj3qrqmZJcc4tg1l+
        Mr8Dz8Q73vmn8w2rUP6E4IY=
X-Google-Smtp-Source: ABdhPJzmOF140+GM/uzKSfSyUBSEyjs3iZNILVDTBnGKwpM7cNDAMm78wvigEdI1M0U0zdSQ21+Vzw==
X-Received: by 2002:a7b:c00b:: with SMTP id c11mr4468983wmb.122.1605304801977;
        Fri, 13 Nov 2020 14:00:01 -0800 (PST)
Received: from ubux1.bb.dnainternet.fi (81-175-130-136.bb.dnainternet.fi. [81.175.130.136])
        by smtp.gmail.com with ESMTPSA id h81sm11769920wmf.44.2020.11.13.14.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 14:00:01 -0800 (PST)
From:   Lev Stipakov <lstipakov@gmail.com>
X-Google-Original-From: Lev Stipakov <lev@openvpn.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Lev Stipakov <lev@openvpn.net>
Subject: [PATCH v3] net: xfrm: use core API for updating/providing stats
Date:   Fri, 13 Nov 2020 23:59:40 +0200
Message-Id: <20201113215939.147007-1-lev@openvpn.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <f1238670-7d0a-2311-7ee5-c254c8ef2a22@gmail.com>
References: <f1238670-7d0a-2311-7ee5-c254c8ef2a22@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
stats.

Use this function instead of own code.

While on it, remove xfrmi_get_stats64() and replace it with
dev_get_tstats64().

Signed-off-by: Lev Stipakov <lev@openvpn.net>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 v3: no code changes, just send separate patch instead of series as
requested
 v2: replace xfrmi_get_stats64() vs dev_get_tstats64()

 net/xfrm/xfrm_interface.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 9b8e292a7c6a..697cdcfbb5e1 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -319,12 +319,7 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 
 	err = dst_output(xi->net, skb->sk, skb);
 	if (net_xmit_eval(err) == 0) {
-		struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
-
-		u64_stats_update_begin(&tstats->syncp);
-		tstats->tx_bytes += length;
-		tstats->tx_packets++;
-		u64_stats_update_end(&tstats->syncp);
+		dev_sw_netstats_tx_add(dev, 1, length);
 	} else {
 		stats->tx_errors++;
 		stats->tx_aborted_errors++;
@@ -538,15 +533,6 @@ static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 	return err;
 }
 
-static void xfrmi_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *s)
-{
-	dev_fetch_sw_netstats(s, dev->tstats);
-
-	s->rx_dropped = dev->stats.rx_dropped;
-	s->tx_dropped = dev->stats.tx_dropped;
-}
-
 static int xfrmi_get_iflink(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
@@ -554,12 +540,11 @@ static int xfrmi_get_iflink(const struct net_device *dev)
 	return xi->p.link;
 }
 
-
 static const struct net_device_ops xfrmi_netdev_ops = {
 	.ndo_init	= xfrmi_dev_init,
 	.ndo_uninit	= xfrmi_dev_uninit,
 	.ndo_start_xmit = xfrmi_xmit,
-	.ndo_get_stats64 = xfrmi_get_stats64,
+	.ndo_get_stats64 = dev_get_tstats64,
 	.ndo_get_iflink = xfrmi_get_iflink,
 };
 
-- 
2.25.1

