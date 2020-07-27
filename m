Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AFE22FC13
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgG0WXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:23:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:58725 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:23:15 -0400
IronPort-SDR: xkRFADb0dvweukAjW17Es5Xe1Q0EEBFRtUqPmSbG8cS1w4LnEwJGDDGT68ZpKhvLV+of29goDB
 crbnYKRPUi6A==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="148986265"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="148986265"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:23:15 -0700
IronPort-SDR: ajTQdtp3nHe4k5c5h3mh08mkr90jRXzVLUCNW7DoNNS8FR4WE+M7491PnnZ0jhEuwlZzAokYOo
 L9APzMB8kGkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="464219018"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-stp-glorfindel.jf.intel.com) ([10.166.241.33])
  by orsmga005.jf.intel.com with ESMTP; 27 Jul 2020 15:23:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [ethtool] ethtool: use "Not reported" when no FEC modes are provided
Date:   Mon, 27 Jul 2020 15:19:52 -0700
Message-Id: <20200727221952.6659-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.26.2
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
index 29557653336e..5616cb2f7b6f 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -473,7 +473,7 @@ static int dump_peer_modes(struct nl_context *nlctx, const struct nlattr *attr)
 
 	ret = dump_link_modes(nlctx, attr, true, LM_CLASS_FEC,
 			      "Link partner advertised FEC modes: ",
-			      " ", "\n", "No");
+			      " ", "\n", "Not reported");
 	return ret;
 }
 
-- 
2.26.2

