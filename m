Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13C8454DA2
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhKQTKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:10:10 -0500
Received: from mta-10-3.privateemail.com ([198.54.127.62]:58079 "EHLO
        MTA-10-3.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhKQTKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:10:07 -0500
Received: from mta-10.privateemail.com (localhost [127.0.0.1])
        by mta-10.privateemail.com (Postfix) with ESMTP id DE83218000A9;
        Wed, 17 Nov 2021 14:07:04 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.215])
        by mta-10.privateemail.com (Postfix) with ESMTPA id 840D718000A5;
        Wed, 17 Nov 2021 14:07:02 -0500 (EST)
From:   Jordy Zomer <jordy@pwning.systems>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] ipv6: check return value of ipv6_skip_exthdr
Date:   Wed, 17 Nov 2021 20:06:48 +0100
Message-Id: <20211117190648.2732560-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211117181610.2731938-1-jordy@pwning.systems>
References: <20211117181610.2731938-1-jordy@pwning.systems>
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

EDIT:  added {}'s, thanks Kees

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 net/ipv6/esp6.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061b8768..f0bac6f7ab6b 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -808,6 +808,12 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+
+		if (offset < 0) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		uh = (void *)(skb->data + offset);
 		th = (void *)(skb->data + offset);
 		hdr_len += offset;
-- 
2.27.0

