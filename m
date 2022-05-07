Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B451E884
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 18:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377862AbiEGQbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 12:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiEGQbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 12:31:34 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D4A34662
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 09:27:43 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id B4DD424010D
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 18:27:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651940860; bh=k0ASTfiS6TwGFLg/edUL08Y/fyise8EySIg2PekxSS8=;
        h=From:To:Cc:Subject:Date:From;
        b=rSJ4eiOukclbqPMoX8l9mO4qbNpWHEHt7hN++Z/aHGdk0WUP0oUKfv+KAvwZljSTu
         dFENVsorV5H742KbA/eKUKPp6Um2s4QyswigATcQLkY11UgCBqBz/2oCto5s7M6dOD
         Dff6biJ61fvBfsKzQVC3M+zevUCt1hgo4Pl3aoNd/At7h/+aFO29IHEhLOQO3Il/qF
         vyFvRJrW2CIN0rvhvko5YiL5H9Bv0Lf2mrSAGI9D1zmeNYw5cF2plVk/iJIFaOe0KC
         YmHQqZxiCy0Db+N5yPTZ5L4W04ZaJeJbE8qlacpxzJhUvVGAHae4dSqRX9PpMqsitM
         XoND24Uk7ws6g==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4KwXsQ3gHDz6tmG;
        Sat,  7 May 2022 18:27:38 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jordan Leppert <jordanleppert@protonmail.com>,
        Holger =?utf-8?Q?Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>, koo5 <kolman.jindrich@gmail.com>
Subject: [PATCH net-next v4] net: atlantic: always deep reset on pm op,
 fixing up my null deref regression
Date:   Sat, 07 May 2022 16:27:48 +0000
Message-ID: <87zgjtz4sb.fsf@posteo.de>
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

From 18dc080d8d4a30d0fcb45f24fd15279cc87c47d5 Mon Sep 17 00:00:00 2001
Date: Wed, 4 May 2022 21:30:44 +0200

The impact of this regression is the same for resume that I saw on
thaw: the kernel hangs and nothing except SysRq rebooting can be done.

Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
par in pm functions, preventing null derefs"), where I disabled deep
pm resets in suspend and resume, trying to make sense of the
atl_resume_common() deep parameter in the first place.

It turns out, that atlantic always has to deep reset on pm
operations. Even though I expected that and tested resume, I screwed
up by kexec-rebooting into an unpatched kernel, thus missing the
breakage.

This fixup obsoletes the deep parameter of atl_resume_common, but I
leave the cleanup for the maintainers to post to mainline.

Suspend and hibernation were successfully tested by the reporters.

Fixes: cbe6c3a8f8f4 ("net: atlantic: invert deep par in pm functions, preve=
nting null derefs")
Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4=
MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=
=3D@protonmail.com/
Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
Reported-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
Tested-by: Jordan Leppert <jordanleppert@protonmail.com>
Tested-by: Holger Hoffst=C3=A4tte <holger@applied-asynchrony.com>
CC: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Manuel Ullmann <labre@posteo.de>
---
I=E2=80=99m very sorry for this regression. It would be nice, if this could
reach mainline before 5.18 release, if applicable. This restores the
original suspend behaviour, while keeping the fix for hibernation. The
fix for hibernation might not be the root cause, but still is the most
simple fix for backporting to stable while the root cause is unknown
to the maintainers.

Changes in v2:
Patch formatting fixes
=E2=80=93 Fix Fixes tag
=E2=80=93 Simplify stable Cc tag
=E2=80=93 Fix Signed-off-by tag

Changes in v3:
=E2=80=93 Prefixed commit reference with "commit" aka I managed to use
  checkpatch.pl.
=E2=80=93 Added Tested-by tags for the testing reporters.
=E2=80=93 People start to get annoyed by my patch revision spamming. Should=
 be
  the last one.

Changes in v4:
=E2=80=93 Moved patch changelog to comment section
=E2=80=93 Use unicode ndash for patch changelog list to avoid confusion with
  diff in editors
=E2=80=93 Expanded comment
=E2=80=93 Targeting net-next by subject

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
