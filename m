Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D7B4DBDDD
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 05:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiCQEsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 00:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiCQEsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 00:48:09 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D8E126FB7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 21:40:09 -0700 (PDT)
X-QQ-mid: bizesmtp85t1647491636t0mm7bcn
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 17 Mar 2022 12:33:47 +0800 (CST)
X-QQ-SSF: 01400000002000D0H000B00A0000000
X-QQ-FEAT: RMVj0UrY8cC0YGAUx/2nKiGC/VzxwmGLjHnmxBG/tXl+3Rzg4sxVsUFyBB4UN
        w6bSm+qsBc5e1KXquUKV2h3yZjONLMwC9YrHc+iqDCVm7RRHYGEjADV9TtK+bk2L33oEbHq
        2bAs1gTjrPbMFVwMEItex/8GLqMKbDKW6CTirY/vCs8KosZCOK4Jf7BHZ9Wo5wcXcCWnElS
        t8ZAwE7Uqhi9yAvfwYXA/tcFqlJCF1/X3xZzNHihT3F/PkjtFZNNQp2Yq55tFmD299aJA0g
        k+yZWUhU8mQiE+co69Jbrbp0l+RIVv01KmfI3MWv3Y2xogG5jBP0DchPVgCLiHNsHXVELn9
        bq7BzTjwh3tLajF/afaasR8CmY7zA==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     klassert@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH] net: 3com: 3c59x: Change the conditional processing for vortex_ioctl
Date:   Thu, 17 Mar 2022 12:33:44 +0800
Message-Id: <20220317043344.15317-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the vortex_ioctl, there are two places where there can be better
and easier to understand:
First, it should be better to reverse the check on 'VORTEX_PCI(vp)'
and returned early in order to be easier to understand.
Second, no need to make two 'if(state != 0)' judgments, we can
simplify the execution process.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/ethernet/3com/3c59x.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index ccf07667aa5e..c22de3c8cd12 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -3032,16 +3032,19 @@ static int vortex_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	struct vortex_private *vp = netdev_priv(dev);
 	pci_power_t state = 0;
 
-	if(VORTEX_PCI(vp))
-		state = VORTEX_PCI(vp)->current_state;
+	if (!VORTEX_PCI(vp))
+		return -EOPNOTSUPP;
 
-	/* The kernel core really should have pci_get_power_state() */
+	state = VORTEX_PCI(vp)->current_state;
 
-	if(state != 0)
+	/* The kernel core really should have pci_get_power_state() */
+	if (!state) {
+		err = generic_mii_ioctl(&vp->mii, if_mii(rq), cmd, NULL);
+	} else {
 		pci_set_power_state(VORTEX_PCI(vp), PCI_D0);
-	err = generic_mii_ioctl(&vp->mii, if_mii(rq), cmd, NULL);
-	if(state != 0)
+		err = generic_mii_ioctl(&vp->mii, if_mii(rq), cmd, NULL);
 		pci_set_power_state(VORTEX_PCI(vp), state);
+	}
 
 	return err;
 }
-- 
2.20.1



