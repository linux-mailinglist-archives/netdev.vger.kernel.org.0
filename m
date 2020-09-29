Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0D827CFE8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgI2NvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgI2NvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:51:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DFAC061755;
        Tue, 29 Sep 2020 06:51:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o25so3954911pgm.0;
        Tue, 29 Sep 2020 06:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=g1NOLKpd2hSWg3tMRG0Q+HZFXyCwBYbuga7haroPsDs=;
        b=XorZi2p5oIwFQmiJxYwTHsuPrZY4roo1m23TLllF0H+IQwrgPU2uh8A0+BoyNFCCf8
         gfwAKsgW2ALMP8/ie5f/9IeyWqotvnMPH95S7YPZRciuHi5aKQ2iuh8KLkfWsQFHdPsv
         YTq+sVCYUwqwajEPJbKR3WGtTg7MbnfzFsxZffpWFJ3nWHxYZC9jjlYZNBrIu6h3IC4t
         MiLKjdVQcLSm90RjOesxss28YBOE7q0JseB4tGb9keObWXbiMHDCQN8j2uXrM263kz8n
         CCtbE957keP9O/isoGv/SSIOnGprlVoC1GVKcm7DIwwR63rxD314hUTIHWrEWBadthhZ
         dttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=g1NOLKpd2hSWg3tMRG0Q+HZFXyCwBYbuga7haroPsDs=;
        b=r9lSkaITtbkSIOpN+r6ziYBM8hFXtO+Kxtk0djbVT/M3HuYFwOrcRvCoqSAXW8gIRa
         sWaldT7KQ7ABEhb697Ro+eopCmjGXU8KkTRcEnOP2Vp5cYxKJAYqzP1fXjJHDOfeNDyq
         kH03ElP08UVomvDPKrA9GZHhMNgZuZLnY0NnM7dosTDGKk2JRH8bT4IMxt+uWkwCAjij
         Z1QjcM3so1o4q0Q57SMzUxIIuMQeGOpRSDJpoiI/T4nbAixX9kBMeTp4Gv5A3YVKjtzM
         HoIlLI0Ox7C/amT6W1SUe6UdEWbk8mz5/5KNVmCGBWr4ohHjzuGBsO4Dvno2V8qXKGEp
         3wOA==
X-Gm-Message-State: AOAM530yXlFqs9aejoYA/rMRNlndE99fyDSQsNVeZTgM+1dmrmn79GbT
        sU5VnejSh9FOaBuvCeTD+NBhnfVt9Ow=
X-Google-Smtp-Source: ABdhPJxRK1bUg9FsFhuQdYcDUmMsf0epxcYJZnhAWuTh7MZ+zKLmPzB69SrRIrXt9UmloWqVss9bAQ==
X-Received: by 2002:a63:5916:: with SMTP id n22mr3227723pgb.375.1601387464002;
        Tue, 29 Sep 2020 06:51:04 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q10sm4946233pja.48.2020.09.29.06.51.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:51:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 12/15] sctp: call sk_setup_caps in sctp_packet_transmit instead
Date:   Tue, 29 Sep 2020 21:49:04 +0800
Message-Id: <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
Add GSO support"), as:

  "We have to refresh this in case we are xmiting to more than one
   transport at a time"

This actually happens in the loop of sctp_outq_flush_transports(),
and it shouldn't be gso related, so move it out of gso part and
before sctp_packet_pack().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf..fb16500 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -508,12 +508,6 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 					sizeof(struct inet6_skb_parm)));
 		skb_shinfo(head)->gso_segs = pkt_count;
 		skb_shinfo(head)->gso_size = GSO_BY_FRAGS;
-		rcu_read_lock();
-		if (skb_dst(head) != tp->dst) {
-			dst_hold(tp->dst);
-			sk_setup_caps(sk, tp->dst);
-		}
-		rcu_read_unlock();
 		goto chksum;
 	}
 
@@ -593,6 +587,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	}
 	skb_dst_set(head, dst);
 
+	rcu_read_lock();
+	if (__sk_dst_get(sk) != tp->dst) {
+		dst_hold(tp->dst);
+		sk_setup_caps(sk, tp->dst);
+	}
+	rcu_read_unlock();
+
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
-- 
2.1.0

