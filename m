Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E1EE5C67
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728475AbfJZNTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbfJZNTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:19:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A389F21D7F;
        Sat, 26 Oct 2019 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095992;
        bh=VkBjWB/R8bRc62N+DtBiVl/0Znyz6mpBvpCJ5F0tXVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1rswr2gt6VSQqiKa6kOvLA+ooBMjLvWU8KPPnv1LxkQQNoec7kC24G9dUqJhjp2q
         2+gmcadPyfDCTgxaKcdYkpjnta3brgUZlcoie+nW20hNfA3BDOPMx3xBoaHV+2vLxB
         wgdVuvymuO5xUdKTLhJwxijmSm3JpRXgahE56Z9c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/59] iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
Date:   Sat, 26 Oct 2019 09:18:34 -0400
Message-Id: <20191026131910.3435-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit b4b814fec1a5a849383f7b3886b654a13abbda7d ]

In alloc_sgtable if alloc_page fails, the alocated table should be
released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index a31a42e673c46..0d567cc0a2643 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -547,6 +547,7 @@ static struct scatterlist *alloc_sgtable(int size)
 				if (new_page)
 					__free_page(new_page);
 			}
+			kfree(table);
 			return NULL;
 		}
 		alloc_size = min_t(int, size, PAGE_SIZE);
-- 
2.20.1

