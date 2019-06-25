Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9D452040
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfFYBKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:10:43 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39635 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbfFYBKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 21:10:43 -0400
Received: by mail-oi1-f194.google.com with SMTP id m202so11239772oig.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 18:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tgOW4kxcRohAWBj4VB1Rlu5IbcfPhlueHKTa/ifHjF8=;
        b=c0uX5iUGu0/v2TaG6x9VjlxOGqov2m0iG1MgUJycCXssJsRyOM8LcCkLK2IP7RsIPd
         FOKVf69sznx2qUuY1zUH7C4jn1a00g7A5BFaMGmF67BwpzZfiw6eDT73SJsMKjRlExnk
         v6lrH0LGSt2a4dvGh2Zc/hrjfp8SxOY3nxrXvwyGQg4ub92HF1woT9Egp30SANLJHxI1
         kRXlf2IotnzSH72/BsEa/Thf1Ai5zDTWVe6ter0FJJHbGpkmVGEhVfwl84z5DWJDzMfS
         Zmai++44f/RycEW4epukeJL04Mbdmz3iddoGhVKJEvULxZDsyF3WzkCsWfSIe4qd2JxQ
         e4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tgOW4kxcRohAWBj4VB1Rlu5IbcfPhlueHKTa/ifHjF8=;
        b=CyXyO4cGuNGv2l4C/xFu9tzdyW7/mmtpOU/7lC2Z5CvuJoGVZb1T8DKUeKsBXIozIw
         yLZwSyCpQ8JQcdzbHtghYuSeAmzK6iEg07/B76ZxGN26DvQhtWvukWMekJRmoeqrKpjF
         D618h4rNOsFdYMsyd4Jl77Z1H7yegUWvMJHbICpBJcXLDNJ6azdNfZtvbbB9e7OSRJ83
         +u6VZOoAxKquBSXctJ931VB5bmTYbcRXGA+0n6vLp+g1CyXgncnuTj6CXS4Ck5MCaiCs
         5qwSWn/FFvSmxTejKbYspxQ2iVYQ/FvAcnyoORnAnZ65lKTRBfHcdhKRsMaWN/TmD4ss
         3uXg==
X-Gm-Message-State: APjAAAVfLMIyMCN1AEEl+i97ys29oNxfaU67PLfRrjoo/rbm0m8324Rz
        seEmSm8UwIrb6LRgrJqVgB21sPRsRg==
X-Google-Smtp-Source: APXvYqwh/AZKjlxo4SbTMIXwqIn9OVuJ+1Ov0D4Tzy9RvZBcKrYGuwo1j/MiiIMmQ6EaiPuVO3jyEg==
X-Received: by 2002:aca:be88:: with SMTP id o130mr197850oif.122.1561425042682;
        Mon, 24 Jun 2019 18:10:42 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id u16sm4601760otk.46.2019.06.24.18.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 18:10:42 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while loop
Date:   Mon, 24 Jun 2019 20:14:06 -0400
Message-Id: <20190625001406.6437-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 19e4e768064a8 ("ipv4: Fix raw socket lookup for local
traffic"), the dif argument to __raw_v4_lookup() is coming from the
returned value of inet_iif() but the change was done only for the first
lookup. Subsequent lookups in the while loop still use skb->dev->ifIndex.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 0b8e06ca75d6..40a6abbc9cf6 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -197,7 +197,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 		}
 		sk = __raw_v4_lookup(net, sk_next(sk), iph->protocol,
 				     iph->saddr, iph->daddr,
-				     skb->dev->ifindex, sdif);
+				     dif, sdif);
 	}
 out:
 	read_unlock(&raw_v4_hashinfo.lock);
-- 
2.17.1

