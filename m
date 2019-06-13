Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9CB43B7E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbfFMP3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:29:50 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39976 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbfFMLWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:22:10 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so16033863eds.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+TYH9AuU2SZ+4j5J2brlsdnwkOAHeCTzyD37V4g/EOU=;
        b=jBELFzRDkjpttrcFxsvtgpydesQvgFI7Ilt9Sfsm8l7EwaQBanynIQHrhMapxunttL
         SJ7P9bkMIRBBI56t0Vpk8s6nagjrlQpB08+QEeo3HFdavhyiW0yEMElLXUMVrljmJyTU
         a3ikUiN8CbM2yMSBsXSutTnrntQ8poDXLZ3AU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+TYH9AuU2SZ+4j5J2brlsdnwkOAHeCTzyD37V4g/EOU=;
        b=qCgse+IMNzqXVT4OMel0yd2oMTbS7I+bHNL9hNM9n6I9UNW//ABZbQiAYSauif9XYg
         oKmpBb8UxD/8fesHgYMC4tRiHqy1qtB/AbPOUp6hpnTuHdHslZ7TG/ZWNPjwTv1JsuiN
         WtcNsWLdBsm9BjBXRndMCQCpjuMMuVRrRU//1OC74f+4xPhfPYD5NPKpOkH8BDdKwMH2
         bMdDMyKiCpLKEDCODB10b/iB5uCG/NC11s84pGM2MVvKHxx+vuV+8IAfFumA7NO7Osg8
         zc25nD/hk8WI0YPechBN3L5ix9vcoQnxUmQWkn5OLkE40wql5cM2K0zigNd5AMea3uAM
         ESFA==
X-Gm-Message-State: APjAAAVgziVJMYYImnYYXOe6OiZQAH2LKmY04rEvAnhjLrVWhjJqouaB
        yi+zEw+vy0cjDGcMihofGjvnVg==
X-Google-Smtp-Source: APXvYqxP2gQ9X+P4ONzL9YVXdw1OFK1MFXI2vZYT62PG7ilbYw/cq10p2SbSqd/DWF7casHhPEx27A==
X-Received: by 2002:a50:b803:: with SMTP id j3mr27797253ede.208.1560424928714;
        Thu, 13 Jun 2019 04:22:08 -0700 (PDT)
Received: from localhost.localdomain ([62.214.5.194])
        by smtp.gmail.com with ESMTPSA id u26sm777908edf.91.2019.06.13.04.22.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 04:22:07 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     mkubecek@suse.cz
Cc:     dcaratti@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, johannes@sipsolutions.net,
        john.hurley@netronome.com, ldir@darbyshire-bryant.me.uk,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        paulb@mellanox.com, toke@redhat.com
Subject: [RFC PATCH net-next] sched: act_ctinfo: use extack error reporting
Date:   Thu, 13 Jun 2019 13:18:52 +0200
Message-Id: <20190613111851.55795-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190612191859.GJ31797@unicorn.suse.cz>
References: <20190612191859.GJ31797@unicorn.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use extack error reporting mechanism in addition to returning -EINVAL

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 net/sched/act_ctinfo.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index e78b60e47c0f..a7d3679d7e2e 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -165,15 +165,20 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	u8 dscpmaskshift;
 	int ret = 0, err;
 
-	if (!nla)
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "ctinfo requires attributes to be passed");
 		return -EINVAL;
+	}
 
-	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
+	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, extack);
 	if (err < 0)
 		return err;
 
-	if (!tb[TCA_CTINFO_ACT])
+	if (!tb[TCA_CTINFO_ACT]) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Missing required TCA_CTINFO_ACT attribute");
 		return -EINVAL;
+	}
 	actparm = nla_data(tb[TCA_CTINFO_ACT]);
 
 	/* do some basic validation here before dynamically allocating things */
@@ -182,13 +187,21 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 		dscpmask = nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_MASK]);
 		/* need contiguous 6 bit mask */
 		dscpmaskshift = dscpmask ? __ffs(dscpmask) : 0;
-		if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f)
+		if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_CTINFO_PARMS_DSCP_MASK],
+					    "dscp mask must be 6 contiguous bits");
 			return -EINVAL;
+		}
 		dscpstatemask = tb[TCA_CTINFO_PARMS_DSCP_STATEMASK] ?
 			nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) : 0;
 		/* mask & statemask must not overlap */
-		if (dscpmask & dscpstatemask)
+		if (dscpmask & dscpstatemask) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_CTINFO_PARMS_DSCP_STATEMASK],
+					    "dscp statemask must not overlap dscp mask");
 			return -EINVAL;
+		}
 	}
 
 	/* done the validation:now to the actual action allocation */
-- 
2.20.1 (Apple Git-117)

