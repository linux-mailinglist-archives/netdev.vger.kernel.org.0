Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BBC4E5266
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbiCWMrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiCWMrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:47:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB517C141;
        Wed, 23 Mar 2022 05:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648039547; x=1679575547;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b3goUzAA/VI/4DOWbJOhFKgO5Gi2BfRA6h5XH2fYuh0=;
  b=oFdDPGtjzx7nzbm5o5aG+jimpH4vtIFO7kZt4NUx5G+mPenqG3+7PmwN
   1f5dWr3OfJW8NPp1etyvtSzmdu8yfVt3s/exVMxrBsVLs1kmevpAqZ+/i
   VRlsWHa/SM0WXRz0VLZwuBVnkQllyoyi+gQybWJGQQCqYSGNY8JCQgZAv
   K1oNUu0TVswmAY1+TppzwnfA3ATmlg9KktuBfY8eUXY8HLI5aM4lk0JNP
   711o/lV1Zi95qBiBiB5y/swDLcTeeo1R1g+Z98pXg+kr6y9F1JPRCamzu
   cpOPZab6JHGnNJ7oGUd04haIrZ/2a7KWY+ER1L5WWhQ8KYPGzcWhBo5S6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="344533883"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="344533883"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 05:45:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="500987437"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2022 05:45:42 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22NCjeuC017350;
        Wed, 23 Mar 2022 12:45:40 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net 0/2] ice: avoid sleeping/scheduling in atomic contexts
Date:   Wed, 23 Mar 2022 13:43:51 +0100
Message-Id: <20220323124353.2762181-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `ice_misc_intr() + ice_send_event_to_aux()` infamous pair failed
once again.
Fix yet another (hopefully last one) 'scheduling while atomic' splat
and finally plug the hole to gracefully return prematurely when
invoked in wrong context instead of panicking.

Alexander Lobakin (2):
  ice: fix 'scheduling while atomic' on aux critical err interrupt
  ice: don't allow to run ice_send_event_to_aux() in atomic ctx

 drivers/net/ethernet/intel/ice/ice.h      |  2 ++
 drivers/net/ethernet/intel/ice/ice_idc.c  |  3 +++
 drivers/net/ethernet/intel/ice/ice_main.c | 25 ++++++++++++++---------
 3 files changed, 20 insertions(+), 10 deletions(-)

-- 
Urgent fix, would like to make it directly through -net.
-- 
2.35.1

