Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7292423AADD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgHCQsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgHCQsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:48:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0E3C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 09:48:40 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id qc22so24551791ejb.4
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 09:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9OIxiTHcwL/VWYGr3CvgTU6daZCGsIFTBxMlbKrSak=;
        b=C4PWfy9c67fyrowdojD5k7vSljI6QUQPObH+nI5XqLJ1WuSnZOkh2nqldPOdUlyQ46
         OOF6aZ07DO9N7HfYp6e/NIgbTxps3vcRqkqPOHcmu90GntWtSBlgTe70CidhuuBUirJ1
         mJN2F31/eZ9/fGYp7Xnp2Iem/dRTPRNq0cl6y3uJprqoZK0VIi1nntvCPBzmV+/RzF5K
         7gbWmMI1ZmYiStEpCEXW0mG/TMHxg5m9jTczuk8fGvqQ6p/V/QZJrH89v0nojm//WNkQ
         9vrW3MSj61EvuZC+45EJXijuzvYhO/C0uUyj6at2fhVb5zvk8XnBM2x4tu6z78xo8p2j
         ENKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f9OIxiTHcwL/VWYGr3CvgTU6daZCGsIFTBxMlbKrSak=;
        b=iLlBsJKNBJbFv5qebVA9bA/IUtxQFCVFhr2nkFV6lVPzaUMDheYO+RRNeVQJ8aqPpB
         txgWWgSOiJG6UprlQIszoY3zxSWEhDz5B+nCdsE8ebYU8rxMUD/crvMJPkrXObDkPO9C
         X3lcPKswo5sbfrehrkT3O/xRNsZkhF9A4wsHKPGDPUEq8F1eC6zXBnENMX1/98/2X0Xz
         KtZgX9vmm+Zo3mWUte6Cf4llS2Bc9POxH6wdG9W8coVQaiOn7G++DGQALBFcKooqOEZc
         xzkcokxPAA6Tk5Ct5yznuMOVhiaNtZFQ9M4XmSShsNRzdBypxbpvnbGVFjcuXfLqXX4/
         PMHw==
X-Gm-Message-State: AOAM532Qeac2zpBmhYwaE39LsOlv7HdNrnokt+dMkA3zGZeSllI30TEC
        W8IEfYgDG8/r0DYnkhHCbFe3qzcN
X-Google-Smtp-Source: ABdhPJxRpz8TLt1EL4yvSwy3qsqV2xz1yK6Eg3gf7l3zHmnsdF65DCOvDChRnjbkq+uGZnYVvRY/oQ==
X-Received: by 2002:a17:906:6004:: with SMTP id o4mr18068162ejj.411.1596473318974;
        Mon, 03 Aug 2020 09:48:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id x21sm16372923edq.84.2020.08.03.09.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 09:48:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next] net: dsa: sja1105: use detected device id instead of DT one on mismatch
Date:   Mon,  3 Aug 2020 19:48:23 +0300
Message-Id: <20200803164823.414772-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although we can detect the chip revision 100% at runtime, it is useful
to specify it in the device tree compatible string too, because
otherwise there would be no way to assess the correctness of device tree
bindings statically, without booting a board (only some switch versions
have internal RGMII delays and/or an SGMII port).

But for testing the P/Q/R/S support, what I have is a reworked board
with the SJA1105T replaced by a pin-compatible SJA1105Q, and I don't
want to keep a separate device tree blob just for this one-off board.
Since just the chip has been replaced, its RGMII delay setup is
inherently the same (meaning: delays added by the PHY on the slave
ports, and by PCB traces on the fixed-link CPU port).

For this board, I'd rather have the driver shout at me, but go ahead and
use what it found even if it doesn't match what it's been told is there.

[    2.970826] sja1105 spi0.1: Device tree specifies chip SJA1105T but found SJA1105Q, please fix it!
[    2.980010] sja1105 spi0.1: Probed switch chip: SJA1105Q
[    3.005082] sja1105 spi0.1: Enabled switch tagging

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 35 ++++++++++++++++++--------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5079e4aeef80..c3f6f124e5f0 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3391,11 +3391,14 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.devlink_param_set	= sja1105_devlink_param_set,
 };
 
+static const struct of_device_id sja1105_dt_ids[];
+
 static int sja1105_check_device_id(struct sja1105_private *priv)
 {
 	const struct sja1105_regs *regs = priv->info->regs;
 	u8 prod_id[SJA1105_SIZE_DEVICE_ID] = {0};
 	struct device *dev = &priv->spidev->dev;
+	const struct of_device_id *match;
 	u32 device_id;
 	u64 part_no;
 	int rc;
@@ -3405,12 +3408,6 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 	if (rc < 0)
 		return rc;
 
-	if (device_id != priv->info->device_id) {
-		dev_err(dev, "Expected device ID 0x%llx but read 0x%x\n",
-			priv->info->device_id, device_id);
-		return -ENODEV;
-	}
-
 	rc = sja1105_xfer_buf(priv, SPI_READ, regs->prod_id, prod_id,
 			      SJA1105_SIZE_DEVICE_ID);
 	if (rc < 0)
@@ -3418,13 +3415,29 @@ static int sja1105_check_device_id(struct sja1105_private *priv)
 
 	sja1105_unpack(prod_id, &part_no, 19, 4, SJA1105_SIZE_DEVICE_ID);
 
-	if (part_no != priv->info->part_no) {
-		dev_err(dev, "Expected part number 0x%llx but read 0x%llx\n",
-			priv->info->part_no, part_no);
-		return -ENODEV;
+	for (match = sja1105_dt_ids; match->compatible; match++) {
+		const struct sja1105_info *info = match->data;
+
+		/* Is what's been probed in our match table at all? */
+		if (info->device_id != device_id || info->part_no != part_no)
+			continue;
+
+		/* But is it what's in the device tree? */
+		if (priv->info->device_id != device_id ||
+		    priv->info->part_no != part_no) {
+			dev_warn(dev, "Device tree specifies chip %s but found %s, please fix it!\n",
+				 priv->info->name, info->name);
+			/* It isn't. No problem, pick that up. */
+			priv->info = info;
+		}
+
+		return 0;
 	}
 
-	return 0;
+	dev_err(dev, "Unexpected {device ID, part number}: 0x%x 0x%llx\n",
+		device_id, part_no);
+
+	return -ENODEV;
 }
 
 static int sja1105_probe(struct spi_device *spi)
-- 
2.25.1

