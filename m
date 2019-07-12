Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15C7B675CB
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 22:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfGLUSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 16:18:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33632 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGLUSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 16:18:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id c14so5268231plo.0
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 13:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuNqHHnUM0Aq+LVX3PCo7e2eIot410B/0PhTcXMZg6E=;
        b=G5OFTETG06n5GR5BAlKqGEGQwIXSzDzYkIDg6u71xDoeBYuI1rEtHqz039IhEULSBX
         oRNq47RhcrVtaHh76kod6C2VbTt0xjtt7a3fR0wgIJExBu1loj+dKt2OkQHsJBgTiNpW
         ksEPx+anqbFkxgus15+fcGGQBWCgs2Z5ipfu2z8c9PlMCmgnVcjuSN4vQM5xOw8aOI75
         nBkqwuX+2zVazRfzlAvyCjPYNQuSaYJo9NXXcLWj5XnOFW9hhPuKNu31XBaXJvE4fv4Z
         PvKTXj82zXz7mjhP9L9CNsI4/Ecz05edXyWiJzVtbJDx2ex5LxKK8hpPzBdmbYPEwHIA
         fpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuNqHHnUM0Aq+LVX3PCo7e2eIot410B/0PhTcXMZg6E=;
        b=h2O8OrSleuWsJRTYvqxrMQ5gvJt9wQ8/t76GPq75ocl3M4YqycSs+pKeiFn2S2oqxX
         wilV6sUMeMWHp7evCHlIN0tZ3cT58WkWNHc43kZ1x5M94nHB1emyVQJE53OVUERSRyct
         aD3R/Ho4K6dASFK6kjvWqZXbw/hGXyZv+IfFJAkJ0AwGrCnRwm4/PoE+H2NaAutaI2gg
         6TceGaIq9Ujlq6726d7KkTm+FBEL+1HJaIcZMAIQpj1B0yVrJ9bbPlteHWRTH7yTjREW
         4WdJsDJCpqZrftDRt51uSKaU9Ard7xonHs4xmlCwvJN/fKGez6UCx+0RfOkBqI4KLahF
         ISZw==
X-Gm-Message-State: APjAAAXFh3n5QJetl3waXm8FsZYmq5UxIO2KPN6km8h09z6PAJcvP5De
        K6TtXlNMiAMfxVeIEuC+M+WdNKEceY4=
X-Google-Smtp-Source: APXvYqy3Azovn1gk3X/afB/+FsqBnKQrh56ZwKzRfmti9FZ0qAh4H5230zl8l76nShQtiknmQ88kAA==
X-Received: by 2002:a17:902:d892:: with SMTP id b18mr12917960plz.165.1562962694439;
        Fri, 12 Jul 2019 13:18:14 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id q4sm8883630pjq.27.2019.07.12.13.18.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 13:18:13 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
Date:   Fri, 12 Jul 2019 13:17:48 -0700
Message-Id: <20190712201749.28421-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
notably fq_codel, it makes no sense to let packets bypass the TC
filters we setup in any scenario, otherwise our packets steering
policy could not be enforced.

This can be easily reproduced with the following script:

 ip li add dev dummy0 type dummy
 ifconfig dummy0 up
 tc qd add dev dummy0 root fq_codel
 tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
 tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
 ping -I dummy0 192.168.112.1

Without this patch, packets are sent directly to dummy0 without
hitting any of the filters. With this patch, packets are redirected
to loopback as expected.

This fix is not perfect, it only unsets the flag but does not set it back
because we have to save the information somewhere in the qdisc if we
really want that.

Fixes: 4b549a2ef4be ("fq_codel: Fair Queue Codel AQM")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 638c1bc1ea1b..5c800b0c810b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2152,6 +2152,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false, rtnl_held);
 		tfilter_put(tp, fh);
+		q->flags &= ~TCQ_F_CAN_BYPASS;
 	}
 
 errout:
-- 
2.21.0

