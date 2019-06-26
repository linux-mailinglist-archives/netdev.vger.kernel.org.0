Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8C5681F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfFZMBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38554 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfFZMBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so1818741wmj.3
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cAEDwnEStKSeqdXMmpna4aYmiIA2+ZGDjRpHTpM4HlE=;
        b=eEMk9hrf6+cZbUebCcsYn86gayG4w5qEUehD5a7q4vdSkctlDOMFMuhqweWPUFBovP
         9U6m4qFV6BG3erBBZXRVdghwYWie0qILUVVmswGwM7ram87xcSlKFwx1VKOTsA6cXrlY
         aW90bXJbRbCuMUXg11KEFt4cjdxpsL9JlAWuA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cAEDwnEStKSeqdXMmpna4aYmiIA2+ZGDjRpHTpM4HlE=;
        b=K0y6f9c1Lph5VqhPgdxFNyNNjOH5lycYlY4TIyoyT7NBi/TmNucyvlPJzN3or6HTCd
         thWSWVmspmeHd/TjeF0c6uF5jfrj54YGxxRYk5iTKt6NU2Wty2ics6/aUV63QzYG9csU
         0frAXLBcbPa71Qlul5v+KUuVQoWnVz+i1lPyBuq40zElE7d7AT8R5AkvCvjKDIhDoO2Q
         b88b12jqnCE6t2glfNJBs+1nuT5oV7xgV/9H2zQFJsAYiD06pyxtIr2uXAGhVcV3y57R
         ZIoORjm1B9br9VC0pgyz3o13SkWtRmdAhQjKPr3wAaURUT++R1oYtQnmWNI7TvJ6GMUU
         L10A==
X-Gm-Message-State: APjAAAUGc6YyPlBVUlB58vBp4g4BugLeLvP4kv0K3jXPfcAQnBvYITRx
        2tee0j5nNf/bI+GlX+wLFXKcLlCA5jo=
X-Google-Smtp-Source: APXvYqxkF4XaKDMwYbbiUnKxyNPPGK6B+IK/ZV9EWa8yJPN9zclkK+VGeCyiELqrUaZRWPDj5eiTMw==
X-Received: by 2002:a1c:c70f:: with SMTP id x15mr2390966wmf.59.1561550468279;
        Wed, 26 Jun 2019 05:01:08 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:07 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 5/5] net: sched: em_ipt: add support for addrtype matching
Date:   Wed, 26 Jun 2019 14:58:55 +0300
Message-Id: <20190626115855.13241-6-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow em_ipt to use addrtype for matching. Restrict the use only to
revision 1 which has IPv6 support. Since it's a NFPROTO_UNSPEC xt match
we use the user-specified nfproto for matching, in case it's unspecified
both v4/v6 will be matched by the rule.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index cfb93ce340da..ce0798f6f1f7 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -72,11 +72,25 @@ static int policy_validate_match_data(struct nlattr **tb, u8 mrev)
 	return 0;
 }
 
+static int addrtype_validate_match_data(struct nlattr **tb, u8 mrev)
+{
+	if (mrev != 1) {
+		pr_err("only addrtype match revision 1 supported");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct em_ipt_xt_match em_ipt_xt_matches[] = {
 	{
 		.match_name = "policy",
 		.validate_match_data = policy_validate_match_data
 	},
+	{
+		.match_name = "addrtype",
+		.validate_match_data = addrtype_validate_match_data
+	},
 	{}
 };
 
-- 
2.20.1

