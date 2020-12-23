Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04CA2E2090
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgLWSsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgLWSsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:48:15 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 800BDC061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 10:47:35 -0800 (PST)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 0DC447D46A;
        Wed, 23 Dec 2020 18:47:33 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1608749253; bh=fHGbddBGWSjBcfjoT0hWmBYVPRCr2uWkSDdDR75fcho=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20gnault@redhat.com,=0D=0A=09jchapman@katalix.com,=0D
         =0A=09Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PATCH=20net
         ]=20ppp:=20hold=20mutex=20when=20unbridging=20channels=20in=20unre
         gister=20path|Date:=20Wed,=2023=20Dec=202020=2018:47:30=20+0000|Me
         ssage-Id:=20<20201223184730.30057-1-tparkin@katalix.com>;
        b=FUmab1nnWZNdkr8kSKeVF1VEtN/i6hhAgiLVd1wBo9upCTpPRB9OU3Nd74BcdtlKe
         LAFt3zMEuR7GxZXVWHzY9EcmFhsgp20YcKlS/ncdH9HKpyU9cnlYMWt1JztPA7KVjY
         UU9k9OzphLJBYYG0jayZgqPsDU5f6pQ47J1xZf9u6tQikrrFX27C69T22MDmn350K1
         J3EASwQipkU56PdkT8dpJbcT1YMcJ7iiSyeYbR423PPYuyUBH/68gf2j7SQHNEyeJP
         g3i85TiAB8RynIqaK6oDRLJmTCaWzH5/2AaRC0IuV+psIBfBdF7oaAdE2T+KdrpZ1W
         KEoxe8UgHMf+g==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net] ppp: hold mutex when unbridging channels in unregister path
Date:   Wed, 23 Dec 2020 18:47:30 +0000
Message-Id: <20201223184730.30057-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Channels are bridged using the PPPIOCBRIDGECHAN ioctl, which executes
with the ppp_mutex held.

Unbridging may occur in two code paths: firstly an explicit
PPPIOCUNBRIDGECHAN ioctl, and secondly on channel unregister.  The
latter may occur when closing the /dev/ppp instance or on teardown of
the channel itself.

This opens up a refcount underflow bug if ppp_bridge_channels called via.
ioctl races with ppp_unbridge_channels called via. file release.

The race is triggered by ppp_unbridge_channels taking the error path
through the 'err_unset' label.  In this scenario, pch->bridge has been
set, but no reference will be taken on pch->file because the function
errors out.  Therefore, if ppp_unbridge_channels is called in the window
between pch->bridge being set and pch->bridge being unset, it will
erroneously drop the reference on pch->file and cause a refcount
underflow.

To avoid this, hold the ppp_mutex while calling ppp_unbridge_channels in
the shutdown path.  This serialises the unbridge operation with any
concurrently executing ioctl.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 09c27f7773f9..e87a05fee2db 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -2938,7 +2938,9 @@ ppp_unregister_channel(struct ppp_channel *chan)
 	list_del(&pch->list);
 	spin_unlock_bh(&pn->all_channels_lock);
 
+	mutex_lock(&ppp_mutex);
 	ppp_unbridge_channels(pch);
+	mutex_unlock(&ppp_mutex);
 
 	pch->file.dead = 1;
 	wake_up_interruptible(&pch->file.rwait);
-- 
2.17.1

