Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6565A46BE58
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbhLGPBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:01:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55604 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbhLGPBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:01:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AC43B817EE
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 14:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290ABC341C1;
        Tue,  7 Dec 2021 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638889055;
        bh=16Flt33efDjvoT5248LZ4hJJ36k614a6c89HvrrFups=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSWNIVXMn/pdqpVa7T+X4rpnBVBYCkVy3lxoMRIonn2YhN5l/kxD0+HzJFhYMz+xA
         6CBKpBFK4/PVuZVzChHWm/weMOg7waTO1V+sgwaTSU+zOcKLp3fHZ8WY58867MyTBD
         PUHc/E/az7IK2alIbRqn3XkM7QQwfV5MBBC9bxIm9npMZszYoJVh+XbFm8kUWwZuF+
         nnaaVY7OiklBVfzXNE6/G4xiYmnVY76BmBxjYC543ibe60JY5btI7/l4TRdKp4qrFU
         RP642BifSUzy5zf4LjQ9E19uY2Y0F2Y/XjdOB1z/TX3R3FZBPGFy69YdfV6hw0nTyY
         oTSryttsaWA6g==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net-sysfs: warn if new queue objects are being created during device unregistration
Date:   Tue,  7 Dec 2021 15:57:25 +0100
Message-Id: <20211207145725.352657-3-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211207145725.352657-1-atenart@kernel.org>
References: <20211207145725.352657-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling netdev_queue_update_kobjects is allowed during device
unregistration since commit 5c56580b74e5 ("net: Adjust TX queue kobjects
if number of queues changes during unregister"). But this is solely to
allow queue unregistrations. Any path attempting to add new queues after
a device started its unregistration should be fixed.

This patch adds a warning to detect such illegal use.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 33f408c24205..53ea262ecafd 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1694,6 +1694,13 @@ netdev_queue_update_kobjects(struct net_device *dev, int old_num, int new_num)
 	int i;
 	int error = 0;
 
+	/* Tx queue kobjects are allowed to be updated when a device is being
+	 * unregistered, but solely to remove queues from qdiscs. Any path
+	 * adding queues should be fixed.
+	 */
+	WARN(dev->reg_state == NETREG_UNREGISTERING && new_num > old_num,
+	     "New queues can't be registered after device unregistration.");
+
 	for (i = old_num; i < new_num; i++) {
 		error = netdev_queue_add_kobject(dev, i);
 		if (error) {
-- 
2.33.1

