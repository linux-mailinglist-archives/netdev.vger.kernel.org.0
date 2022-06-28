Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACCB55D4DD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbiF1BDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243002AbiF1BCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD40B22B31
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378173; x=1687914173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EJvn72C9iNx1ZNK7vsLL/vNLnYeIv6S01w9Gf9NZz9M=;
  b=d0DEPdXDgtVhnkMS/9fQuCDS+Rhq8xU1yjZoz9Rla/GlJmgWcl/YXO0D
   OPNymQ7ysat6o8RxUaUMkASquVrMzi936DuwDYqDutvYK07SBfeS/8eJf
   gVrV6RfVwQrImfYENxIcZXXDf/PvWaM/DOkJDTajpVtAwcGNxJF3jm9va
   wwJ3tvZI6NOp+HovJKcjFCeoQkiFatQBXisBA4BNHAnUZ8jIFDJbCpExJ
   YY8U0vDEuXrBJ2cT3Oy6jue3+4wZVodZSldoeXczKzWI9qD1FvxyDJzHs
   M4XrMbgRsPdut3SCFyhvsb13jd8LFa8ZoYuLtP19QKzMpOpWc6R3MBk3/
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642456"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642456"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867420"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Ossama Othman <ossama.othman@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 8/9] mptcp: fix conflict with <netinet/in.h>
Date:   Mon, 27 Jun 2022 18:02:42 -0700
Message-Id: <20220628010243.166605-9-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
References: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ossama Othman <ossama.othman@intel.com>

Including <linux/mptcp.h> before the C library <netinet/in.h> header
causes symbol redefinition errors at compile-time due to duplicate
declarations and definitions in the <linux/in.h> header included by
<linux/mptcp.h>.

Explicitly include <netinet/in.h> before <linux/in.h> in
<linux/mptcp.h> when __KERNEL__ is not defined so that the C library
compatibility logic in <linux/libc-compat.h> is enabled when including
<linux/mptcp.h> in user space code.

Fixes: c11c5906bc0a ("mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support")
Signed-off-by: Ossama Othman <ossama.othman@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 921963589904..dfe19bf13f4c 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -2,16 +2,17 @@
 #ifndef _UAPI_MPTCP_H
 #define _UAPI_MPTCP_H
 
+#ifndef __KERNEL__
+#include <netinet/in.h>		/* for sockaddr_in and sockaddr_in6	*/
+#include <sys/socket.h>		/* for struct sockaddr			*/
+#endif
+
 #include <linux/const.h>
 #include <linux/types.h>
 #include <linux/in.h>		/* for sockaddr_in			*/
 #include <linux/in6.h>		/* for sockaddr_in6			*/
 #include <linux/socket.h>	/* for sockaddr_storage and sa_family	*/
 
-#ifndef __KERNEL__
-#include <sys/socket.h>		/* for struct sockaddr			*/
-#endif
-
 #define MPTCP_SUBFLOW_FLAG_MCAP_REM		_BITUL(0)
 #define MPTCP_SUBFLOW_FLAG_MCAP_LOC		_BITUL(1)
 #define MPTCP_SUBFLOW_FLAG_JOIN_REM		_BITUL(2)
-- 
2.37.0

