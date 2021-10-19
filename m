Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219CD433015
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhJSHwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhJSHwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 03:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A910611EF;
        Tue, 19 Oct 2021 07:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634629800;
        bh=rIL076xoyFjm//EYIsSYuFMM8goK+90QV11q1ToYPzo=;
        h=From:To:Cc:Subject:Date:From;
        b=idkNivlbKhf1u5DER7HAQOgZPmAtbOre+bvhyvBYd7VwtU9EE62Ks3qWBtpejS24a
         MLncmkpSAgb2oQPKvMk2w6c9Z/KQ0mWiTMGTbgnqFzm70Up8j6nQRcHPmpRSEsc9wk
         dWZ1MHh5/JZzp7eTeIl9QLd2I8QhSF+JpvpF1jf0e+hSdK6CQxQnNna17rcl/vek95
         IJOD0MVZXdBgLTdT6zJrt5Br63ovl+IqhkpE+OYd+RiLu/sVCiFP47K0vojL7VFL6k
         psxiLaVxPeWIR7EttBNOVsSkdSu9c9OojP0rFJJ6YtAfEHSZDGfUvzdHr5gViEmldJ
         6iXwONjwSHqxQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] devlink: Remove extra device_lock assert checks
Date:   Tue, 19 Oct 2021 10:49:54 +0300
Message-Id: <8bbcc624cf574a1f491a674e436dbd0673cb0127.1634629765.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

PCI core code in the pci_call_probe() has a path that doesn't hold
device_lock. It happens because the ->probe() is called through the
workqueue mechanism.

   349 static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
   350                           const struct pci_device_id *id)
   351 {
   352
....
   377         if (cpu < nr_cpu_ids)
   378                 error = work_on_cpu(cpu, local_pci_probe, &ddi);

Luckily enough, the core still ensures that only single flow is executed,
so it safe to remove the assert checks that anyway were added for annotations
purposes.

Fixes: b88f7b1203bf ("devlink: Annotate devlink API calls")
Reported-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3ce6147a2fe8..3464854015a2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9147,7 +9147,6 @@ void devlink_register(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 	/* Make sure that we are in .probe() routine */
-	device_lock_assert(devlink->dev);
 
 	mutex_lock(&devlink_mutex);
 	xa_set_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
@@ -9165,7 +9164,6 @@ void devlink_unregister(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_REGISTERED(devlink);
 	/* Make sure that we are in .remove() routine */
-	device_lock_assert(devlink->dev);
 
 	devlink_put(devlink);
 	wait_for_completion(&devlink->comp);
-- 
2.31.1

