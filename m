Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344943F1BAC
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbhHSOff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238547AbhHSOfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 10:35:31 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F428C061575;
        Thu, 19 Aug 2021 07:34:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso4932357pjb.1;
        Thu, 19 Aug 2021 07:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iIZPqJjZjKDPhOPHiCG06zMlA2AMWMzeg+mvcemafrg=;
        b=jrW35CUdbNF1lRcJDNtkkP4ZhPd7/6lWV7dSTvSt1/qkSFLT5bhxTaPQPKaQnGvMtk
         za1s7Z23Npmwfg4PjUStgnlw4yah96uwvu/mMimp8TqnsrJ172kyAs6bxskyQ7gUHRyi
         2I5QTkHYTG/5SSIm1Zwyktz/bIymUcnmB40pIHYpAfQAhVW30MeTjbJxD/UfCcnFDUIT
         /UF/KMrRQOa55JmSmxsuCgYlTZWKgFY7ark4ZyV+yeuAk2JX+4LXQTSW5Izf/wnY+pjV
         1MulBwDG+N+Hm5fas5vVtsmZaF/xxcwox8JeC8QPaMhLqntvTArpCnGY+aqkvqvJ4GSZ
         bHPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iIZPqJjZjKDPhOPHiCG06zMlA2AMWMzeg+mvcemafrg=;
        b=fWQLEY2PnxbUpnqXUV2FY3PIJGs3+LOY3lIsnnemoqD+o34mX36jgs/bQJs5+TLE0m
         ztCxWcPL/qyRdk7SusypQ2bz3RzLQ1JAl7pY0XBLJo0foFehAEuU+WtUTSgOMuKpy1mX
         RgypGGnR+Uyqyaji5JX8anunKdWpGP5ULSYxVIc0W5sxGQDwvq9gclVKyOOnPHn6zDB9
         lxXs9iazbCbr4k80xtryn66UG6jrmd73c2BJk/na7Tc1gcvbe8bl43TbgSE4pVeaKLI0
         AuZLZvoDx64av6uuVpmJWC8RqN9mvHFMzSpwDRlscU4ZBlOEs6zLOUmE/fR4RRMZYTPe
         u8zQ==
X-Gm-Message-State: AOAM5329c1oLAGWka9MeB9jfgfFhFSCcuGn05o3Hm5uIhAqrw8Gu5Yi8
        LMEzZWESyBHecrjIe4oHj1JWZAP0xHRfdmZo
X-Google-Smtp-Source: ABdhPJzLbYI2vth8zZTIG4VuTWiEYHMcVXdqqGYSM9YpUq4iM+lWiSA5vOg5Xlo9zch6VQpAyzw7UQ==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr15153317pjw.0.1629383694761;
        Thu, 19 Aug 2021 07:34:54 -0700 (PDT)
Received: from fedora.. ([2405:201:6008:6ce2:9fb0:9db:90a4:39e2])
        by smtp.googlemail.com with ESMTPSA id t5sm3843080pfd.133.2021.08.19.07.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 07:34:54 -0700 (PDT)
From:   Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: [PATCH] ip_gre/ip6_gre: add check for invalid csum_start
Date:   Thu, 19 Aug 2021 20:04:47 +0530
Message-Id: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we get a ip gre packet with TUNNEL_CSUM set, an invalid csum_start
value causes skb->csum_start offset to be less than the offset for
skb->data after we pull the ip header from the packet during the
ipgre_xmit call.

This patch adds a sanity check to gre_handle_offloads, which checks the
validity of skb->csum_start after we have pulled the ip header from the
packet in the ipgre_xmit call.

Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
---
 net/ipv4/ip_gre.c  | 2 ++
 net/ipv6/ip6_gre.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 12dca0c85f3c..95419b7adf5c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,6 +473,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index bc224f917bbd..7a5e90e09363 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -629,6 +629,8 @@ static int gre_rcv(struct sk_buff *skb)
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb,
 					csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
-- 
2.31.1

