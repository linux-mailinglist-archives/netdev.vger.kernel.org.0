Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B58505020
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 14:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbiDRMVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 08:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238297AbiDRMVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 08:21:22 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3C01B79C
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 05:17:23 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 39BED24010E
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 14:17:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1650284240; bh=m06zaNElDOLmrPptGcaA5mPzK3FeCBh7vUpbw9C7Aao=;
        h=From:To:Cc:Subject:Date:From;
        b=PFZZxCFbQ17Ssq3wyEkcGBdFPYCwMHyIDbKvhPleIr85vIie4UqvbQNKhnVmGidS0
         3oU9t1NILe0vMOF30091NH+BeUPu+PEm6ZuvG6HdK7rdchWEEyWiy4Wf3XwMoqtnFc
         R6ctNhP1N695Oj6YnZtJPhevczhrWq/ongOFWK2JOFbwNtC28h44oHWe34rhabck+G
         13IIdpX7tWN1x7++8HtODTfYkmg0X4QT3zfpkp/Dy5C6aiqAkGuoJVOQ+o1X7bv5DC
         neFJ7hxsfWoqU6LHzVzCzYxHPFWzA4Tt46LGSVMEaApbPw0M8CVYzQESfDHr4DvUpM
         x95yMcyYs1BGA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KhmC30fQpz6trV;
        Mon, 18 Apr 2022 14:17:03 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev
Subject: [PATCH] net: atlantic: invert deep par in pm functions, preventing
 null derefs
Date:   Mon, 18 Apr 2022 12:17:02 +0000
Message-ID: <87sfqaa8n5.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manuel Ullmann <labre@posteo.de>
From 6c4cd8210835489da84bf4ee5049945dc0f2c986 Mon Sep 17 00:00:00 2001
Date: Mon, 18 Apr 2022 00:20:01 +0200

This will reset deeply on freeze and thaw instead of suspend and
resume and prevent null pointer dereferences of the uninitialized ring
0 buffer while thawing.

The impact is an indefinitely hanging kernel. You can't switch
consoles after this and the only possible user interaction is SysRq.

BUG: kernel NULL pointer dereference
RIP: 0010:aq_ring_rx_fill+0xcf/0x210 [atlantic]
aq_vec_init+0x85/0xe0 [atlantic]
aq_nic_init+0xf7/0x1d0 [atlantic]
atl_resume_common+0x4f/0x100 [atlantic]
pci_pm_thaw+0x42/0xa0

resolves in aq_ring.o to

```
0000000000000ae0 <aq_ring_rx_fill>:
{
/* ... */
 baf:	48 8b 43 08          	mov    0x8(%rbx),%rax
 		buff->flags = 0U; /* buff is NULL */
```

The bug has been present since the introduction of the new pm code in
8aaa112a57c1 ("net: atlantic: refactoring pm logic") and was hidden
until 8ce84271697a ("net: atlantic: changes for multi-TC support"),
which refactored the aq_vec_{free,alloc} functions into
aq_vec_{,ring}_{free,alloc}, but is technically not wrong. The
original functions just always reinitialized the buffers on S3/S4. If
the interface is down before freezing, the bug does not occur. It does
not matter, whether the initrd contains and loads the module before
thawing.

So the fix is to invert the boolean parameter deep in all pm function
calls, which was clearly intended to be set like that.

First report was on Github [1], which you have to guess from the
resume logs in the posted dmesg snippet. Recently I posted one on
Bugzilla [2], since I did not have an AQC device so far.

#regzbot introduced: 8ce84271697a
#regzbot from: koo5 <kolman.jindrich@gmail.com>
#regzbot monitor: https://github.com/Aquantia/AQtion/issues/32

Fixes: 8aaa112a57c1 ("net: atlantic: refactoring pm logic")
Link: https://github.com/Aquantia/AQtion/issues/32 [1]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215798 [2]
Cc: stable@vger.kernel.org
Reported-by: koo5 <kolman.jindrich@gmail.com>
Signed-off-by: Manuel Ullmann <labre@posteo.de>
---
Once in mainline, this should be backported to 5.10 and newer
supported stable branches. Although 5.4 includes the bug, it is not
affected (see above).

As a side effect, this might increase suspend/resume performance,
although I did no measurements.
 
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 797a95142d1f..3a529ee8c834 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -444,22 +444,22 @@ static int atl_resume_common(struct device *dev, bool deep)
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev, false);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev, false);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.35.1
