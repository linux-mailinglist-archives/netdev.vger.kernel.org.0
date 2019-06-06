Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04EFA37481
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfFFMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:50:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:47024 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfFFMuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 08:50:19 -0400
Received: by mail-ed1-f66.google.com with SMTP id h10so3129216edi.13
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 05:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=djZr00Rg8wSgNNwodtSVSFuu7dTmAN2hve7Qa44iXiU=;
        b=JYOg/o60oE7CbW3H+kqmlaZg46QHFiR/QWvhAScn3goIGJY1693MVDC+yfN0yYdqxr
         e5sNWUBNNZ9rre2CdTprJ4cZK3na3Od+xxTxCAfUuFpikQaSfJ1y83y3NOF4IgNBq4Of
         V56Q8Bo2TpuEvh2yK5swNzydxej7eK/OunVydCqUkh85m/9FuMkSrapH+rASGOXLhu+Z
         0YNPcwoy7/3SA5HFgXPBDDeiREOtAvPM7+kOwDAZsoa7HjcNGRtPd5EfZM4iamkDGHI/
         SOYWJLfRCyXW76uOxqKXmPXjKUi7mpiA1UR0Ahhi+tiG+nOGpxPZURf83P6lAb51VXb2
         EmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=djZr00Rg8wSgNNwodtSVSFuu7dTmAN2hve7Qa44iXiU=;
        b=Zsp/R2quZtKDCa7OPJb9gTZE07YoDWsJP5a7ZIC4jRisI2wnPun5zZTDAdz73DECSm
         DPxpe85WqAFwcStmX1KNAjQpI4T4X7XQueJUdSsmAuEoMnAPn2LxmzCRWDsYdcrw9Yy1
         njBFckaj7Ms7EaursVB5oHLcZXdCnocoZS4d6OU2v3ACpd52UO4FgP7eCA1WMesrFf/J
         0eNA7k7KpY0fNOkuED1uRlU2WdUD7JQWsuYq6xeXwqNl/xY0YvLRsT19scuiNjOCRXBx
         I4QPFpWj6dJUhYbzyFrSyip+VVZuYX7rQhIa8FbV6aSd/dHzTEOEN0wFvPobQxzh8i+5
         k9Lg==
X-Gm-Message-State: APjAAAVVk/rgL34zRC+a/Doq4SIMnLaLTwbqLSevcY3xtkEsNlyLtL67
        qY74sQ8MFziiajSUsNaAcGfywqlOGxI=
X-Google-Smtp-Source: APXvYqzqDbCyOpetr9fZLDk1Ab49sRNYSOo4fUqZJVR1YAcDol0JqixTP2HEJwtA6r8Fl4q39xoYjA==
X-Received: by 2002:a50:fd15:: with SMTP id i21mr49033753eds.89.1559825416992;
        Thu, 06 Jun 2019 05:50:16 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id i3sm81127edk.9.2019.06.06.05.50.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 06 Jun 2019 05:50:16 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        jhs@mojatatu.com, fw@strlen.de, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next v2 1/1] net: sched: protect against loops in TC filter hooks
Date:   Thu,  6 Jun 2019 13:49:34 +0100
Message-Id: <1559825374-32117-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
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
between multiple hooks. This can lead to stack overflow panics among other
things.

Previous versions of the kernel (<4.2) had a TTL count in the tc_verd skb
member that protected against loops. This was removed and the tc_verd
variable replaced by bit fields.

Extend the TC fields in the skb with an additional 2 bits to store the TC
hop count. This should use existing allocated memory in the skb.

Add the checking and setting of the new hop count to the act_mirred file
given that it is the source of the loops. This means that the code
additions are not in the main datapath.

v1->v2
- change from per cpu counter to per skb tracking (Jamal)
- move check/update from fast path to act_mirred (Daniel)

Signed-off-by: John Hurley <john.hurley@netronome.com>
---
 include/linux/skbuff.h | 2 ++
 net/sched/act_mirred.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2ee5e63..f0dbc5b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -645,6 +645,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_at_ingress: used within tc_classify to distinguish in/egress
  *	@tc_redirected: packet was redirected by a tc action
  *	@tc_from_ingress: if tc_redirected, tc_at_ingress at time of redirect
+ *	@tc_hop_count: hop counter to prevent packet loops
  *	@peeked: this packet has been seen already, so stats have been
  *		done for it, don't do them again
  *	@nf_trace: netfilter packet trace flag
@@ -827,6 +828,7 @@ struct sk_buff {
 	__u8			tc_at_ingress:1;
 	__u8			tc_redirected:1;
 	__u8			tc_from_ingress:1;
+	__u8			tc_hop_count:2;
 #endif
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index c329390..6cf7f90 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -29,6 +29,8 @@
 #include <linux/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_mirred.h>
 
+#define MAX_HOP_COUNT	3
+
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
@@ -222,6 +224,12 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	int m_eaction;
 	int mac_len;
 
+	if (unlikely(skb->tc_hop_count == MAX_HOP_COUNT)) {
+		net_warn_ratelimited("Packet at %s exceeded max TC hop count\n",
+				     netdev_name(skb->dev));
+		return TC_ACT_SHOT;
+	}
+
 	tcf_lastuse_update(&m->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
 
@@ -271,6 +279,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 	skb2->skb_iif = skb->dev->ifindex;
 	skb2->dev = dev;
+	skb2->tc_hop_count++;
 
 	/* mirror is always swallowed */
 	if (is_redirect) {
-- 
2.7.4

