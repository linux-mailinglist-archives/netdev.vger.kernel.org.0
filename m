Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74962351D84
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhDAS27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:28:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:54734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239248AbhDASZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:25:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617292708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=6UwfTNvzk/rBdwnem0QltuqdTNpaA3AX8aKjdt3iTOw=;
        b=AqFG8RYiTXzuDrwZ+qfWY8KvUs51zRT4tcXiCPsY4H6Fa9fADOEgmqcr3Wnw13rEA7Shtx
        1m5v9rnN0Av4ib7gqhTV7pWmyxLsU8S0zYYmNY9PeZC08hh1OqKJHPzKYvehsily3n5yfD
        U8aeEWeJAfQGx5FDf80Vi4HpZ3Zverg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3222CB176;
        Thu,  1 Apr 2021 15:58:28 +0000 (UTC)
From:   Otto Hollmann <otto.hollmann@suse.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Ahern <dsahern@kernel.org>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Otto Hollmann <otto.hollmann@suse.com>
Subject: [PATCH net-next] net: document a side effect of ip_local_reserved_ports
Date:   Thu,  1 Apr 2021 17:57:05 +0200
Message-Id: <20210401155704.35341-1-otto.hollmann@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    If there is overlapp between ip_local_port_range and ip_local_reserved_ports with a huge reserved block, it will affect probability of selecting ephemeral ports, see file net/ipv4/inet_hashtables.c:723

    int __inet_hash_connect(
    ...
            for (i = 0; i < remaining; i += 2, port += 2) {
                    if (unlikely(port >= high))
                            port -= remaining;
                    if (inet_is_local_reserved_port(net, port))
                            continue;

    E.g. if there is reserved block of 10000 ports, two ports right after this block will be 5000 more likely selected than others.
    If this was intended, we can/should add note into documentation as proposed in this commit, otherwise we should think about different solution. One option could be mapping table of continuous port ranges. Second option could be letting user to modify step (port+=2) in above loop, e.g. using new sysctl parameter.

Signed-off-by: Otto Hollmann <otto.hollmann@suse.com>
---
 Documentation/networking/ip-sysctl.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c7952ac5bd2f..74c458d2686a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1073,7 +1073,9 @@ ip_local_reserved_ports - list of comma separated ranges
 
 	although this is redundant. However such a setting is useful
 	if later the port range is changed to a value that will
-	include the reserved ports.
+	include the reserved ports. Also keep in mind, that overlapping
+	of these ranges may affect probability of selecting ephemeral
+	ports which are right after block of reserved ports.
 
 	Default: Empty
 
-- 
2.26.2

