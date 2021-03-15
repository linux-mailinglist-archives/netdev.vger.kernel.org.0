Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849C333BCB5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhCOO2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239062AbhCOO1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:27:41 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335CAC061762;
        Mon, 15 Mar 2021 07:27:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x13so5793653wrs.9;
        Mon, 15 Mar 2021 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SHHSRUWezr0Ic1+f9vMp5xPcEDElTAD5qEAa1pLjQAg=;
        b=MGiRr632QDPiDLeR4leJ3CuqmG6+zFoRJizK5b0yiZdg1pEGmZz2ufa8XPocKZFO6K
         kdUkjdvVNv8uG75S+96TTU/oZQAO93aB926oS2Ejci/HdswZCl5N/DFkom9HC8fJnB3i
         pf8FqYzWHNMTiQcUvNOs0dA8QJ5HVR8K2716tiFCt93mP/3aivZH7OsYh/jI1uJqRw+h
         bEUfl6ICWgubJ/IKG9lOvppUi1WIWFWcuPxfCBplUtMpSxrSqr8zEsYnYCwtdmAHjHf7
         QkriDHBUtL52367kSgpoHVR9AgTDFqJK4jPEwX0WUjnpviCf20nb7FmCvRLTTkA14JEU
         Xwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SHHSRUWezr0Ic1+f9vMp5xPcEDElTAD5qEAa1pLjQAg=;
        b=kI/H2oyNRRn22RONIP1k//RAyFmNZNMWl7Z6oC9lp6uhXZExgUcpZcgBpja35uHvRp
         QC03pKQjA3Y4bqTInyAPiuA1CYmUHKfc+XgvKK4o43BvepzFh73Kl2Df8fHQ3Yv16rLH
         DF1qhIsy4YeEN/lAaTx77NJWjLRHy/co5fIn7xluVsQddri9oCkybPjKxH8j+8PSljE5
         aPD2A8spFegF9cRZ7qqxdtViWQknjSdUeQgFT7aWK29JxN2VxsbYlmaGl8GGJj9Pm9dt
         H1qr1t3a2bORtw+tSGJti0d9X7TcINWQM6NXWSikILINvxbhfHAwlaugkMnHSKN/4D7E
         w5Hw==
X-Gm-Message-State: AOAM532TjkF12P746nYJZ38ttmzJGNdwJdaFW9bX1L/CgeF65By0inoo
        woTkLPS6jbJ+RNFkegRqN8A=
X-Google-Smtp-Source: ABdhPJzvWD6D9aDv2XV7Y2SCAsk72abeozDbFK4bvuR509ebm/PvobpQz0ytgmThsS9Q+chRhd/gYg==
X-Received: by 2002:adf:e68e:: with SMTP id r14mr27251593wrm.273.1615818459918;
        Mon, 15 Mar 2021 07:27:39 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id 21sm12856606wme.6.2021.03.15.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:39 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: b53: support legacy tags
Date:   Mon, 15 Mar 2021 15:27:36 +0100
Message-Id: <20210315142736.7232-3-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315142736.7232-1-noltari@gmail.com>
References: <20210315142736.7232-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tags are used on BCM5325, BCM5365 and BCM63xx switches.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/Kconfig      | 1 +
 drivers/net/dsa/b53/b53_common.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index f9891a81c808..90b525160b71 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -3,6 +3,7 @@ menuconfig B53
 	tristate "Broadcom BCM53xx managed switch support"
 	depends on NET_DSA
 	select NET_DSA_TAG_BRCM
+	select NET_DSA_TAG_BRCM_LEGACY
 	select NET_DSA_TAG_BRCM_PREPEND
 	help
 	  This driver adds support for Broadcom managed switch chips. It supports
diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a162499bcafc..a583948cdf4f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2034,6 +2034,7 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
 
 	switch (tag_protocol) {
 	case DSA_TAG_PROTO_BRCM:
+	case DSA_TAG_PROTO_BRCM_LEGACY:
 	case DSA_TAG_PROTO_BRCM_PREPEND:
 		dev_warn(ds->dev,
 			 "Port %d is stacked to Broadcom tag switch\n", port);
@@ -2055,12 +2056,16 @@ enum dsa_tag_protocol b53_get_tag_protocol(struct dsa_switch *ds, int port,
 	/* Older models (5325, 5365) support a different tag format that we do
 	 * not support in net/dsa/tag_brcm.c yet.
 	 */
-	if (is5325(dev) || is5365(dev) ||
-	    !b53_can_enable_brcm_tags(ds, port, mprot)) {
+	if (!b53_can_enable_brcm_tags(ds, port, mprot)) {
 		dev->tag_protocol = DSA_TAG_PROTO_NONE;
 		goto out;
 	}
 
+	if (is5325(dev) || is5365(dev) || is63xx(dev)) {
+		dev->tag_protocol = DSA_TAG_PROTO_BRCM_LEGACY;
+		goto out;
+	}
+
 	/* Broadcom BCM58xx chips have a flow accelerator on Port 8
 	 * which requires us to use the prepended Broadcom tag type
 	 */
-- 
2.20.1

