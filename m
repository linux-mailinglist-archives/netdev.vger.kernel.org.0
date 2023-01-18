Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9307C671825
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 10:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjARJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 04:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbjARJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 04:49:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A5B611CF;
        Wed, 18 Jan 2023 01:01:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03C6B61734;
        Wed, 18 Jan 2023 09:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FBEC433D2;
        Wed, 18 Jan 2023 09:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674032485;
        bh=NLYd7TN6vH/s+v7UK420x0jDdP0vK/RzDH5BQQI3Y18=;
        h=From:To:Cc:Subject:Date:From;
        b=f2ti79ww970dIOt3KZ0XH9Tuw2nWIvtSyhV5GxRydxxL2HkeIJGviT3aWAp8dCcec
         fFBdV1Z/Vcm4InuSIId2ZPOSVpU1k0e5lvf72w/CVbBYd0oTDqiWjQnKzxge+e2vgh
         dy78n3FwHREzxmd/NQtu8fg2/qW9RPEAIx2fqevG1XQzK/YDF+g/jXQqNnzeoeOIjo
         NCcjymomjT7hFr520Ls2+UnkqDqLroQeaoJu/PrxCDou0oRlB3PXgOK1J3ijyeo4V1
         aiELqaE3n8eiW7TtHPG6NWzSzz/YOeog64RLE18uhNUMnFTT7/doyCH9dRVRZG/Dit
         32w9+xG+ZlgCA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i40e: fix dma alloc/free prototypes
Date:   Wed, 18 Jan 2023 10:01:05 +0100
Message-Id: <20230118090120.2081560-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-13 notices a mismatch between the declaration and the definition
for a few functions that apparently used to return a i40e_status_code
instead of an int:

drivers/net/ethernet/intel/i40e/i40e_main.c:129:5: error: conflicting types for 'i40e_allocate_dma_mem_d' due to enum/integer mismatch; have 'int(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'int(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'} [-Werror=enum-int-mismatch]
  129 | int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
      |     ^~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/ethernet/intel/i40e/i40e_type.h:8,
                 from drivers/net/ethernet/intel/i40e/i40e.h:41,
                 from drivers/net/ethernet/intel/i40e/i40e_main.c:12:
drivers/net/ethernet/intel/i40e/i40e_osdep.h:40:25: note: previous declaration of 'i40e_allocate_dma_mem_d' with type 'i40e_status(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'enum i40e_status_code(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'}
   40 |                         i40e_allocate_dma_mem_d(h, m, s, a)
      |                         ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/intel/i40e/i40e_alloc.h:23:13: note: in expansion of macro 'i40e_allocate_dma_mem'
   23 | i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
      |             ^~~~~~~~~~~~~~~~~~~~~

Change the prototypes to match the definition.

Fixes: 56a62fc86895 ("i40e: init code and hardware support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/intel/i40e/i40e_alloc.h | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_alloc.h b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
index cb8689222c8b..e9c4a8fda9de 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
@@ -20,16 +20,14 @@ enum i40e_memory_type {
 };
 
 /* prototype for functions used for dynamic memory allocation */
-i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
-					    struct i40e_dma_mem *mem,
-					    enum i40e_memory_type type,
-					    u64 size, u32 alignment);
-i40e_status i40e_free_dma_mem(struct i40e_hw *hw,
-					struct i40e_dma_mem *mem);
-i40e_status i40e_allocate_virt_mem(struct i40e_hw *hw,
-					     struct i40e_virt_mem *mem,
-					     u32 size);
-i40e_status i40e_free_virt_mem(struct i40e_hw *hw,
-					 struct i40e_virt_mem *mem);
+int i40e_allocate_dma_mem(struct i40e_hw *hw,
+			  struct i40e_dma_mem *mem,
+			  enum i40e_memory_type type,
+			  u64 size, u32 alignment);
+int i40e_free_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem);
+int i40e_allocate_virt_mem(struct i40e_hw *hw,
+			   struct i40e_virt_mem *mem,
+			   u32 size);
+int i40e_free_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem);
 
 #endif /* _I40E_ALLOC_H_ */
-- 
2.39.0

