Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AA11DD92C
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgEUVLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730566AbgEUVLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:08 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C774C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:07 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l25so7726910edj.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RbB6CXL0qgQWxXTRExMkrz+2z7uh3PUfZ9RjInw+Vf8=;
        b=QFXa7pJ3teMwRJt7Zx0QraCNc5oPPIJmEA0fviwzRl3B+8vNVVKhUBrt51N4KUbN9H
         pz+RkmSck8H0NI2k/SlfIxYdbXx4ohEkTh8dSiaOfAzMctOSwn2LkGrWMHP5uCf/qxgZ
         vJoHzcym/jmOkzXr/GXrXXaUWu15a++I5lbilwt9T4p5d7R+dZ2PSe9BlrU9XCaKUqLs
         kQxkWKxnU2kp/twFqDViJ2k5KMFnqYa9ICY5y0VsnltUiIo+UbYj+rON16gatr0uolvA
         psoXzL4TKBu7IfcDPy67hKfqXdHeSgxwqRvi/6q6wgwwSipm1KOI4sNOOXq9bBzb3F7G
         Ndhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RbB6CXL0qgQWxXTRExMkrz+2z7uh3PUfZ9RjInw+Vf8=;
        b=MMKIKzyUTQRG8WSvbLKOfN1LyZlTGOeDhX47zOXD/vKgxkBm3jGAl2Eba+hwd1DGZP
         CSIsNXVlt5YqLGMoPlX4HqmrdshW/oeIOH7JbL26ntDS4DSMZ+QyOHoCl0kE1+3vQVqP
         lILmQhV57Nfn7mEyBJkkOG/ELgTxhHDuUz8U2H/nBWJ6omb16WEXdDGwWIoe69/onjUB
         cwlkBqO89seYKHvU6Ze221faY1P85LoU5m+wc2huhfsh3b0fvESaWEMIVpURacXLCD5t
         TYD7/7gOY3SKB7HHvWfCf8KuWZyoKaN3t1C+boOm2naGjPgREk5QNUFk/4gNz+8USnlg
         /W4w==
X-Gm-Message-State: AOAM532DjXpo2xcCsZWJ1C6qYcAszeQ1Bq4UsuK8AGj0y/i87QHiYcQj
        TIR0KU5nLSw2APEu7dFINPg=
X-Google-Smtp-Source: ABdhPJy1cRHIiCJ3jatnT9eOB9gzd+WRTzSMXxdaoyMRUsJQ6lYoBNi0At4MXbENZZZpm7I45E3dMg==
X-Received: by 2002:a50:9f66:: with SMTP id b93mr547968edf.376.1590095466236;
        Thu, 21 May 2020 14:11:06 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 12/13] net: dsa: treat switchdev notifications for multicast router connected to port
Date:   Fri, 22 May 2020 00:10:35 +0300
Message-Id: <20200521211036.668624-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Similar to the "bridge is multicast router" case, unknown multicast
should be flooded by this bridge to the ports where a multicast router
is connected.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2743d689f6b1..c023f1120736 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -467,7 +467,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, trans);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
+		/* A multicast router is connected to this external port */
+		ret = dsa_port_mrouter(dp, attr->u.mrouter, trans);
+		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
+		/* The local bridge is a multicast router */
 		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, trans);
 		break;
 	default:
-- 
2.25.1

