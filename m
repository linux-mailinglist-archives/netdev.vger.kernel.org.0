Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ECB6134CC
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiJaLp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiJaLpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:45:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65CF02D;
        Mon, 31 Oct 2022 04:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB05EB815DB;
        Mon, 31 Oct 2022 11:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B98C433C1;
        Mon, 31 Oct 2022 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216700;
        bh=adfQlcnVctTBnUDpH4VOx1zBf1snHtulVQoBO8D5+xc=;
        h=From:To:Cc:Subject:Date:From;
        b=E8mdJOctRTx3d5d28JYRXP0Q56DDiwOmrgi06SHu2QHYho5Wf1Ba2oF0nADEsQbHO
         9fFDDECbr3cusRdv/2yroG4W2Z0R8A9yS/5XoxWJSEgL3Hrjo5Rg/rP20ouW3a0hcz
         UPk6myKUQUZzMdz++6Q9sScw1xQ+9y1rN9oqcuwOlFOhpvEs5Ds88wligNm7Mbin9f
         p7IcO42Y3BwrbPd2nq+4vr7EyOVAgR5CjqqwPHjRY6EJ7wUHFDS1Ma75SuJaF2ldBd
         91dHSnflIrItYRrTXwiDvNidTdlMuHZ66FCwr5EQJcxF/eF5M96MU+TFQ7plFQVN3f
         iuCUpuhLJpNww==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     jesse.brandeburg@intel.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] i40e (gcc13): synchronize allocate/free functions return type & values
Date:   Mon, 31 Oct 2022 12:44:56 +0100
Message-Id: <20221031114456.10482-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i40e allocate/free functions generate a valid warning with gcc-13:
  drivers/net/ethernet/intel/i40e/i40e_main.c:129:5: error: conflicting types for 'i40e_allocate_dma_mem_d' due to enum/integer mismatch; have 'int(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'int(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'} [-Werror=enum-int-mismatch]
  drivers/net/ethernet/intel/i40e/i40e_osdep.h:40:25: note: previous declaration of 'i40e_allocate_dma_mem_d' with type 'i40e_status(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'enum i40e_status_code(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'}
...

I.e. the type of their return value in the definition is int, while the
declaration spell enum i40e_status. Synchronize the definitions to the
latter.

And make sure proper values are returned. I.e. I40E_SUCCESS and not 0,
I40E_ERR_NO_MEMORY and not -ENOMEM.

Cc: Martin Liska <mliska@suse.cz>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 25 +++++++++++----------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1a1fab94205d..92fd4db7195f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -126,8 +126,9 @@ static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
  * @size: size of memory requested
  * @alignment: what to align the allocation to
  **/
-int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
-			    u64 size, u32 alignment)
+i40e_status i40e_allocate_dma_mem_d(struct i40e_hw *hw,
+				    struct i40e_dma_mem *mem, u64 size,
+				    u32 alignment)
 {
 	struct i40e_pf *pf = (struct i40e_pf *)hw->back;
 
@@ -135,9 +136,9 @@ int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
 	mem->va = dma_alloc_coherent(&pf->pdev->dev, mem->size, &mem->pa,
 				     GFP_KERNEL);
 	if (!mem->va)
-		return -ENOMEM;
+		return I40E_ERR_NO_MEMORY;
 
-	return 0;
+	return I40E_SUCCESS;
 }
 
 /**
@@ -145,7 +146,7 @@ int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
+i40e_status i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
 {
 	struct i40e_pf *pf = (struct i40e_pf *)hw->back;
 
@@ -154,7 +155,7 @@ int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
 	mem->pa = 0;
 	mem->size = 0;
 
-	return 0;
+	return I40E_SUCCESS;
 }
 
 /**
@@ -163,16 +164,16 @@ int i40e_free_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem)
  * @mem:  ptr to mem struct to fill out
  * @size: size of memory requested
  **/
-int i40e_allocate_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem,
-			     u32 size)
+i40e_status i40e_allocate_virt_mem_d(struct i40e_hw *hw,
+				     struct i40e_virt_mem *mem, u32 size)
 {
 	mem->size = size;
 	mem->va = kzalloc(size, GFP_KERNEL);
 
 	if (!mem->va)
-		return -ENOMEM;
+		return I40E_ERR_NO_MEMORY;
 
-	return 0;
+	return I40E_SUCCESS;
 }
 
 /**
@@ -180,14 +181,14 @@ int i40e_allocate_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem,
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-int i40e_free_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem)
+i40e_status i40e_free_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem)
 {
 	/* it's ok to kfree a NULL pointer */
 	kfree(mem->va);
 	mem->va = NULL;
 	mem->size = 0;
 
-	return 0;
+	return I40E_SUCCESS;
 }
 
 /**
-- 
2.38.1

