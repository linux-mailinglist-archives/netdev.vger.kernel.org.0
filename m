Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E1415EAE1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403833AbgBNRRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391794AbgBNQL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B67E9222C2;
        Fri, 14 Feb 2020 16:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696688;
        bh=vCOwDC4HiMKfA9asIcQGpE8w0AH9BpB7uecmviq9Qsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZE6dLUMmNUHYgS9l8DrV9xh/EocV/pq54xwKnbsE7NMykE6hd+TkcixLfYmrQUXq
         dBZEGylGTZuc+66NRw3zzywNjM63Y3WdbeFy5S3qcwoeqTlUCI0CPLEZ6zkGBybf3m
         M8IKqf16lrkg+DJu2FmLAyKM0bVweDdeM2yHTEHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 455/459] i40e: Relax i40e_xsk_wakeup's return value when PF is busy
Date:   Fri, 14 Feb 2020 11:01:45 -0500
Message-Id: <20200214160149.11681-455-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit c77e9f09143822623dd71a0fdc84331129e97c3a ]

Return -EAGAIN instead of -ENETDOWN to provide a slightly milder
information to user space so that an application will know to retry the
syscall when __I40E_CONFIG_BUSY bit is set on pf->state.

Fixes: b3873a5be757 ("net/i40e: Fix concurrency issues between config flow and XSK")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20200205045834.56795-2-maciej.fijalkowski@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index f73cd917c44f7..3156de786d955 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -791,7 +791,7 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 	struct i40e_ring *ring;
 
 	if (test_bit(__I40E_CONFIG_BUSY, pf->state))
-		return -ENETDOWN;
+		return -EAGAIN;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
-- 
2.20.1

