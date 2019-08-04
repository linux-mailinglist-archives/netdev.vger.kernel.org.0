Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9144E80B5D
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfHDPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37979 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDPK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so49384270wmj.3
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3SGrb+RQF9ki5vYBnH9UJLtaJKTkIWuOgwt/Nyd92Z4=;
        b=kPUfZU9ErkmJfal6Q7iC9f8qz/8DOjdpNTTQD7R/o52+9R+GX102SJDh+m2mh0oSyj
         4w/IUU87gW2PcZaiOsDlqOvU+uIlNzVQzpnoVsxccoQ9ZEdFRExB0Hma3EzSeCkLgXLs
         ayH3CRtAHwpc7EeYgKkyPLfVdeOD88Ecs8woACgjnEJOFqje0czyFmNwqoqJa7jBSK6N
         fedUMFoK5zdv5Fr0omRIj5K2Vlagl4wnmNd9XNsEaKKZXg5bTHiMNNO45fFCMUqytLrl
         wooEIU6PaiWqNB+aIBivp8bKDukU9uCJGFO97kX0HaGtPa8TEbi3/f39b96ud8IL/OiQ
         iY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3SGrb+RQF9ki5vYBnH9UJLtaJKTkIWuOgwt/Nyd92Z4=;
        b=qSmlpfSK/40APYKzm1+cq8l3onxqGRH31GspgRYJtU7IFLSHhuNgwYGhDxL3Df6muV
         /A+I3eTPPqUGcWJ5PvGUr9nAWLoYEk5GRyRLfotQcJ4Ar7eYhNPZCSn+IKUSmhbuFQoV
         UH0e2VR/Hr9WR0D3X5nHS/TYV6aq1pAEu++jEztAzPoPDMuFcExB8nhdyJURTiYhtHCV
         sQ/bJoGVd96RXtG7P7P1q2Dut1Xq/Ym63KC2APszAJXyNo9eopELmIjIpsr8jf1oHi5k
         RBNUjRH7K67xQK6k+5QnVIMTLU3TepGmDrlDf4M1UMgsMEkDAl4I4RsGfJUEBnJVeep9
         AVgA==
X-Gm-Message-State: APjAAAXIp0euEeTtQBgAWl+7Ds5pGAgdcOjuF8NsgCnovoAvvD00RAvn
        t23CyhcTIG2zUcZSTYHa/m0/fMuB6JE=
X-Google-Smtp-Source: APXvYqxtyFwjOY5I01pBJZAv+B9mZHK4d2ylpN6Zi2l7xDBssF1MraLy9/tG+x5NvERAmxS8NEJ2Sg==
X-Received: by 2002:a1c:a6d3:: with SMTP id p202mr14558665wme.26.1564931424930;
        Sun, 04 Aug 2019 08:10:24 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:24 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 01/10] net: tc_act: add skbedit_ptype helper functions
Date:   Sun,  4 Aug 2019 16:09:03 +0100
Message-Id: <1564931351-1036-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc_act header file contains an inline function that checks if an
action is changing the skb mark of a packet and a further function to
extract the mark.

Add similar functions to check for and get skbedit actions that modify
the packet type of the skb.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tc_act/tc_skbedit.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index 4c04e29..b22a1f6 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -54,4 +54,31 @@ static inline u32 tcf_skbedit_mark(const struct tc_action *a)
 	return mark;
 }
 
+/* Return true iff action is ptype */
+static inline bool is_tcf_skbedit_ptype(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	u32 flags;
+
+	if (a->ops && a->ops->id == TCA_ID_SKBEDIT) {
+		rcu_read_lock();
+		flags = rcu_dereference(to_skbedit(a)->params)->flags;
+		rcu_read_unlock();
+		return flags == SKBEDIT_F_PTYPE;
+	}
+#endif
+	return false;
+}
+
+static inline u32 tcf_skbedit_ptype(const struct tc_action *a)
+{
+	u16 ptype;
+
+	rcu_read_lock();
+	ptype = rcu_dereference(to_skbedit(a)->params)->ptype;
+	rcu_read_unlock();
+
+	return ptype;
+}
+
 #endif /* __NET_TC_SKBEDIT_H */
-- 
2.7.4

