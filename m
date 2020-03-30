Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189901986B9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgC3VjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34931 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgC3VjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id d5so23573464wrn.2
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uisaVSbt+AjqZJIhEGd05nS3aQ/c+8p2XMpEluonO5o=;
        b=U8NfGzr4KRjcEg7EmMrMzVRVAhGKRHLhkhNUyu33G4tpjAl0/tPcuMYzfekLVo1z4y
         368CCQQD6DwREOqjQE15V/Ud58E8u9slKdgjIBcEweKU9M/bwoKRsBCiV+SPw6wp9WE5
         p4otrg601vBB9Tf+tWaL6peX81h3xHmRGX+PF+iz+Cmx0pZP86IrTeDHNCs5HfPwAifB
         2/zBVV504x3Zg+c00s2Fs2NBy5XlgiroMe4GYd8dzk02s7g7W4/v2jNX1G24v44IOX4R
         2J4jApst4cGsefWZyZYjHne30Bk6z+JVro9BbPNy5M4qGc6hrXqwneXQ4vXvv5IkKnjd
         S37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uisaVSbt+AjqZJIhEGd05nS3aQ/c+8p2XMpEluonO5o=;
        b=DFMxXDP0u+dMGz0vBaTMOlnTt8yxpZEUCyD5l/Zfbbcszp6tM4LtjIaOPxSQ9Guj2E
         EMiW036n7zcaOkdiUqKVthLMxBqcKBqhhH1bnoyykurzi5n0vYvSCaivN1NTP2lZm0Ye
         mhUanumHveZ00hWzN7N/i4OPWjmBb1PfGWTm7BzsL8k5auqMAXgGQxlbwPgwyvpqRIAi
         MctGwYFy9C3pdsk/3MC0s172lrKaTf+ollK8tojUHxXoE9usmwPU+PKm8QKv8JmN8kLy
         cEAloPd5XYTBYfE8CuMnlC8IpI/p9k62ojVf4fVg8xHxlQhtyaLUwpX3oxZTyvEhebzV
         gSMA==
X-Gm-Message-State: ANhLgQ1qdR8PgW9O/i7QBNczIpwgkwWEsgRaJyJNLDqpece8tnxsbhKB
        7YH//8vWKtfb0nuX8HP1EuCGXOiz
X-Google-Smtp-Source: ADFU+vtBTX3LOJy/LCbG55wv7xYQDKzDMxR75StZ6mt1fqkgouwdQ6/E/KAw35/m3XbfvyS+oElmCQ==
X-Received: by 2002:adf:8187:: with SMTP id 7mr17719315wra.358.1585604353506;
        Mon, 30 Mar 2020 14:39:13 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:12 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 6/9] net: dsa: bcm_sf2: Check earlier for FLOW_EXT and FLOW_MAC_EXT
Date:   Mon, 30 Mar 2020 14:38:51 -0700
Message-Id: <20200330213854.4856-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not currently support matching on FLOW_EXT or FLOW_MAC_EXT, but we
were not checking for those bits being set in the flow specification.

The check for FLOW_EXT and FLOW_MAC_EXT are separated out because a
subsequent commit will add support for matching VLAN TCI which are
covered by FLOW_EXT.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index f9785027c096..40ea88c304de 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -878,8 +878,9 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	int ret = -EINVAL;
 
 	/* Check for unsupported extensions */
-	if ((fs->flow_type & FLOW_EXT) && (fs->m_ext.vlan_etype ||
-	     fs->m_ext.data[1]))
+	if ((fs->flow_type & FLOW_EXT) ||
+	    (fs->flow_type & FLOW_MAC_EXT) ||
+	    fs->m_ext.data[1])
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
-- 
2.17.1

