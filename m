Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0842C51B19A
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 00:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354636AbiEDWJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379047AbiEDWJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 18:09:38 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAA7BE1C
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:05:59 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id 869F524010A
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 00:05:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651701957; bh=ULZZ+k26KKjcsFqAjZrCBvWd2aE7gAOo79lBw+9K7RA=;
        h=From:To:Cc:Subject:Date:From;
        b=Mj0ixB7Cx2Fo2Tjdg89gHmvZlpDrCkY1nH9NZpPSy5P1xzWWI0/fkQftmGPGtD9Sb
         U6U10z5b+uCJl5uWlzQLUXZy/O5ksv9xIf8+xgmWyUqcS16aeSULtYCv3iVLga3KtE
         S0GCawRfSrWEcnzduDG4dz1PqXNw1EqP8JHv6rAqHxFUFsHpR855fyBmqFoYtKw2bS
         o9hZT9Xy88pDuCc8sAUFAq2eS5aO73hGW/xlzJJGqy1mx3+3olE+zTbni9yKQprUor
         c10hoGCQh/UZJxHjoKFKpaGGUg8DChuG2VZ4lz30jC9zh7Im65ksazELNF5bb06AZ1
         QHeP2Z3KS1NTw==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KtrW76HfFz6tmP;
        Thu,  5 May 2022 00:05:55 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        Jordan Leppert <jordanleppert@protonmail.com>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, koo5 <kolman.jindrich@gmail.com>
Subject: [PATCH] net: atlantic: always deep reset on pm op, fixing null
 deref regression
Date:   Wed, 04 May 2022 22:06:12 +0000
Message-ID: <87czgt2bsb.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From a3eccd32c618fe4b4f5c537cd83ba5611149623e Mon Sep 17 00:00:00 2001
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

Fixes: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c
Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4=
MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=
=3D@protonmail.com/
Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
Reported-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
CC: <stable@vger.kernel.org> # 5.17.5
CC: <stable@vger.kernel.org> # 5.15.36
CC: <stable@vger.kernel.org> # 5.10.113
Signed-off-by: Manuel ULlmann <labre@posteo.de>
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
