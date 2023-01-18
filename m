Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B24D67244F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjARQ6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjARQ55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:57:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D5146D4D
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674061027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kps1z9ixd0lDxco9/OkjAqqpIKVmg5Dst50L33D/YhY=;
        b=N2J4xJOg3en3lhV1LPq5xo0ukY8/IItclwi2gQOYSE17P65U7T95OTb/ZvOQAMkxHJx+b2
        F4Y3blHLaUMspHFKBOThMcDK1GDNZZNgJajKl033QhOeGDUssHV8Mf6sIz1aRqq7N45Ryz
        Iwm29qBhV5omos+ldXzop0x1d2w7uwA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-XaNrFmsCPN2KBnpN6fdJcQ-1; Wed, 18 Jan 2023 11:57:06 -0500
X-MC-Unique: XaNrFmsCPN2KBnpN6fdJcQ-1
Received: by mail-ot1-f69.google.com with SMTP id bu27-20020a0568300d1b00b006865fffa6d7so329769otb.14
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kps1z9ixd0lDxco9/OkjAqqpIKVmg5Dst50L33D/YhY=;
        b=BuIVKFNeKQw+VPBXqD8purmVCNC1XnS7CuioiQYTf/fxddImr9PbL2UqwscArwNO6y
         9jDrLcPrKhC6VG4n12WqIlu2NyZ2C32bma549ffr0oyj5IccKzoA0Vj2tIYBirNghNSM
         ki1eiysoBHThMCvwr6gtHVoZ5kokx7rCBYRLteykXhIaJBN4im5J2CF/EbslR7c6RkBW
         oCVZe/ydFpyk/28wyES04gNTYvtEd3U/UHhCqgGCFapUlMAKJGriG9ufYA6puEmRwCju
         C9SqjsGubxg4jeL0CNu6SG4MuGAHBIlgxYMFgYThK+4k4F4WpxCHGcIC+TVXERunFUT5
         UOsg==
X-Gm-Message-State: AFqh2kqiS7GtwAdDsjoqKioL2/ttiI4Ji55MJeMJiYO8i7Fb5mLwnWWb
        iE7wE7HveWloq3aJEIpmgbjkzygWwqxG50Z/6L6b0F9PoRJonmmfMa3bkJElhFfPdvkplcAhSE/
        /j3pVzGHLSGLw1UF+
X-Received: by 2002:a4a:1843:0:b0:4f2:8fa2:acda with SMTP id 64-20020a4a1843000000b004f28fa2acdamr3678868ooo.5.1674061023631;
        Wed, 18 Jan 2023 08:57:03 -0800 (PST)
X-Google-Smtp-Source: AMrXdXupkdVG/yfD1cPihjSS9PG73ekCsefEWVRwlr9j6832liTFaRdIJ5Wb9zlCzZCcuDSscvm3Sw==
X-Received: by 2002:a4a:1843:0:b0:4f2:8fa2:acda with SMTP id 64-20020a4a1843000000b004f28fa2acdamr3678860ooo.5.1674061023348;
        Wed, 18 Jan 2023 08:57:03 -0800 (PST)
Received: from halaney-x13s.attlocal.net ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id i23-20020a4a8d97000000b004a0ad937ccdsm6365174ook.1.2023.01.18.08.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:57:02 -0800 (PST)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     davem@davemloft.net
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vee.khee.wong@linux.intel.com, noor.azura.ahmad.tarmizi@intel.com,
        vijayakannan.ayyathurai@intel.com, michael.wei.hong.sit@intel.com,
        Andrew Halaney <ahalaney@redhat.com>,
        Ning Cai <ncai@quicinc.com>
Subject: [PATCH net RESEND] net: stmmac: enable all safety features by default
Date:   Wed, 18 Jan 2023 10:56:38 -0600
Message-Id: <20230118165638.1383764-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the original implementation of dwmac5
commit 8bf993a5877e ("net: stmmac: Add support for DWMAC5 and implement Safety Features")
all safety features were enabled by default.

