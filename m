Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536865746B3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiGNI1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiGNI1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:27:30 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A16D3AE64
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 01:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657787249; x=1689323249;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VvBRfMhqTzqK+dJB7aP7E0otYreFq+aGN5A3IGZ6900=;
  b=lWEvNtCK4YmFKgZnEc8SLxg5I3+LC2P9Lzfs6wOfvthIatxmqjUn4Q9+
   gJ9yfYdQlFJeB3ZYQBbHaXRT9ycDnvj2Snz0itnOiVi8zJ2N/Pb0Tqaqn
   u2Ycd/BJc68zpnS187weCoN8lBiE6gPTKFWtUTWaNe0ufUfSMreYbutP9
   igquKoVBTySt1JMbaP5BNdzXkLzHKiW+S+nblrOVQtIdk5AYPS0m1Q1FN
   KqtruRd09NxBmWJ6pDHgG7bgyrZlfbOZ6wfa5vE1pNxfIEQOnYFmrGr9y
   cUbcSxbRQwUz2/QeUkePeTJ5iRHjF71geoxRCatwvQxtWXN4iYLI1epY6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="349420048"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="349420048"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 01:27:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="546187144"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 14 Jul 2022 01:27:27 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26E8RQl6029602;
        Thu, 14 Jul 2022 09:27:27 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute2-next 0/2] PPPoE support in tc-flower
Date:   Thu, 14 Jul 2022 10:25:20 +0200
Message-Id: <20220714082522.54913-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements support for matching
on PPPoE specific fields using tc-flower.
First patch adds support for parsing ppp protocols
and it also introduces small refactor which allows
to use same mechanism of finding protocol for
both ppp and ether protocols. Second patch
is about parsing PPPoE fields.

Kernel changes:
https://lore.kernel.org/netdev/20220708122421.19309-1-marcin.szycik@linux.intel.com/T/#t

Wojciech Drewek (2):
  lib: Introduce ppp protocols
  f_flower: Introduce PPPoE support

 include/rt_names.h            |  3 ++
 include/uapi/linux/pkt_cls.h  |  3 ++
 include/uapi/linux/ppp_defs.h | 37 +++++++++++++++++++++++
 include/utils.h               | 10 +++++++
 lib/Makefile                  |  2 +-
 lib/ll_proto.c                | 33 +++++----------------
 lib/ppp_proto.c               | 52 ++++++++++++++++++++++++++++++++
 lib/utils.c                   | 34 +++++++++++++++++++++
 man/man8/tc-flower.8          | 17 ++++++++++-
 tc/f_flower.c                 | 56 +++++++++++++++++++++++++++++++++++
 10 files changed, 220 insertions(+), 27 deletions(-)
 create mode 100644 include/uapi/linux/ppp_defs.h
 create mode 100644 lib/ppp_proto.c

-- 
2.31.1

