Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC75A63E4
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiH3Mvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiH3Mvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:51:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84071A397;
        Tue, 30 Aug 2022 05:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661863894; x=1693399894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Sz2pM0oueet+LZH53lL+eqoz2BCqs9OOXqyIhNHl00c=;
  b=Ly1VwXftZIq1HwNv1/h+iRpdqV7umSxzZYDG6NSzNbKoZwnVPn2MCmkb
   b+TaHs8cPy3YmeOTjFw2kQRVRsf8pU4Ipz/gc7bps6UhIPdGNaO/XCxx6
   rwRCxT0eHHJqiXcaMJo1UIrUDleOitrIrifzqiK8Kyfhc1DG+/d8dCtEu
   B3HxGgkpZMw2ZtHOeGKT81sJLltiG1oUCoQb+O8gV+n/Gi7p4Hkl0N3tY
   1Rv9X/j9k1Zj0jAaN4jduYwWZtwtMceDxDt21xYj94C7ZIy2l8fWyMpb1
   OeZiJJp7VP1Ank/YFQD5K8j1pCigKP8U3Xj/0/MQABETGH0IfFjPQZ/Zw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="321292288"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="321292288"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:51:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="680024087"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 05:51:33 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        alasdair.mcwilliam@outlook.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 0/2] ice: xsk: ZC changes
Date:   Tue, 30 Aug 2022 14:51:20 +0200
Message-Id: <20220830125122.9665-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 165 +++++++++-------------
 drivers/net/ethernet/intel/ice/ice_xsk.h  |   7 +-
 3 files changed, 72 insertions(+), 102 deletions(-)

-- 
2.34.1

