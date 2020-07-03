Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BE21406B
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 22:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgGCUnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 16:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCUnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 16:43:12 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1812C061794
        for <netdev@vger.kernel.org>; Fri,  3 Jul 2020 13:43:12 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id g13so24734640qtv.8
        for <netdev@vger.kernel.org>; Fri, 03 Jul 2020 13:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5mGeV2+BvRVDgVyeJWIBIMmrz5adbrBYpjs8tjUxYg=;
        b=u7w1Ggt3vsXwQmTysqqWk8bbdsZ/ZNRUetPPUYlX8+U56fsf1cLxW29tJakvzeFHQu
         QeFucnl31ksg5wTiIWw0q8YaJei8RhTca8CxEsY4qCpTaVIiF3J2RmfmZTDmXE13g4LB
         Ft6dtdpeW0GR/JSRWYaBpmh8df65o4UIx7GH1PjZlGEkRQKvjLQeycPd6o/vuXBd2w5V
         ry3iRJls9WcmOmg75H5PyOMjrmhnNbaei3r7OS5Oe2B2uo6Lqw7yiusnhYpvd5RTG8g/
         M98KWWuxvBjqfmDDFiEKc94qJzP5REQq785VVK5AG52e6o8OIgmV5PV7rHeU+COiZx0o
         xMqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k5mGeV2+BvRVDgVyeJWIBIMmrz5adbrBYpjs8tjUxYg=;
        b=OPXohlmbMefQjJ5ITZGvKjTwobNK4x1Js1phM3I7P3wsTKdHXJnJcrdxOEPc/igsri
         /dhQ0WoZeh4aF2DeQ71Qlrfx825vSUeolNkhtU9P8rPI5JNXghfj6WFpQUom7sBYTqIb
         OGyxj7iACb2d77ikHi31NkJgJRFrm86Qsx5xCKoWGYwoXtCPeB0vmbh4h3iardmd0SDI
         qhy6cntCK4l5mnb/g1ffoifly/42yPUT3l+bPQwcgd+0uo1YofZIpAbIcsYr6m9xgWN4
         E7WlePN91DL+wBSvDXDy1yCX9laiW7Bpd6XQQ9oiywayEicEHfR+EdH1Mh3zNBonQ8p6
         XBhg==
X-Gm-Message-State: AOAM533X4SS10a8MhNvF66fC2mBn0yAPyouYvICuXpDZhr7IqweY3Vqm
        +V3rFu6yqX8d17yZHF77Lc50GT//
X-Google-Smtp-Source: ABdhPJyRj+JN9epYT4k08NzvwLRQWM7vj1gRWjbenlRqCnAKBKiR5GJ8QP8okcIBs+rB59nHCecIdQ==
X-Received: by 2002:ac8:1667:: with SMTP id x36mr26630285qtk.344.1593808991248;
        Fri, 03 Jul 2020 13:43:11 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id n2sm11942785qtp.45.2020.07.03.13.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 13:43:10 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] ipv6/ping: set skb->mark on icmpv6 sockets
Date:   Fri,  3 Jul 2020 16:43:08 -0400
Message-Id: <20200703204308.3372523-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

IPv6 ping sockets route based on fwmark, but do not yet set skb->mark.
Add this. IPv4 ping sockets also do both.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/ping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 98ac32b49d8c..6caa062f68e7 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -114,6 +114,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
 	ipcm6_init_sk(&ipc6, np);
+	ipc6.sockc.mark = sk->sk_mark;
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
 	dst = ip6_sk_dst_lookup_flow(sk, &fl6, daddr, false);
-- 
2.27.0.212.ge8ba1cc988-goog

