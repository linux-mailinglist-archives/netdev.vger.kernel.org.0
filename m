Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CEC583A8A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 10:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiG1Iqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 04:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiG1Iqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 04:46:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A879C13FBA
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658997994; x=1690533994;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CK+xkeayYYpm9G4SnUqRpyAii2N3b6xVDIQ+n7X7Pjc=;
  b=b7x2nzcrgR0arWyKfpCEdbb6GlHxphmIRKybj0QDidZtDp4s7b8y+4uu
   j69eCE+K3U27ItRgi31D19HiGGUHEFqry6lZM0+jTqKrMsMiPHqFwLs7l
   emPctbp/3TXVDfYSt0VOpZW5pfdglSn83Ndk7wirVuyP3Yxl0moTJsJM/
   fokxDhnLUmKEwhwW11S3nWj9j2NSLPXw2lHbvv2Vv8DAQ0xrK5T5C08Tc
   2N06yi0kPVsMRnbpHq9bG6YHLLMyjLyn+9tqdIx4IbWYKkwCIEGhMTv73
   hrCHgiYYdfeGqJbe3yb2C5be001CeSY3/WvSwbkP2uM9ZAT36gFvs+Mn8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="275341372"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="275341372"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 01:46:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="633576825"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 28 Jul 2022 01:46:33 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26S8kWS0008698;
        Thu, 28 Jul 2022 09:46:32 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org
Subject: [PATCH iproute-next v2 0/3] PPPoE support in tc-flower
Date:   Thu, 28 Jul 2022 10:44:34 +0200
Message-Id: <20220728084437.486187-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements support for matching
on PPPoE specific fields using tc-flower.
First patch introduces small refactor which allows
to use same mechanism of finding protocol for
both ppp and ether protocols. Second patch
adds support for parsing ppp protocols.
Last patch is about parsing PPPoE fields.

Kernel changes:
https://lore.kernel.org/netdev/20220726203133.2171332-1-anthony.l.nguyen@intel.com/T/#t

Wojciech Drewek (3):
  lib: refactor ll_proto functions
  lib: Introduce ppp protocols
  f_flower: Introduce PPPoE support

 include/rt_names.h            |  3 ++
 include/uapi/linux/pkt_cls.h  |  3 ++
 include/uapi/linux/ppp_defs.h | 37 ++++++++++++++++++++++
 include/utils.h               | 10 ++++++
 lib/Makefile                  |  2 +-
 lib/ll_proto.c                | 33 +++++---------------
 lib/ppp_proto.c               | 52 +++++++++++++++++++++++++++++++
 lib/utils.c                   | 34 ++++++++++++++++++++
 man/man8/tc-flower.8          | 17 +++++++++-
 tc/f_flower.c                 | 58 +++++++++++++++++++++++++++++++++++
 10 files changed, 222 insertions(+), 27 deletions(-)
 create mode 100644 include/uapi/linux/ppp_defs.h
 create mode 100644 lib/ppp_proto.c

-- 
2.31.1

