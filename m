Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858BD6E7009
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbjDRXpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjDRXoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:44:55 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D9A5E2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:51 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-546ec98b2e2so531539eaf.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861490; x=1684453490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxgK6hoycq0EQWv2MTQ00IogRcEaKtcIwR30qqhff54=;
        b=B8nJ4NoRWfBs6AuoP+EqciSJdlyGQV7klJC6kgZSlqc94+2WTGrhh4nvMftVMJeGu1
         nw7X+F5v26vMaPVw0awy/SUmsuZJJ0pWv2fFYQtCABnik1tCjd1R+hzYjl4E40qa7EWY
         7HYJItvDROL8ep4/3iAmRM7Y3TRv5wdR9nH4VEl4KuIHM1Y9ZM1dAAT6R15/8tDglwYv
         eo0Ho0QHjIPi5Vor+I/MENvCkzaYxVnMHLR0YFDst2ua/Ol46cELWC7160/doOKcwRCi
         6NboLNS9EuJ72ZTHbMDcPMsWN07L3ALTPbd7mh+i+DMwr007hCc1rQIKdUKxaXU353pK
         WWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861490; x=1684453490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GxgK6hoycq0EQWv2MTQ00IogRcEaKtcIwR30qqhff54=;
        b=Hmsg0xm8j/73qfRZkmNwo5wuoz5hnbcgzjefpqQNCRpml2EuKg2iaIpkTVH6SP45NX
         /1LY7FKKTQNNCGCnIsM041UmoutbsA7RwNpy58m02oiHPVlpLp5Or9QUoIim+ovAAsXr
         dD+d8u11hymEZeqAr/zTVMRrWdV/+PZIfSYFitqnUR1aI+IdlSZyHAC08p5tZv4+8Q6Y
         KX92PvQUhSYqhOz44k68fQNSrt7YU9GPIRL10FRnd1t8XAlpyq2/XfRraXDeEE7IDKhH
         war6JkgQ/GE66Ihx8nQFK8AET8cnMJLhHLdAYnUJj9u65c3lqGiMruZQr/nuDuiQ7+pL
         Qrhg==
X-Gm-Message-State: AAQBX9eWvs8jFpGkDWLZ6FPSWcaA3CjA34yJ3EHUAjv6dsBOGnq+u+el
        Swg/+bKjyz9P2F6S6WcjAoj3Lg0g7Q0RpvLSuvs=
X-Google-Smtp-Source: AKy350bUWgObcyJEzz58gzRz6vxIH6gqU5rGKeh5mkAjQqvhNMSbnUdJDU3y14ky2OBLmFfINbEZFw==
X-Received: by 2002:a05:6808:2389:b0:389:340e:be3f with SMTP id bp9-20020a056808238900b00389340ebe3fmr2212895oib.2.1681861490388;
        Tue, 18 Apr 2023 16:44:50 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:50 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 3/5] net/sched: act_pedit: check static offsets a priori
Date:   Tue, 18 Apr 2023 20:43:52 -0300
Message-Id: <20230418234354.582693-4-pctammela@mojatatu.com>
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

Static key offsets should always be on 32 bit boundaries. Validate them on
create/update time for static offsets and move the datapath validation
for runtime offsets only.

iproute2 already errors out if a given offset and data size cannot be
packed to a 32 bit boundary. This change will make sure users which
create/update pedit instances directly via netlink also error out,
instead of finding out when packets are traversing.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c8f27a384800..ef6cdf17743b 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -256,6 +256,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		if (cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -414,12 +420,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 					       sizeof(_d), &_d);
 			if (!d)
 				goto bad;
-			offset += (*d & tkey->offmask) >> tkey->shift;
-		}
 
-		if (offset % 4) {
-			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
-			goto bad;
+			offset += (*d & tkey->offmask) >> tkey->shift;
+			if (offset % 4) {
+				pr_info("tc action pedit offset must be on 32 bit boundaries\n");
+				goto bad;
+			}
 		}
 
 		if (!offset_valid(skb, hoffset + offset)) {
-- 
2.34.1

