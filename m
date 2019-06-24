Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D8551E08
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfFXWOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:14:50 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41933 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXWOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:14:49 -0400
Received: by mail-ed1-f66.google.com with SMTP id p15so23902504eds.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x4+rpoOW+R7APWuWBhJuh8MoLkBsDMPtItA5+c/ZNQM=;
        b=jRQPWvbeZChpGDYQX0iJlY0obaitrU/+I3Yrl3PWgPwXioPDUQEMO0uEhViH9cdqm5
         Ko0neGIOe7NDuEnNd2sWyTqxbNEWUth9UnPx73U49rQB8aSmE4BXaTxDHjnGtEhsN5z7
         GwhFLxVg9NnCfdadEjs3kYDVHjYPaUre5vUjFPgB/W2uVrUjooEQ4ywCh1ww4nm5e2T5
         g8f+Xi7+RkI1NkKrKJrWydVCmYos3MCVvV6VgFyimCBpgPCSaXROKYdlt9BLyWtsb9SR
         lXB9XT9gA7l9lVvWMneapaWix54Y8TaYzfNn04fwt4nGPfxGUQ0qHZA3fcED4WjCkQGv
         cKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x4+rpoOW+R7APWuWBhJuh8MoLkBsDMPtItA5+c/ZNQM=;
        b=aT1Oa4yXHukfCPJGCbLywO1SAnu28P57z8ZQYPyQ5+MGTL2Gd02P3x9mNBNzeDQ46n
         AHOYEQhao+OgR9d3c9W3grLNulxJrGoK+CUj5Cph/LQmacgXkwHaNMvogc6758VtI9fl
         KnGVZgdIkdh5y2vXMCfa41x+2p9SH1eQ60T6+iP62hSlX2WItQARiQmUrlzhiYAbzZCg
         5SoglB4N9muFaLQsf9RlDTkDegxmieB8lxPZWzvGVCiQqN3Z5zc1lSJOyOxeNpNb/QPf
         /wbpuWgSxtKBH5l7JTPKUFPmL9UusCOMdud8wN6xxF3cUl7jaqmLbQs/Rjskkn0Gr+x5
         0+EQ==
X-Gm-Message-State: APjAAAVRRNXSKvUs60G+hvly4MpcSpBE/++2Dl1HLxHdxbaK09tAIVnv
        1CCuViyVcD+YFlAI4jNG4QuWpUxxtjI=
X-Google-Smtp-Source: APXvYqw01kfQ5boAJrUuPPL0ncL52Iu38rwrUhWz+cQFv3lFvCkOY3rd7cCRVnAekNRtu80pIXNiOw==
X-Received: by 2002:a17:906:6055:: with SMTP id p21mr58545489ejj.35.1561414487785;
        Mon, 24 Jun 2019 15:14:47 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id y3sm4046025edr.27.2019.06.24.15.14.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Jun 2019 15:14:47 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/2] net: sched: protect against stack overflow in TC act_mirred
Date:   Mon, 24 Jun 2019 23:13:36 +0100
Message-Id: <1561414416-29732-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
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
index 8c1d736..c3fce36 100644
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

