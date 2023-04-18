Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD16E700A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjDRXpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjDRXpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:45:08 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF7F196
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:57 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-541af0d27d8so453282eaf.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861497; x=1684453497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GdIUZtQy0YH9bPACPF7kkjB6snFDfJMGHK0km93mha4=;
        b=Ftk9RTyxLAn48h925YQwII0eNYdcEFthM6UnP/rsKMJU8ZE1/K2T4TU9WuOHKfGScT
         1nmCjtMBF9gG/crzFvNBW7kkwGtmyljzjv3AGRAPXI4/shrRA7X54YZFB3meqUujtTNE
         eno8CtmHwkAw5VmFhkzrxVRkl+q0/0ASilIegJZ0+W6NWIXSIYm98DBHafpcuLUVbDrQ
         MuvOkwP0DeXc93BDjYuEYFu4JszIbB64pSQyi8Z3sDHdA2LebKUKGYd9BDPm2o/X2TrX
         vob3ktz1q/gJ8Ex+ojWjHwp1ByOtOpBbWCS7ZnC5ljV1DMKi09DAq6f+yuka1YzFctUL
         9SOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861497; x=1684453497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdIUZtQy0YH9bPACPF7kkjB6snFDfJMGHK0km93mha4=;
        b=GeWE/KzKTe8KR65Z+5YN7QosoIg5tVgp0f8If7wLtRm3t8QpkLbwC4bNoUYNVU8fts
         Mj7+h5SSCm1W3cU2/4Cw9UO1mQwQDb25XN3hOaVNX1IJo9ODcll+5+OI1LCdc7OnoGsz
         B51i1L2i93Ktjov+Z2Bn58Jta41aEbAvCQtY44y6YM0uLJ35lqzB7rAvL/4uAUMbIQPx
         gd0kN3p+hEqbAjdNpar/wCKQl3ui8M0adxf3rX8Nk1vGft+ZWxSjk48pg2osi2JwXphR
         BbMbBt1mIuELBhBwV2ZzuDMVXuYBlejPQyVpVZR6txoJ9Sxyv4GtoYB5HlaNRF1cWSaV
         5/eg==
X-Gm-Message-State: AAQBX9fqboI/7IhhUzgrPL5ldSsZU/nFY4ayZ2QgJBqrDe1EpevM7rcm
        iG0r7ntSCXpSYpfUM52o3QOPj/hZJgVzFV1baOU=
X-Google-Smtp-Source: AKy350bbN6W7l75vRSjYUNz3SNKziZjnqh/jU79OYalun04Rxss/A7oZ/Xs1bQQuLRY9yVk+7ng+gw==
X-Received: by 2002:a05:6808:3a1:b0:384:833:2a79 with SMTP id n1-20020a05680803a100b0038408332a79mr1853683oie.48.1681861496876;
        Tue, 18 Apr 2023 16:44:56 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:56 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 5/5] net/sched: act_pedit: rate limit datapath messages
Date:   Tue, 18 Apr 2023 20:43:54 -0300
Message-Id: <20230418234354.582693-6-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418234354.582693-1-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unbounded info messages in the pedit datapath can flood the printk
ring buffer quite easily depending on the action created.
As these messages are informational, usually printing some, not all,
is enough to bring attention to the real issue.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 2eacada5dcbb..791144012c91 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -397,8 +397,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			u8 *d, _d;
 
 			if (!offset_valid(skb, hoffset + tkey->at)) {
-				pr_info("tc action pedit 'at' offset %d out of bounds\n",
-					hoffset + tkey->at);
+				pr_info_ratelimited("tc action pedit 'at' offset %d out of bounds\n",
+						    hoffset + tkey->at);
 				goto bad;
 			}
 			d = skb_header_pointer(skb, hoffset + tkey->at,
@@ -408,14 +408,13 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
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
 
@@ -432,8 +431,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
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

