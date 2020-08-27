Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC33E2542C1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgH0Jur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:50:47 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:58843 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0Jur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1272; q=dns/txt; s=iport;
  t=1598521846; x=1599731446;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FEjUCww3X4VyfbXQTIh1F+d9DewinySBfeJRQxjDkOs=;
  b=e+rnP18I15Xnu5OVVnw3lDcy0PnL75NbQpD4ju4XvGEn9E4HfiZWyCQx
   H8BfDTE2ozSTDyo+znj9XQ9wJ5qjMkUfpd9OhWkmdrzG/oAG5eo+JFozB
   cGEjUu7V7dsCZ6ufIViwxVZrKAkTy28IW/Bo6sJzNhbUKBlyiOm6oNhow
   c=;
X-IronPort-AV: E=Sophos;i="5.76,359,1592870400"; 
   d="scan'208";a="29104720"
Received: from aer-iport-nat.cisco.com (HELO aer-core-2.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 27 Aug 2020 09:50:45 +0000
Received: from hce-anki.rd.cisco.com ([10.47.78.120])
        by aer-core-2.cisco.com (8.15.2/8.15.2) with ESMTP id 07R9oisp012939;
        Thu, 27 Aug 2020 09:50:45 GMT
From:   Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
To:     netdev@vger.kernel.org
Cc:     Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [v2] ioctl: only memset non-NULL link settings
Date:   Thu, 27 Aug 2020 11:50:33 +0200
Message-Id: <20200827095033.3265848-1-hegtvedt@cisco.com>
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
kernel') a regression slipped in. If we have a kernel that does not
support the ETHTOOL_xLINKSETTINGS API, then the do_ioctl_glinksettings()
function will return a NULL pointer.

Hence before memset'ing the pointer to zero we must first check it is
valid, as NULL return is perfectly fine when running on old kernels.

Fixes: bef780467fa7 ("ioctl: do not pass transceiver value back to kernel")
Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
---
 ethtool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index e32a93b..606af3e 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -3048,10 +3048,11 @@ static int do_sset(struct cmd_context *ctx)
 		struct ethtool_link_usettings *link_usettings;
 
 		link_usettings = do_ioctl_glinksettings(ctx);
-		memset(&link_usettings->deprecated, 0,
-		       sizeof(link_usettings->deprecated));
 		if (link_usettings == NULL)
 			link_usettings = do_ioctl_gset(ctx);
+		else
+			memset(&link_usettings->deprecated, 0,
+			       sizeof(link_usettings->deprecated));
 		if (link_usettings == NULL) {
 			perror("Cannot get current device settings");
 			err = -1;
-- 
2.25.1

