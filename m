Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2E4A2410
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfH2SUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbfH2SRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:17:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16ACB2189D;
        Thu, 29 Aug 2019 18:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102673;
        bh=poF2p1dOFWsFT9gsvuUclClyNNuKrI4x8utnd09I2VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uytpaxxTYbpB/LKTYPPQOqvXboG+SNGA0W+Re2CG/6OpsHAO0HWy1I5oxJ3kuFU25
         palcLkLdiWFqIq4jWfpDLyMhbe2eWAV0j2DGJjk7XcAFQB94f8ooJlMw7gOCtL3/ek
         c7ePvB5VXdf1FIgsSVtzZRsBXjVJ8SOP9uqK5s+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/16] wimax/i2400m: fix a memory leak bug
Date:   Thu, 29 Aug 2019 14:17:28 -0400
Message-Id: <20190829181736.9040-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181736.9040-1-sashal@kernel.org>
References: <20190829181736.9040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 44ef3a03252844a8753479b0cea7f29e4a804bdc ]

In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
to hold the original command line options. Then, the options are parsed.
However, if an error occurs during the parsing process, 'options_orig' is
not deallocated, leading to a memory leak bug. To fix this issue, free
'options_orig' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wimax/i2400m/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index c9c711dcd0e6b..0e6c665a4de82 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -351,13 +351,15 @@ int i2400m_barker_db_init(const char *_options)
 			}
 			result = i2400m_barker_db_add(barker);
 			if (result < 0)
-				goto error_add;
+				goto error_parse_add;
 		}
 		kfree(options_orig);
 	}
 	return 0;
 
+error_parse_add:
 error_parse:
+	kfree(options_orig);
 error_add:
 	kfree(i2400m_barker_db);
 	return result;
-- 
2.20.1

