Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844451D6B66
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgEQR0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgEQR0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 13:26:35 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C959720657;
        Sun, 17 May 2020 17:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589736395;
        bh=YtPS3xdaNP3lmaxTWpeU4j5R4wOBgiN3RyypdSlntpE=;
        h=From:To:Cc:Subject:Date:From;
        b=Dq8XDoaNnQslOuo4zoKj0MyRkOmHljQYLt73HUwtdCOGqh/DVaLPqT4EvRRff8j0a
         rVOkSk4kx+DNgVlvWNwpoxi/cbS3tI5OUa4OtI6/k0wcaXrvKbPxdyHufdyg+Lnh0w
         Zeu1ZYCZwF5tJZFTkYK9OSc+yl0FIJI/gpxdN01Y=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@gmail.com>,
        ASSOGBA Emery <assogba.emery@gmail.com>
Subject: [PATCH net] nexthop: Fix attribute checking for groups
Date:   Sun, 17 May 2020 11:26:32 -0600
Message-Id: <20200517172632.75013-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

For nexthop groups, attributes after NHA_GROUP_TYPE are invalid, but
nh_check_attr_group starts checking at NHA_GROUP. The group type defaults
to multipath and the NHA_GROUP_TYPE is currently optional so this has
slipped through so far. Fix the attribute checking to handle support of
new group types.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: ASSOGBA Emery <assogba.emery@gmail.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index fdfca534d094..2a31c4af845e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -433,7 +433,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 		if (!valid_group_nh(nh, len, extack))
 			return -EINVAL;
 	}
-	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
+	for (i = NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
 
-- 
2.21.1 (Apple Git-122.3)

