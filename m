Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0389624F2BE
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 08:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgHXGxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 02:53:42 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:44768 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHXGxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 02:53:42 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2020 02:53:41 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1149; q=dns/txt; s=iport;
  t=1598252022; x=1599461622;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xz1vP/1kr8FxDu7tNiS2681+avMILaR4D9gMtdWax1Y=;
  b=eicH5Uk+eiHuJqRA4ONRc86tuJGO3HrKhi1O0LqU82revNCc4R/HQk49
   3dMCNfGMW3m8kAEzQQszsdUBa/RR+rH0S4JwdBy82FboQT9f0KqPx8t8K
   5scGw8LcjOFnx41B7XnPYFxTFC3XxsQHcAOL7tVsfYmdc3Y7FWLbfbHbh
   k=;
X-IronPort-AV: E=Sophos;i="5.76,347,1592870400"; 
   d="scan'208";a="28992227"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Aug 2020 06:46:32 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.120])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id 07O6kWUg007636;
        Mon, 24 Aug 2020 06:46:32 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH] ioctl: only memset non-NULL link settings
Date:   Mon, 24 Aug 2020 08:46:30 +0200
Message-Id: <20200824064630.3836539-1-hegtvedt@cisco.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.47.78.120, [10.47.78.120]
X-Outbound-Node: aer-core-2.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit bef780467fa ('ioctl: do not pass transceiver value back to
kernel') a regression slipped. If we have a kernel that does not support
the ETHTOOL_xLINKSETTINGS API, then the do_ioctl_glinksettings()
function will return a NULL pointer.

Hence before memset'ing the pointer to zero we must first check it is
valid, as NULL return is perfectly fine when running on old kernels.

Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
---
 ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index c4ad186..8267d6b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2908,8 +2908,10 @@ static int do_sset(struct cmd_context *ctx)
 		struct ethtool_link_usettings *link_usettings;
 
 		link_usettings = do_ioctl_glinksettings(ctx);
-		memset(&link_usettings->deprecated, 0,
-		       sizeof(link_usettings->deprecated));
+		if (link_usettings) {
+			memset(&link_usettings->deprecated, 0,
+			       sizeof(link_usettings->deprecated));
+		}
 		if (link_usettings == NULL)
 			link_usettings = do_ioctl_gset(ctx);
 		if (link_usettings == NULL) {
-- 
2.25.1

