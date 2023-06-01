Return-Path: <netdev+bounces-7198-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A2571F0BA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7D6528183D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B2846FFE;
	Thu,  1 Jun 2023 17:28:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9742501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:28:26 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C2A136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640504; x=1717176504;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NkwbIvRwalMOActZYxfVCY2oZOunel4g7+JZdBIjO84=;
  b=GaZiKVRvFx9H4crJjLKGTAr0iCEafQM8gHNjHxEbrq8RKWH4658PJhwM
   WaThLFl8tXsSc4K/6KmWb/ldzCy3RQs2MWRrD1xWbU62SORjWly0Ist/k
   1jPVA6HIjQQekgsiEtA5ZAihSNryDI3mkBECoEa2iLMwBbgQNkOdPj/yC
   k2C3XxN/A+JVJnUZDma3/0rr1Gg/4eazPHCfvxjTvloh/FxUyb5/8JZKw
   EoH3O+TvKSOdIpAr8d1q1jIJbuqPPLh6dupKSUEUAnevf9GzC8lf6pDTk
   LhLMrtBPByDIxP/Ixa2UCdcUrdaunmZHSZOgJZcwUo6Wk/V8Xz72gyPCT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="354485262"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="354485262"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:28:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="710596308"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="710596308"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2023 10:28:24 -0700
Subject: [net-next/RFC PATCH v1 0/4] Introduce napi queues support
From: Amritha Nambiar <amritha.nambiar@intel.com>
To: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date: Thu, 01 Jun 2023 10:42:20 -0700
Message-ID: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce support for associating napi instances with
corresponding RX and TX queue set. Add the capability
to export napi information supported by the device.
Extend the netdev_genl generic netlink family for netdev
with napi data. The napi fields exposed are:
- napi id
- queue/queue-set (both RX and TX) associated with each
  napi instance

Additional napi fields such as PID association for napi
thread etc. can be supported in a follow-on patch set.

This series only supports 'get' ability for retrieving
napi fields (specifically, napi ids and queue[s]). The 'set'
ability for setting queue[s] associated with a napi instance
via netdev-genl will be submitted as a separate patch series.

Previous discussion at:
https://lore.kernel.org/netdev/c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com/T/#m00999652a8b4731fbdb7bf698d2e3666c65a60e7

$ ./cli.py --spec netdev.yaml  --do dev-get --json='{"ifindex": 12}'
[{'ifindex': 12,
  'xdp-features': {'xsk-zerocopy', 'basic', 'rx-sg', 'redirect'}},
 {'napi-info': [{'napi-id': 600, 'rx-queues': [7], 'tx-queues': [7]},
                {'napi-id': 599, 'rx-queues': [6], 'tx-queues': [6]},
                {'napi-id': 598, 'rx-queues': [5], 'tx-queues': [5]},
                {'napi-id': 597, 'rx-queues': [4], 'tx-queues': [4]},
                {'napi-id': 596, 'rx-queues': [3], 'tx-queues': [3]},
                {'napi-id': 595, 'rx-queues': [2], 'tx-queues': [2]},
                {'napi-id': 594, 'rx-queues': [1], 'tx-queues': [1]},
                {'napi-id': 593, 'rx-queues': [0], 'tx-queues': [0]}]}]

---

Amritha Nambiar (4):
      net: Introduce new napi fields for rx/tx queues
      net: Add support for associating napi with queue[s]
      netdev-genl: Introduce netdev dump ctx
      netdev-genl: Add support for exposing napi info from netdev


 Documentation/netlink/specs/netdev.yaml   |   39 ++++
 drivers/net/ethernet/intel/ice/ice_lib.c  |   57 ++++++
 drivers/net/ethernet/intel/ice/ice_lib.h  |    4 
 drivers/net/ethernet/intel/ice/ice_main.c |    4 
 include/linux/netdevice.h                 |   18 ++
 include/uapi/linux/netdev.h               |    4 
 net/core/dev.c                            |   55 ++++++
 net/core/netdev-genl.c                    |  261 ++++++++++++++++++++++++-----
 tools/include/uapi/linux/netdev.h         |    4 
 9 files changed, 402 insertions(+), 44 deletions(-)

--

