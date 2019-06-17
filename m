Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB948D6D
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfFQTF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:05:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34984 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfFQTF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:05:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so6186413pfd.2
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YnCb3pKFcjJQDWfuu4zZ4IPAqdP8bDj70tQarrqJA4E=;
        b=A4X/KhXA7O5XTHuY6NfApDEsClzY9VLycFoj+ighBJrb+Bt694nnq+36B/8JuZa4NF
         Kom2/gAYRcGqoiOyePIQcIgNPOLRMzlzsFb4hOPHoDsAGJR9rSJOdvpsR1bwSCgsq8mL
         oDqOpKOvGsTrxnmb8gabRYqod4AIDAhsdJ7jg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YnCb3pKFcjJQDWfuu4zZ4IPAqdP8bDj70tQarrqJA4E=;
        b=RW8gEi5QEKs61h7c44fmEsLo9aua6N/+/8iIk1l/7i4a0vj4vOgCIDxzg8dC2umxOt
         32x0ShX9YQRX9ZEczwygKBUp2+pM3o3mpeZ4ZRcksNXEd3RqQ4fP3XdpewCx/8Gm/x14
         pRpDPpH5BSgxVp7F9tXiX8AejSIsJop+DzUx4zvne5QhPy6QDrMN6ORn6CtDYecHmjBE
         siQGw9Lolsj0F9At7cQIgXH7Y7SkJ/D/OmZM5z9SAco5O/2Qhu3AyOvxar7RJCohfOIz
         SEkU/L6PIqbfzm2r6dWpMeCAXAbNctaKmuW3bLUkPP52PIySsAna1nxZ9cW3grUxfSIk
         IMeg==
X-Gm-Message-State: APjAAAUaJHWPKf+e0C7zd7gCLWAm4msxMwv3Ju0aQHeAE/+soUbDPrgB
        4Ee1qqij6V6H37I5Xsm1XOXyIg==
X-Google-Smtp-Source: APXvYqyfGNVM3XuLS06e9v7G9O4NGlFdS+43bjHE9rkWn//VId1KvzFuE1PdRbwS03I5cQfwI7Y3EQ==
X-Received: by 2002:a62:e515:: with SMTP id n21mr48498381pff.186.1560798325712;
        Mon, 17 Jun 2019 12:05:25 -0700 (PDT)
Received: from linux-net-fred.jaalam.net ([2001:4958:15a0:24:5054:ff:fecb:7a95])
        by smtp.googlemail.com with ESMTPSA id l63sm13042616pfl.181.2019.06.17.12.05.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 12:05:24 -0700 (PDT)
From:   Fred Klassen <fklassen@appneta.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Cc:     Fred Klassen <fklassen@appneta.com>
Subject: [PATCH net v4] net/udp_gso: Allow TX timestamp with UDP GSO
Date:   Mon, 17 Jun 2019 12:05:07 -0700
Message-Id: <20190617190507.12730-1-fklassen@appneta.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes an issue where TX Timestamps are not arriving on the error queue
when UDP_SEGMENT CMSG type is combined with CMSG type SO_TIMESTAMPING.
This can be illustrated with an updated updgso_bench_tx program which
includes the '-T' option to test for this condition. It also introduces
the '-P' option which will call poll() before reading the error queue.

    ./udpgso_bench_tx -4ucTPv -S 1472 -l2 -D 172.16.120.18
    poll timeout
    udp tx:      0 MB/s        1 calls/s      1 msg/s

The "poll timeout" message above indicates that TX timestamp never
arrived.

This patch preserves tx_flags for the first UDP GSO segment. Only the
first segment is timestamped, even though in some cases there may be
benefital in timestamping both the first and last segment.

Factors in deciding on first segment timestamp only:

- Timestamping both first and last segmented is not feasible. Hardware
can only have one outstanding TS request at a time.

- Timestamping last segment may under report network latency of the
previous segments. Even though the doorbell is suppressed, the ring
producer counter has been incremented.

- Timestamping the first segment has the upside in that it reports
timestamps from the application's view, e.g. RTT.

- Timestamping the first segment has the downside that it may
underreport tx host network latency. It appears that we have to pick
one or the other. And possibly follow-up with a config flag to choose
behavior.

v2: Remove tests as noted by Willem de Bruijn <willemb@google.com>
    Moving tests from net to net-next

v3: Update only relevant tx_flag bits as per
    Willem de Bruijn <willemb@google.com>

v4: Update comments and commit message as per
    Willem de Bruijn <willemb@google.com>

Fixes: ee80d1ebe5ba ("udp: add udp gso")
Signed-off-by: Fred Klassen <fklassen@appneta.com>
---
 net/ipv4/udp_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 06b3e2c1fcdc..9763464a75d7 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -224,6 +224,11 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	seg = segs;
 	uh = udp_hdr(seg);
 
+	/* preserve TX timestamp flags and TS key for first segment */
+	skb_shinfo(seg)->tskey = skb_shinfo(gso_skb)->tskey;
+	skb_shinfo(seg)->tx_flags |=
+			(skb_shinfo(gso_skb)->tx_flags & SKBTX_ANY_TSTAMP);
+
 	/* compute checksum adjustment based on old length versus new */
 	newlen = htons(sizeof(*uh) + mss);
 	check = csum16_add(csum16_sub(uh->check, uh->len), newlen);
-- 
2.11.0

