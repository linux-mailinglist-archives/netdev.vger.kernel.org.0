Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACAE22FC81
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgG0WxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:53:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:27607 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG0WxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:53:00 -0400
IronPort-SDR: Y5yuryRWSeaq9GezpMF5xB8e7VCB8ix07zVDycalBuxNfaCNi4NiVL9XXiZ1I3ZTGwkl09WK5f
 4hziByuXfJtw==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="138638237"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="138638237"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:52:59 -0700
IronPort-SDR: QLX0nwlR2QKvAuG6UR5byfQIw/w5qhObUxWRnlubTKzSbFPnKfYDDyCUWw75TYfsTAKov9LLp5
 23qy7kJfh1Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="434104242"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-stp-glorfindel.jf.intel.com) ([10.166.241.33])
  by orsmga004.jf.intel.com with ESMTP; 27 Jul 2020 15:52:59 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [ethtool v2 2/2] ethtool: use "Not reported" when no FEC modes are provided
Date:   Mon, 27 Jul 2020 15:49:37 -0700
Message-Id: <20200727224937.9185-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727224937.9185-1-jacob.e.keller@intel.com>
References: <20200727224937.9185-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When displaying the FEC link modes advertised by the peer, we used the
string "No" to indicate when nothing was provided. This does not match
the IOCTL output which indicates "Not reported". It also doesn't match
the local advertised FEC modes, which also used the "Not reported"
string.

This is especially confusing for FEC, because the FEC bits include
a "None" bit which indicates that FEC is definitely not supported. Avoid
this confusion and match both the local advertised settings display and
the old IOCTL output by using "Not reported" when FEC settings aren't
reported.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 netlink/settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 66b0d4892cdd..726259d83702 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -481,7 +481,7 @@ static int dump_peer_modes(struct nl_context *nlctx, const struct nlattr *attr)
 
 	ret = dump_link_modes(nlctx, attr, false, LM_CLASS_FEC,
 			      "Link partner advertised FEC modes: ",
-			      " ", "\n", "No");
+			      " ", "\n", "Not reported");
 	return ret;
 }
 
-- 
2.26.2

