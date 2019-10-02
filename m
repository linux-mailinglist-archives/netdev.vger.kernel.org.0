Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0CC9502
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfJBXiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:38:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34572 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbfJBXh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:37:58 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so5982674wmc.1
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qQSzNitpvdHS6kOolE9IO5IH7oQr1k8gUdzsz0ePNYc=;
        b=t6G0mm8r9cXYH/OoNyH18Ebf32Mp8ROPst4Y2YpENC7zuQ3N7CRnslQRpPeo8cWOoP
         uWqVCL1As0mZ58B7PX6rLgVKBQEMfKo47Yo7sdcdBCew2U4oDVOyGIhAgs7rZHsKejSp
         vFhWsTF9P32FIOK+DXV314vMWgeCMn1OLjyduVfGAPugfWBwzLJ3W+8PY0OLshAcruNq
         s4izi474e0zraX/Kv6+EqIm0Agy8ib/pMwG6qnyNIoXVuqOPagFddiKSuo/DLEHSlTs0
         zKyWJwQ5tRCBQqS2vwHv/HTw650IbhbU0+TUoULcoFKSM6HRr7H7um2TALGtAxtKTy6I
         xZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qQSzNitpvdHS6kOolE9IO5IH7oQr1k8gUdzsz0ePNYc=;
        b=C2tR19ODXMtEnqbPeOwW/T5yMOZE02S5C736WRykLb6OYuPDMyWmgqqcu5Buw+jvhP
         Us54AF4C+gWSl9OW31fV8pRGwBQ1VR9fKNb4CsQuXozErJnxB6ywzeTKr59OlkGGv7tG
         Y2hUBtNEfMZzePRA4BzFYnvEOFcWy6MVE92uxl54jFAtSVFFvMFXU4e1fZiD+aCkAYcG
         kMy0uGSdxk3QZADnySYMbAzw3GzfrADDaYAqG/HM/6hp7pTx22ZaLHaYAO63zTqamEL+
         itP2tGwSaOjZccy1tl2/DHzbdG3HUhUBRodAauuunLP15MO2VISvFxTJaooK1XsA4suN
         PKvw==
X-Gm-Message-State: APjAAAWDDiNP3F9fBy75YEcN+yZ41wTyb30J0UGAkm+ntAX+rrfPXFP+
        XCUEmcLB5GG7JNHBl1Ra+oA=
X-Google-Smtp-Source: APXvYqzoI13vvMAOyZWQpCdix4meNaIQyV8/L7G8Hbapc6U/XDqCFVUhnHfMPMiqUeZTi7uc1Ic17w==
X-Received: by 2002:a1c:3bd6:: with SMTP id i205mr4527643wma.135.1570059476271;
        Wed, 02 Oct 2019 16:37:56 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id s10sm934251wmf.48.2019.10.02.16.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 16:37:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: Allow port mirroring to the CPU port
Date:   Thu,  3 Oct 2019 02:37:50 +0300
Message-Id: <20191002233750.13566-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On a regular netdev, putting it in promiscuous mode means receiving all
traffic passing through it, whether or not it was destined to its MAC
address. Then monitoring applications such as tcpdump can see all
traffic transiting it.

On Ethernet switches, clearly all ports are in promiscuous mode by
definition, since they accept frames destined to any MAC address.
However tcpdump does not capture all frames transiting switch ports,
only the ones destined to, or originating from the CPU port.

To be able to monitor frames with tcpdump on the CPU port, extend the tc
matchall classifier and mirred action to support the DSA master port as
a possible mirror target.

Tested with:
tc qdisc add dev swp2 clsact
tc filter add dev swp2 ingress matchall skip_sw \
	action mirred egress mirror dev eth2
tcpdump -i swp2

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 75d58229a4bd..5db0a4f45e7b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -872,7 +872,7 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 	__be16 protocol = cls->common.protocol;
 	struct dsa_switch *ds = dp->ds;
 	struct flow_action_entry *act;
-	struct dsa_port *to_dp;
+	const struct dsa_port *to_dp;
 	int err = -EOPNOTSUPP;
 
 	if (!ds->ops->port_mirror_add)
@@ -889,7 +889,11 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 		if (!act->dev)
 			return -EINVAL;
 
-		if (!dsa_slave_dev_check(act->dev))
+		if (dsa_slave_dev_check(act->dev))
+			to_dp = dsa_slave_to_port(act->dev);
+		else if (act->dev == dp->cpu_dp->master)
+			to_dp = dp->cpu_dp;
+		else
 			return -EOPNOTSUPP;
 
 		mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
@@ -900,8 +904,6 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
 		mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
 		mirror = &mall_tc_entry->mirror;
 
-		to_dp = dsa_slave_to_port(act->dev);
-
 		mirror->to_local_port = to_dp->index;
 		mirror->ingress = ingress;
 
-- 
2.17.1

