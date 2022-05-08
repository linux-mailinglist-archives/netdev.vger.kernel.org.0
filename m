Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4C51EABB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 02:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiEHAkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 20:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiEHAkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 20:40:41 -0400
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D0C273
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 17:36:51 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout02.posteo.de (Postfix) with ESMTPS id CFBDD240108
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:36:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1651970209; bh=eRJ72IYITlVDpKnZ6+UmjwqGp62CGsHXISCjq+X2pUU=;
        h=From:To:Cc:Subject:Date:From;
        b=htiC7MpderyPkMni74pcJip/ThagMEqWgQEwlpsU6u/5RV4PfczParYp4l4EX+NPJ
         StiMHYN1ZRt4qX5l+F3y81wYpB1vM26U/wsSqGoGVqJ87L+JPeKQYwtd0A8yyAiSL2
         vFsToZJeo18TfZhJILkosIc+0lsQ88ZrDI50H/o1eTlLz3IIceFqe1hfAAN7y17a6s
         gZY1UTcqsb46XKA1tprU9msbV36A2txwt9Wc3o+TUCFAFf29YXohaeWpHxPgv4xcjh
         KqcGSr0dBbs0j+LQP4OEgjHcZXECI6JwFFTsf6aQKi4Z47ZDErd0lurj5kFul72Ty9
         stET4FtO43M6w==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4Kwljr30zTz9rxG;
        Sun,  8 May 2022 02:36:48 +0200 (CEST)
From:   Manuel Ullmann <labre@posteo.de>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        regressions@lists.linux.dev, davem@davemloft.net,
        ndanilov@marvell.com, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jordan Leppert <jordanleppert@protonmail.com>,
        Holger Hoffstaette <holger@applied-asynchrony.com>,
        koo5 <kolman.jindrich@gmail.com>
Subject: [PATCH v6] net: atlantic: always deep reset on pm op, fixing up my
 null deref regression
Date:   Sun, 08 May 2022 00:36:46 +0000
Message-ID: <87bkw8dfmp.fsf@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain
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

Fixes: cbe6c3a8f8f4 ("net: atlantic: invert deep par in pm functions, preventing null derefs")
Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com/
Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
Reported-by: Holger Hoffstaette <holger@applied-asynchrony.com>
Tested-by: Jordan Leppert <jordanleppert@protonmail.com>
Tested-by: Holger Hoffstaette <holger@applied-asynchrony.com>
CC: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Manuel Ullmann <labre@posteo.de>
---
I'm very sorry for this regression. It would be nice, if this could
reach mainline before 5.18 release, if applicable. This restores the
original suspend behaviour, while keeping the fix for hibernation. The
fix for hibernation might not be the root cause, but still is the most
simple fix for backporting to stable while the root cause is unknown
to the maintainers.

Changes in v2:
Patch formatting fixes
~ Fix Fixes tag
~ Simplify stable Cc tag
~ Fix Signed-off-by tag

Changes in v3:
~ Prefixed commit reference with "commit" aka I managed to use
  checkpatch.pl.
~ Added Tested-by tags for the testing reporters.
~ People start to get annoyed by my patch revision spamming. Should be
  the last one.

Changes in v4:
~ Moved patch changelog to comment section
~ Use unicode ndash for patch changelog list to avoid confusion with
  diff in editors
~ Expanded comment
~ Targeting net-next by subject

Changes in v5:
~ Changed my MTA transfer encoding to 8 bit instead of
  quoted-printable. Git should like this a bit more.

Changes in v6:
~ Reducing content to 7 bit chars, because nipa did not apply v4 and v5, while
  git does against a fresh net-next HEAD. Maybe it chokes on the
  additional bit.
~ Omitting target tree to resemble the last passing patch version the most.

 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 3a529ee8c834..831833911a52 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -449,7 +449,7 @@ static int aq_pm_freeze(struct device *dev)
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_thaw(struct device *dev)
@@ -459,7 +459,7 @@ static int aq_pm_thaw(struct device *dev)
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {

base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
2.35.1
