Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87A5A5F15
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiH3JSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiH3JSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:18:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB75D573E
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661851121; x=1693387121;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cgyxot/3a6HYnTlAp77OFixwpJSU9J4wguaPhc6ycp4=;
  b=nUz13yD78NoXu41EwjLLEUsExbvn+XKr1HtLP89MAuoIq4xnFX03zJej
   Gi60HmWAEz53PL9Q4WCqNrNA9cmPqf84SbfgZgC5slVjEXhXtFY0Y1AAZ
   QnbwK/fUYIEbQAkzd+Of94cE2ym/mhrmr3Yu5iZHZZEef41aRnUjSxh+d
   rTMwHVyYK46coK4B+DpIRADY91vhpWldfQ8psJ1L4X1ia+BEjMu4kbdNL
   aVMlyJvIVU7uA98kIEuryVbf3KvJU+S8mbIwIbVd/XOR1RwCe4IvEVYbX
   IKj5spCSXzYZkmjj8QF8EZ/gO9ASIW8XRn0mJPi3JmNINdTngDVhMeG7O
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="292705959"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="292705959"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:18:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="679964312"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 02:18:39 -0700
Subject: [net-next PATCH 0/3] Extend action skbedit to RX queue mapping
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.h.duyck@intel.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Tue, 30 Aug 2022 02:28:39 -0700
Message-ID: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the discussion on
https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
the following series extends skbedit tc action to RX queue mapping.
Currently, skbedit action in tc allows overriding of transmit queue.
Extending this ability of skedit action supports the selection of receive
queue for incoming packets. Offloading this action is added for receive
side. Enabled ice driver to offload this type of filter into the
hardware for accepting packets to the device's receive queue.

---

Amritha Nambiar (3):
      act_skbedit: Add support for action skbedit RX queue mapping
      act_skbedit: Offload skbedit queue mapping for receive queue
      ice: Enable RX queue selection using skbedit action


 drivers/net/ethernet/intel/ice/ice.h        |   15 +
 drivers/net/ethernet/intel/ice/ice_main.c   |    2 
 drivers/net/ethernet/intel/ice/ice_tc_lib.c |  351 +++++++++++++++++++--------
 drivers/net/ethernet/intel/ice/ice_tc_lib.h |   40 ++-
 include/net/act_api.h                       |    1 
 include/net/flow_offload.h                  |    2 
 include/net/tc_act/tc_skbedit.h             |   11 +
 net/sched/act_skbedit.c                     |   40 ++-
 net/sched/cls_api.c                         |    7 +
 9 files changed, 352 insertions(+), 117 deletions(-)

--
