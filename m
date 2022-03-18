Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2B4DDEA8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiCRQXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbiCRQWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:22:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06888117991;
        Fri, 18 Mar 2022 09:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647620368; x=1679156368;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=K35+NJn4cb9SB2tUyATnivg4yiRvcwab/IpVO7uv9zs=;
  b=EvsZu8WP+wbpJBT/YXbXnJK+ct1167XMBjSeA9aJzOnBajSas6WiAvcm
   InIY71URdKuXzLZux/jS/TTzrVl/vLCdf6uP8WyK1Mkb5iCca9GRIUS53
   Okb+FeQC9f997R9F+yLsxjTrX1hhgtf1/uzJq8Dr0m8qGQpyTy2ExvB2g
   LL0HnbtvQcteyQI+eIXLPgD0zxEU91iAsUJkLtk+QQfb6ytWu0AJ6hoU4
   iuHGR+QiYj4Y6TLV9FlZ6wXQFqF4/ZsCopLArew0DDL9zYUhQu6QPiH9o
   Y0jwYA3RYwkKcb1uoSlcN+dD+chqgAC0FZKx/PA7Ep3bqTl9svwXZqGAv
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="257114781"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="257114781"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:18:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="784286416"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 18 Mar 2022 09:18:25 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22IGIOmC024113;
        Fri, 18 Mar 2022 16:18:24 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 0/5] ice: switch: debloat packet templates code
Date:   Fri, 18 Mar 2022 17:17:08 +0100
Message-Id: <20220318161713.680436-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1045 (-1043)
Function                                     old     new   delta
ice_fill_adv_dummy_packet                    289     291      +2
ice_adv_add_update_vsi_list                  201       -    -201
ice_add_adv_rule                            2950    2106    -844
Total: Before=413901, After=412858, chg -0.25%
add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
RO Data                                      old     new   delta
ice_dummy_pkt_profiles                         -     672    +672

Diffstat also looks nice, and adding new packet templates now takes
less lines.

We'll probably come out with dynamic template crafting in a while,
but for now let's improve what we have currently.

From v2[0]:
 - rebase on top of the GTP changes;
 - new: convert template search code to a rodata array (-1000 bytes
   from .text, -400 bytes from ice.ko);
 - collect Reviewed-by and Tested-by (Marcin, Michal).

From v1[1]:
 - rebase on top of the latest next-queue (to fix #3 not applying);
 - adjust the kdoc accordingly to the function proto changes in #3;
 - no functional changes.

[0] https://lore.kernel.org/netdev/20220127154009.623304-1-alexandr.lobakin@intel.com
[1] https://lore.kernel.org/netdev/20220124173116.739083-1-alexandr.lobakin@intel.com

Alexander Lobakin (5):
  ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h,m}_u
  ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
  ice: switch: use a struct to pass packet template params
  ice: switch: use convenience macros to declare dummy pkt templates
  ice: switch: convert packet template match code to rodata

 drivers/net/ethernet/intel/ice/ice_switch.c | 489 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_switch.h |  12 +-
 2 files changed, 211 insertions(+), 290 deletions(-)

-- 
2.35.1

