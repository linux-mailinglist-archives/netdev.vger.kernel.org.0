Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660401CCC4A
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgEJQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729154AbgEJQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:36 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEAAC061A0C;
        Sun, 10 May 2020 09:43:36 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so1408979wmd.0;
        Sun, 10 May 2020 09:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t2q/+kLZ8m4kfHoubHx5th7aZ54O84h5KKZCd08nJiA=;
        b=dM9ZHwFFiD/nMLUKsOG3Q2sWk19Mzy4hM6XJqIPpNwM91zjHE7qRHXNFy+olPdIX6r
         9N/1oGYHjmqZO1V79LEop/82rhc7NQoNQZHjDO+92Io4UO6UvT62XWuldN+VxkPPjaBt
         /+UPpR7iFoa2o5htERSvrT9l5PgJwe0DmUpugR5hZfHcCk3qLXTLUWOgnO0/w2DnVZNH
         UhsDeCgBMIZ+aGP3iZkrrCaQTjhfeesWn4VtTjNfbqSQbWCnYboI/sD1sWDTthifbs+q
         9560VT2C1C0SBzK9+xL7q9Rzk8MG2vlX9xYJoLo04R2flUZFKWM9XHY6ZmpMjPkoA5xY
         +rHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t2q/+kLZ8m4kfHoubHx5th7aZ54O84h5KKZCd08nJiA=;
        b=PFP1yer0Ipw1RxY9E1uOUMkgJszOWcZwX3fC3S42CZWjPwTeFfPNCA2UnE1X12ndAf
         wMP2Sgr+mOMc8uVTr6RnGEc3xaUAH3H4FLZS75nbduDnBLHLi8aSVs8AV2XbMyXTxEBu
         LzgzrfODzfBSxuUZ8y2AvAOkuqC3fm4SkumaRcSacxgIcHo9uRQB5J5gKOwjF+OPK8Uh
         IuS2daJJ79v1wdGYlSxOLP1gFFMgT2w/j+XT/tLEIRhvlnCPbh7LBTFcxkdku9hPeqfs
         LZXcNj+KroKiNqQssQ8JPQrj3Idy/xO8pGSh4PYJFZ90TUVg3N9Ia+NPmd0fxcEgnIi2
         OfHA==
X-Gm-Message-State: AGi0PuaRmLpcX4xqM8XNaKbepCAWudLsvkAOCBNXHpt4aiBnXHQP/TP1
        PO47IC2e82peVJBLBwQX1es=
X-Google-Smtp-Source: APiQypILCo/4dSdM6QHiJb7NYT4z88Ubo7nmyKX7+E28fYgJOtkW+SmuoWHlRhS5sOdyAkkluaBbHA==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr5890557wme.135.1589129015099;
        Sun, 10 May 2020 09:43:35 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/15] net: dsa: sja1105: allow VLAN configuration from the bridge in all states
Date:   Sun, 10 May 2020 19:42:46 +0300
Message-Id: <20200510164255.19322-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Let the DSA core call our .port_vlan_add methods every time the bridge
layer requests so. We will deal internally with saving/restoring VLANs
depending on our VLAN awareness state.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 8aa8bbcce6e3..15db37067bf1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2340,6 +2340,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
 	ds->mtu_enforcement_ingress = true;
+	ds->vlan_bridge_vtu = true;
 
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
-- 
2.17.1

