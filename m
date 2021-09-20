Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9A34112C7
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 12:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhITKU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 06:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbhITKUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 06:20:52 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956AC061574
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:26 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id p4so40673776qki.3
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 03:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mpa9RboK8bSXJaugfzTpZs6uSVX02G6AQbuiFVw65i0=;
        b=p4S2pZji7kwcdFfVR3tYr0I2WxlJINDDmreE/dbHG4QUMqALhbb0EeetYzxjDSSU1j
         v824Qv4TO1lf3q3Jo/5YlSw4iMSJebb1uZHq/2coOquyWYapLogjgGRT8haQA7+jnRKp
         BRzTvRh1kawV21yQiwKkRV3hU04GaJDSKG75qolNSZrqs8kF8wzYe4PveIHtA0ojerdn
         kkqW90NpEMTNOQYYCDtXI+/9qlPcIxhTnkyWrUpmKYQe3EPgkhrZit9kRSB/rokQjbPR
         mzr9aAfeZb1eAIm+eegnpFaR7Gi2rrJcej4G1lPSX6MkVv6JJ8rPMZ/zAarEx485nLkf
         kW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mpa9RboK8bSXJaugfzTpZs6uSVX02G6AQbuiFVw65i0=;
        b=V8vKav6znVSIr/nIJ3xKZBUS+axhdgaU1MH2bynDx7wS6m81bZ3TVJdAmKLGGCqtHA
         UjVR0ZexhkYhfEn32ny6F6OSvEh5Y1AdpMT0oyYwpuyW3qDdbx6f3vHHzW/KjKe1AhcL
         T30iyKZxVbsfLdWoCSxJwrmNxjkK1hstaxwVi16mcO51zJudRptxHee77S5n9NwpPGg/
         uHn96a7cRC3BtLuc95+FoVuzon0NgpwPrRsw1nKLAgSL5wkjKsxoRNKBGUxTb/PjLNPt
         JUhvijdztJ7BpQnNp+8cIjEIL3VTLu1C9MtAmslnwV26unF1H2kQvGgVxHiqN7f50NGV
         oXIA==
X-Gm-Message-State: AOAM530/Jebar92/yGfrS/xzb7H5EuT4qcv36Ouj4EKCZ9LSPlp/iv9/
        Ji4Oc46oY5x/zZR3rqEkhosHPksxmC/OSw==
X-Google-Smtp-Source: ABdhPJzxiEJhm9z/AIx0iyg1KZUOr+ka48F25GTPGhwG7R1zUqtfK1p5rnSDz36n4hKSZ0duVOTdqQ==
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr23649890qkj.194.1632133165326;
        Mon, 20 Sep 2021 03:19:25 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u9sm4637985qke.91.2021.09.20.03.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 03:19:24 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 2/2] net: sched: also drop dst for the packets toward ingress in act_mirred
Date:   Mon, 20 Sep 2021 06:19:22 -0400
Message-Id: <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1632133123.git.lucien.xin@gmail.com>
References: <cover.1632133123.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without dropping dst, the packets sent from local mirred/redirected
to ingress will may still use the old dst. ip_rcv() will drop it as
the old dst is for output and its .input is dst_discard.

This patch is to fix by also dropping dst for those packets that are
mirred or redirected to ingress in act_mirred.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_mirred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 46dff1f1e7c8..5e30b3e64b63 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -19,6 +19,7 @@
 #include <linux/if_arp.h>
 #include <net/net_namespace.h>
 #include <net/netlink.h>
+#include <net/dst.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <linux/tc_act/tc_mirred.h>
@@ -209,6 +210,7 @@ static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 		return tcf_dev_queue_xmit(skb, dev_queue_xmit);
 
 	nf_reset_ct(skb);
+	skb_dst_drop(skb);
 
 	return netif_receive_skb(skb);
 }
-- 
2.27.0

