Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106A86BA0AB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCNUZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCNUZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:25:14 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DED4FF35
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:08 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id f17-20020a9d7b51000000b00697349ab7e7so1652815oto.9
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678825508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzQcWiPyd6cW0XzNnHNmInOQT29eG1He3iX5OPy5vIU=;
        b=AXq+C9C06n+rCYBhAwiB8LF35e4exwyk9D6L5SBRM2CkSFJgcP2GFmXLDPUlQJZft6
         MyDaPmU2qH//RyTMMPV8f5FqvCzV8NdhogW5PunMxw3QEF7pn4xqTgDF7kUc520T0Cqc
         hM/+XGG+dCyZHH1SQb7dEbcAVe49HIsBACjlI792squeIy5lqRgxQpr8JCvGrTDEpNcM
         il0Pl8k7+107A8KYPHvjNsjiZ4KGhSnU/EwEz3uA+KgYKaaOeD/HgXPBd2DdrZl0fgdo
         MWwxCfkXaGz3onZULFfiTuyCul7IJJEel83b9CZT/G3U1Gujv7rcpWQG2Qwrik58LgNv
         Qslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzQcWiPyd6cW0XzNnHNmInOQT29eG1He3iX5OPy5vIU=;
        b=jbrgUUCWmRBgqSGp/Or/eZXuqz9vJX1mUpmtqXKEycP4JAwdTa2tH/h5K2Q0HWZm9t
         bVkzp9glrMhmq02mkGOD4x3nlhMuVrK33U9vFCeFskR2dQdzT2INr/5ZbjaCZS7Hu7qY
         czmP6Of8mBqB1j9C+kiTOdv74fZ/275nT30Nvd46uKSWH5mIF7KsRhGF3B/wdcqNbFPM
         fdV+NqAlYjqUbCBv1NMwUJM76sKF3pVQkuUNEA/cL0zsMNMk4TJ2MXQYTIBFJHjZYyw9
         9PzVWuXoY7yQehF0x7HqrInGoZ1XuGeunJ9I+kBQ3uk2ng49DBRT6vr69UrwxQygXIOe
         VYVw==
X-Gm-Message-State: AO0yUKXj8Nqv5ArHSV0cmJK/CGrKinYSFLYceCGP3cHneOkuZHP4NG6R
        uE64KVcjmrlSxE6ZFGYe/tMjEDprqqP+2ja5MW8=
X-Google-Smtp-Source: AK7set+5Akl05v/cg4ZM6LHFCfqqdMiVIZTFH9XeDIbWQz5YaywKmQYckO6ISPTGe2jNN/lrZ27PuQ==
X-Received: by 2002:a05:6830:71b:b0:694:88fa:b82f with SMTP id y27-20020a056830071b00b0069488fab82fmr12928070ots.27.1678825507950;
        Tue, 14 Mar 2023 13:25:07 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id 103-20020a9d0870000000b00690e783b729sm1509278oty.52.2023.03.14.13.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:25:07 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 4/4] net/sched: act_pedit: rate limit datapath messages
Date:   Tue, 14 Mar 2023 17:24:48 -0300
Message-Id: <20230314202448.603841-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314202448.603841-1-pctammela@mojatatu.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
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
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index b09e931f23d5..ffcbc83dd5c5 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -390,8 +390,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			u8 *d, _d;
 
 			if (!offset_valid(skb, hoffset + tkey->at)) {
-				pr_info("tc action pedit 'at' offset %d out of bounds\n",
-					hoffset + tkey->at);
+				pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
+						    hoffset + tkey->at);
 				goto bad;
 			}
 			d = skb_header_pointer(skb, hoffset + tkey->at,
@@ -401,14 +401,13 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
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
 
@@ -425,8 +424,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
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

