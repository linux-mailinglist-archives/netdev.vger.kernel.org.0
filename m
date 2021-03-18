Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3229E3407A3
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhCROQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbhCROQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:17 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D24CC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id j11so4840372lfg.12
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=Re8gOX+OB1Wzo+MBLWfqDrR9tfDJGKbyWNHNC47gGWs=;
        b=ithbiiLzxQz5TK3JF1/50ynztFUviotOliLAgfI2OCIif4f59kg+4jRZCk/Nf6csBi
         +v9nQxblYYCV4q6KFUvNOnPnf6fhF4/Nk0AjodjVAvz7UP6dT4Bmae2Ub7Qk5zLytept
         +rTuz297C+OZ0uB5ws+INJD+cGz9T3oIYbmtG+PC8jmrf7t5nn4jzpXOAT1jNYzH91/X
         WUpQ0us1A9bFleeYOUqXdnShLyKSVg8uvXbUGuchhdbCGvlb9lm8GbC63ALzCurAKITP
         8iOXrsC+PqklVzU1h6oX1/sd+pssrB74K8Z8Nq8n+yy10yOkMBIlhZJNeH8wfMN76u/Y
         3pEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=Re8gOX+OB1Wzo+MBLWfqDrR9tfDJGKbyWNHNC47gGWs=;
        b=fAEqXOBiF35W3z9mG5oZDGUPysK2wywYHWr4BucD4CLOvswR3/eHxhoCf40pAUOwHT
         3ZTKEgEHtwpuyT2RcaJBThloB35FL0ue4zkr32qyWbFdGe/XHgqL1CiKIo5GAPiBVfvs
         nA4qVCphJVLMygG5pOoMwQOyGN9oD4QT77mGHxFlS6bnYDxd4e4/i0H0NKkfW/hyjdK+
         +8UVe3tbLSSBAqUDHnS1r/NL1DPmNGziv4+2sndSiUDva+Sae6pprtO2UWnsj0N0zrwD
         QRa6tnNhv2qbUnPOwyth8MafVBujIiK6cvoq40tEMeAsZBo3lNXrKdcIBVSGKLFBAWbA
         xqOQ==
X-Gm-Message-State: AOAM531QU1rvmllxIvAKLDR4WXsUIUJWlErI7WtPvr0n3/iD9mvsixM5
        1nO3zTFfluo1WpHImjInyNRiBw==
X-Google-Smtp-Source: ABdhPJzX/v8yiaZk2QoVeH4CNWvKV0hlqwYmu98f1lGj+/CWuEwxJ0whUq5JczBeg5vusbh1WtavGQ==
X-Received: by 2002:a05:6512:2117:: with SMTP id q23mr5479728lfr.423.1616076975700;
        Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 5/8] net: dsa: mv88e6xxx: Use standard helper for broadcast address
Date:   Thu, 18 Mar 2021 15:15:47 +0100
Message-Id: <20210318141550.646383-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the conventional declaration style of a MAC address in the
kernel (u8 addr[ETH_ALEN]) for the broadcast address, then set it
using the existing helper.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c18c55e1617e..17578f774683 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1968,8 +1968,10 @@ static int mv88e6xxx_set_rxnfc(struct dsa_switch *ds, int port,
 static int mv88e6xxx_port_add_broadcast(struct mv88e6xxx_chip *chip, int port,
 					u16 vid)
 {
-	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	u8 state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
+	u8 broadcast[ETH_ALEN];
+
+	eth_broadcast_addr(broadcast);
 
 	return mv88e6xxx_port_db_load_purge(chip, port, broadcast, vid, state);
 }
-- 
2.25.1

