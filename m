Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0845A2A1953
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgJaSPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:15:03 -0400
Received: from correo.us.es ([193.147.175.20]:48040 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbgJaSOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:14:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7DB27B567
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA9E1DA793
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9FB76DA78C; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FF9EDA704;
        Sat, 31 Oct 2020 19:14:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 19:14:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4B8CC42EF42B;
        Sat, 31 Oct 2020 19:14:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net 5/5] netfilter: ipset: Update byte and packet counters regardless of whether they match
Date:   Sat, 31 Oct 2020 19:14:37 +0100
Message-Id: <20201031181437.12472-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201031181437.12472-1-pablo@netfilter.org>
References: <20201031181437.12472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

In ip_set_match_extensions(), for sets with counters, we take care of
updating counters themselves by calling ip_set_update_counter(), and of
checking if the given comparison and values match, by calling
ip_set_match_counter() if needed.

However, if a given comparison on counters doesn't match the configured
values, that doesn't mean the set entry itself isn't matching.

This fix restores the behaviour we had before commit 4750005a85f7
("netfilter: ipset: Fix "don't update counters" mode when counters used
at the matching"), without reintroducing the issue fixed there: back
then, mtype_data_match() first updated counters in any case, and then
took care of matching on counters.

Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
ip_set_update_counter() will anyway skip counter updates if desired.

The issue observed is illustrated by this reproducer:

  ipset create c hash:ip counters
  ipset add c 192.0.2.1
  iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

if we now send packets from 192.0.2.1, bytes and packets counters
for the entry as shown by 'ipset list' are always zero, and, no
matter how many bytes we send, the rule will never match, because
counters themselves are not updated.

Reported-by: Mithil Mhatre <mmhatre@redhat.com>
Fixes: 4750005a85f7 ("netfilter: ipset: Fix "don't update counters" mode when counters used at the matching")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6f35832f0de3..7cff6e5e7445 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -637,13 +637,14 @@ ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set)) {
 		struct ip_set_counter *counter = ext_counter(data, set);
 
+		ip_set_update_counter(counter, ext, flags);
+
 		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
 		    !(ip_set_match_counter(ip_set_get_packets(counter),
 				mext->packets, mext->packets_op) &&
 		      ip_set_match_counter(ip_set_get_bytes(counter),
 				mext->bytes, mext->bytes_op)))
 			return false;
-		ip_set_update_counter(counter, ext, flags);
 	}
 	if (SET_WITH_SKBINFO(set))
 		ip_set_get_skbinfo(ext_skbinfo(data, set),
-- 
2.20.1

