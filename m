Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85D0A8CEE
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfIDQTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731936AbfIDP6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1775A2341C;
        Wed,  4 Sep 2019 15:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612702;
        bh=BJV4xn+dCqPEYrNnYRxOCtNh4EYW7nfGMGy0JjAm954=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcyCd7g1r/YX/msrp9c+X9VI3BfdKXQLfcKq+t5GsH19OAuKz2WJewdbySMievCJi
         6WEcfQK0gvdiDLrhEMr2MCBwIdt1MJ0nLubfy1RlIVY5wYcHGTsEYmu4TrS+rzHNmo
         lxF7glNordrfDdAZQNTbZieZhquFZQM5InSnLHoo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 30/94] xdp: unpin xdp umem pages in error path
Date:   Wed,  4 Sep 2019 11:56:35 -0400
Message-Id: <20190904155739.2816-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

[ Upstream commit fb89c39455e4b49881c5a42761bd71f03d3ef888 ]

Fix mem leak caused by missed unpin routine for umem pages.

Fixes: 8aef7340ae9695 ("xsk: introduce xdp_umem_page")
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 9c6de4f114f84..9bd7b96027c12 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -368,7 +368,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->pages = kcalloc(umem->npgs, sizeof(*umem->pages), GFP_KERNEL);
 	if (!umem->pages) {
 		err = -ENOMEM;
-		goto out_account;
+		goto out_pin;
 	}
 
 	for (i = 0; i < umem->npgs; i++)
@@ -376,6 +376,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 
 	return 0;
 
+out_pin:
+	xdp_umem_unpin_pages(umem);
 out_account:
 	xdp_umem_unaccount_pages(umem);
 	return err;
-- 
2.20.1

