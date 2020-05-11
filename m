Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABD11CE548
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgEKUVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:21:03 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9AAC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u16so20827981wmc.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QCJsr1bjL/UCzSPEJyWUbWrF4uRYIeBzzCHHqrl9688=;
        b=J3RgWUStUe4rRVTysuYzbwOVzP5gCd6SDVbTSfnSD21eJXuvLS31/vFDV36g0WQKtT
         nDRNbfjotiQaB7uj7zQxdwr1abkiVF/G5poVRDQZPdicxVxieFi4LDnBYFqgZDPAhrmQ
         7RmDVcfYcJ4bJ5E4NzXpt6CB/nlYS7JWWrJQXOP7S8+WIpv/84JvMtXlKVw9OfIy5BKf
         FTh5XakppV+kjqnE+syArv8EJWUE1RDqLOl5ItapfhEKet3wEOL4S6FDVVC0yL1tQc2i
         mJyb9P5b8Ct2SlNADbOwcXaSosWsSgPswNJzV2h0Q4kdZ5V13kAwGtPs+x/jhPpO8BAL
         4Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QCJsr1bjL/UCzSPEJyWUbWrF4uRYIeBzzCHHqrl9688=;
        b=gP01HKu/S0ih8z0+np9aNOSC/+ZawsciKGbLzU84ypUVeT8jWNc4FgtzoBo808wAzw
         rSF4+GDtlfbtxClJ+qd8AYc48myrM/ovI6mJQznF+t2N7JgqpI/GUJdY3dS8lPB8hhle
         RfD52qY1UXohRVpKrb5KG3pvoA9jruMmEDfEhajBpf1IhTQlpGSLR2goPpR6hjgdfWCG
         TMaCHBoihTxkk4ZMeRC1Zw0GZ5pj01WyC9VGljQua/9Ns/j1A/GOJ3xzaGCzpDjO0HyD
         I/V5xnAKSQoNKwG7x+zrihsh/+9WRcoA1xG4EGziKeSth0eIUy6XrwEnch0GQK3gcNQt
         MOHg==
X-Gm-Message-State: AGi0PubZLopyYjXgaBDTOabarViza6htRzrj2ER/5wz6TlqY11+gAhbf
        vrPYnfBbJSeusF+FrKzUSF4=
X-Google-Smtp-Source: APiQypJGiflquim4ZesmfH7XzGXOLUbbvuhuD7XIYfqXwSRCB6ekPNg3C65mwzVFh5ESTE65K+U4Sw==
X-Received: by 2002:a1c:5683:: with SMTP id k125mr32565113wmb.17.1589228461589;
        Mon, 11 May 2020 13:21:01 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 77sm19811305wrc.6.2020.05.11.13.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:21:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: dsa: sja1105: request promiscuous mode for master
Date:   Mon, 11 May 2020 23:20:44 +0300
Message-Id: <20200511202046.20515-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511202046.20515-1-olteanv@gmail.com>
References: <20200511202046.20515-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently PTP is broken when ports are in standalone mode (the tagger
keeps printing this message):

sja1105 spi0.1: Expected meta frame, is  180c200000e in the DSA master multicast filter?

Sure, one might say "simply add 01-80-c2-00-00-0e to the master's RX
filter" but things become more complicated because:

- Actually all frames in the 01-80-c2-xx-xx-xx and 01-1b-19-xx-xx-xx
  range are trapped to the CPU automatically
- The switch mangles bytes 3 and 4 of the MAC address via the incl_srcpt
  ("include source port [in the DMAC]") option, so an address installed
  to the RX filter would, at the end of the day, not correspond to the
  final address seen by the DSA master.

Assume RX filters on DSA masters are typically too small to include all
necessary addresses for PTP to work properly on sja1105, and just
request promiscuous mode unconditionally.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d5de9305df25..786e698b1856 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2080,6 +2080,9 @@ static int sja1105_setup(struct dsa_switch *ds)
 		dev_err(ds->dev, "Failed to configure MII clocking: %d\n", rc);
 		return rc;
 	}
+
+	ds->promisc_on_master = true;
+
 	/* On SJA1105, VLAN filtering per se is always enabled in hardware.
 	 * The only thing we can do to disable it is lie about what the 802.1Q
 	 * EtherType is.
-- 
2.17.1

