Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044E927D635
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgI2S4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbgI2S4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 14:56:16 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9A622076D;
        Tue, 29 Sep 2020 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601405775;
        bh=B4LAoCA5W+8yr4Ajd8NMhnc+SSJLU315huDeq+kqHT0=;
        h=Date:From:To:Cc:Subject:From;
        b=K3kaRVQui+deC0532ckd9YNAnVhOcaqYzyqkRIy1t5X9hEm7PTeEMXip/Y0isOHre
         dUXVtpwqhw0FMn56Tj9t/8gSeVLwjY6xrqk7TLaueetVHjsoVMNui6tScT/IO4QTT7
         QBtev1ZKwIOco3iXvT+6s1BvGgR373hV3pMkdw7w=
Date:   Tue, 29 Sep 2020 14:01:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ice: Replace one-element array with flexible-array
 member
Message-ID: <20200929190156.GA25604@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in
struct ice_res_tracker, instead of a one-element array and use the
struct_size() helper to calculate the size for the allocations.

Also, notice that the code below suggests that, currently, two too many
bytes are being allocated with devm_kzalloc(), as the total number of
entries (pf->irq_tracker->num_entries) for pf->irq_tracker->list[] is
_vectors_ and sizeof(*pf->irq_tracker) also includes the size of the
one-element array _list_ in struct ice_res_tracker.

drivers/net/ethernet/intel/ice/ice_main.c:3511:
3511         /* populate SW interrupts pool with number of OS granted IRQs. */
3512         pf->num_avail_sw_msix = (u16)vectors;
3513         pf->irq_tracker->num_entries = (u16)vectors;
3514         pf->irq_tracker->end = pf->irq_tracker->num_entries;

With this change, the right amount of dynamic memory is now allocated
because, contrary to one-element arrays which occupy at least as much
space as a single object of the type, flexible-array members don't
occupy such space in the containing structure.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9-rc1/process/deprecated.html#zero-length-and-one-element-arrays

Built-tested-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 65583f0a1797..a4c84faa36d6 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -164,7 +164,7 @@ struct ice_tc_cfg {
 struct ice_res_tracker {
 	u16 num_entries;
 	u16 end;
-	u16 list[1];
+	u16 list[];
 };
 
 struct ice_qs_cfg {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2297ee7dba26..f6a7a23615eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3500,9 +3500,9 @@ static int ice_init_interrupt_scheme(struct ice_pf *pf)
 		return vectors;
 
 	/* set up vector assignment tracking */
-	pf->irq_tracker =
-		devm_kzalloc(ice_pf_to_dev(pf), sizeof(*pf->irq_tracker) +
-			     (sizeof(u16) * vectors), GFP_KERNEL);
+	pf->irq_tracker = devm_kzalloc(ice_pf_to_dev(pf),
+				       struct_size(pf->irq_tracker, list, vectors),
+				       GFP_KERNEL);
 	if (!pf->irq_tracker) {
 		ice_dis_msix(pf);
 		return -ENOMEM;
-- 
2.27.0

