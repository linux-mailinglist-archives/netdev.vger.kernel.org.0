Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56FC5A94D7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbiIAKla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbiIAKlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:41:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE92C88A1;
        Thu,  1 Sep 2022 03:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662028845; x=1693564845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ldRO/Hqc+BxfjmQ0KMK1BIF3nGuLHXkqCkrsqB0q2WI=;
  b=ncOlazprB6EJI7n6mfvUcsZ5y9N7kyl04DismLk5QNj/8d2h1Vzn5ak8
   VHtLd4j+pBgCzZibo7xWbfuyb1aqZH8ikA02ZJil1AwmTBXG1pDYmRqWQ
   xZOOz4BrgGy2MP+dTy9xdSMPU31Cd4xXypSkD1HJGoucXMo2jSSWPI01u
   U7SVviHcdfIDHjUGGveBHaSd6xzEHRsSuzRarY0d2nRrT8NhrqVTm4pEz
   k00jQL903KE43ehctZNqBJTZJMn3is7abaURiDPaHUiLNAoBqTs1DKGV2
   K6Ml0MpF5wjkC1CpkjoXXG86VNNLgZZOAZFu9NoydrC4IMaaubaQwyse8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="357399188"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="357399188"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:40:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="857801156"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 01 Sep 2022 03:40:42 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        alasdair.mcwilliam@outlook.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 intel-net 0/2] ice: xsk: ZC changes
Date:   Thu,  1 Sep 2022 12:40:38 +0200
Message-Id: <20220901104040.15723-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this set consists of two fixes to issues that were either pointed out on
indirectly (John was reviewing AF_XDP selftests that were testing ice's
ZC support) mailing list or were directly reported by customers.

First patch allows user space to see done descriptor in CQ even after a
single frame being transmitted and second patch removes the need for
having HW rings sized to power of 2 number of descriptors when used
against AF_XDP.

I also forgot to mention that due to the current Tx cleaning algorithm,
4k HW ring was broken and these two patches bring it back to life, so we
kill two birds with one stone.

v3:
- make sure patches apply to net

v2:
- remove doubled fixes tag from patch 1
- add Alasdair to CC as he reported need for bigger rings used with
  AF_XDP ZC

Thanks!
Maciej

Maciej Fijalkowski (2):
  ice: xsk: change batched Tx descriptor cleaning
  ice: xsk: drop power of 2 ring size restriction for AF_XDP

 drivers/net/ethernet/intel/ice/ice_txrx.c |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 163 +++++++++-------------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
 3 files changed, 71 insertions(+), 101 deletions(-)

-- 
2.34.1

