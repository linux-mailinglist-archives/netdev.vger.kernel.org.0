Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72693D8C4A
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 12:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236075AbhG1Kz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 06:55:26 -0400
Received: from m15113.mail.126.com ([220.181.15.113]:51581 "EHLO
        m15113.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhG1KzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 06:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=2PFzgfjcY3uTE1yPG9
        WCfCRS+p3+UpTzgxogbw7XsIc=; b=MAkkbuu8dFs9aTEKLwwg0sKBQ3Tzb+k/7T
        BxhB8A0jIoD+PQcu52lJLk2pbNvJ6PM7uTF0/YSjYxN6xH+BOKVF4T+w0FhCBJUf
        gOPkcmDfLyZPXeZeNXR+hJnDEp1xZzICpd3qjiARkEuljzhi0nkcsz1lr2QyHghl
        SZRUqWtAE=
Received: from localhost.localdomain (unknown [221.221.159.150])
        by smtp3 (Coremail) with SMTP id DcmowABXDoNnNwFhQ07ZTQ--.17643S4;
        Wed, 28 Jul 2021 18:54:33 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        krzysztof.kozlowski@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] net: let flow have same hash in two directions
Date:   Wed, 28 Jul 2021 18:54:18 +0800
Message-Id: <20210728105418.7379-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DcmowABXDoNnNwFhQ07ZTQ--.17643S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF4xAFWDuw43Ar4rKFykKrg_yoW8ZFyfpr
        WfAF12g3y8ur15WrsrJrs29w17KFZ5Z3yfWa4fuw1FkFsxuFnxWF1akrZ8Gan8ur1jya4U
        GrW8Jry5C3Z2vrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UKkskUUUUU=
X-Originating-IP: [221.221.159.150]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi2Qnd-lpECAxCLwAAsE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

using same source and destination ip/port for flow hash calculation
within the two directions.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/core/flow_dissector.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3ed7c98a9..dfc18f212 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1504,7 +1504,7 @@ __be32 flow_get_u32_dst(const struct flow_keys *flow)
 }
 EXPORT_SYMBOL(flow_get_u32_dst);
 
-/* Sort the source and destination IP (and the ports if the IP are the same),
+/* Sort the source and destination IP and the ports,
  * to have consistent hash within the two directions
  */
 static inline void __flow_hash_consistentify(struct flow_keys *keys)
@@ -1515,11 +1515,11 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		addr_diff = (__force u32)keys->addrs.v4addrs.dst -
 			    (__force u32)keys->addrs.v4addrs.src;
-		if ((addr_diff < 0) ||
-		    (addr_diff == 0 &&
-		     ((__force u16)keys->ports.dst <
-		      (__force u16)keys->ports.src))) {
+		if (addr_diff < 0)
 			swap(keys->addrs.v4addrs.src, keys->addrs.v4addrs.dst);
+
+		if ((__force u16)keys->ports.dst <
+		    (__force u16)keys->ports.src) {
 			swap(keys->ports.src, keys->ports.dst);
 		}
 		break;
@@ -1527,13 +1527,13 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 		addr_diff = memcmp(&keys->addrs.v6addrs.dst,
 				   &keys->addrs.v6addrs.src,
 				   sizeof(keys->addrs.v6addrs.dst));
-		if ((addr_diff < 0) ||
-		    (addr_diff == 0 &&
-		     ((__force u16)keys->ports.dst <
-		      (__force u16)keys->ports.src))) {
+		if (addr_diff < 0) {
 			for (i = 0; i < 4; i++)
 				swap(keys->addrs.v6addrs.src.s6_addr32[i],
 				     keys->addrs.v6addrs.dst.s6_addr32[i]);
+		}
+		if ((__force u16)keys->ports.dst <
+		    (__force u16)keys->ports.src) {
 			swap(keys->ports.src, keys->ports.dst);
 		}
 		break;
-- 
2.17.1

