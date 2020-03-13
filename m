Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4E3184871
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgCMNrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:47:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35881 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgCMNrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 09:47:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id g62so10377097wme.1
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 06:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ndIu99ABAkYmGCp9Qn/hXDVqgwRjxDCp9aP8bVN88h4=;
        b=FrV2iXTeEMAPRNd3jd8GCRQwhBlnovVlQ2opFhgVcj2zdnuoWTwFkts2C3xGVCXzzz
         h4xkazRn3vlYqt5a9Vh0Mpbv110wY4oJ0nzvZEs6K40RVpqQQ6wvtYC/1XmyZ2sRPnqA
         xjSOZWDU0z5ISfhwyJlJLFIqAzV4VNI+bFBLODSOE8LdNcVZbXvsG916FW15E8Qy/GWY
         uOUS9UjpOXmYro6TDA8BDJWkV/vwhuoXUcpci5i6q4bY7uFjLF2DRS0dtCcaeHKA7HUS
         tZMCeGJELR+LoLpWMiktedgRo/13Vk0g+hsHIwFQPkfeivkCAUpQkdf3KaqqJzpG1gWO
         3AHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ndIu99ABAkYmGCp9Qn/hXDVqgwRjxDCp9aP8bVN88h4=;
        b=hRLLAHq0GyJ+Es0L6kEVZXJH1ZFxkBq9pTlhaiaSkClhmzHw9SZeBPk1H2obGrKmPr
         fDrJyXQuOrLyzbMg26Owss7z/MU5NGDAm9lqSmH9/4mODc96YpyNAtfZAkTRNBohWKil
         ZAwqH/7g9ZbcX2mAzh+eeqOsdBkAC3cglLct1+vZMASJ3oeDEOIBi5p+DCqvxzRQA88S
         OPnuUPtu3X3gpK0X3ry4fqBGq1NbsKk9sUrK8cIFgp0wB6I7wKvcoQVjeGPuwzDUBpso
         /0I1j/j6dK0DDoFfr1gXSEGMetGpamZQv/7VaKup0skKwyvvPdw9oQqrvwVDHR78n4aO
         JKAg==
X-Gm-Message-State: ANhLgQ0dKAmwvjhaQpaggq2mPcztdKCFjO2xxLDVt6h25eRPnRwMiekq
        FrMXQrKCdP6ufsLoRiNrAAE=
X-Google-Smtp-Source: ADFU+vvTsg0vuKC5Fk/1fv4IROJdDcCRACQxF+IEY6rQEqa02ovcLHXUK0CcXKswyMQPRQUAV5YSBA==
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr10608826wme.36.1584107225751;
        Fri, 13 Mar 2020 06:47:05 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id t1sm34112219wrq.36.2020.03.13.06.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 06:47:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com
Subject: [PATCH net-next] net: mscc: ocelot: adjust maxlen on NPI port, not CPU
Date:   Fri, 13 Mar 2020 15:46:51 +0200
Message-Id: <20200313134651.5771-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Being a non-physical port, the CPU port does not have an ocelot_port
structure, so the ocelot_port_writel call inside the
ocelot_port_set_maxlen() function would access data behind a NULL
pointer.

This is a patch for net-next only, the net tree boots fine, the bug was
introduced during the net -> net-next merge.

Fixes: 1d3435793123 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
Fixes: a8015ded89ad ("net: mscc: ocelot: properly account for VLAN header length when setting MRU")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 460dba862d24..38e9210f6099 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2359,7 +2359,7 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 		else if (injection == OCELOT_TAG_PREFIX_LONG)
 			sdu += OCELOT_LONG_PREFIX_LEN;
 
-		ocelot_port_set_maxlen(ocelot, cpu, sdu);
+		ocelot_port_set_maxlen(ocelot, npi, sdu);
 
 		/* Enable NPI port */
 		ocelot_write_rix(ocelot,
-- 
2.17.1

