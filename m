Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B529E5BF0
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfJZNVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729068AbfJZNVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 046D62070B;
        Sat, 26 Oct 2019 13:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096097;
        bh=Xst7r6Og8CbzbfVwav+UJkWGXsNWcL/fy+F8I9Q6Ql0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU9EFiZCsx8jyZlhQzPBEpM8zD1pZ7IJfkxI115Yor6OQvLKaNsjdQUSBwvv9HBdz
         flIMHZh3yW8UU6HJ1FQgzF8i+awoD2Xxm9gvuujy6/M1qy5RrHySr3pn1KkWuMD+69
         qywdzAVLQJEMIobQRs6uL9BQYgypp1nSKiGyDfZo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/33] iwlwifi: dbg_ini: fix memory leak in alloc_sgtable
Date:   Sat, 26 Oct 2019 09:20:50 -0400
Message-Id: <20191026132110.4026-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
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
index 8390104172410..2ae5c831764a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -532,6 +532,7 @@ static struct scatterlist *alloc_sgtable(int size)
 				if (new_page)
 					__free_page(new_page);
 			}
+			kfree(table);
 			return NULL;
 		}
 		alloc_size = min_t(int, size, PAGE_SIZE);
-- 
2.20.1

