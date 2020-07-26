Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374AE22E353
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 01:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgGZXe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 19:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGZXe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 19:34:56 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C1C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:55 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s16so20893ljc.8
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 16:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rc8F31vQgyzmseTSjEvvQ2ZmeNk370kua+35RMa42C4=;
        b=OgV4FKg2bFryYIZG1CBaMggEvTkCLo/3eYeIrf2hzbeJXmmwYekh/9gWr5QzbV6+Gh
         Sp0oOtSiMd5FLjOkaU/sU+TC03+1umvDfxoryaAoHBvpd2nsT6bmTHiQaPkWRIMOrfzh
         2gx41dgrNJ0iaxngLIKSIgJLb1KImK7MqcTFInNeIHYUmyC/PE+BlEeCJDIvgzPXDdbI
         +V0pSFYy1Qvxp1cG/ZleREB3q2LodgdcirKz+BIh/ZJotDi0SKXgWMLEfjMxRwicydef
         iX69PJFCWqqwhP1xbGRiwz8LnMY9DQ1OzlKMt02R4qxolj+qrLQEVdvSGJmsOEv3eHKw
         WySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rc8F31vQgyzmseTSjEvvQ2ZmeNk370kua+35RMa42C4=;
        b=BD/QckveiXY94jLYMsqk5YcgyTVba73heYFXi2A0R+FYaxODFo7QV2bhHG598FBu0Q
         0T5iSrBpKe83Od+HVswWW+/DpYnZFxTqJ2BU4rCieVcv/OiyWVIyxCvizfpBA3YIoU3j
         GBMABTHz9qxhHHBnVKJ/hhAMstevv0wPEk76fgkgFZ2FMvbR4f52ozu1Ji/Bu5/NEoGu
         qs5pbrgi4jrPCYqOi5W+lT2ALFFBOQT3aE1ZfsJIWKcRenIOxklH5mVcA/mLm57JcgSk
         1DX1QtWiI2TG8MPH20gUtZ522JHX2RSFz07sKxp22spCLy29QcqHQpvEzvsGRDwoCCpn
         9ouw==
X-Gm-Message-State: AOAM531he0d5v0pH4ddPL5bXGgs6eB3Db2ilcMxyXaDF52V75JjBMXve
        PR067RN+UZGiBs+Td4en1tR6fA==
X-Google-Smtp-Source: ABdhPJzW2EUGvz8gkWvr/YdW6NAwbPzf0/0XBrFql6M6HRIg1AQ24q8PgszY/Smz3Zvax1rRwsoNQw==
X-Received: by 2002:a2e:9d84:: with SMTP id c4mr8947727ljj.46.1595806493815;
        Sun, 26 Jul 2020 16:34:53 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id v25sm2028605ljg.95.2020.07.26.16.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 16:34:53 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 1/2 v2] net: dsa: rtl8366: Fix VLAN semantics
Date:   Mon, 27 Jul 2020 01:34:39 +0200
Message-Id: <20200726233440.374390-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726233440.374390-1-linus.walleij@linaro.org>
References: <20200726233440.374390-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8366 would not handle adding new members (ports) to
a VLAN: the code assumed that ->port_vlan_add() was only
called once for a single port. When intializing the
switch with .configure_vlan_while_not_filtering set to
true, the function is called numerous times for adding
all ports to VLAN1, which was something the code could
not handle.

Alter rtl8366_set_vlan() to just |= new members and
untagged flags to 4k and MC VLAN table entries alike.
This makes it possible to just add new ports to a
VLAN.

Put in some helpful debug code that can be used to find
any further bugs here.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Collect Florian's Review-tag
---
 drivers/net/dsa/rtl8366.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 993cf3ac59d9..2997abeecc4a 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -43,18 +43,26 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 	int ret;
 	int i;
 
+	dev_dbg(smi->dev,
+		"setting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
+		vid, member, untag);
+
 	/* Update the 4K table */
 	ret = smi->ops->get_vlan_4k(smi, vid, &vlan4k);
 	if (ret)
 		return ret;
 
-	vlan4k.member = member;
-	vlan4k.untag = untag;
+	vlan4k.member |= member;
+	vlan4k.untag |= untag;
 	vlan4k.fid = fid;
 	ret = smi->ops->set_vlan_4k(smi, &vlan4k);
 	if (ret)
 		return ret;
 
+	dev_dbg(smi->dev,
+		"resulting VLAN%d 4k members: 0x%02x, untagged: 0x%02x\n",
+		vid, vlan4k.member, vlan4k.untag);
+
 	/* Try to find an existing MC entry for this VID */
 	for (i = 0; i < smi->num_vlan_mc; i++) {
 		struct rtl8366_vlan_mc vlanmc;
@@ -65,11 +73,16 @@ int rtl8366_set_vlan(struct realtek_smi *smi, int vid, u32 member,
 
 		if (vid == vlanmc.vid) {
 			/* update the MC entry */
-			vlanmc.member = member;
-			vlanmc.untag = untag;
+			vlanmc.member |= member;
+			vlanmc.untag |= untag;
 			vlanmc.fid = fid;
 
 			ret = smi->ops->set_vlan_mc(smi, i, &vlanmc);
+
+			dev_dbg(smi->dev,
+				"resulting VLAN%d MC members: 0x%02x, untagged: 0x%02x\n",
+				vid, vlanmc.member, vlanmc.untag);
+
 			break;
 		}
 	}
-- 
2.26.2

