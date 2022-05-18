Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05EC52BA36
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbiERM1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiERM1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E967B132A2B;
        Wed, 18 May 2022 05:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C316167D;
        Wed, 18 May 2022 12:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D02FC34115;
        Wed, 18 May 2022 12:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876855;
        bh=QtFm/YePJogpPbhTBVQihthpmdFp/bsXcwx5js230EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxRAGVw4qp+xTDKfOmMkAab2/4mc/aHYZDr6q99C8Dcx32FO66il9ys2Dv5xDVRdy
         6jmUr1oMXbFI25oRuB2lajX/3iifSTNYWBXEJs3KBHSl4W5ca8q0dLmiVJ4RpLzVLb
         CGwfS+uoVlzAV8P6Q9A2hGi3316AjpIz+LRhMGT1BqCzyMM8AnuERSkVuHSwiy919b
         v8TsM/VBDuOOQEqJwRyZEmNk/0g03bGYaScx3N2l5cw5SHi+/8GBx5mGQiLXjcxOOD
         t6hO+UCwg/+9VvZDUiyjuy5rrHPIfSAx9aVf1Yg89jAMxlJ1JNnKPpaXIFWHv5pQC4
         aWVC/hR3PSl+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grant Grundler <grundler@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, irusskikh@marvell.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 19/23] net: atlantic: reduce scope of is_rsc_complete
Date:   Wed, 18 May 2022 08:26:32 -0400
Message-Id: <20220518122641.342120-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grant Grundler <grundler@chromium.org>

[ Upstream commit 79784d77ebbd3ec516b7a5ce555d979fb7946202 ]

Don't defer handling the err case outside the loop. That's pointless.

And since is_rsc_complete is only used inside this loop, declare
it inside the loop to reduce it's scope.

Signed-off-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 440423b0e8ea..bc1952131799 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -346,7 +346,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
-	bool is_rsc_completed = true;
 	int err = 0;
 
 	for (; (self->sw_head != self->hw_head) && budget;
@@ -366,6 +365,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				bool is_rsc_completed = true;
+
 				if (buff_->next >= self->size) {
 					err = -EIO;
 					goto err_exit;
@@ -377,18 +378,16 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed))
-					break;
+				if (unlikely(!is_rsc_completed)) {
+					err = 0;
+					goto err_exit;
+				}
 
 				buff->is_error |= buff_->is_error;
 				buff->is_cso_err |= buff_->is_cso_err;
 
 			} while (!buff_->is_eop);
 
-			if (!is_rsc_completed) {
-				err = 0;
-				goto err_exit;
-			}
 			if (buff->is_error ||
 			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
-- 
2.35.1

