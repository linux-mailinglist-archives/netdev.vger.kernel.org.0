Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0103E4B2CFE
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352721AbiBKScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352724AbiBKScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:32:18 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D43D42
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 10:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644604337; x=1676140337;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CmeN+3OaZ9B/HvzWN9JpZXHvgw/0hXWgVRolZmV5RXQ=;
  b=gN7dkg+04wg2B2feYO0AdbE01NCraxLO8YJP2/hhAc+9v21kEJjSBRz4
   rz1mrSlRJZHhzYQ2UIUH+qRL7jqhXK5wrBXvyfmnA/afiAhnDIUR7dvGS
   p1YsfOj/S0u8dU9KPUiyKETA7WxuNNds3ydgaIGN16xkffcxYSCleUpzX
   qpx3ttt6BE93v9qT0no0PBoZ3cBqcyX9gHCNnn/fCLwsdDMq0Z/Q4DC3O
   bTRudK6ArwcW+MdtMm/zt/pPRagSyqTnbav3ZhjxfIO7FsJCQOrDVlL+d
   zsENmbUpXXSoK01Dicus/W7dEofE8pFAKeEsYal352OO/mnaZ4jIxphQG
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="233338466"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="233338466"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 10:32:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="774320815"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 11 Feb 2022 10:32:14 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21BIWD5N026815;
        Fri, 11 Feb 2022 18:32:13 GMT
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, laforge@gnumonks.org
Subject: [PATCH iproute2-next v3 0/2] GTP support for ip link and tc flower
Date:   Fri, 11 Feb 2022 19:29:00 +0100
Message-Id: <20220211182902.11542-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces GTP support to iproute2. Since this patch
series it is possible to create net devices of GTP type. Then, those
devices can be used in tc in order to offload GTP packets. New field
in tc flower (gtp_opts) can be used to match on QFI and PDU type.

Kernel changes:
https://lore.kernel.org/netdev/20220211175405.7651-1-marcin.szycik@linux.intel.com/T/#t

Wojciech Drewek (2):
  ip: GTP support in ip link
  f_flower: Implement gtp options support

 include/uapi/linux/if_link.h |   2 +
 include/uapi/linux/pkt_cls.h |  16 +++++
 ip/Makefile                  |   2 +-
 ip/iplink.c                  |   2 +-
 ip/iplink_gtp.c              | 128 +++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        |  29 +++++++-
 man/man8/tc-flower.8         |  10 +++
 tc/f_flower.c                | 122 ++++++++++++++++++++++++++++++++-
 8 files changed, 306 insertions(+), 5 deletions(-)
 create mode 100644 ip/iplink_gtp.c

-- 
2.31.1

