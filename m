Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84463AF43D
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhFUSHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234030AbhFUSEb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:04:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1199061353;
        Mon, 21 Jun 2021 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298163;
        bh=k5qbGDjrmYPjqZwRGbFcF5nge5fMT5E8R3/0InNUKos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pcsz0YcYKCKmTJo3CBUlk3Q4D92uEsnbhC2hIcQ3Vh6mH4/NTQUJMGOLIvVB7WpWg
         OhZQ8Bbr+uDsgl40XJN8YoB9xpOXNtMV3vyNJ2/awPHffKdZNKlxCK9962yigKJVv7
         mTeGp6jS1OUeqmmbuBRonAadYqYVaPN58cdWfIBlztVBAAseju7RSXVPoHio8XsPGi
         qv+PMo0NL4xotWEAJ0GD2BArzdfHIyg26umJIZsT5rGeYnZ2nVGDUeMUXhafnUpLcS
         61k9FwcBU1k7CywOqZ6sdicc9mQWuSsstCLJfRxVjtSuQxrcTQdh/ATcrqUlepwM1y
         8Jb30YOHgrY9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/13] net: qed: Fix memcpy() overflow of qed_dcbx_params()
Date:   Mon, 21 Jun 2021 13:55:42 -0400
Message-Id: <20210621175544.736421-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175544.736421-1-sashal@kernel.org>
References: <20210621175544.736421-1-sashal@kernel.org>
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
index 7b6824e560d2..59e59878a3a7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -1205,9 +1205,11 @@ int qed_dcbx_get_config_params(struct qed_hwfn *p_hwfn,
 		p_hwfn->p_dcbx_info->set.ver_num |= DCBX_CONFIG_VERSION_IEEE;
 
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

