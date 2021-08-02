Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC13DE105
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhHBUvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhHBUvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:51:53 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B59C06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 13:51:43 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x9so12584831qtw.13
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 13:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BqJSD4T0M737YOUIOc1rd3UBATj9S05HS7TXPJdFx5c=;
        b=jcaHEV1Yl4Svqrc+zHdWLfneB1HvNSpJHkFWR/QYhggWMFZXBhMb/wXoCzAdt2F5fF
         7zrHUHP2s1GTCPxccDv4jcfVQWJdphzNUKBMFRDsFp+lBHqWhu1ba3w1gZ5A4b9HxGX9
         2bXkPYgoGWksnFtedQ3ogrMvul1XbKQCupBby1r8sVDzJdJGnFppdQmz9JgB7Vmq9fAY
         O/UInuIeQYYuWLskpRYH7zpHzZeKgckPN8WT9qdHdoDWRFvOnKgrIUP/R/vmekOM0XSV
         Mc2ZZUvqn9ktdDa47Fy4vVERM5osH/0UkuaTfc9NGCKg/LfTcYySHKOKBH0O1fGVDXxf
         q1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BqJSD4T0M737YOUIOc1rd3UBATj9S05HS7TXPJdFx5c=;
        b=T9VxIXirjgxDWL6bi8QKpPsZ8Amhv9peF35xv+CCmYtldup2g7QMNp3t1Q9cacdvym
         ONmjh/pVOtfk6IqeZlc8agBU2Zr6WwAKVMytC4oCB1urgKdG3RjY5w/i8HWGeUfWnb5G
         N/s7uyPILhxFwOGfgWNEMJc967A3f6CcHUhTtiWLAsZ08DPBejUtQKoji5PfkkzddPMu
         XyaijNno1rfeaFfJFMjZ3izrLzpCIN+6QuSBRoisVwroqYx4u1cHENyoEdn0R5Wv9CDj
         yNeW5BtgjgHfc8nRXkl4bxJG6iQMoL+XGxEf+SpIXfwZgnRCMsCV9B5EuFkHvSGoMbiK
         kj2A==
X-Gm-Message-State: AOAM5333U9DGVQgPd1rct4ePyr9ZnvpcYALXUStRD0mLkLHNEGWspcPw
        HVMkn5mUdYclv7fOwajwg5UMns25sw==
X-Google-Smtp-Source: ABdhPJyNEpKxXO813T0VeIV1QMFKOrpMUDidTW7A26Tg6TQzJ0cY3Kpq4V05rTSqUGka/bdXQ8EGYw==
X-Received: by 2002:ac8:5456:: with SMTP id d22mr15988169qtq.316.1627937502837;
        Mon, 02 Aug 2021 13:51:42 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id n5sm6382134qkp.116.2021.08.02.13.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 13:51:42 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next] tc/ingress: Introduce clsact egress mini-Qdisc option
Date:   Mon,  2 Aug 2021 13:51:11 -0700
Message-Id: <20210802205111.8220-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721232053.39077-1-yepeilin.cs@gmail.com>
References: <20210721232053.39077-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

If the ingress Qdisc is in use, currently it is not possible to add
another clsact egress mini-Qdisc to the same device without taking down
the ingress Qdisc, since both sch_ingress and sch_clsact use the same
handle (0xFFFF0000).

To solve this issue, recently we added a new clsact egress mini-Qdisc
option for sch_ingress in the kernel.  Support it in the q_ingress front
end, and update the usage message accordingly.

To turn on the egress mini-Qdisc:

    $ tc qdisc add dev eth0 ingress
    $ tc qdisc change dev eth0 ingress clsact-on

Then users can add filters to the egress mini-Qdisc as usual:

    $ tc filter add dev eth0 egress protocol ip prio 10 \
	    matchall action skbmod swap mac

Deleting the ingress Qdisc removes the egress mini-Qdisc as well.  To
remove egress mini-Qdisc only, use:

    $ tc qdisc change dev eth0 ingress clsact-off

