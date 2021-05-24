Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6638F468
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhEXUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhEXUbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 16:31:55 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764FBC061574;
        Mon, 24 May 2021 13:30:25 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id b25so28281622oic.0;
        Mon, 24 May 2021 13:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GqUcUpb2Ej5ByHB7iSH1hiStjrC0tu1eCOwjuG9fVMA=;
        b=LdosPC1Hy1iNWhY5aFHn37/tLbrTirZ/a+cthsRf+IOORtG/CqJRvdeJ0gjHhrBDN0
         KMyfM0N9b+ESX3si6WmvNsCtleq2vQeFJqZn3XsaOWO7KTBFvMhqqNoLUSTpdlTycah3
         vC9+JdiRKwMd4KSQpuB471rxlah/dUFOXHSMQerMeXtGXGHP00d8elf9OOSJC8MeqfOF
         aypRq5jWEO2RLOcw0LfuU+zWGSOPdZzWaxb9Lz55lUvPLnFr4hMYCl7Fz4Wux2NiR/kp
         iilSw3AxL9V+a6wsdktXHIHnNoyN4DeZHBMKFA4iEPDXSBQrvWS+SbBBokfVhk9EDLO3
         IKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GqUcUpb2Ej5ByHB7iSH1hiStjrC0tu1eCOwjuG9fVMA=;
        b=YFLyB0KyeLfR1hJ7srsc3HUCw837a69rFlfVFH8A9gzGYUnZ4zaqHJUlE03LINgbSL
         GUY5xK+dF0yPYiy0U4dubcDCn4MC6QYVxJz3KX9D9iXSMRW9KTJ7+dKyiTI9yONoo2nb
         A9wP+CrUPGDffomk0gQEnVc+0SLP7TKxXaBbAXNY8Flrj4c37rVuLsMv/pM8H/dcQia1
         yCM6V/JrsbuxHEDSaJgnUhiPZSy5qhDVFqcQ1mkQranVp612URcVCwV4BwtavkKe4gK/
         3j81cZOg8y+HiXOio6LFbiAMTue7pLhIW1WK0CJrbrulshBxJBp31f9JyrWCMFy9UJ8L
         VBiA==
X-Gm-Message-State: AOAM533lBcTmwQtDZfbPNDMUjyvplEmhkbw4RnYNQ3xURmzrJNK/dPe7
        WACjmhdYFsbsb1Aeh0EdT4YT3MdLieEI
X-Google-Smtp-Source: ABdhPJwcvYPe1008UJs7WtpgbMmUIvPjfrMw4RU6xipJ9exupeYXtQpkotdHQK6mIs1iAWF6te0tkg==
X-Received: by 2002:a05:6808:2003:: with SMTP id q3mr527111oiw.171.1621888224287;
        Mon, 24 May 2021 13:30:24 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id q1sm361548oos.32.2021.05.24.13.30.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 May 2021 13:30:23 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net] net: dsa: microchip: enable phy errata workaround on 9567
Date:   Mon, 24 May 2021 15:29:53 -0500
Message-Id: <20210524202953.70379-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also enable phy errata workaround on 9567 since has the same errata as
the 9477 according to the manufacture's documentation.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index b99e453b0a56..4dae07da1b53 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1639,6 +1639,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
+		.phy_errata_9477 = true,
 	},
 };
 
-- 
2.11.0

