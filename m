Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30844841B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfFQNen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:34:43 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43679 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfFQNen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:34:43 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so5826661pgv.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XQB/IlK9ti/EW4b4Hw0cdZdjCUh7WjAf+/WozL9mkVE=;
        b=WkVdWgblhYbvoZu1FlFM1eHbjOLmSo1/UWbJxHaSHMjF05hRbctPuIbD7O0HG223b8
         E3cOKpJOGUyXDa5h8lnPkjsuQMZrmj08YES9PB5BLK6YlVFxHjDN/QF8Pxlgs6asi0We
         f2r6g/FXWUIfyX2TTW/tFqd3NaSyGLPyIfY5zNEnKrfViuRThl2mOfRJJq72kTEsGjyW
         4TwG1HZS+JmMPqEQ0K/jePicvkYJ7k9LI+VwmOqvoo+l3/3sn8UqMAuZq6BVEB5Y/EaH
         ylHsPJBtRBUhjR3tbd/otit5wrTOvctdsoP4adXpGEACX07UzTtF/MGQsomSSP52v1iM
         E3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XQB/IlK9ti/EW4b4Hw0cdZdjCUh7WjAf+/WozL9mkVE=;
        b=c2yNL/4zeXDoje6lpTf40zjRRWoiFeMDuY4rCmOhfwg5pXYWP8l0v4ZaOUsTtEiHcv
         fq2ox5+75sFBv9wvpVKIEFFZgRIaPxO7NBFTVB/XVBEUuYJC4LiyD+nLXJdX+tEV+ngr
         BLnXmNBq5CBkLsed45qT6Ybnt6XP0+YKf0+PdAHVZZZGv6iQra9v+Ec5VM75oO4otVp4
         mdF+C5g6jxPd6pli+qAnENeRRU+zUUdw2+kVbeTCCaFZGYHl5SCZLLy6jfAx3DK1flLn
         LULF2x43uOIf0nOYgTHMvMHmYjz1ybvPf1SjYbBoSwcRPFfwrbs/UfEii+jbBoDGcoso
         5Fyg==
X-Gm-Message-State: APjAAAWInOKxuKcmz6gphROA5lUDLKShtxgYymE4D8K7s5/atNrlVAxG
        WEVRlo7Q8sRNJhtvejNyQ5Mh2iRr
X-Google-Smtp-Source: APXvYqzcZWC6E7Dnr2qPM6/0Yo3PNIsK9F+pIgYQ3pRhRnRyWrKa4KZMVFbF5A4Md4cmuC9dzvIcHg==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr25990134pjj.7.1560778481825;
        Mon, 17 Jun 2019 06:34:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm11173394pgi.91.2019.06.17.06.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:34:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: [PATCH net 2/3] ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL
Date:   Mon, 17 Jun 2019 21:34:14 +0800
Message-Id: <92d40ac2577045f09a1d3ee79c7fed73fbdbde1a.1560778340.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <89113721df2e1ea6f2ea9ecffe4024588f224dc3.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
 <89113721df2e1ea6f2ea9ecffe4024588f224dc3.1560778340.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1560778340.git.lucien.xin@gmail.com>
References: <cover.1560778340.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A similar fix to Patch "ip_tunnel: allow not to count pkts on tstats by
setting skb's dev to NULL" is also needed by ip6_tunnel.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/ip6_tunnel.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
index 69b4bcf..028eaea 100644
--- a/include/net/ip6_tunnel.h
+++ b/include/net/ip6_tunnel.h
@@ -158,9 +158,12 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
 	memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 	pkt_len = skb->len - skb_inner_network_offset(skb);
 	err = ip6_local_out(dev_net(skb_dst(skb)->dev), sk, skb);
-	if (unlikely(net_xmit_eval(err)))
-		pkt_len = -1;
-	iptunnel_xmit_stats(dev, pkt_len);
+
+	if (dev) {
+		if (unlikely(net_xmit_eval(err)))
+			pkt_len = -1;
+		iptunnel_xmit_stats(dev, pkt_len);
+	}
 }
 #endif
 #endif
-- 
2.1.0

