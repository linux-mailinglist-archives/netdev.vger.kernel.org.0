Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D943ED951
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhHPO6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 10:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhHPO5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 10:57:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C36CC0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bq25so22257496ejb.11
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 07:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WwnW+GWJajN/nHK/Uu8SXGjaStKjr4BPobqUYTEyxn4=;
        b=hHDIhLqQj6tIa4w4qVJf800brqAuVR7rfr+AG9ipbfVi11s4nScM+Xibp+zDBVAzii
         hkuPeCjHsZ76AvynBapL8kF5odlTh+GOYV3RmrFzMiVTp6OGizUh7XLkDgJg/0+30Waw
         shC1D7SpfqudW6TBOtRVs8KoP1WtmJUbp8UCIgYkiWKAFxkd/8KzKcfIA1kdVCmbaxVs
         od1nxE3C5Ntg/CsaSs82plPxuYsT5V8PiAYsREpXB1FsLaqU6BX9nH4MGvalMe26FGCe
         wgHOj8zgTjecbISRYIBn+sMHQ7/pDvJ3yC4gDGkylHK1BduQ1Xal4OIF2lJrml648DzN
         JH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WwnW+GWJajN/nHK/Uu8SXGjaStKjr4BPobqUYTEyxn4=;
        b=flhTQ1i/A33pL7fjZbn0s8EdmpjyHuAMaz9rnRX9wrJPD2UsgC6MOaHKbTkMPqYztH
         EX+ZTuq2wIMIFI+7FrXWD8a9sTdD9CsUOi3/DQaVc72UDigiw7fmHvFMOT5QQJuEqvqA
         vl84/MLCfIBH0nZQ+H+WsZWFJZMwL2YQ5wlHdadh32t5h7kJabYxEe6w8FH77StS9Fx4
         V60ZEslFYhmbpTl/rKRJN8UcUs/1eNMybOwnuzUx9tLJIpN5hrGwet8k4hDQjvt0bYYe
         zDwfVCvJE1DIdpXDSO8zvg3IbiY2jtP0rIOJ/gfrNHIwtO0IBIyez2tGtLS2gu3vnnkW
         AohQ==
X-Gm-Message-State: AOAM532D4TDe41Bc0Yygka9WtO8oZu1QCVkBoTN7UV4T869k96UJxB0f
        M0aV/wzOL9ql0CADEQTOSMxY9/wpuWxDyTwE
X-Google-Smtp-Source: ABdhPJxqMtz9zZxKS+mZkhGaAszppeNwrGy17MtcxbPLFXs4I2+RGIMmU2ef/7QEnl9dmxvJ4xrbzw==
X-Received: by 2002:a17:906:4b42:: with SMTP id j2mr6762196ejv.437.1629125837966;
        Mon, 16 Aug 2021 07:57:17 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t25sm4946076edi.65.2021.08.16.07.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:57:17 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/4] net: bridge: vlan: enable mcast snooping for existing master vlans
Date:   Mon, 16 Aug 2021 17:57:04 +0300
Message-Id: <20210816145707.671901-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816145707.671901-1-razor@blackwall.org>
References: <20210816145707.671901-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We always create a vlan with enabled mcast snooping, so when the user
turns on per-vlan mcast contexts they'll get consistent behaviour with
the current situation, but one place wasn't updated when a bridge/master
vlan which already exists (created due to port vlans) is being added as
real bridge vlan (BRIDGE_VLAN_INFO_BRENTRY). We need to enable mcast
snooping for that vlan when that happens.

Fixes: 7b54aaaf53cb ("net: bridge: multicast: add vlan state initialization and control")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_vlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index cbc922681a76..e25e288e7a85 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -694,6 +694,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 		vlan->flags |= BRIDGE_VLAN_INFO_BRENTRY;
 		vg->num_vlans++;
 		*changed = true;
+		br_multicast_toggle_one_vlan(vlan, true);
 	}
 
 	if (__vlan_add_flags(vlan, flags))
-- 
2.31.1

