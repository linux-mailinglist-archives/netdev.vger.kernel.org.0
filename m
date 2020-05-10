Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6A1CCC63
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgEJQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729168AbgEJQni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:38 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7D5C061A0C;
        Sun, 10 May 2020 09:43:37 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so15412081wmb.4;
        Sun, 10 May 2020 09:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6xcuiP37UyCaOrsW3hqo0Y2XODppUiFrZnzXTjx4S0k=;
        b=vJrLPXUk2QKRO15Se7GIMgGmGG/wAP1E3EtpeHrKXADxPBRuFX7iXjHEbTfvURnN1o
         Cn5eT89zwSVk+1i7z1vblEDVlYLpOL+R62CnkGZPQzvv9MDoeuAPFPK7H+hXUgd5ZWsv
         2H28PjknhZWibXyOwm3hEcG+er/hKJ1KWwlx7wOtLyDx1hjQePB3fO3X1+fy0OD+QNpu
         bQNFObXWfIUAwQFoPrGG8KSzaXbLGF2LSWHpR+Miy/2gnssTzz+pEbdvjjDYvPx1b+9h
         FQ19piijLcv1A/GReY19t74091MllKLM2UzK9gCZVqdKSxSmE73u5huVYuhYq8sMSQXu
         TKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6xcuiP37UyCaOrsW3hqo0Y2XODppUiFrZnzXTjx4S0k=;
        b=tEGrx4iJRDS9XcQIgUGywavbd9HFEyybAulOLsYo+TlUaj35Codrh6eVvIICT/gDl+
         nkVC4cV76QOw0nDI7p1U1MgoZZsRRIs7XE19dlemKkade9S540qJv0AJRB/LWjUVHx0g
         sbkc2kZyob6BqUTDYmS4Mi12i+73eUdlpG/14ESnplnOeNveT9clCZBrgxZbHSXWcLl8
         BNneeKUi4zO6I36kFBDuJ/JsCu6w2+wQw9soAUcJZ44zTTM9kG1Sgrni+CxxiMZOjPfG
         urWjyeUxMdzonsB1HH2IAmSO3XLDm7R9YJqfy1/4ihjBOVGTV0nl4qOF3TJSgWmzTLjZ
         NsHA==
X-Gm-Message-State: AGi0PuaNVf3t+0VrQcUrY+Aoys7pszdQBnnApSa+MRVnX3QqUUbKUG8r
        RG8bBnVYG2OuplxINsf4boM=
X-Google-Smtp-Source: APiQypKsoR77XB6Q9xEtQ/cC2yoZ4pewQuFzXr9xnz9Y2UlEIYQUosHc6LBUO4u/Vf+7E0NZbY7rHw==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr14146888wmi.146.1589129016216;
        Sun, 10 May 2020 09:43:36 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 07/15] net: dsa: sja1105: exit sja1105_vlan_filtering when called multiple times
Date:   Sun, 10 May 2020 19:42:47 +0300
Message-Id: <20200510164255.19322-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

VLAN filtering is a global property for sja1105, and that means that we
rely on the DSA core to not call us more than once.

But we need to introduce some per-port state for the tagger, namely the
xmit_tpid, and the best place to do that is where the xmit_tpid changes,
namely in sja1105_vlan_filtering. So at the moment, exit early from the
function to avoid unnecessarily resetting the switch for each port call.
Then we'll change the xmit_tpid prior to the early exit in the next
patch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 15db37067bf1..8cf17238bc6a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2141,6 +2141,9 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	else
 		state = SJA1105_VLAN_FILTERING_FULL;
 
+	if (priv->vlan_state == state)
+		return 0;
+
 	priv->vlan_state = state;
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
-- 
2.17.1

