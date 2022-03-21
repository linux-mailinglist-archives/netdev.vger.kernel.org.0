Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2F34E24DF
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346594AbiCULDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346579AbiCULDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:03:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE2314F135;
        Mon, 21 Mar 2022 04:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647860501; x=1679396501;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NmyGAg3H5qIjkqj2AgtDJJmkpqDu2Ml32OAol27OBlQ=;
  b=k3e92X1Q1twaVlP3jgWw2JL8ohG1zJYgRU1WgSN3ME3hYj0jX4LLRLJB
   wQRjananrWQd56+UM4QegQ5Ww+weCjLgILNQ6QRksV7xNUXYxI9xbagNw
   mLh4MQZsuqR8OWu7lFd1M0LdLUddkE6gfUuFxbzhTvutReKdnIdmGh0m3
   GpYOtgRQykv/VZQusS6YwC2zm1xCb8liH2qhPN/mlFLM9M7y+NHjpJJ7K
   Ou3PkLcN6GpGiZdcdInwltRHzDzFTdsAJ8CufCNeFJtb/L631gkPJuT+9
   HebRAppzd6aM1ARVRvb7BM9nwcylun0WkYU7EbeFgge5S/2MZyDoFoR90
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237467084"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="237467084"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 04:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="543173127"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2022 04:01:18 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22LB1HaB031880;
        Mon, 21 Mar 2022 11:01:17 GMT
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
Subject: [PATCH v4 net-next 0/5] ice: switch: debloat packet templates code
Date:   Mon, 21 Mar 2022 11:59:49 +0100
Message-Id: <20220321105954.843154-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
ice_find_dummy_packet() became very complex at this point with tons
of nested if-elses. It clearly showed this approach does not scale,
so convert its logics to the simple mask-match + static const array.

bloat-o-meter is happy about that (built w/ LLVM 13):

add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1058 (-1056)
Function                                     old     new   delta
ice_fill_adv_dummy_packet                    289     291      +2
ice_adv_add_update_vsi_list                  201       -    -201
ice_add_adv_rule                            2950    2093    -857
Total: Before=414512, After=413456, chg -0.25%
add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
RO Data                                      old     new   delta
ice_dummy_pkt_profiles                         -     672    +672
Total: Before=37895, After=38567, chg +1.77%

Diffstat also looks nice, and adding new packet templates now takes
less lines.

We'll probably come out with dynamic template crafting in a while,
but for now let's improve what we have currently.

From v3[0]:
 - change u64:48 + u64:16 -> u32 + u16 to fix issues on 32-bit
   platforms (and make object code a bit simpler);
 - mention ice_find_dummy_packet() conversion in the cover letter.

From v2[1]:
 - rebase on top of the GTP changes;
 - new: convert template search code to a rodata array (-1000 bytes
   from .text, -400 bytes from ice.ko);
 - collect Reviewed-by and Tested-by (Marcin, Michal).

From v1[2]:
 - rebase on top of the latest next-queue (to fix #3 not applying);
 - adjust the kdoc accordingly to the function proto changes in #3;
 - no functional changes.

[0] https://lore.kernel.org/netdev/20220318161713.680436-1-alexandr.lobakin@intel.com
[1] https://lore.kernel.org/netdev/20220127154009.623304-1-alexandr.lobakin@intel.com
[2] https://lore.kernel.org/netdev/20220124173116.739083-1-alexandr.lobakin@intel.com

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

