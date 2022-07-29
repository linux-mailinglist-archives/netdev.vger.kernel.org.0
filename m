Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC6A584DB3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 10:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbiG2Iwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 04:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiG2Iwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 04:52:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E501883206
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 01:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659084753; x=1690620753;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gGRCkNszxYPwbc+UF2sSw5+fUIX46ZfH1BqxL+ASUbE=;
  b=MzrchL26AV61KXzcQhoWoZpM9ZSk/bthlrvnhoTCd9NYi5yNGgB61ePk
   wd3NqjfvpJtUC0HPiqEFfbN5MZlNP4WTBu5y+1l/D/e9PM0IICXSQzWf8
   GL8wkxPKj3hC6muMusAF+8myvHZkgcMR9hCNbG0FeKUwpt7XWARNbrjb8
   emF9whOup3Mv2WkwSJ+z0R/DRKLvs+/MOVO2VPZOtNQl8GXZ9nBARJle+
   /9AMUftoNTksCg1MVpsvmuIVCdsE22gTEVgbturr/duVQdDND7upssQG9
   itHHbuaR6mxCndkE4qyau3xFwb4SNXsg2KSNFVOzyQ70nxxttP3wICDK0
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10422"; a="275610575"
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="275610575"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 01:52:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,200,1654585200"; 
   d="scan'208";a="660154357"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jul 2022 01:52:28 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 26T8qR39020937;
        Fri, 29 Jul 2022 09:52:27 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute-next v4 0/3] PPPoE support in tc-flower
Date:   Fri, 29 Jul 2022 10:50:32 +0200
Message-Id: <20220729085035.535788-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Kernel changes (merged):
https://lore.kernel.org/netdev/20220726203133.2171332-1-anthony.l.nguyen@intel.com/T/#t

Wojciech Drewek (3):
  lib: refactor ll_proto functions
  lib: Introduce ppp protocols
  f_flower: Introduce PPPoE support

 include/rt_names.h           |  3 ++
 include/uapi/linux/pkt_cls.h |  3 ++
 include/utils.h              | 10 +++++++
 lib/Makefile                 |  2 +-
 lib/ll_proto.c               | 33 +++++---------------
 lib/ppp_proto.c              | 52 ++++++++++++++++++++++++++++++++
 lib/utils.c                  | 34 +++++++++++++++++++++
 man/man8/tc-flower.8         | 17 ++++++++++-
 tc/f_flower.c                | 58 ++++++++++++++++++++++++++++++++++++
 9 files changed, 185 insertions(+), 27 deletions(-)
 create mode 100644 lib/ppp_proto.c

-- 
2.31.1

