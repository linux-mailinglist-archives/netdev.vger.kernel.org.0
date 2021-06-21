Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF343AF2C5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhFUR4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232316AbhFURzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8925D61360;
        Mon, 21 Jun 2021 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297968;
        bh=yGIMFfXBv351FkDVH59jFGEwcYsPTos591RKcHoH8NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlCA6bUTi2VkBqLLnHb2nebkPgGKoJx+mGrQ1b0N6Zf3DvQy02xyzL9ARgbD16Q0+
         9aRUpGbT61Yq7LlczbcRSOeR2UiRXS+DydGL0DfkbiD/x765gu2fD1sZGf2p3+xVoJ
         3Xk64GCyoZI9zgNyp4DAq8ordWS8exBxzjb1mK34fXnd/N2ZN6qBw6IYSSYsfub/r0
         dANYCrfc41x7vSJWXGgn+6AaOq0Kd0lR+2oBywXIDrWnFTKduC0Fzt5GYXgtCg6G+J
         O+BFQ3edEc3KPIm6YZh0S2QW0PecHxlh8oEnrHFe3plqEkLZR97Ujj7s8dABYU+Qzs
         Np2/iKspQCnhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 32/39] net: qed: Fix memcpy() overflow of qed_dcbx_params()
Date:   Mon, 21 Jun 2021 13:51:48 -0400
Message-Id: <20210621175156.735062-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1c200f832e14420fa770193f9871f4ce2df00d07 ]

The source (&dcbx_info->operational.params) and dest
(&p_hwfn->p_dcbx_info->set.config.params) are both struct qed_dcbx_params
(560 bytes), not struct qed_dcbx_admin_params (564 bytes), which is used
as the memcpy() size.

However it seems that struct qed_dcbx_operational_params
(dcbx_info->operational)'s layout matches struct qed_dcbx_admin_params
(p_hwfn->p_dcbx_info->set.config)'s 4 byte difference (3 padding, 1 byte
for "valid").

On the assumption that the size is wrong (rather than the source structure
type), adjust the memcpy() size argument to be 4 bytes smaller and add
a BUILD_BUG_ON() to validate any changes to the structure sizes.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index 17d5b649eb36..e81dd34a3cac 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1266,9 +1266,11 @@ int qed_dcbx_get_config_params(struct qed_hwfn *p_hwfn,
 		p_hwfn->p_dcbx_info->set.ver_num |= DCBX_CONFIG_VERSION_STATIC;
 
 	p_hwfn->p_dcbx_info->set.enabled = dcbx_info->operational.enabled;
+	BUILD_BUG_ON(sizeof(dcbx_info->operational.params) !=
+		     sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	memcpy(&p_hwfn->p_dcbx_info->set.config.params,
 	       &dcbx_info->operational.params,
-	       sizeof(struct qed_dcbx_admin_params));
+	       sizeof(p_hwfn->p_dcbx_info->set.config.params));
 	p_hwfn->p_dcbx_info->set.config.valid = true;
 
 	memcpy(params, &p_hwfn->p_dcbx_info->set, sizeof(struct qed_dcbx_set));
-- 
2.30.2

