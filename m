Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E3E454CE9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbhKQSTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:19:39 -0500
Received: from mta-13-4.privateemail.com ([198.54.127.109]:47381 "EHLO
        MTA-13-4.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbhKQSTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 13:19:39 -0500
X-Greylist: delayed 3611 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2021 13:19:39 EST
Received: from mta-13.privateemail.com (localhost [127.0.0.1])
        by mta-13.privateemail.com (Postfix) with ESMTP id 36EAA18000AC;
        Wed, 17 Nov 2021 13:16:40 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.217])
        by mta-13.privateemail.com (Postfix) with ESMTPA id 9797618000A5;
        Wed, 17 Nov 2021 13:16:37 -0500 (EST)
From:   Jordy Zomer <jordy@pwning.systems>
To:     linux-kernel@vger.kernel.org
Cc:     linux-hardening@vger.kernel.org,
        Jordy Zomer <jordy@pwning.systems>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] ipv6: check return value of ipv6_skip_exthdr
Date:   Wed, 17 Nov 2021 19:16:10 +0100
Message-Id: <20211117181610.2731938-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The offset value is used in pointer math on skb->data.
Since ipv6_skip_exthdr may return -1 the pointer to uh and th
may not point to the actual udp and tcp headers and potentially
overwrite other stuff. This is why I think this should be checked.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 net/ipv6/esp6.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061b8768..dc4251655df9 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -808,6 +808,11 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+
+		if (offset < 0)
+			err = -EINVAL;
+			goto out;
+
 		uh = (void *)(skb->data + offset);
 		th = (void *)(skb->data + offset);
 		hdr_len += offset;
-- 
2.27.0

