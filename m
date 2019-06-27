Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8113157E02
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfF0INM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:13:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33231 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF0INL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:13:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so1445395wru.0
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5sOD6naeLXiSsldLWJyNqacaRGnRa8BAZeXQKuUF/mM=;
        b=AWtJQbQAfQI7Lq78jAzUe5+OZCvC3/Q5BtMumugtPZdkyXnsS+W95OKxxSZikgZCg9
         C8bOcaQnG68vXeMVb+y31bKyiPnIkueY5dA8BflqX32obbIMsEu8EUKcHfU3Xue6v2dm
         3iwQ2tBFplwTV4sHxuUFar9H9UX4zqE1bb1ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5sOD6naeLXiSsldLWJyNqacaRGnRa8BAZeXQKuUF/mM=;
        b=PA4GdlIMALSgR1fQoP/fXjUzwSAJ79E3IzkKN+X70IBJe/tryLAL6Ywg22EH/Pq8rq
         DZaToPK/KMIxxUZQxaccMQY/RxTJgKZjkf+Buw5D5shvKfeOV0D1zVm22vcoDMeQnk1d
         rBz94SfFCDnxmMwG75RZB0ALTKP4mZXPXfkAQ52VNl6m2BmTH5g4+SYKjZsTW8jRFWtU
         /dNf7HnxC6NVpOxvL/JT3ijfgnvg5imdDz5cT16rT+xslbvmVazLMn35sJ+LPiTG4yfM
         zRVPn5PYSEFMPTdY0AHK1I176fy1nJBfV21S3EMJx/21hFF08c8gKg7GTC+O42ixEgqY
         mDLg==
X-Gm-Message-State: APjAAAUGAmpQYk4jFo40jK0MgPaYpzyLPWRUOcE1shWdHsf60n+WKeHJ
        TqiZ8zpLhaxLmghbYwvLmewqS+c1HXY=
X-Google-Smtp-Source: APXvYqzp1+Ll0H0dEYF1OExtmtwUomSoAybvIk8Vr1eENwslOzpBJ6aTD7r7zAoFItbNM1gTAXtNgQ==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr2030355wrp.293.1561623189221;
        Thu, 27 Jun 2019 01:13:09 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm6969949wmc.15.2019.06.27.01.13.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:13:08 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 4/4] net: sched: em_ipt: add support for addrtype matching
Date:   Thu, 27 Jun 2019 11:10:47 +0300
Message-Id: <20190627081047.24537-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
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
v3: no changes

 net/sched/em_ipt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 3c356d6f719a..9fff6480acc6 100644
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
2.21.0

