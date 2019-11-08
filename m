Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688B9F45FA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 12:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732955AbfKHLi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732910AbfKHLiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A107C21D7E;
        Fri,  8 Nov 2019 11:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213134;
        bh=U24cqw19Ki1GCxDzs7Eviju9mnv0Og7Nxqdr/g0uSQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYa/decjF060e8XlXf4f/ym2rrO97WKmRFI0HJVv3dIomy7+LTilJ2EybNdHf+88z
         vMn7HBpwrcAqimlmwsd2OGDBuKCi8Zyq+ksHy3DqU6CEEgQy6TZLP4XD6n8f7RqHoW
         AqpUM60/Gsx4v/BTYVcE2aDehjGsOSEZb3KIPTAM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lihong Yang <lihong.yang@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 052/205] i40evf: cancel workqueue sync for adminq when a VF is removed
Date:   Fri,  8 Nov 2019 06:35:19 -0500
Message-Id: <20191108113752.12502-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lihong Yang <lihong.yang@intel.com>

[ Upstream commit babbcc60040abfb7a9e3caa1c58fe182ae73762a ]

If a VF is being removed, there is no need to continue with the
workqueue sync for the adminq task, thus cancel it. Without this call,
when VFs are created and removed right away, there might be a chance for
the driver to crash with events stuck in the adminq.

Signed-off-by: Lihong Yang <lihong.yang@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 3fc46d2adc087..f50c19b833686 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3884,6 +3884,8 @@ static void i40evf_remove(struct pci_dev *pdev)
 	if (adapter->watchdog_timer.function)
 		del_timer_sync(&adapter->watchdog_timer);
 
+	cancel_work_sync(&adapter->adminq_task);
+
 	i40evf_free_rss(adapter);
 
 	if (hw->aq.asq.count)
-- 
2.20.1

