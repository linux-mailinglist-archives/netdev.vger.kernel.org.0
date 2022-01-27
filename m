Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66649E65C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242955AbiA0PmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:42:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:10340 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242931AbiA0PmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 10:42:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643298127; x=1674834127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ilgXZaqxDA9kqy7YRB+bhcP2wz4pTOi+q3i19NEBc9w=;
  b=GtivIG/xio5umHBeNYuAuZAcw1zjOSJr6SI1wwbYqTNGVmbLZcs1lNdZ
   apxrLDoXwfAoEQg5STdbj9Ubm4MyKekgsgu4yV92yDm9bfHv9+sSBzOkY
   SpUJcbfVRzjyHIOdB7AyUxa6DD7VeRXiRJs6m3+CLnrYXflOSa/o3bhpb
   uGbZqL3j9o6NcyWq3vxcH1tlUMRdb7K/NkS0b8k63SGJIPB0FGfcC0R+S
   hjbw2cHqq4RhH+od8Q7o5KiT2uunPoHNC/iJVwfl7DGCIZG9EF1cjFGZT
   82wbV1jsK96HLeuh+7Kr/vzgECyQNZvk5RS+A/vWXQextXjIo13ukEWKh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333242522"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="333242522"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 07:41:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="521282143"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 27 Jan 2022 07:41:47 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20RFfjOn028674;
        Thu, 27 Jan 2022 15:41:45 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 0/4] ice: switch: debloat packet templates code
Date:   Thu, 27 Jan 2022 16:40:05 +0100
Message-Id: <20220127154009.623304-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This hunts down several places around packet templates/dummies for
switch rules which are either repetitive, fragile or just not
really readable code.
It's a common need to add new packet templates and to review such
changes as well, try to simplify both with the help of a pair
macros and aliases.

bloat-o-meter is happy about that (built w/ LLVM 13):

add/remove: 0/1 grow/shrink: 2/0 up/down: 148/-202 (-54)
Function                                     old     new   delta
ice_add_adv_rule                            2383    2529    +146
ice_fill_adv_dummy_packet                    289     291      +2
ice_adv_add_update_vsi_list                  202       -    -202
Total: Before=395813, After=395759, chg -0.01%

Diffstat also looks nice, and adding new packet templates now takes
less lines.

We'll probably come out with dynamic template crafting in a while,
but for now let's improve what we have currently.

Note: this will conflict with [1] going through net-next,
a followup will be sent once accepted.

From v1 ([0]):
 - rebase on top of the latest next-queue (to fix #3 not applying);
 - adjust the kdoc accordingly to the function proto changes in #3;
 - no functional changes.

[0] https://lore.kernel.org/netdev/20220124173116.739083-1-alexandr.lobakin@intel.com
[1] https://lore.kernel.org/netdev/20220127125525.125805-1-marcin.szycik@linux.intel.com

Alexander Lobakin (4):
  ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h,m}_u
  ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
  ice: switch: use a struct to pass packet template params
  ice: switch: use convenience macros to declare dummy pkt templates

 drivers/net/ethernet/intel/ice/ice_switch.c | 273 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_switch.h |  12 +-
 2 files changed, 123 insertions(+), 162 deletions(-)

-- 
2.34.1

