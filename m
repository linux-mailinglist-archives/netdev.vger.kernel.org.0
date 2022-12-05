Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8BE643873
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 23:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiLEWxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 17:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiLEWxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 17:53:19 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979231DA4E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 14:53:18 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-12c8312131fso15304278fac.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 14:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=PFOE8WfYO6hhhriuQsR5ULbWt4e+xJQ0SvmRM10p1vsdmTRfYgDtPIA38iPfbUFy4s
         iUcusvumpnGXvAoqsEqDD3HmEpYKa6rdh9O3TahOnf9npBQbGTZ+7HxjdznkuO0ntmqi
         1bcA0CY5340R4cTquA1S3YQO7AT2RFwyBqp88nvqyrPmJCMR0C/dwDpl4xzR9/rW629x
         pnvORnN4t6aJIGXURl2ApDURusHvK4UBP1jjZ76UQCodsFSPqHMJE3oTIjW9rgs17B67
         8CxUv9mC2SGLo/QStqPAHqd6C3hkDHQ++099iqsuh4fKeQXoOVpd+4928wYisIlIJ07i
         vk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fmE6o7d7fvntn++wwu1tqKlh3U35UkULWAbCQ1sRGz0=;
        b=Nup0DiJn4VFNGTB7VB3Qe3dCtP1pvuw34E3EBzZYUQfMjjvZmS3NBiIKM2I04VNaE4
         JB2xPnvRQvYNsFw4PeLetv2wkE3y53sKj6zBCehOUcnPYJqgJ4Z4TOb/tnVc3pblcKfC
         PVdQm7ZYOY7J7VNp35lqcIXo/i/rWR/+ziPZp0+9CaoYMUeGdiNmGc/1Wmt7P5jsG2K/
         ykhcYJxtl1A2x+vG06U/ybF38X8oDnMPTyFkU7I9/TFSpK5dOmaeuktx1pgCPZnzGZQL
         BVWFWmdp4flzFgYDRguurmx7DMwdpHMw1H22/VKL9EcGUCNz7xU9K/vj8oeOB9dFGpY7
         3vDg==
X-Gm-Message-State: ANoB5pnovBvFCoO4l51FBLqFmGeJXjjOFKw3sMwK8tj+bsAFdPU94hfD
        iKtidry1lMsNXvGsF3g4cBk600sDevmuK5Gb
X-Google-Smtp-Source: AA0mqf4IWLyCGhZBIE5uOC0D6ebyjhQjVBD7SXOPnK3lBAric3cxcyuBmUwBHjctfHNJVN3dheoK4Q==
X-Received: by 2002:a05:6870:6b08:b0:144:8c6d:33ca with SMTP id mt8-20020a0568706b0800b001448c6d33camr4421417oab.217.1670280797884;
        Mon, 05 Dec 2022 14:53:17 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id e5-20020a544f05000000b0035a5ed5d935sm7608935oiy.16.2022.12.05.14.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 14:53:17 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>,
        Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net-next v4 1/4] net/sched: move struct action_ops definition out of ifdef
Date:   Mon,  5 Dec 2022 19:53:03 -0300
Message-Id: <20221205225306.1778712-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205225306.1778712-1-pctammela@mojatatu.com>
References: <20221205225306.1778712-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The type definition should be visible even in configurations not using
CONFIG_NET_CLS_ACT.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
---
 include/net/act_api.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c94ea1a306e0..2a6f443f0ef6 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -101,11 +101,6 @@ static inline enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-#ifdef CONFIG_NET_CLS_ACT
-
-#define ACT_P_CREATED 1
-#define ACT_P_DELETED 1
-
 typedef void (*tc_action_priv_destructor)(void *priv);
 
 struct tc_action_ops {
@@ -140,6 +135,11 @@ struct tc_action_ops {
 				     struct netlink_ext_ack *extack);
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+
+#define ACT_P_CREATED 1
+#define ACT_P_DELETED 1
+
 struct tc_action_net {
 	struct tcf_idrinfo *idrinfo;
 	const struct tc_action_ops *ops;
-- 
2.34.1

