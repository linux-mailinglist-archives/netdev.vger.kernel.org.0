Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA617FE4
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfEHScM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 14:32:12 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37950 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbfEHScM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 14:32:12 -0400
Received: by mail-pg1-f195.google.com with SMTP id j26so10514040pgl.5;
        Wed, 08 May 2019 11:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qIetWDv4+uBIOVqkeb68fVDdokjhpaBl7wMXX9efLfc=;
        b=bP1jRGQHKHAyV8RCpsbv3stlScbSzAWrWTJNP5jDmYq/hi9ac3BG1MIW/LEiOVrHgc
         +AQw5EwKPlM+V1LPmo3q+tdS7LVvZ1yL06scRv+7eTqZkDFBHbeqJuBF3T0wGWBwjx60
         vAoU8qFRjxWIkw3lu8T6ByInNowUzibQCHSlc4eHwIPz8yX0q9Cn21PV97vAB08mg6up
         vAqpMeRyChIE59HTcJoFzayOEfR9YiEslvES1uJlQIbaYkZFxl1bXYNDdhxH/SmnOAzc
         6427yCcTvJmll1K5JST3q3JpprycZuXZ4mrLfNcjAu4sNpDdUyel0vtxE6XCi0DA0eWL
         XsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qIetWDv4+uBIOVqkeb68fVDdokjhpaBl7wMXX9efLfc=;
        b=VzPrsJrpiub8QthdI7rdHF4r1coR/jhc+u2hZViMauxvwC0DgHDRThBcNrDJ1OiudT
         1I+iLbfCAfiB+0cUQYHvhMjjJ5nLekH/ZzvXmWyZ75FcAQpP310Bfb/r4AYvH/dbRWZ0
         k/ecOPQkOUIRHssqbBAbwDD6PQ0nQ5OIktvVfOkN0IC3su6M87vikJb1iV9T1Qur/Faz
         0tFF59IkzP9KhDTei9xQBLUGldpLUjgY1ML5YOhzovphKcZAAuqew/ek8BgKkD70OqxY
         4LbDui1hezaPmk0Bp9J6MWnKz/PvIO1WcxuEeC82YwdR5EaFM8GO5R/FN/Tfj6IL3CX1
         autQ==
X-Gm-Message-State: APjAAAVXa5ZRia09n2fFc+UI6dg0MfW2eca2dDqzH7cql6JGOYoaZa17
        BvYYGCReD8w8b1bp0gNBnascgE3R52Fz2A==
X-Google-Smtp-Source: APXvYqzLucjYSQpwyBqCgLmkeo168GNWKZrn9juo302pblUlTwW1LeU7l306emrUEaRn5kCI4ZCW4Q==
X-Received: by 2002:a65:6496:: with SMTP id e22mr49157168pgv.249.1557340331223;
        Wed, 08 May 2019 11:32:11 -0700 (PDT)
Received: from localhost.localdomain ([122.170.180.197])
        by smtp.googlemail.com with ESMTPSA id 2sm12843903pgc.49.2019.05.08.11.32.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 11:32:10 -0700 (PDT)
From:   Jagdish Motwani <j.k.motwani@gmail.com>
To:     netdev@vger.kernel.org
Cc:     j.k.motwani@gmail.com,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: nf_queue:fix reinject verdict handling
Date:   Thu,  9 May 2019 00:01:14 +0530
Message-Id: <20190508183114.7507-1-j.k.motwani@gmail.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jagdish Motwani <jagdish.motwani@sophos.com>

In case of more than 1 nf_queues, hooks between them are being executed
more than once.

Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 9dc1d6e..b5b2be5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -255,6 +255,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.9.5

