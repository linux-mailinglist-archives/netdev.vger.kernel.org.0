Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A537B56E27
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFZP4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:56:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38720 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfFZP4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:56:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so2633862wmj.3
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y2Mtcdbgx0lmywlzyLoj3yNMZu8xHe+hD0/o+4yg7kY=;
        b=MaOOsm/kbsZMrQggOWKSCuSqHxXISF5l6Twnp318XCrwB2RGl2v4mwl6hsv6btJXA0
         00ekHH7GgHnfSOSkDcvCAGZQhi8GXxzj0dcOSUCxkfIjvdApIWLeQYSvPIo7Xry8Bu4F
         wTT2S7EzwRgzqXW0895qFPvoHc/UsKz88NR2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2Mtcdbgx0lmywlzyLoj3yNMZu8xHe+hD0/o+4yg7kY=;
        b=exrXW/gnp+FZQMStwqrn7F6a/53XsLzvTOI+57UHehVTqGvyTtc3MnZwmf+6IjB2CY
         we708zRdslr2a95ILVkNByJ0n91MlHLPuyujMQx0xmJFYBHCMqqOcU6GplDdhKTCrM4u
         2aJGh7IuQ7FdA0s3zQXYayW1kJa9X+P2moYxBzpdBfciykZ7GDnkEuGCv22DPXh7qnVV
         4IVe0d1GAeg3HkXNrpo4twslYrjw/iRGhiUZyZI9eebq803ZmgfPO9yPUH2xMfB7Uegc
         wUZCFFzXIfDshiipUa50cc8K0ao68UJdbUlXBQO88Y0XzohrSQF15NbxtIylzL4Gzj59
         JkUA==
X-Gm-Message-State: APjAAAWZ1vdCTwpcqYIW9vDtskEihUpIJCUQN4qzC94cd1yAnnESKXTd
        pMEGyP8NKHo9Qm/D+cM7P7JaIRgH18g=
X-Google-Smtp-Source: APXvYqzz4J0dyjFd2FnDZCq/rDd6lk+XGuksNhpPd5GENeReVMr5f/fw6NR7+E/yGZtpe7awC7yS1g==
X-Received: by 2002:a1c:411:: with SMTP id 17mr2919937wme.74.1561564592743;
        Wed, 26 Jun 2019 08:56:32 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h8sm1832556wmf.12.2019.06.26.08.56.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:56:32 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 4/4] net: sched: em_ipt: add support for addrtype matching
Date:   Wed, 26 Jun 2019 18:56:15 +0300
Message-Id: <20190626155615.16639-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
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

v2: no changes, was patch 5 in v1

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index ce91f3cea0bd..b08d87bd120b 100644
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

