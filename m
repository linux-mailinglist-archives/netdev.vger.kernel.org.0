Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079022D0B61
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 08:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgLGH4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 02:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgLGH43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 02:56:29 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F25EC0613D0
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 23:55:49 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id hk16so6961107pjb.4
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 23:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oAioQ6dTxjmVKPdqlT3FIFzHsyhGqpzcvzZAXbUUcmg=;
        b=P+N7c1NhPH0fwxkiFMKjoa32aJbvanluG4yuYorspL5hy9ji57g+lIDeOUJauQikQ9
         CdXy+jLU3XRdbdt3ToaNucr1SryCdmeM69AdEE18mYq7piIaR1eDwrWsS7kODzxaDPQz
         KC1Dnxvymfvuf5uJKMDSEWjE2K1N8uJCvnk8EpV2TKpAFepfVZNXjiV/4eGgaGnM4eyx
         BPKQ2JP7yhb0shzi/MWrUwPHELHWnCvaQxiU+ONXYNolMHSEWujvWJ9M+b/cN5Z4w0+B
         HJKA1qNpC92Ufaw7b4RXEcSs+SvBJXWznIgyekKvpmV/YS2h7XUKCT3tGKA5GuddVTY+
         RbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oAioQ6dTxjmVKPdqlT3FIFzHsyhGqpzcvzZAXbUUcmg=;
        b=uhoO5O+EwqNG9CmYYOLxBb4BLNtbJUkqbU2hAYVCTnn9V+vaW8BgRKPr2fxBM15Dn8
         yokom/i3VLzCMmLtcJDWouNC/zY5zZMRAeo1hCRDsWL6bYp6vAxf2e9S/8ifCLIhkNNd
         gI7OqOIoPL8uIn9m8lAWnYdd9WaK7knwb3Vb9ETgiJ45APPUG8mxOmRa7uygaMep5Mb1
         7g1lS1KaSILelxKnVU93peDZqSSzsl3+FPs6HbndCWgHP21DVtdLvIAK62l7VNeRzWfe
         zYERzHlaCSWXEXW5YkrlfHs4ZkVND8a2JyBP7VQmNp8HurYVXgTt6Tx0HjQa/WrkzPGM
         DsyQ==
X-Gm-Message-State: AOAM530Cd42OJwsZIs/ME6AOUyqhG7vlywjod949cBdqgbqfQCWYB7EX
        /Bh/EyyQceGey+xlEOKpFhmI3Xdrz6p8mw==
X-Google-Smtp-Source: ABdhPJxDytA5eOiRPvHsExZRWTRwRoHz2DuvEkSWZa0d5N8P7z3gTdf+e3Yzbk293H/2ehsqzmG+Pw==
X-Received: by 2002:a17:90a:a108:: with SMTP id s8mr3411584pjp.206.1607327748867;
        Sun, 06 Dec 2020 23:55:48 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o2sm12303410pgq.63.2020.12.06.23.55.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Dec 2020 23:55:48 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net] udp: fix the proto value passed to ip_protocol_deliver_rcu for the segments
Date:   Mon,  7 Dec 2020 15:55:40 +0800
Message-Id: <f8ad5904d273443f4c52ce4895f6d08d0f2ed18e.1607327740.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume noticed that: for segments udp_queue_rcv_one_skb() returns the
proto, and it should pass "ret" unmodified to ip_protocol_deliver_rcu().
Otherwize, with a negtive value passed, it will underflow inet_protos.

This can be reproduced with IPIP FOU:

  # ip fou add port 5555 ipproto 4
  # ethtool -K eth1 rx-gro-list on

Fixes: cf329aa42b66 ("udp: cope with UDP GRO packet misdirection")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..9eeebd4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2173,7 +2173,7 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		__skb_pull(skb, skb_transport_offset(skb));
 		ret = udp_queue_rcv_one_skb(sk, skb);
 		if (ret > 0)
-			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, -ret);
+			ip_protocol_deliver_rcu(dev_net(skb->dev), skb, ret);
 	}
 	return 0;
 }
-- 
2.1.0

