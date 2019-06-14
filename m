Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A830B460E2
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfFNOeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:34:13 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37409 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbfFNOeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:34:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so3829975eds.4
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o/p/eyyiOteZi+gTCEBMN7ZyAuGUWOn78GJfRqRj/9k=;
        b=MNlRDeHhQEj0xlOKviZbI7mOdn4ZkiEvAX96Dux2tdXXx/SOi2tJl7hcFCLSlx0al2
         QNm1tAMOSL0r3zOcSsk+0XDEKo2jh2O6HpXo3C6KL47VNjt/fo/uQmWlFMurjzpFI8e8
         Fovp4B14PRwpaE+aZbeT9ppjza/WBpm8ce6RO8q/gNEnyR5sHIrpuXN/U/TtvZKeJPQ+
         joIvkscoAVIAnu5u8epmHhpb80iN3zw6T5+WKO4orFJ8gyBpbC4J7i4jTdDAh5KW1DUo
         Ss3BHVkPBZpWJLHXl0pDjL5vQu/WQl5PTEnq0hN18NB7wYhqcUca2g/H2P170+7fBOdd
         A6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o/p/eyyiOteZi+gTCEBMN7ZyAuGUWOn78GJfRqRj/9k=;
        b=avcnzmr4YEUa0K6yhLgKnRKwDq3q3HYeBFxCjWiC3xRrHiElH4QL9hTQC9CmYL9JMN
         H9LkuSpjcuYhrpppSe4OEC3tw2M2m7/ya33YVRj9OXW5yjmR0v9e7erLa9a4IID/nexY
         bnwzDxUVDUx1Lg8+rNkuIG0pMj0dWIDpzk3RUIYuSZ/RmBH3N3ez2LalbLHHaXXFDy+X
         IV6kENHk7Cnz5GndGSQzU+oaOxJloXFlVqpFa+ziifoyv4tlgDLaWXqiWZrs+vgQF31C
         Y3578AodihgPYAsc/tTu7Hl3krDvUIjCb/is3ocQ2S/AuEXlV//2YOePMZSaft6X5QgA
         pMKQ==
X-Gm-Message-State: APjAAAUm8YJJWcGjm9sRXxBkxKL8LrHUFtTOLKku5axsiLY2+GHkWMZC
        yCOd/iy+PI8a7fAGFdFoURiaEXiQC9o=
X-Google-Smtp-Source: APXvYqxO5kDD0I85UTgp/CrkKqCGzh62n178ULJz3si8YyvoGUlf9SniixG5ZeixN0HGuk0zW9icFQ==
X-Received: by 2002:a17:906:6dc3:: with SMTP id j3mr33427495ejt.258.1560522850255;
        Fri, 14 Jun 2019 07:34:10 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id r11sm350971ejr.57.2019.06.14.07.34.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 07:34:09 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 2/2] net: sched: protect against stack overflow in TC act_mirred
Date:   Fri, 14 Jun 2019 15:33:51 +0100
Message-Id: <1560522831-23952-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC hooks allow the application of filters and actions to packets at both
ingress and egress of the network stack. It is possible, with poor
configuration, that this can produce loops whereby an ingress hook calls
a mirred egress action that has an egress hook that redirects back to
the first ingress etc. The TC core classifier protects against loops when
doing reclassifies but there is no protection against a packet looping
between multiple hooks and recursively calling act_mirred. This can lead
to stack overflow panics.

Add a per CPU counter to act_mirred that is incremented for each recursive
call of the action function when processing a packet. If a limit is passed
then the packet is dropped and CPU counter reset.

Note that this patch does not protect against loops in TC datapaths. Its
aim is to prevent stack overflow kernel panics that can be a consequence
of such loops.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/sched/act_mirred.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 8c1d736..766fae0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -27,6 +27,9 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
+#define MIRRED_RECURSION_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+
 static bool tcf_mirred_is_act_redirect(int action)
 {
 	return action == TCA_EGRESS_REDIR || action == TCA_INGRESS_REDIR;
@@ -210,6 +213,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
+	unsigned int rec_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -217,6 +221,14 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	int m_eaction;
 	int mac_len;
 
+	rec_level = __this_cpu_inc_return(mirred_rec_level);
+	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
+				     netdev_name(skb->dev));
+		__this_cpu_dec(mirred_rec_level);
+		return TC_ACT_SHOT;
+	}
+
 	tcf_lastuse_update(&m->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
 
@@ -278,6 +290,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			res->ingress = want_ingress;
 			res->qstats = this_cpu_ptr(m->common.cpu_qstats);
 			skb_tc_reinsert(skb, res);
+			__this_cpu_dec(mirred_rec_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -293,6 +306,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
+	__this_cpu_dec(mirred_rec_level);
 
 	return retval;
 }
-- 
2.7.4

