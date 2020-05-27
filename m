Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F28A1E4BC1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387994AbgE0RUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387880AbgE0RUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:20:48 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCF9C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:20:47 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id d7so29016359eja.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziZ1nideIllkgVR1CoVHC5kwedtfNJYpZWnysvqa2ds=;
        b=Ec+8xh4e01Dzaf9tgpnKdZRM4PlzCcxRvaJIhWBbV/hR8XpYWJ39zC+rHLB78VUET0
         j+C7BdVuzgLnm8yTBhDHm7tRc3S9BnZ+LdDu5gD4sgz/omHQBa7f/DJEHlgp0EmRBl0o
         eQHngVLKD/2myFjdDb9FeT0y4HIFNINRdCGu5ukFYay1bntfvAWCfUgfdbYUv9NL08jD
         C52UyGUdudRQJaDldWd6CW+BxjJXMT4kbRBj80KVIt5DIJFyIJ4mHosqKnXFgrnXqFEM
         NiqP354DQkmxYNppv1pUkfttHj/5jtYTgk8QFx1DZAGCSC2m+h/xjJ8zXLYQcXy3MLQu
         qpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziZ1nideIllkgVR1CoVHC5kwedtfNJYpZWnysvqa2ds=;
        b=Jh1xruCDD+9Q7QrhrsJwdnLyXzxEBknmPr4hzz9MyINCRpBltvjXpcnP0mhs4L5rl/
         Rvads0F84GRA68QiwTwSns3LMXt9zW3Mi6S6P7GnuhacSmmRkLsElJvtI+DWX+RYcqe2
         4wda3uYAarDHhbJ9olLd18to4544J8CirEqioZb6+s+YCoNMSpsmacdyd/1chK2GuREG
         dFGLf/iFafLtPXS2OW+ss6jI8lLqBtnfNoodGCWyxBoEXRRLtjhs06F/veWREm84iaKH
         mRJalmblOU2PuOQej81jWW65i8n13WbA7nkssgTdgkuUcQvDGgrESdWNKjK9Xe4xeCA2
         g3TQ==
X-Gm-Message-State: AOAM531u1TOjj1JnMf+mJky+ccxiwftVnDc13VY8sjtdo1YKrbjMyzAw
        IjyTW01Lsl/r0XWfPHGPLJFDydKQ
X-Google-Smtp-Source: ABdhPJxuY3aPVklL9b4BWNW5sdZ4iDDTdfE45bc/HOdinqcP6O/ftVMzu2FQX5uXNDLYUTfl+Ooiog==
X-Received: by 2002:a17:906:d216:: with SMTP id w22mr6731324ejz.420.1590600046441;
        Wed, 27 May 2020 10:20:46 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id ca5sm3331259ejb.98.2020.05.27.10.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:20:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: avoid invalid state in sja1105_vlan_filtering
Date:   Wed, 27 May 2020 20:20:38 +0300
Message-Id: <20200527172038.1142072-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Be there 2 switches spi/spi2.0 and spi/spi2.1 in a cross-chip setup,
both under the same VLAN-filtering bridge, both in the
SJA1105_VLAN_BEST_EFFORT state.

If we try to change the VLAN state of one of the switches (to
SJA1105_VLAN_FILTERING_FULL) we get the following error:

devlink dev param set spi/spi2.1 name best_effort_vlan_filtering value
false cmode runtime
[   38.325683] sja1105 spi2.1: Not allowed to overcommit frame memory.
               L2 memory partitions and VL memory partitions share the
               same space. The sum of all 16 memory partitions is not
               allowed to be larger than 929 128-byte blocks (or 910
               with retagging). Please adjust
               l2-forwarding-parameters-table.part_spc and/or
               vl-forwarding-parameters-table.partspc.
[   38.356803] sja1105 spi2.1: Invalid config, cannot upload

This is because the spi/spi2.1 switch doesn't support tagging anymore in
the SJA1105_VLAN_FILTERING_FULL state, so it doesn't need to have any
retagging rules defined. Great, so it can use more frame memory
(retagging consumes extra memory).

But the built-in low-level static config checker from the sja1105 driver
says "not so fast, you've increased the frame memory to non-retagging
values, but you still kept the retagging rules in the static config".

So we need to rebuild the VLAN table immediately before re-uploading the
static config, operation which will take care, based on the new VLAN
state, of removing the retagging rules.

Fixes: 3f01c91aab92 ("net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 44ce7882dfb1..bfef6c120f9d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2656,6 +2656,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	sja1105_frame_memory_partitioning(priv);
 
+	rc = sja1105_build_vlan_table(priv, false);
+	if (rc)
+		return rc;
+
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
-- 
2.25.1

