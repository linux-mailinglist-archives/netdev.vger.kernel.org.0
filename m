Return-Path: <netdev+bounces-349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6846F7397
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9E691C213A8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF238107BD;
	Thu,  4 May 2023 19:42:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B083AF4EA
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F91CC4339C;
	Thu,  4 May 2023 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229346;
	bh=ZDpaaRyf/2z6KTrKXSfxuTRt3NtW4e5+JRI1L/NAYzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKkci5/C2fHbatKqreZWWQu/esLMB819tK+LoV6p+oaDXdePC2PZAnDpwJ4qkrw4Q
	 HmHvw8PXm5Wo6P9LWT7gje/T0oTkYe6FAOIpMQugvSFK/cTx2ifeguzWO90XYdE42O
	 QzmOM6nABINc84H7fDm7iGUg0Aeu8uG5X1d4qHDbwrEHBtq0eVd15ij3Kz31qfvPgG
	 6GBLkygeS4XJpfEbH+N48+argBYxC11FqTZvF6lcIO8sVfMg/TcwZw9zSrCOufv4t1
	 fW0CBwHYBprHH/6MNF8TxvY7NWgAymVHiWo0wpOrmg8AsaeQgQPEshdEbcOgf+g/NA
	 gA437zW/lb+bQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	michael.chan@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 14/59] bnxt: avoid overflow in bnxt_get_nvram_directory()
Date: Thu,  4 May 2023 15:40:57 -0400
Message-Id: <20230504194142.3805425-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Maxim Korotkov <korotkov.maxim.s@gmail.com>

[ Upstream commit 7c6dddc239abe660598c49ec95ea0ed6399a4b2a ]

The value of an arithmetic expression is subject
of possible overflow due to a failure to cast operands to a larger data
type before performing arithmetic. Used macro for multiplication instead
operator for avoiding overflow.

Found by Security Code and Linux Verification
Center (linuxtesting.org) with SVACE.

Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://lore.kernel.org/r/20230309174347.3515-1-korotkov.maxim.s@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6bd18eb5137f4..2dd8ee4a6f75b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2864,7 +2864,7 @@ static int bnxt_get_nvram_directory(struct net_device *dev, u32 len, u8 *data)
 	if (rc)
 		return rc;
 
-	buflen = dir_entries * entry_length;
+	buflen = mul_u32_u32(dir_entries, entry_length);
 	buf = hwrm_req_dma_slice(bp, req, buflen, &dma_handle);
 	if (!buf) {
 		hwrm_req_drop(bp, req);
-- 
2.39.2


