Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA7214885E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405176AbgAXOVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405162AbgAXOVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471642087E;
        Fri, 24 Jan 2020 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875664;
        bh=Lm4TMMTrCrjyhWS8DD1qBTELzqdN6Jn68xYLu48n62M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0pvxSWzUiF5z5Z2+cQOk4v83iIbQA29hItLbMoWpZcU4ekPWibA+4wJnN8j38UiX
         s+uSdXdta/O/8DdCS7H7bCJuThcSV72otMRbHBSkIAefAp/cVDtvF2FkuaLQ4xcCt/
         pzBZ/36jI0Ok12Q59Y7TX9umDSDC/SUQ90nPh/zA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mohammed Gamal <mgamal@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 44/56] hv_netvsc: Fix memory leak when removing rndis device
Date:   Fri, 24 Jan 2020 09:20:00 -0500
Message-Id: <20200124142012.29752-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mohammed Gamal <mgamal@redhat.com>

[ Upstream commit 536dc5df2808efbefc5acee334d3c4f701790ec0 ]

kmemleak detects the following memory leak when hot removing
a network device:

unreferenced object 0xffff888083f63600 (size 256):
  comm "kworker/0:1", pid 12, jiffies 4294831717 (age 1113.676s)
  hex dump (first 32 bytes):
    00 40 c7 33 80 88 ff ff 00 00 00 00 10 00 00 00  .@.3............
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
  backtrace:
    [<00000000d4a8f5be>] rndis_filter_device_add+0x117/0x11c0 [hv_netvsc]
    [<000000009c02d75b>] netvsc_probe+0x5e7/0xbf0 [hv_netvsc]
    [<00000000ddafce23>] vmbus_probe+0x74/0x170 [hv_vmbus]
    [<00000000046e64f1>] really_probe+0x22f/0xb50
    [<000000005cc35eb7>] driver_probe_device+0x25e/0x370
    [<0000000043c642b2>] bus_for_each_drv+0x11f/0x1b0
    [<000000005e3d09f0>] __device_attach+0x1c6/0x2f0
    [<00000000a72c362f>] bus_probe_device+0x1a6/0x260
    [<0000000008478399>] device_add+0x10a3/0x18e0
    [<00000000cf07b48c>] vmbus_device_register+0xe7/0x1e0 [hv_vmbus]
    [<00000000d46cf032>] vmbus_add_channel_work+0x8ab/0x1770 [hv_vmbus]
    [<000000002c94bb64>] process_one_work+0x919/0x17d0
    [<0000000096de6781>] worker_thread+0x87/0xb40
    [<00000000fbe7397e>] kthread+0x333/0x3f0
    [<000000004f844269>] ret_from_fork+0x3a/0x50

rndis_filter_device_add() allocates an instance of struct rndis_device
which never gets deallocated as rndis_filter_device_remove() sets
net_device->extension which points to the rndis_device struct to NULL,
leaving the rndis_device dangling.

Since net_device->extension is eventually freed in free_netvsc_device(),
we refrain from setting it to NULL inside rndis_filter_device_remove()

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/rndis_filter.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index f47e36ac42a7f..dd91834f841d5 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1375,8 +1375,6 @@ void rndis_filter_device_remove(struct hv_device *dev,
 	/* Halt and release the rndis device */
 	rndis_filter_halt_device(net_dev, rndis_dev);
 
-	net_dev->extension = NULL;
-
 	netvsc_device_remove(dev);
 }
 
-- 
2.20.1

