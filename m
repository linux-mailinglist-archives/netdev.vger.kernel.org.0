Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 556BC16033
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEGJLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:11:42 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43222 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfEGJLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:11:42 -0400
Received: by mail-pl1-f193.google.com with SMTP id n8so7860102plp.10
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wh9ypKnL8/scQYcQ6MC4LXnpWFh7pzdbyGjn7ivKvx8=;
        b=D+Ma3+6S5UkoN0DtYJje8C5V8slfRYq+TlqLVQph+pxe1GtUiyX+suX60Djben7tsY
         6x+9kmNNiLGXdg7XYZOEEcYbvlIYbaxiUQBN0YSw8n+FZa8KJJfnpgnvC0A7bVRF9vh+
         cTSYZw59t++YOPZxeJP+03yqvMG/AF/F/o4Tgk98f85agHusZWv2x2hfG1ivBzeBJXsn
         AerA/hUc7OLUPrcrOWXd985icZkjzhl1YUDbgFPGb+/Ren0OAwcFN4/IR6FKpJLtuC4N
         XJI7m4c+UUoDSLvFZrESwlpf2iIX4mBnIsO/oze9Mmj7vaOIvhu2lepM1fWuLBDpGuxk
         kwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wh9ypKnL8/scQYcQ6MC4LXnpWFh7pzdbyGjn7ivKvx8=;
        b=jda8TrnauvCIq4ko0btCyknIPp/2CFrbKi8y5gBUCSszZEiWbcjg+ZZP3nIpwYM2d/
         o1qXJps0VhMPfgjs76wlWZmjtT6SWIIwAWPMG7FLodgQlIn0sYjoaWLf8PHivpAkli+W
         nRn8VX5/BFTUjFtTe7yR+gOBSzyaDOIvXsgpEqxQd5Oydn8WhyZNo0Gb8KVkOm9hV/BY
         rtMXEfeN1/Uf2E7E2gvInIe41IBi/nFb8Qb8T/3pz8JqpZ/5BWovkMNkDhNi1zri7Zx/
         AdsEIx9X3XHLs/Yf55L/3u9RuiLbTtHF0yxK9s81TcWMIm4AeFPCX1aLEt7bVEwZzEQa
         A0yA==
X-Gm-Message-State: APjAAAXIZ3XuL4lp8OemkM1GNV90Lip86ZWUxp8OLoY8gmmUhzWqsrzP
        cRshm5zYljs0sVSl6nEh0ht7zARndW8=
X-Google-Smtp-Source: APXvYqxpXNNV2sbP3N6qx6G7WAY2AsXltVjDMcwZ5oFYrnoaiFyPZs1fmISqRFtppG1kLxCCfFSfKA==
X-Received: by 2002:a17:902:7294:: with SMTP id d20mr32421517pll.276.1557220301355;
        Tue, 07 May 2019 02:11:41 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i12sm19468547pgb.61.2019.05.07.02.11.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 02:11:40 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Mateusz Bajorski <mateusz.bajorski@nokia.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] fib_rules: return 0 directly if an exactly same rule exists when NLM_F_EXCL not supplied
Date:   Tue,  7 May 2019 17:11:18 +0800
Message-Id: <20190507091118.24324-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to
fib_nl_newrule") we now able to check if a rule already exists. But this
only works with iproute2. For other tools like libnl, NetworkManager,
it still could add duplicate rules with only NLM_F_CREATE flag, like

[localhost ~ ]# ip rule
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default
100000: from 192.168.7.5 lookup 5
100000: from 192.168.7.5 lookup 5

As it doesn't make sense to create two duplicate rules, let's just return
0 if the rule exists.

Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
Reported-by: Thomas Haller <thaller@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/core/fib_rules.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index ffbb827723a2..c49b752ea7eb 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -756,9 +756,9 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		goto errout;
 
-	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
-	    rule_exists(ops, frh, tb, rule)) {
-		err = -EEXIST;
+	if (rule_exists(ops, frh, tb, rule)) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			err = -EEXIST;
 		goto errout_free;
 	}
 
-- 
2.19.2

