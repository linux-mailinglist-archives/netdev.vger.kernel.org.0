Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F414C35E000
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345820AbhDMN0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241658AbhDMN0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:26:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13822C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id s14so3616012pjl.5
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 06:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JMtB3sTR+OLp053ETHSfMwDWfNuUQ0eFZhxyaM8Kg78=;
        b=Y5k68lrtZD3rwlPLfIsn6XsnrCDZ3QPLJNN1VmVSCT+lJr862+WEI2DaC8llyWtrrb
         goUhVXv8HqvA2GF9DesywhGw5ff6j7ORaf4ciDSpOCiUfGui5gRq9EA1eVcrlUT+ag8n
         0p8oOmu8wNHXEaVufGwuwvY+8WROIOmtETPy6IfxP82GG2Ced/F0PGFdbi4O9RDCTtXH
         VtNYOX8oCQ7s5K+d8rqPQdRbEi/MwyKKU0GaXFrQO3a/MsfsCTkGFT3pDMF0xl+P5jcs
         P1JmSZ+Nm/U8a9nMYyTsLQRKjO/NssjzmcfVFCEbMEF7LYloII7wv8VOH1mKL+gifrZT
         TU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JMtB3sTR+OLp053ETHSfMwDWfNuUQ0eFZhxyaM8Kg78=;
        b=PJxi7SOPppgtILGeU5sImIHxF8dQ4fxc6uojHm5tmt2wlybuibdJ86UZQLJFoxqyVu
         4OvR6ZFgptwFdYFjSdHwaVD6vf8GQ5jMClHxwKH4Oh5iQN1S7+Q507pzCyDH3NYZoW/0
         aYZ1U/CbAHfjtco/z5dBsx2oIvM7AedbppLcV7m5+uzGvI1cx40GylUqwMv9L7p/HpVS
         b6oZJCYjSbB7GfTv2eKC+RlvxTGQDTZpkswOE1eB1TB51QIpqNaM3ACsd8pfECzrjw4+
         vHX/FDd16snpKfbQj757JuYuiPK2uvdp+bmbjBS75s7hWuvD8dACsburlsyMPM6edD5q
         8Zew==
X-Gm-Message-State: AOAM531LsxiHeCAOU0nsZ5w3CmPwAhb1VSqdHTrhsiTDmPeLvmMf/9HJ
        U4rpbX5uNeYtZsngWvdfhig=
X-Google-Smtp-Source: ABdhPJzYK3EV5jPdzovCexfLOjszJtYcA6s4BPmw73D3uDWdWvhc0crVqBgPeWGuiq+UWKakL2VMyg==
X-Received: by 2002:a17:90a:28a1:: with SMTP id f30mr20006pjd.198.1618320355601;
        Tue, 13 Apr 2021 06:25:55 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id z18sm12417650pfa.39.2021.04.13.06.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 06:25:55 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/5] dpaa2-switch: install default STP trap rule with the highest priority
Date:   Tue, 13 Apr 2021 16:24:45 +0300
Message-Id: <20210413132448.4141787-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210413132448.4141787-1-ciorneiioana@gmail.com>
References: <20210413132448.4141787-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Change the default ACL trap rule for STP frames to have the highest
priority.

In the same ACL table will reside both default rules added by the driver
for its internal use as well as rules added with tc flower.  In this
case, the default rules such as the STP one that we already have should
have the highest priority.

Also, remove the check for a full ACL table since we already know that
it's sized so that we don't hit this case.  The last thing changes is
that default trap filters will not be counted in the acl_tbl's num_rules
variable since their number doesn't change.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 351ee8f7461c..fc9e2eb0ad11 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2700,11 +2700,6 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 	acl_h = &acl_key.match;
 	acl_m = &acl_key.mask;
 
-	if (port_priv->acl_tbl->num_rules >= DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES) {
-		netdev_err(netdev, "ACL full\n");
-		return -ENOMEM;
-	}
-
 	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
 	memset(&acl_key, 0, sizeof(acl_key));
 
@@ -2718,7 +2713,7 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 	dpsw_acl_prepare_entry_cfg(&acl_key, cmd_buff);
 
 	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
-	acl_entry_cfg.precedence = port_priv->acl_tbl->num_rules;
+	acl_entry_cfg.precedence = 0;
 	acl_entry_cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
 	acl_entry_cfg.key_iova = dma_map_single(dev, cmd_buff,
 						DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
@@ -2739,8 +2734,6 @@ static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
 		return err;
 	}
 
-	port_priv->acl_tbl->num_rules++;
-
 	return 0;
 }
 
-- 
2.30.0

