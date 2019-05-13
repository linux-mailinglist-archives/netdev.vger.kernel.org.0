Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C67E51BC96
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732239AbfEMSD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 14:03:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45022 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbfEMSD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 14:03:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id z16so7142760pgv.11;
        Mon, 13 May 2019 11:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ntNFmfAba/mtS6B9QOAxkZnKC/SuijUpSJOLnJWUe5A=;
        b=gIf/diVYLQfpHWD0bPwsMkLoCo/1aSXhQgBUgpK9jlngeTA1XXV5av+aM4OaFB/UWe
         eRWGg9nFUKJp/afRbt6nwQCcMxEmkYgQFhmqHSm5Ciu+Kky2GEDIwVZmWs8O9TwP3/3K
         Gw817R2tmS/YwyQDdqXGcMBWRW0WjAkF9/fGq44woj+ScRnsd3LPtFDKFOiqf2LQNNkE
         tj14cqoVEv3yKvXaopgQ5hwrLCS4ejGojQX0dAT1CI8ji7WG5BdyUezJTLGuqwAJX7Kq
         2RtRU5Lp0+yvKa5+25g6rR0qndigsOp1eQ9vIeNvG5JVRe8PUiz89iyOYrFKMgCbxfIZ
         8trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ntNFmfAba/mtS6B9QOAxkZnKC/SuijUpSJOLnJWUe5A=;
        b=kH1mZe6pnuUWd6x0RzTGn5y6eaBg+hBk15ecQ8N/lWFyxUAJzFJ3TG/Ii1ZZKn+pe7
         RRDuZHk/MRYtVV6//fNLHUG0KCgqK72DSIsFKkdKjxiVRtPj9PIUj69sKxwbHybfENSG
         /zatbhTbS6u02yV8daU1/JclRxPVPFPy9H6Yk89cboboDJjETpU8Q6EACuRTfv5zHVh+
         5WZRd572+nKaQHDL4cx6QRxcUbhAm8vP93fhiqZu3ASFZEsJ2HtfplhB0UShWDZhXgu2
         wtolyvaRanCnYQ6eo+mhLnVMSS1Vz2E9g3c3YBqBIZJPuysNnAIqKqoCGEbAFv7iKpYs
         tjdg==
X-Gm-Message-State: APjAAAW5/sUo5nCKt5dO4nXdRpvm/ED4OmygN8JyDCpRPMzg36TNtgUI
        kxN+gkb3fC6fd9xOETljuZs79rnebBClFg==
X-Google-Smtp-Source: APXvYqzjeQclPcaH8//c6qT10PD1AHbrExP8TVeAi7n4n7gf1ut02OR69C+9hxoCIbog8za5Wzt7nA==
X-Received: by 2002:a65:448b:: with SMTP id l11mr32453167pgq.185.1557770637532;
        Mon, 13 May 2019 11:03:57 -0700 (PDT)
Received: from localhost.localdomain ([122.179.175.43])
        by smtp.googlemail.com with ESMTPSA id z6sm1076096pfr.135.2019.05.13.11.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 11:03:56 -0700 (PDT)
From:   Jagdish Motwani <j.k.motwani@gmail.com>
To:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     j.k.motwani@gmail.com,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] netfilter: nf_queue:fix reinject verdict handling
Date:   Mon, 13 May 2019 23:32:25 +0530
Message-Id: <20190513180225.5186-1-j.k.motwani@gmail.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However, if it
again receives a NF_QUEUE verdict (by some other netfilter hook), it queues the
packet with a wrong hook_index. So, when the second queue reinjects the packet,
it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
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

