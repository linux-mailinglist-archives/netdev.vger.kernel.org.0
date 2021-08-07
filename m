Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655D03E3242
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 02:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhHGAGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 20:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhHGAGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 20:06:38 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1563BC061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 17:06:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b7so15447290edu.3
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 17:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RzozSNQTz1Bpza4jp/rOPaJfg+JvR6EqQ0E1yzsox8A=;
        b=T2Lf2SOPRd8WVy6tOKA1+5ahRA27A4734PUTOhAWiMNvW9ZjqSTMS4rB+b5+JnQplY
         vm7zZuNjVHqAiwuF4z2FPr9cyQmpHAKq+EnP01wBy9Kuk4UpPDroOG31/0AZ+As/U4Dm
         3XZc3AJI/aDTU8kyBworzrVuJTtPP8dEkFMKQGU+AbNKA6RyA9GlfnZjOEti0F+XH1y1
         biXR/7Ttu2TdX/JcO5Qit8uP5v4WX2R8TgalekYtbZZWq/z2z6bw1NktkjE6N8PXNNe2
         1T0KdXfmvOB6jUn9Ns0e+XBDTBb2c6mJ8LJBkNJHz+ahmUE7/Eg1WbNRffTAW6tjYQ/I
         ZAdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RzozSNQTz1Bpza4jp/rOPaJfg+JvR6EqQ0E1yzsox8A=;
        b=ILE6IIr/lWwVsMfdQw0I1LrEvAWVBtWNOF3bVy0gKE4d1nnLx9068zH3x3Fk4KGTKD
         VjMzBZD1gAP4ztrNbH0wHcjSQLW8K73k3f0kFA5upBRhtNGfR4JWF0XrnlnTAUkgME7z
         kMyzpb6DCNmrH+bvS1zc48wQJ8rJRNQjA0swDD89Y/Wr+yNrWv4SYI5TvmrrTl9wf+RR
         Vh8KkOpg2D6lW3CdqtA7KGtKo3c6UcdXf92+pCEOeCP1IB/bOA0EOSRFQ2VpPRExLNiX
         Ia3+4kZ4OF6QT0Ykrys1uYPu4b5sllkCKvPr9gHn9urmEmBDCbyVK8DM8aX9Ir54uThK
         vl4A==
X-Gm-Message-State: AOAM533vIqBMusIaIpW4iQbfhi18qBcpkuurgZUqsa9r7OY3hBE7Ieae
        cakkjCIsDvP3KXw5qTh6Ml5CJw==
X-Google-Smtp-Source: ABdhPJzijoUVX8vE9DIoBCMrXonPi4y3ILNA2/rCE4NzWtj2Mqnh56DmLUrbDFvf95XBrFBxhqfQEw==
X-Received: by 2002:a05:6402:1cb6:: with SMTP id cz22mr16086918edb.148.1628294780302;
        Fri, 06 Aug 2021 17:06:20 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id w23sm4419437edx.34.2021.08.06.17.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 17:06:20 -0700 (PDT)
Date:   Sat, 7 Aug 2021 02:06:18 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Steve Bennett <steveb@workware.net.au>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: phy: micrel: Fix link detection on ksz87xx switch"
Message-ID: <20210807000618.GB4898@cephalopod>
References: <20210730105120.93743-1-steveb@workware.net.au>
 <20210730095936.1420b930@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <74BE3A85-61E2-45C9-BA77-242B1014A820@workware.net.au>
 <20210807000123.GA4898@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807000123.GA4898@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a5e63c7d38d5 "net: phy: micrel: Fix detection of ksz87xx
switch" broke link detection on the external ports of the KSZ8795.

The previously unused phy_driver structure for these devices specifies
config_aneg and read_status functions that appear to be designed for a
fixed link and do not work with the embedded PHYs in the KSZ8795.

Delete the use of these functions in favour of the generic PHY
implementations which were used previously.

Fixes: a5e63c7d38d5 ("net: phy: micrel: Fix detection of ksz87xx switch")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/phy/micrel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 53bdd673ae56..5c928f827173 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1760,8 +1760,6 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
-	.config_aneg	= ksz8873mll_config_aneg,
-	.read_status	= ksz8873mll_read_status,
 	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
-- 
2.20.1

