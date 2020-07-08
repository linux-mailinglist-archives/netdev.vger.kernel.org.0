Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9712A2191C1
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgGHUpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHUpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:45:04 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A2C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:45:04 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id 9so55741318ljv.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxpijXJIOjPIklfG1x2EzSdICT9vwKHmOm2JtWTs0Fw=;
        b=SxfFGjjWk5hoNictuMHtMHPdx4driKUAgl2+5nTTA4FOs9zX8W+6rEq+lTwW7CwISh
         VmQumaukXRYIiWJ8KxHmZ8+Jxi47UGk+ZkM/0xh5joVEVISwOs/esBM8Jx1n8Hgs5Ztt
         Qyyvk5wNVRhNXmHIy+yY9MNTrsKAOWk98C/3BFSKr+MikvTa46newNAHv8fv9BAwF2bW
         mIOQVLyx1r25Tvh8i2WbYOwwv1vMP3RrA5UfvmByHl6+bU/Oh3iXo28LRF3gv8ZtRcq9
         Pta1FUPzQV3awdvXh4iRVdg7DZUof8DS8Wt/oHgsMsv0DosKjMaWB2WlEDkMn3AisG0s
         C7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxpijXJIOjPIklfG1x2EzSdICT9vwKHmOm2JtWTs0Fw=;
        b=YNawcw0ip6bhCs4OnPA3FaHKOlrXPlsJD3zYjCMRc87tnPl8CLRPQxlCdSDI03gw1I
         fKOoRDa/FGmZmkf/ODBzePyjWxbc4yorRedh2y22/AjNt0edEEZkc6Wbm39xlz0ra8dd
         mOPIpBy8R3CnQA9gSShrHEnwc3xxw/kluS0Hh60OfpNmXMWx1k9M2qNzG/K9DIzt9a+m
         nwQ0enQMU45YhRDLNPkVtk/xhieRWOKCxLyvWrg1SrlhcImAt5tsabeTRlB9UhZG8ppD
         Z+UsFjL20dTTGaZaw/iFftUdxFvKnTurZE+l0HkioPJFOBnas8Xj/bAQ76nGmkOMY/fT
         ze6A==
X-Gm-Message-State: AOAM530ZfxSjtATBUpORMFgsRBpuVyNjhQ9s+FMNngmPv9g6482ztcgp
        iB9hteASRblucqNBssQbxKV+FA==
X-Google-Smtp-Source: ABdhPJxn4mjb+QNhwEVTEkDlEKuRwmVET/5YE0l1J6PIi+pW7/u5T0M/rmt4yY1O481cdzy9AXKRoA==
X-Received: by 2002:a2e:9f4d:: with SMTP id v13mr3616814ljk.122.1594241102993;
        Wed, 08 Jul 2020 13:45:02 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id i10sm206688ljg.80.2020.07.08.13.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 13:45:02 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 1/3 v1] net: dsa: rtl8366: Fix VLAN semantics
Date:   Wed,  8 Jul 2020 22:44:54 +0200
Message-Id: <20200708204456.1365855-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708204456.1365855-1-linus.walleij@linaro.org>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
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
Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
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