Finally, if the egress mini-Qdisc is enabled, the "show" command will
print out a "clsact" flag to indicate it:

    $ tc qdisc show ingress
    qdisc ingress ffff: dev eth0 parent ffff:fff1 ----------------
    $ tc qdisc change dev eth0 ingress clsact-on
    $ tc qdisc show ingress
    qdisc ingress ffff: dev eth0 parent ffff:fff1 ---------------- clsact

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 include/uapi/linux/pkt_sched.h | 12 +++++++++
 tc/q_ingress.c                 | 46 ++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f106b1..cb0eb5dd848a 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -586,6 +586,18 @@ enum {
 
 #define TCA_ATM_MAX	(__TCA_ATM_MAX - 1)
 
+/* INGRESS section */
+
+enum {
+	TCA_INGRESS_UNSPEC,
+	TCA_INGRESS_FLAGS,
+#define	TC_INGRESS_CLSACT	   _BITUL(0)	/* enable clsact egress mini-Qdisc */
+#define	TC_INGRESS_SUPPORTED_FLAGS TC_INGRESS_CLSACT
+	__TCA_INGRESS_MAX,
+};
+
+#define	TCA_INGRESS_MAX	(__TCA_INGRESS_MAX - 1)
+
 /* Network emulator */
 
 enum {
diff --git a/tc/q_ingress.c b/tc/q_ingress.c
index 93313c9c2aec..25bf2dce0b56 100644
--- a/tc/q_ingress.c
+++ b/tc/q_ingress.c
@@ -17,21 +17,45 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... ingress\n");
+	fprintf(stderr,
+		"Usage: [ add | replace | link | delete ] ... ingress\n"
+		"       change ... ingress [ clsact-on | clsact-off ]\n"
+		" clsact-on\tenable clsact egress mini-Qdisc\n"
+		" clsact-off\tdelete clsact egress mini-Qdisc\n");
 }
 
 static int ingress_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			     struct nlmsghdr *n, const char *dev)
 {
+	struct nla_bitfield32 flags = {
+		.selector = TC_INGRESS_SUPPORTED_FLAGS,
+	};
+	bool change = false;
+	struct rtattr *tail;
+
 	while (argc > 0) {
 		if (strcmp(*argv, "handle") == 0) {
 			NEXT_ARG();
-			argc--; argv++;
+		} else if (strcmp(*argv, "clsact-on") == 0) {
+			flags.value |= TC_INGRESS_CLSACT;
+			change = true;
+		} else if (strcmp(*argv, "clsact-off") == 0) {
+			flags.value &= ~TC_INGRESS_CLSACT;
+			change = true;
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			explain();
 			return -1;
 		}
+
+		argc--;
+		argv++;
+	}
+
+	if (change) {
+		tail = addattr_nest(n, 1024, TCA_OPTIONS);
+		addattr_l(n, 1024, TCA_INGRESS_FLAGS, &flags, sizeof(flags));
+		addattr_nest_end(n, tail);
 	}
 
 	return 0;
@@ -40,7 +64,25 @@ static int ingress_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 static int ingress_print_opt(struct qdisc_util *qu, FILE *f,
 			     struct rtattr *opt)
 {
+	struct rtattr *tb[TCA_INGRESS_MAX + 1];
+	struct nla_bitfield32 *flags;
+
 	print_string(PRINT_FP, NULL, "---------------- ", NULL);
+
+	if (!opt)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_INGRESS_MAX, opt);
+
+	if (!tb[TCA_INGRESS_FLAGS])
+		return -1;
+	if (RTA_PAYLOAD(tb[TCA_INGRESS_FLAGS]) < sizeof(*flags))
+		return -1;
+
+	flags = RTA_DATA(tb[TCA_INGRESS_FLAGS]);
+	if (flags->value & TC_INGRESS_CLSACT)
+		print_string(PRINT_FP, NULL, "clsact", NULL);
+
 	return 0;
 }
 
-- 
2.20.1

