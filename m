Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF7486D0C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbiAFWGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:06:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:48366 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244830AbiAFWGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 17:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641506804; x=1673042804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rdHOfvTm/dAwcmwRlIfBvl2VIjEbWqaZR3GfUuomywo=;
  b=XGKJPur2XRRIPJQdOqhp8tplBMD/YeKmzDHUZ1IV4cO3HnkF4cq7JZkr
   cCnQbXgKNraoEnNQY64et1DkzlWmuqMoBJR7u5dsrL/P6PgmPg6WJImVA
   Y5IZyZpy/qXfrNOZoxvEllkNnBQs8pwrO20jY/DBq44OWCi9iSdxbV+Gy
   Y+iPbmTgLfrxCPOvnsSnLUZfHNIgTSEhplO334955uIs4qeS9MdnZukt6
   nwbO2x6S/1EgtsKUc8KrDdDj/YQxR1F8WDQH0n9bOc4zQteWQU5VXkzIB
   mAtj1CMzDWzb0W85OmO4oXYODw2uetWx3or/3hnejF3WwFCs1iiLMoZIO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229560624"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="229560624"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 14:06:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="618479818"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 14:06:43 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/3] mptcp: fix a DSS option writing error
Date:   Thu,  6 Jan 2022 14:06:37 -0800
Message-Id: <20220106220638.305287-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106220638.305287-1-mathew.j.martineau@linux.intel.com>
References: <20220106220638.305287-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

'ptr += 1;' was omitted in the original code.

If the DSS is the last option -- which is what we have most of the
time -- that's not an issue. But it is if we need to send something else
after like a RM_ADDR or an MP_PRIO.

Fixes: 1bff1e43a30e ("mptcp: optimize out option generation")
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 96c6efdd48bc..6661b1d6520f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1319,6 +1319,7 @@ void mptcp_write_options(__be32 *ptr, const struct tcp_sock *tp,
 				put_unaligned_be32(mpext->data_len << 16 |
 						   TCPOPT_NOP << 8 | TCPOPT_NOP, ptr);
 			}
+			ptr += 1;
 		}
 	} else if (OPTIONS_MPTCP_MPC & opts->suboptions) {
 		u8 len, flag = MPTCP_CAP_HMAC_SHA256;
-- 
2.34.1

