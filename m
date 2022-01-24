Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49E24986DB
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiAXRdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:33:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:16022 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244172AbiAXRdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 12:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643045581; x=1674581581;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=APJ8zDgY079UWWK2xtzuhPmpX1L8BovvQH53cnFvTAs=;
  b=SYE/XAIURkDu5lY9Wp9pnne8oHqsy0oKvMspgfJSgxqn3i3mRgCRXzSb
   NOeHUjlvDZrPkVuF3blaDeErBvVhOFrr+nWOoGC5wLhMZbLK7gSSB8puV
   VU/t1yFupRknVhTfiEQyTK8uufTqCy7S2ku0OLcJN336IvtHLeuVelyqF
   g/Lv+gUU3ShrcayS0Y35A7xdoNwH2TovowCPhKzvjifDwdgzJC/fRzLnm
   U/fOqUsegOLnRAHKpN1RPr1tZVFcoywjJCDHsY+YM9wO3cG7gSQSRcX4K
   ZC9EloPvYe45Zh95uN9nqXTRPPgL73C5liO/xwXANvxmeSmfh24EujxFY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="226773763"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="226773763"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 09:33:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="596852642"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2022 09:32:58 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 20OHWuIo010465;
        Mon, 24 Jan 2022 17:32:56 GMT
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
Subject: [PATCH net-next 0/4] ice: switch: debloat packet templates code
Date:   Mon, 24 Jan 2022 18:31:11 +0100
Message-Id: <20220124173116.739083-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applies on top of
commit 1ed7aede32fd ("ice: Add support for inner etype in switchdev")
(here: [0]) to exclude non-trivial conflicts and cover the code added
there as well.

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

[0] https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20220110/027399.html

Alexander Lobakin (4):
  ice: switch: add and use u16[] aliases to ice_adv_lkup_elem::{h,m}_u
  ice: switch: unobscurify bitops loop in ice_fill_adv_dummy_packet()
  ice: switch: use a struct to pass packet template params
  ice: switch: use convenience macros to declare dummy pkt templates

 drivers/net/ethernet/intel/ice/ice_switch.c | 264 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_switch.h |  12 +-
 2 files changed, 120 insertions(+), 156 deletions(-)

base-commit: 1ed7aede32fd46f0fac72cef138c9d5e36326c98
-- 
2.34.1

