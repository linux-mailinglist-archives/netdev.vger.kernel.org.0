Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E2425F76E
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgIGKMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIGKMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:12:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733C6C061755
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:12:21 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y15so1011272wmi.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIuHXFTT8iNlPReahxS4AxVZc+AV0svGQsmfuvJB638=;
        b=SNTV8BHaruyvyyhiibjlyWpTha0xScucliRh0jRwUFtVM3zSePtusSkCCUYgh9u6Oh
         MGZsqBtC7pSaftd4V6pNSJMJZo/767RnEpqeicNPitCD89VR+KzXs5RBBMNCeVsK02xa
         itVDCRVNDSYd5MBqJ9zPqcb4WI0zsqr6ky3JY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIuHXFTT8iNlPReahxS4AxVZc+AV0svGQsmfuvJB638=;
        b=uQIXB852QFeqd9wDDxz7YZr2ftR8hOz1RePZM/d0N2ji8u2REc5Nc50+5RkBZDZqeo
         b8hIteZRByuN1USxkGKBW6AjOz7j5alFTcCEYic2IOvPhIHkA92qJqVYEJajE2Ig5vAY
         4tbwU1b7o5Gfin/2WrouFWufjlOE0mR5gN6j9uP9eKVhS2NO7Hgiqk2nPgmwu+UVD+C7
         6cQi6yUcXIEJrqlo+O/Z3Fvolpwvm5y5vM54jmHhsX81imPEuxDrV8M7LOJIvhBnVbK6
         oumlgFR7oytJSMdCkp23WX/V1Nq7mIE3wTOLGeu/B3bHmZKXh6la6lj24Yssjxlb+FIN
         XqbA==
X-Gm-Message-State: AOAM531eSb8I0HLziagjHrRSDcIzEf0EcnIYZdttXZJHEhFmbJwZcUqq
        O24XUqS0aCUaJDKwfmH0WPIDiw==
X-Google-Smtp-Source: ABdhPJzrBd06xztwhsQa6CrjESbvkiuY7MO0bb9in6tdBtfv/dcZIuPN3mFHpGLsCcDQ8eTeyjwA0A==
X-Received: by 2002:a1c:9883:: with SMTP id a125mr21056219wme.133.1599473540003;
        Mon, 07 Sep 2020 03:12:20 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id i16sm24173748wrq.73.2020.09.07.03.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:12:19 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH v2 3/4] net: dsa: microchip: Disable RGMII in-band status on KSZ9893
Date:   Mon,  7 Sep 2020 11:12:07 +0100
Message-Id: <20200907101208.1223-4-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101208.1223-1-pbarker@konsulko.com>
References: <20200907101208.1223-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't assume that the link partner supports the in-band status
reporting which is enabled by default on the KSZ9893 when using RGMII
for the upstream port.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/microchip/ksz9477.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 9513af057793..f379ea8242e0 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1235,6 +1235,9 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 			if (dev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 			    dev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 				data8 |= PORT_RGMII_ID_EG_ENABLE;
+			/* On KSZ9893, disable RGMII in-band status support */
+			if (dev->features & IS_9893)
+				data8 &= ~PORT_MII_MAC_MODE;
 			p->phydev.speed = SPEED_1000;
 			break;
 		}
-- 
2.28.0

