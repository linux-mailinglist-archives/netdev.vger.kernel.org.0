Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2486E3DF36E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhHCRB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbhHCQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:57:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA46C06179A
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:55:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z11so7409385edb.11
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WcpJLFMuyKDTsryqscypG2jHuqXU5BfE82h5fqfdiOk=;
        b=VTtkF/81nmBXS1IdoZrf20plgAHDM/Fs8Cl+SsR3XW5c46txsiy+6LbF5Qpw1q+Min
         4dEF9T8LXew2GBQOtYI4TNJozeURSxRwNypijYgEsgOujpQO2TXcC7SSc6ZQKvSU1u+J
         gUCxEdiREVsXOiboeMW0qgo8I39gpdnX2VxoRqhL7nfNpROIyTRBUyggKc2u4yyOZj+2
         58O7RDCOQu7/hiBr93OiP43S4olx6Mswa/sFWiE01FTfoV9MrbPS+Z7Jfsi4f3/S73LT
         MbOn/p4JQxbCzKourKEunib4UGwy26JvHHNcPMSgI6Mxf/Cx6IsXXRc6YKI1lvJqokD/
         BE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WcpJLFMuyKDTsryqscypG2jHuqXU5BfE82h5fqfdiOk=;
        b=WmU0qdBFcdDftRNFkaMyHLW5oc94lqxCMlgjL83wSUumMoDIzI3LpaMjIxn2b49iJH
         FLJBfjHbUjJaJnqOPquvu2OY7YQsCvJMDqRuJw/Lkp+7H8559XvSfTWcDnvL5ba+al3R
         HdZ2lPequTucU95mOoL31Ow5J6iZfODHKkxmOVt094jf1n+hXD93/aixairNYSb86v5x
         LrvLA5/t54xNVY3QKzTEH2ujrSB9QqPtrU+yR6+nMKkbmwHOK2kh8BoM3kqrG9mphyfq
         GHcpE1Lk5wlW7yz5lSY76QcfDPaRG3zP8ETG8G1Fx3COPoQFv5Fz0Ses/lZL6qriBT2X
         oR3g==
X-Gm-Message-State: AOAM531AryXc09LUkkVXcJui8K875MGdwa6s3noDuqHIA1j/4PiyhtjJ
        h1k9NSv1yHHkr1JUormN4WY=
X-Google-Smtp-Source: ABdhPJx1tGtMmN86Z8KGmVPC8UywDWs2DHA31fKbETuNXYNEObKw7h88Y8vh3b3PLCQGYRvvyIkvcQ==
X-Received: by 2002:a05:6402:1d3a:: with SMTP id dh26mr4701688edb.250.1628009757519;
        Tue, 03 Aug 2021 09:55:57 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:57 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/8] dpaa2-switch: no need to check link state right after ndo_open
Date:   Tue,  3 Aug 2021 19:57:41 +0300
Message-Id: <20210803165745.138175-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The call to dpaa2_switch_port_link_state_update is a leftover from the
time when on DPAA2 platforms the PHYs were started at boot time so when
an ifconfig was issued on the associated interface, the link status
needed to be checked directly from the ndo_open() callback.  This is not
needed anymore since we are now properly integrated with the PHY layer
thus a link interrupt will come directly from the PHY eventually without
the need to call the sync function.
Fix this up by removing the call to dpaa2_switch_port_link_state_update.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 36a6cfe9eaeb..aad7f9abfa93 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -692,23 +692,9 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 		return err;
 	}
 
-	/* sync carrier state */
-	err = dpaa2_switch_port_link_state_update(netdev);
-	if (err) {
-		netdev_err(netdev,
-			   "dpaa2_switch_port_link_state_update err %d\n", err);
-		goto err_carrier_sync;
-	}
-
 	dpaa2_switch_enable_ctrl_if_napi(ethsw);
 
 	return 0;
-
-err_carrier_sync:
-	dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
-			port_priv->ethsw_data->dpsw_handle,
-			port_priv->idx);
-	return err;
 }
 
 static int dpaa2_switch_port_stop(struct net_device *netdev)
-- 
2.31.1

