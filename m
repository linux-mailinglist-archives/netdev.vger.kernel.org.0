Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A450FCA43
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:51:24 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44944 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfKNPvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:51:24 -0500
Received: by mail-pf1-f193.google.com with SMTP id q26so4490530pfn.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MA+53mahoGl8KhUYSwJ0ekQMhhMNkVpkRAS9r6tNXO8=;
        b=NxOmhaFe22NCdX210hO4v4RpSrqDf14q/G8huEm3xkP+qyEllfMWy52RGOVNV5MbEP
         kDtv5c6tIau+sw3wS3UFSE06T9c8AjT2Mna4Ov1Qzk0ed5ZQTmvU5owRM/mc0CItb3Ge
         hD4c3I9ikA9c/hftu/NB98z04T/jkfVGNu3MbtPX8dOT3h+npSULwwWlD8To5gqLzn1j
         MhHELP9Quxg7tfPhUf+HOhakizcQwCv0hnfcf3B4ozG0ko38iEdzZWhC28kQb85AEcTF
         hYuTkySipx891WjLH5heqmpSxu2H4g7a7T95iDK+Bcy10/3w1cI3Bc5bMSHHNBe1IN6z
         HEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MA+53mahoGl8KhUYSwJ0ekQMhhMNkVpkRAS9r6tNXO8=;
        b=Krrp0m+EQk9hEh1oDyCAc41KwdM9dEFN5++jo4tnmsEuVJ8UFeucEjynj/Ip8GHnjL
         s/j8hAa2peoRB4Foo8MCYZpdIbhA39DdcYp3FmZlrM2YIXgJZvNvoU+cUikNq6tGlj2Q
         ib80rhYLlQsZ8qZDzxmxHPwTHoXNnWTDPr5hJG4yRViZIvwnL+HrQCUXs0SdplKprFnC
         uk6HJ7KtJJHkO6M6oOIO/jbnhW5hJJ/G8y8sQjj/3ecJQrDrL7hx6zvh6KV6rgavPKFK
         QT0FAEtLn+B7AkEufG/UOcjxbvj6WkilSayHxbuO/7kC7Zwmsv9Yuzlnhd/32+cFD60j
         fqpQ==
X-Gm-Message-State: APjAAAU7g/tN12UgNX1mIyRSCXxlKDF6rGvs4+QUv/13YDMqH7+y1Fhi
        Y0edvWe4P9U9aWd04P0x2s+NiW+z0kQ=
X-Google-Smtp-Source: APXvYqzrY1oL12EG0x6Hzknb34gwQIiReL4oHaq8opNYoK/d1Rofm4lNVgK0G62O7p5Hean5lc16sQ==
X-Received: by 2002:a17:90a:77c3:: with SMTP id e3mr13654866pjs.14.1573746681923;
        Thu, 14 Nov 2019 07:51:21 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([115.171.60.86])
        by smtp.gmail.com with ESMTPSA id c13sm6617409pfo.5.2019.11.14.07.51.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 07:51:21 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Joe Stringer <joe@ovn.org>, William Tu <u9012063@gmail.com>
Subject: [PATCH net-next] net: openvswitch: don't call pad_packet if not necessary
Date:   Thu, 14 Nov 2019 23:51:08 +0800
Message-Id: <1573746668-6920-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The nla_put_u16/nla_put_u32 makes sure that
*attrlen is align. The call tree is that:

nla_put_u16/nla_put_u32
  -> nla_put		attrlen = sizeof(u16) or sizeof(u32)
  -> __nla_put		attrlen
  -> __nla_reserve	attrlen
  -> skb_put(skb, nla_total_size(attrlen))

nla_total_size returns the total length of attribute
including padding.

Cc: Joe Stringer <joe@ovn.org>
Cc: William Tu <u9012063@gmail.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8ce1f773378d..93d4991ddc1f 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -487,23 +487,17 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	}
 
 	/* Add OVS_PACKET_ATTR_MRU */
-	if (upcall_info->mru) {
-		if (nla_put_u16(user_skb, OVS_PACKET_ATTR_MRU,
-				upcall_info->mru)) {
-			err = -ENOBUFS;
-			goto out;
-		}
-		pad_packet(dp, user_skb);
+	if (upcall_info->mru &&
+	    nla_put_u16(user_skb, OVS_PACKET_ATTR_MRU, upcall_info->mru)) {
+		err = -ENOBUFS;
+		goto out;
 	}
 
 	/* Add OVS_PACKET_ATTR_LEN when packet is truncated */
-	if (cutlen > 0) {
-		if (nla_put_u32(user_skb, OVS_PACKET_ATTR_LEN,
-				skb->len)) {
-			err = -ENOBUFS;
-			goto out;
-		}
-		pad_packet(dp, user_skb);
+	if (cutlen > 0 &&
+	    nla_put_u32(user_skb, OVS_PACKET_ATTR_LEN, skb->len)) {
+		err = -ENOBUFS;
+		goto out;
 	}
 
 	/* Add OVS_PACKET_ATTR_HASH */
-- 
2.23.0

