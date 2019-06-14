Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1A34584C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfFNJL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:11:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35362 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfFNJL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:11:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id m3so1711661wrv.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bVhW79bBYyLp9fWIKsquilnXhLd+Mu1VilLxjgv+L8o=;
        b=YEjQ/4Es98jOhpWfobUhZrVHNfDE+Tr5fkQrA/EP8K03COpfIZcjOFVbbJ/8F5XAXI
         tY8A6FIeeaxzNvv8rsUyg/+xWD/aODdVFavKBSywE9Ff82vIrv9/AqaVKTVF4ctYJHzd
         nI45bX2WGKOPj2aZ2nTTvu9Yn6DyskLzGhxQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=bVhW79bBYyLp9fWIKsquilnXhLd+Mu1VilLxjgv+L8o=;
        b=P5WlbDMRNwB6B6K4W1qZhKmotQs3enPUvfny/UBUID2/xa4MlKOUO1d5KVMSj+6eDZ
         zvDjPQ6ndXwqkXyZ1rhzE/iEBs+fDdcAB6+jMJUrFbPqm9/LKe5FAuZazSicCQTSnvPM
         HxJUneHQL1gqSOo2IcWAxelOXHKHj1yvg4knUdkxXY5BdREU+Ey/tCAbeic9TBNJynXF
         sDkvQG1Irnt9YxVHTP6qvvCkIkOBIWs/NU1yVsiRtOwzqHbNubPrnEVkKx/ZBT4seu/l
         jlhFfOYxuL1wU3YgU5J/vU0IHC8E+4UWb5GobKpyV7uyPTVaUIFm4qiCkBD+EqkrGC4L
         SASg==
X-Gm-Message-State: APjAAAW8UoJrwiWBPXJEY6YnopHNt2ZRJ6DcRMy7+PTpwfkOLgPEGOeC
        nKlmjyqtYBvbym9YY/6/aD0ykQ==
X-Google-Smtp-Source: APXvYqyMMRgGqQSRd8Zk29pACspG/x6EQYVU/KxNcewU+cwhZJNZ70Ts/qHAX6byPSl3j/N5sIIAxQ==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr37926487wrt.343.1560503486146;
        Fri, 14 Jun 2019 02:11:26 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id z14sm6279983wre.96.2019.06.14.02.11.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:11:24 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     marcelo.leitner@gmail.com
Cc:     dcaratti@redhat.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        john.hurley@netronome.com, ldir@darbyshire-bryant.me.uk,
        mkubecek@suse.cz, netdev@vger.kernel.org, paulb@mellanox.com,
        simon.horman@netronome.com, toke@redhat.com
Subject: [PATCH net-next] sched: act_ctinfo: use extack error reporting
Date:   Fri, 14 Jun 2019 10:09:44 +0100
Message-Id: <20190614090943.82245-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190613200849.GH3436@localhost.localdomain>
References: <20190613200849.GH3436@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use extack error reporting mechanism in addition to returning -EINVAL

NL_SET_ERR_* code shamelessy copy/paste/adjusted from act_pedit &
sch_cake and used as reference as to what I should have done in the
first place.

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

