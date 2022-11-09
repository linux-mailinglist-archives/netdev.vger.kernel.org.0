Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DEE623740
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiKIXJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 18:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKIXJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 18:09:54 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16247647D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 15:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668035394; x=1699571394;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hk/NnKkjPwdYpI3XOzeF9oRH7zj2AVvWhqJReQqQSzY=;
  b=fil8m1HkQogeD8aCOdE+UMa5ipe5zn2uhO6wDu0ox7ILkpiQW+4WSKfK
   DlXqBVN7s4Be+ECIRsu/LCy+zDFRUQkhuvyj5Q0hSyJ6dzttPxlMaVvCK
   DPQjp54/+fZWbudVGqK0+jfuh4H9gbiZ2yFYw5rFl+hWfJiflu5Y3b7Ak
   Ex+S1WKDh/jkRomADGvvVCygm3A5qfCPQ0QEH4UhmmRzneF6iliOwvakT
   zP7ZZkq1jp8KEBHKqjPCvl40lFDWEKF74x/+GBlOZXCQqA0v8ckqBUo3i
   9o0p6VLE5THaYffQubhywv6zN/TFor1fzmeI0AVUpQ7RnLoUN0inJCdzg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="309860517"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="309860517"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="636930540"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="636930540"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 15:09:53 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 0/9] ptp: convert remaining users of .adjfreq
Date:   Wed,  9 Nov 2022 15:09:36 -0800
Message-Id: <20221109230945.545440-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda05763
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A handful of drivers remain which still use the .adjfreq interface instead
of the newer .adjfine interface. The new interface is preferred as it has a
more precise adjustment using scaled parts per million.

A handful of the remaining drivers are implemented with a common pattern
that can be refactored to use the adjust_by_scaled_ppm and
diff_by_scaled_ppm helper functions. These include the ptp_phc, ptp_ixp64x,
tg3, hclge, stmac, cpts and bnxt drivers. These are each refactored in a
separate change.

The remaining drivers, bnx2x, liquidio, cxgb4, fec, and qede implement
.adjfreq in a way different from the normal pattern expected by
adjust_by_scaled_ppm. Fixing these drivers to properly use .adjfine requires
specific knowledge of the hardware implementation. Instead I simply refactor
them to use .adjfine and convert scaled_ppm into ppb using the
scaled_ppm_to_ppb function.

Finally, the .adjfreq implementation interface is removed entirely. This
simplifies the interface and ensures that new drivers must implement the new
interface as they no longer have an alternative.

This still leaves parts per billion used as part of the max_adj interface,
and the core PTP stack still converts scaled_ppm to ppb to check this. I
plan to investigate fixing this in the future.

Jacob Keller (9):
  ptp_phc: convert .adjfreq to .adjfine
  ptp_ixp46x: convert .adjfreq to .adjfine
  ptp: tg3: convert .adjfreq to .adjfine
  ptp: hclge: convert .adjfreq to .adjfine
  ptp: stmac: convert .adjfreq to .adjfine
  ptp: cpts: convert .adjfreq to .adjfine
  ptp: bnxt: convert .adjfreq to .adjfine
  ptp: convert remaining drivers to adjfine interface
  ptp: remove the .adjfreq interface function

 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  9 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 22 +++++-------------
 drivers/net/ethernet/broadcom/tg3.c           | 22 ++++++------------
 .../net/ethernet/cavium/liquidio/lio_main.c   | 11 +++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    | 13 +++++++----
 drivers/net/ethernet/freescale/fec_ptp.c      | 13 +++++++----
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         | 22 ++++--------------
 drivers/net/ethernet/qlogic/qede/qede_ptp.c   | 13 +++++++----
 drivers/net/ethernet/sfc/ptp.c                |  7 +++---
 drivers/net/ethernet/sfc/siena/ptp.c          |  7 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 23 ++++++-------------
 drivers/net/ethernet/ti/am65-cpts.c           |  5 ++--
 drivers/net/ethernet/ti/cpts.c                | 20 ++++------------
 drivers/net/ethernet/xscale/ptp_ixp46x.c      | 19 ++++-----------
 drivers/ptp/ptp_clock.c                       |  5 +---
 drivers/ptp/ptp_dte.c                         |  5 ++--
 drivers/ptp/ptp_pch.c                         | 19 ++++-----------
 include/linux/ptp_clock_kernel.h              |  7 ------
 18 files changed, 88 insertions(+), 154 deletions(-)


base-commit: 154ba79c9f160e652a2c9c46435b928b3bfae11f
-- 
2.38.0.83.gd420dda05763

