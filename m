Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD52025A77
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 00:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfEUWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 18:47:39 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37481 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfEUWrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 18:47:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id a23so206549pff.4;
        Tue, 21 May 2019 15:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lzg0QOFg5tZ6dvh54DcZawapBEZVzAMWtzXZVVv9sp0=;
        b=HCy5iDZkYsrdGRrFxUMfInlmlRmTrlwmj3R6QAQ4W66T7w88YtrV4oCfU/Dfi9OzrD
         /McGADQU7XAY0TxTVFjkNDPqb+XgSz6EFFALygM+exgYSNHbDDqslytRxKpw3c1JPEgQ
         54ExLbSGtd6kiFP78VhOfreqaNLev5GtcVXulgnbdgOfwK17kwrhpymLpil4GzZ2w8La
         VJAGDIMmoRUhSQElK2EbSxniad2WjHiphG2f4tAbvOhvlp1FnlLIQXnIrzr0pYTXj2RQ
         9s0mnXPFJz0U681RY2guqdrEuktpV8FbsbreL5jt1mM5Umv5A1YQhdOEvrSUI/SmF3C2
         as5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lzg0QOFg5tZ6dvh54DcZawapBEZVzAMWtzXZVVv9sp0=;
        b=fmzFEe5Q72gADFVJywBrWYPZxtxFN+czYEUt3p5tuylUW4yOXOYY8dPRJVQ0n33x2B
         t6DxXLxwvkwGwWVSSm+x7cDdY2DGcUEbzVdPO4z3LsWN5RannQ9MlZ/ghLjNBXJuehif
         2s5TcDxN/Egeg3LhJhO+RJiBxLAAmgvioyp3Qn5DNtmyTouOWZ7/hneRsbBrt8ksDxtb
         2kAZO+YXrNaTFYboQ6yd1pi+TTcTVgqVBnrORm1H0+DHk1GFpYD3nnQSbSeCjL1bJ+EA
         ksU7Z/b1Ct3tIan927s9voyzMSV6CO067qIgSAEOb1bCBJz0IdexlcxLW1bwekynwaKn
         OD2A==
X-Gm-Message-State: APjAAAXYY+YyRQMuuoV1GXgkHo9LJJitHNt8FKhpQkJqQLvvAz3HQdW/
        AN3RDVq2loBpDYy9cc4aNzx98pTm
X-Google-Smtp-Source: APXvYqypQjNAKalfLdreWjJgmUOa4VTghdJcFRveY1h4YapX7e4bx/1qOFNvNBCj03Q9uClQBjQO/w==
X-Received: by 2002:aa7:86c3:: with SMTP id h3mr89215810pfo.169.1558478852376;
        Tue, 21 May 2019 15:47:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id r29sm34122419pgn.14.2019.05.21.15.47.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 15:47:31 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V3 net-next 5/6] net: mdio: of: Register discovered MII time stampers.
Date:   Tue, 21 May 2019 15:47:22 -0700
Message-Id: <20190521224723.6116-6-richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When parsing a PHY node, register its time stamper, if any, and attach
the instance to the PHY device.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/phy_device.c |  3 +++
 drivers/of/of_mdio.c         | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9d6468bae6b4..a7dd76a91289 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -877,6 +877,9 @@ EXPORT_SYMBOL(phy_device_register);
  */
 void phy_device_remove(struct phy_device *phydev)
 {
+	if (phydev->mii_ts)
+		unregister_mii_timestamper(phydev->mii_ts);
+
 	device_del(&phydev->mdio.dev);
 
 	/* Assert the reset signal */
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index fcf25e32b1ed..c18629b1a72a 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -43,14 +43,37 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
+struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+{
+	struct of_phandle_args arg;
+	int err;
+
+	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
+
+	if (err == -ENOENT)
+		return NULL;
+	else if (err)
+		return ERR_PTR(err);
+
+	if (arg.args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	return register_mii_timestamper(arg.np, arg.args[0]);
+}
+
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
+	struct mii_timestamper *mii_ts;
 	struct phy_device *phy;
 	bool is_c45;
 	int rc;
 	u32 phy_id;
 
+	mii_ts = of_find_mii_timestamper(child);
+	if (IS_ERR(mii_ts))
+		return PTR_ERR(mii_ts);
+
 	is_c45 = of_device_is_compatible(child,
 					 "ethernet-phy-ieee802.3-c45");
 
@@ -95,6 +118,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 		of_node_put(child);
 		return rc;
 	}
+	phy->mii_ts = mii_ts;
 
 	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
 		child, addr);
-- 
2.11.0

