Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BA112FD5C
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgACUBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:01:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39229 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgACUBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:01:49 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so43463706wrt.6
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 12:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wqXMXCnxhaXI8tjirHvg26Psm0q12h6CVvV+f3E6dtk=;
        b=Jgb84Z3ZiwzOF++4Rb8Dt/+1y65WcFB0L+GPQpmNpvp6gaNfafSLM+secvvdzefGxT
         CHrMlFDV9h5FctXDOxME+xfc4Z/xiuMwppJNnpXlBM51KimHAglM4alY9Y+CYTqxTouL
         XhP6raCi1oAvqydNFLm0TAQeh7JSFfrnt8UplEzpdJaxTNp6LlrHjJu5GYu+tASmDOdC
         AE9K60NlX/65yH2RqjMlQd37+JDkTBX1aMFTYANXRVhfnB6O0ZSzl2mcAkJQjdOx3H2g
         s2xNuusW07tqOUNNqluNIDa8dB8YQaQZeWobUlKoNgy7Ob0hqNAtjtGfH1IwmZ693hnJ
         m0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wqXMXCnxhaXI8tjirHvg26Psm0q12h6CVvV+f3E6dtk=;
        b=AhL7rmo6kl6SJFlrNZTeK9SADb9I6LDSbk2FqDxDjAQI+wNdRKAKE1/I3ulyON3mnK
         DFJXIdLCCpGxmBnIwmHekvJ8V0Qgt2qviSB1uk8grRwhCDBKtusdT6iz6NBOEAaP0d59
         uYO3rvUR5VF8SOoheqoEmnVGnHa8T2gDR3o1IOLAGcDMys1XEYSHEzcdTsqjjNdy/uCL
         WqIKA2tuMI/EA5yLA9vGTxSzAk1JmyOhD3xR63sKrKfKC1EzhkjiL3QMqDaKOiBVXEhe
         xG+2qECNDXjEdRTN7harmBtv/qiInOHXqsxDEAQB0cDJB8IWdMiPK4YygAfGVhMBqYZX
         aiiA==
X-Gm-Message-State: APjAAAV2EqR/gHtE080sBThjGu+I6t+vVidKixywxawzvgMCrRSZI4ci
        3UtSl5XPA3bDFwa4ifQ8CFk=
X-Google-Smtp-Source: APXvYqzXsN+wSauBKnx8rhDaehHJT8hIEYVEhFg9Qp+VfgWR+ojKBrdQkqDh17CLQEPaUUPOkjwRcA==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr96258007wrp.17.1578081707563;
        Fri, 03 Jan 2020 12:01:47 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id e12sm60998154wrn.56.2020.01.03.12.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 12:01:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 2/9] net: phylink: make QSGMII a valid PHY mode for in-band AN
Date:   Fri,  3 Jan 2020 22:01:20 +0200
Message-Id: <20200103200127.6331-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200103200127.6331-1-olteanv@gmail.com>
References: <20200103200127.6331-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

QSGMII is a SerDes protocol clocked at 5 Gbaud (4 times higher than
SGMII which is clocked at 1.25 Gbaud), with the same 8b/10b encoding and
some extra symbols for synchronization. Logically it offers 4 SGMII
interfaces multiplexed onto the same physical lanes. Each MAC PCS has
its own in-band AN process with the system side of the QSGMII PHY, which
is identical to the regular SGMII AN process.

So allow QSGMII as a valid in-band AN mode, since it is no different
from software perspective from regular SGMII.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
- None.

Changes in v3:
- None.

Changes in v2:
- None.

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ba9468cc8e13..c19cbcf183e6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -281,6 +281,7 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 
 		switch (pl->link_config.interface) {
 		case PHY_INTERFACE_MODE_SGMII:
+		case PHY_INTERFACE_MODE_QSGMII:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
 			phylink_set(pl->supported, 100baseT_Half);
-- 
2.17.1

