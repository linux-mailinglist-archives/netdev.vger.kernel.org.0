Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312E434EB3D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhC3OzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhC3Oyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D3C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x21so18553016eds.4
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0e5bfMQeB45LqDwZPaeES/kzrcpabV+H5DsnQ+4B4I=;
        b=lVzAB7QEl1lzeZR2HUOq4erJHQMMZLQDMnOzSCE5xauWCVfB/efbBfSjOeenMGfiEB
         ra51iXvWh2UEaiYQrgPmES8Wszrg9qedHHxSPuPZRtas59N2ahlq1m4fQAzvirzedv9e
         3GV8V8vrbgyr3zjIMRiaox26q9Zt5nmp74cmrW9NmPKhbECDCsGQlkojFlawrhVEWS25
         RTRbnR6AhiEWzsD0r4pm2m38jBA9H9BOOKD0vnevn2vQg0NwgUw/2V7jqRgSDUUNTNaM
         pSMGIZV27skJjzLDy4UtbyFqlwwEEBQXHvbtgIZMg4Rr+qgFZK93BGY+fvnBx7MKWvRA
         arKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0e5bfMQeB45LqDwZPaeES/kzrcpabV+H5DsnQ+4B4I=;
        b=qxE10grNWVd3ozotrnv0lIVgFV/d9Df/3T5dh0TYI+Dib4S6hslzHaMO1iRUVVu+vJ
         ouH+s1t5zAttnv1ovCIb/jLLuyWrLLiBaLh73Gi7mry33Enqfs6MbdaqNrgQWek2K834
         YxH8m1J8ggffn62CRhjE8gb8cLUb5B3w06Sfbiu+aRhswK2LSGg/Ty5eyO0wm590ArZW
         w/nYpIyPxX0s/2FDT6BuBtToKd+p8FWpaimKpWTK7RfmsX9Mjr+u18Gqxbw4Pi3leWUc
         11MXQsF9Do8jSaAxRgzNKeC+KSL6MfTZKmYuqNY74D3Vhm3qcc8sIRaGDKIsGUXuaIaa
         poJQ==
X-Gm-Message-State: AOAM530oqQdXwQmw4OkrZKoNPL4dmXfF9yBSjMRZJCPlYFmUPW42hQ/e
        AwYgTasyNzLjyMY/0YuLzLs=
X-Google-Smtp-Source: ABdhPJxFCbItpX3c95XtOP1pJlo1gwGAylBbRZJkwbJEff35I/NkGyLVYulpd/xlV10e4FwZZowr8A==
X-Received: by 2002:a05:6402:1517:: with SMTP id f23mr35003364edw.272.1617116070195;
        Tue, 30 Mar 2021 07:54:30 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:29 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/5] dpaa2-switch: fix the translation between the bridge and dpsw STP states
Date:   Tue, 30 Mar 2021 17:54:15 +0300
Message-Id: <20210330145419.381355-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The numerical values used for STP states are different between the
bridge and the MC ABI therefore, the direct usage of the
BR_STATE_* macros directly in the structures passed to the firmware is
incorrect.

Create a separate function that translates between the bridge STP states
and the enum that holds the STP state as seen by the Management Complex.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index a9b30a72ddad..073316d0a77c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -318,17 +318,34 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 	return 0;
 }
 
+static enum dpsw_stp_state br_stp_state_to_dpsw(u8 state)
+{
+	switch (state) {
+	case BR_STATE_DISABLED:
+		return DPSW_STP_STATE_DISABLED;
+	case BR_STATE_LISTENING:
+		return DPSW_STP_STATE_LISTENING;
+	case BR_STATE_LEARNING:
+		return DPSW_STP_STATE_LEARNING;
+	case BR_STATE_FORWARDING:
+		return DPSW_STP_STATE_FORWARDING;
+	case BR_STATE_BLOCKING:
+		return DPSW_STP_STATE_BLOCKING;
+	default:
+		return DPSW_STP_STATE_DISABLED;
+	}
+}
+
 static int dpaa2_switch_port_set_stp_state(struct ethsw_port_priv *port_priv, u8 state)
 {
-	struct dpsw_stp_cfg stp_cfg = {
-		.state = state,
-	};
+	struct dpsw_stp_cfg stp_cfg = {0};
 	int err;
 	u16 vid;
 
 	if (!netif_running(port_priv->netdev) || state == port_priv->stp_state)
 		return 0;	/* Nothing to do */
 
+	stp_cfg.state = br_stp_state_to_dpsw(state);
 	for (vid = 0; vid <= VLAN_VID_MASK; vid++) {
 		if (port_priv->vlans[vid] & ETHSW_VLAN_MEMBER) {
 			stp_cfg.vlan_id = vid;
-- 
2.30.0

