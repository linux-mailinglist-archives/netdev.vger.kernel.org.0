Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F5F12A9AC
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfLZCQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35937 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfLZCQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:27 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so12542659pfb.3;
        Wed, 25 Dec 2019 18:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUdlEwyS6RYa1hXdLY5fHxlvIjKv50oIs66wiKRqcgw=;
        b=oYSpy1U92nFgQ0nGXyCQL4x8poBXo/b57v154rK9ql0BosjHnslmxLRab7P6xD0Qbz
         ghhslEJxXA8jt2OhTQTyoVmYHe/K0SQa6w6/ShCM0HO12CVPR3iwK23vgWTuma+CrcmT
         E2wL87i9xSPwcM1NcPHLWAVVF3zelQ26PzdLAk8BCK/1LhAofUchpQUL1NJ8MXWsUqkr
         n/UBJxqbps2n1bc50opO1e0aC8hEQc6+/dDg3ZXiDickaf6nPBER9J0H5mVRYdBb1XPS
         jnqHlRAtSn4R3cyTlfzs731BEbGhdXR4HPl9Z76GswgbSPKKBClR16h0eYposeTbTBu5
         YseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUdlEwyS6RYa1hXdLY5fHxlvIjKv50oIs66wiKRqcgw=;
        b=mrsrBLYbmDvqFnu0+hJK0tSxJsfiD89rqUk/8R83PNeZDtnbdfIRQoeQnEMmHbJW6V
         JEaCqi8XtagO7Mz01fNFzlILTgpg8shUMbYy2QWp7VLEIAIAaMM+d3cigGS62maFhKGa
         3VPa+pkAzyJysiF8DQkr5x3b+/uBj4NHLO3b3Mzeb9sHXdJ5UeqDJlktyil9XPVAo4TC
         3NuEHU2AzvYJoa/dFSYjKZ/icOM+P2xlzVSvGzZSYMvWDEwq1XHJHcXbwtp4qq1Nv3zk
         WRmuc11zA5UdIpUH9Oh/gjASxMbyxIh2RCN1QIBs7llTqm7ZbGAypfSsvEEPK3GrJOTd
         52YQ==
X-Gm-Message-State: APjAAAUq2EEnZQq411nHaqE7COWtGF1Jl6K/j241tOB+4fvf/Fj4wKyH
        PP54iPOtqZRa42nYuOzIFx3K5xKu
X-Google-Smtp-Source: APXvYqxVYZf0HRIiWnI2s6hTYV6TSLa6oXIXJjrQD/5nJCQddXqAQ5wPoK9vBjd053xGgzBM/Ot3pw==
X-Received: by 2002:a65:680f:: with SMTP id l15mr47573379pgt.307.1577326586638;
        Wed, 25 Dec 2019 18:16:26 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:25 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 03/12] net: vlan: Use the PHY time stamping interface.
Date:   Wed, 25 Dec 2019 18:16:11 -0800
Message-Id: <1febd2b2d0a5bd99d70e9e46e8d794bbf8d118cd.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vlan layer tests fields of the phy_device in order to determine
whether to invoke the PHY's tsinfo ethtool callback.  This patch
replaces the open coded logic with an invocation of the proper
methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/8021q/vlan_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index e5bff5cc6f97..5ff8059837b4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -646,8 +646,8 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
 	struct phy_device *phydev = vlan->real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phy_has_tsinfo(phydev)) {
+		return phy_ts_info(phydev, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(vlan->real_dev, info);
 	} else {
-- 
2.20.1

