Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532956B2D2E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjCISwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCISwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:52:30 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1E1FA8E7
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:52:17 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id r23-20020a05683001d700b00690eb18529fso1620295ota.1
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 10:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678387937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSGMSYSX6IsJrRKeSPwghMZU2+X4vAr4S/os1lTIXGg=;
        b=itqyp/gFScnrMAykSA6hIN0yafMJSpBcdGlsKx3D+MwzxNzRUed7+nGQtm6aBlmniN
         VXaQxj2Ga9Gc8l7giKkX87lgVeBfS1zPkGdTAlzSqxa60AJUxL0dB+JY+ml2IC3Ld9dS
         JnmLMiDnmsm9ldNs8oUWexCQFnZg55HtoVXN4pQbR99mH2MHBjag2n8ZaUhpvlU8RoXY
         Vx9YeaxwJR6V6pBbcTCJyHF/TKb9Wy2SHbpyjMJRBvXWWsr0wUA3SIfcfXQb351XhEIq
         GrTUU2+T1O7Q7ZJREuTyEn7VqMUtvgor+njL9kolQSE/D0UicubCcR+yHbhXQGooTIJT
         v9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678387937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSGMSYSX6IsJrRKeSPwghMZU2+X4vAr4S/os1lTIXGg=;
        b=P37aTzRgPyEsl3KY5HrqFIJeQeis6/6oW9TTtWy8TrT7ui6ZLSVftkoUlu1392OQjS
         wbOxZvGOx7S9uFiW6NPEdqhGaVIQ2EnMIvtcXbdkjShv3ETRFV7qdDWtVRfH4La0X+2o
         YJmShsymY2tb0W+JyfOm9zsl37ug5OXCiVKc6IIrwsS4kkBAX2H3P/MOyW3Q1NOlU4O0
         8Y9/cVHa4+NBkcgPJvZPSZw3WaC3j/5TDFSuGt0NSkeOcJt+ifnOyFyFfTgdLkmFGbAQ
         uFYSngBY5vVVBOeiOJ85WlJGig+jzFsJMWlXQJzqDmA6bscwEZ3Y3gAD/7EaGASaoj4/
         0oyQ==
X-Gm-Message-State: AO0yUKUv97mcEcsdNzrQr8bO6+YYEw21adD2cRmnj3UCVSiQkJTp6gqb
        1vLE3AVuAMDcnSV8APvEHoWeRLnuT3p4UdfTGsQ=
X-Google-Smtp-Source: AK7set/BHR44V79w3vWPDG2SMPGJBEdtg/bBw4O6G5EZjkDwoSqn8My3EHmXuATG02hy/ptBmByPVQ==
X-Received: by 2002:a9d:1782:0:b0:68b:e0bc:c533 with SMTP id j2-20020a9d1782000000b0068be0bcc533mr10724715otj.20.1678387937026;
        Thu, 09 Mar 2023 10:52:17 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:d22f:e7ce:9ab3:d054])
        by smtp.gmail.com with ESMTPSA id o25-20020a9d7199000000b0068657984c22sm63248otj.32.2023.03.09.10.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 10:52:16 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 3/3] net/sched: act_pedit: rate limit datapath messages
Date:   Thu,  9 Mar 2023 15:51:58 -0300
Message-Id: <20230309185158.310994-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309185158.310994-1-pctammela@mojatatu.com>
References: <20230309185158.310994-1-pctammela@mojatatu.com>
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

Unbounded info messages in the pedit datapath can flood the printk ring buffer quite easily
depending on the action created. As these messages are informational, usually printing
some, not all, is enough to bring attention to the real issue.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index e42cbfc369ff..b5a8fc19ee55 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -388,9 +388,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 		}
 
 		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-		if (rc) {
-			pr_info("tc action pedit bad header type specified (0x%x)\n",
-				htype);
+		if (unlikely(rc)) {
+			pr_info_ratelimited("tc action pedit bad header type specified (0x%x)\n", htype);
 			goto bad;
 		}
 
@@ -398,8 +397,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			u8 *d, _d;
 
 			if (!offset_valid(skb, hoffset + tkey->at)) {
-				pr_info("tc action pedit 'at' offset %d out of bounds\n",
-					hoffset + tkey->at);
+				pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
+						    hoffset + tkey->at);
 				goto bad;
 			}
 			d = skb_header_pointer(skb, hoffset + tkey->at,
@@ -409,14 +408,13 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
 			offset += (*d & tkey->offmask) >> tkey->shift;
 			if (offset % 4) {
-				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				pr_info_ratelimited("tc action pedit offset must be on 32 bit boundaries\n");
 				goto bad;
 			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-			pr_info("tc action pedit offset %d out of bounds\n",
-				hoffset + offset);
+			pr_info_ratelimited("tc action pedit offset %d out of bounds\n", hoffset + offset);
 			goto bad;
 		}
 
@@ -433,8 +431,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			val = (*ptr + tkey->val) & ~tkey->mask;
 			break;
 		default:
-			pr_info("tc action pedit bad command (%d)\n",
-				cmd);
+			pr_info_ratelimited("tc action pedit bad command (%d)\n", cmd);
 			goto bad;
 		}
 
-- 
2.34.1