Later it seems some implementations didn't have support for all the
features, so in
commit 5ac712dcdfef ("net: stmmac: enable platform specific safety features")
the safety_feat_cfg structure was added to the callback and defined for
some platforms to selectively enable these safety features.

The problem is that only certain platforms were given that software
support. If the automotive safety package bit is set in the hardware
features register the safety feature callback is called for the platform,
and for platforms that didn't get a safety_feat_cfg defined this results
in the following NULL pointer dereference:

[    7.933303] Call trace:
[    7.935812]  dwmac5_safety_feat_config+0x20/0x170 [stmmac]
[    7.941455]  __stmmac_open+0x16c/0x474 [stmmac]
[    7.946117]  stmmac_open+0x38/0x70 [stmmac]
[    7.950414]  __dev_open+0x100/0x1dc
[    7.954006]  __dev_change_flags+0x18c/0x204
[    7.958297]  dev_change_flags+0x24/0x6c
[    7.962237]  do_setlink+0x2b8/0xfa4
[    7.965827]  __rtnl_newlink+0x4ec/0x840
[    7.969766]  rtnl_newlink+0x50/0x80
[    7.973353]  rtnetlink_rcv_msg+0x12c/0x374
[    7.977557]  netlink_rcv_skb+0x5c/0x130
[    7.981500]  rtnetlink_rcv+0x18/0x2c
[    7.985172]  netlink_unicast+0x2e8/0x340
[    7.989197]  netlink_sendmsg+0x1a8/0x420
[    7.993222]  ____sys_sendmsg+0x218/0x280
[    7.997249]  ___sys_sendmsg+0xac/0x100
[    8.001103]  __sys_sendmsg+0x84/0xe0
[    8.004776]  __arm64_sys_sendmsg+0x24/0x30
[    8.008983]  invoke_syscall+0x48/0x114
[    8.012840]  el0_svc_common.constprop.0+0xcc/0xec
[    8.017665]  do_el0_svc+0x38/0xb0
[    8.021071]  el0_svc+0x2c/0x84
[    8.024212]  el0t_64_sync_handler+0xf4/0x120
[    8.028598]  el0t_64_sync+0x190/0x194

Go back to the original behavior, if the automotive safety package
is found to be supported in hardware enable all the features unless
safety_feat_cfg is passed in saying this particular platform only
supports a subset of the features.

Fixes: 5ac712dcdfef ("net: stmmac: enable platform specific safety features")
Reported-by: Ning Cai <ncai@quicinc.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

RESEND: with some Intel folks on Cc this time as requested by Jakub!

I've been working on a newer Qualcomm platform (sa8540p-ride) which has
a variant of dwmac5 in it. This patch is something Ning stumbled on when
adding some support for it downstream, and has been in my queue as I try
and get some support ready for review on list upstream.

Since it isn't really related to the particular hardware I decided to
pop it on list now. Please let me know if instead of enabling by default
(which the original implementation did and is why I went that route) a
message like "Safety features detected but not enabled in software" is
preferred and platforms are skipped unless they opt-in for enablement.

Thanks,
Andrew

 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 9c2d40f853ed..413f66017219 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -186,11 +186,25 @@ static void dwmac5_handle_dma_err(struct net_device *ndev,
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp,
 			      struct stmmac_safety_feature_cfg *safety_feat_cfg)
 {
+	struct stmmac_safety_feature_cfg all_safety_feats = {
+		.tsoee = 1,
+		.mrxpee = 1,
+		.mestee = 1,
+		.mrxee = 1,
+		.mtxee = 1,
+		.epsi = 1,
+		.edpp = 1,
+		.prtyen = 1,
+		.tmouten = 1,
+	};
 	u32 value;
 
 	if (!asp)
 		return -EINVAL;
 
+	if (!safety_feat_cfg)
+		safety_feat_cfg = &all_safety_feats;
+
 	/* 1. Enable Safety Features */
 	value = readl(ioaddr + MTL_ECC_CONTROL);
 	value |= MEEAO; /* MTL ECC Error Addr Status Override */
-- 
2.39.0

