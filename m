Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBA9583CC6
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiG1LDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiG1LDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:03:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783C4664D2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659006195; x=1690542195;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=00K0oMdUZV/VN9d8yGmx7a21IbYht+0KtKCpg9ZQ0u8=;
  b=XdRgAJm/gDeBHfC7PqytMrAZVvGWPWH+O0KuqaToltRAPFsQTe5fzk5I
   Ou3O3iKqlRq5IC//3mPcF597+oXSeF5WBRjDFlSFvoGq3+DlTFhuiGzey
   9FKJKsBXieeYGwN36FDz0eg4JoVRM8M6RwcFOrjbf7VmsYY+tZ/fCx6LI
   EqgM1QY6oSSq5wOGJc+Ky+t56qnPPNPM0dKo2NaFd6adGfgVDeuqUNawA
   zjUV+F2omCKVxPQOjlsTf/6r3lnmXAAj24a7f2yzhwAV7TeMOCbezLC1I
   bepIxKvzOntHL7cs4LnH7Y0GMLFUpEbxnawKhE6dVk3atcx9gD5LJww3F
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10421"; a="352480752"
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="352480752"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 04:03:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,196,1654585200"; 
   d="scan'208";a="551263336"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 28 Jul 2022 04:03:12 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26SB3BbJ019284;
        Thu, 28 Jul 2022 12:03:11 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v3 0/3] PPPoE support in tc-flower
Date:   Thu, 28 Jul 2022 13:01:14 +0200
Message-Id: <20220728110117.492855-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Kernel changes (merged):
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

