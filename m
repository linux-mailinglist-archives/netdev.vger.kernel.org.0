Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5DD51CB86
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 23:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386043AbiEEVpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 17:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386040AbiEEVpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 17:45:12 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D2A52B06
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 14:41:31 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 1372624002A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 23:41:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651786889; bh=bPb1kqwTN0xfUWA9/0wHbJECuxh+OsfFhhPsmRIveHU=;
        h=From:To:Cc:Subject:Date:From;
        b=mgxwNJ57cOkMTtZQ8Ij0d2a9HKiG/02Ow6ajM4qlk4M4vPF8soQh0ubJanHUwZl04
         jRn2LXVZHd6m7HjlbQO9/6Uk4xUCZs7ezNZyVAarqXQPsH6CFqCgLZe+yhUrCJtm6h
         kTw9UFFpyFyLa7PTpdm4q2kE60SSWo/xAagQ8kl+HfbHHxtx3a+alRaRGtQvpYSOh6
         bnYL0RvSFz0xy8WaatlgXzPwedU1A5eTWZiEDvvSuB67wMU3Ix04Trtvw2v/BG7iu9
         kW6OlyP8KnGg7Fhk6gzP5xj4nH0rL7ln/YbmqARRvaNScHdZCSC9z5Qrv/SK6a0NjJ
         /6Y+clGza1tDA==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KvRwQ6d7Jz6tpp;
        Thu,  5 May 2022 23:41:26 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jordan Leppert <jordanleppert@protonmail.com>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, koo5 <kolman.jindrich@gmail.com>
Subject: [PATCH v2] net: atlantic: always deep reset on pm op, fixing null
 deref regression
Date:   Thu, 05 May 2022 21:41:41 +0000
Message-ID: <877d6zirmy.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 86ba48e4c5e1b34cea471b8f5a64b085763e0c57 Mon Sep 17 00:00:00 2001
From: Manuel Ullmann <labre@posteo.de>
Date: Wed, 4 May 2022 21:30:44 +0200

The impact of this regression is the same for resume that I saw on
thaw: the kernel hangs and nothing except SysRq rebooting can be done.

The null deref occurs at the same position as on thaw.
BUG: kernel NULL pointer dereference
RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]

Fixes regression in cbe6c3a8f8f4 ("net: atlantic: invert deep par in
pm functions, preventing null derefs"), where I disabled deep pm
resets in suspend and resume, trying to make sense of the
atl_resume_common deep parameter in the first place.

It turns out, that atlantic always has to deep reset on pm operations
and the parameter is useless. Even though I expected that and tested
resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
missing the breakage.

This fixup obsoletes the deep parameter of atl_resume_common, but I
leave the cleanup for the maintainers to post to mainline.

PS: I'm very sorry for this regression.

Changes in v2:
Patch formatting fixes
- Fix Fixes tag
=E2=80=93 Simplify stable Cc tag
=E2=80=93 Fix Signed-off-by tag

Fixes: cbe6c3a8f8f4 ("net: atlantic: invert deep par in pm functions, preve=
nting null derefs")
Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4=
MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=
=3D@protonmail.com/
Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
Reported-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Manuel Ullmann <labre@posteo.de>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers=
/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 3a529ee8c834..831833911a52 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -449,7 +449,7 @@ static int aq_pm_freeze(struct device *dev)
=20
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
=20
 static int aq_pm_thaw(struct device *dev)
@@ -459,7 +459,7 @@ static int aq_pm_thaw(struct device *dev)
=20
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
=20
 static const struct dev_pm_ops aq_pm_ops =3D {

base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
--=20
2.35.1
