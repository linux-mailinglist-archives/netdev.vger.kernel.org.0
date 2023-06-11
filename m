Return-Path: <netdev+bounces-9947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EA472B3F8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 22:44:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0299281157
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 20:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B92F10952;
	Sun, 11 Jun 2023 20:44:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210B92C9D
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 20:44:22 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313FFE51
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 13:44:19 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 8Rv5qwjzfZnIG8Rv5qdCzN; Sun, 11 Jun 2023 22:44:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1686516257;
	bh=UiEF+Yax2f7tK9mHB7IIdxWz2jAlp2s9xTkNsdxvvkw=;
	h=From:To:Cc:Subject:Date;
	b=OUYbcJz4qYNl/rvRcj8m+xkYnIYgYw5GQYzEjeohGePg5f/NCQ8hwaP+KA2NayJR9
	 9wo1V+vywBUF/RBzAz2/5PuBFXnj/0Pumv0YzR/p0GHPoa8tBx76xKE/EEB4WV7TIy
	 RyeSIE2ybOJ2nDKb/sSutIi5Gk+NTRKPv+sOcgvJOe89LUM8dsLItS05cgRvcGguI8
	 XtgUsQBFlGN/AqyLmN7CtnL3gCdjewsqhU16bNZpQhctYekQU1iorp9X7RZD038Z8n
	 /DGcOik+Xj5t5duaZZ3W3HuTPTCqjC+UPykoE5W1Reir3MyjLEIhDLR2sEM8iMMTgB
	 S7YmbF3ZWGfQg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Jun 2023 22:44:17 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next] ice: Remove managed memory usage in ice_get_fw_log_cfg()
Date: Sun, 11 Jun 2023 22:44:13 +0200
Message-Id: <e86a1ab7b450462a1e92264dccb5a5855546e384.1686516193.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is no need to use managed memory allocation here. The memory is
released at the end of the function.

You kzalloc()/kfree() to simplify the code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index eb2dc0983776..4b799a5d378a 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -834,7 +834,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
 	u16 size;
 
 	size = sizeof(*config) * ICE_AQC_FW_LOG_ID_MAX;
-	config = devm_kzalloc(ice_hw_to_dev(hw), size, GFP_KERNEL);
+	config = kzalloc(size, GFP_KERNEL);
 	if (!config)
 		return -ENOMEM;
 
@@ -857,7 +857,7 @@ static int ice_get_fw_log_cfg(struct ice_hw *hw)
 		}
 	}
 
-	devm_kfree(ice_hw_to_dev(hw), config);
+	kfree(config);
 
 	return status;
 }
-- 
2.34.1


