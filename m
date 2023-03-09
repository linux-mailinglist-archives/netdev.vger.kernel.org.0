Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D346B2D2D
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjCISwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 13:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCISw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 13:52:29 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59DBFAED0
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 10:52:14 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id m25-20020a05683026d900b006941a2838caso1606115otu.7
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 10:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678387934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G0L8emv2pJSrZmSSOqCvjwuklxY4YhMLOQGqbfEikcU=;
        b=3p3xwetV1Ic6E1/kfNET58dtntwVFEIVT7Cb7VQryTd7XcFpWAup3oCkhnUAa/DQqD
         u1gE6q1jRaonCcR4r4WXG9y/n3A+fzdqPyH5JBG18aHzrjtaL6aVvoCKQmHXknSIPsmZ
         CZHkqMssFdcB7a6H+wKddtGwnKaTIQWpPTGsmaFuq2HpP3HjVNSijj5jnnTy7h4pv1GZ
         6GddAiEGNzZoo2bd2LObdkZxl+9Ay0iPrvJ7ePyPgmUvXS9wTqFL64XscNcb3PBsS7BP
         LcfdCYAFIjS0152XvLU3CXVsIlu6/+sUjrH3BMO10FB+il9mCAQTtXlXzCeC4mWFYp2X
         GTPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678387934;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G0L8emv2pJSrZmSSOqCvjwuklxY4YhMLOQGqbfEikcU=;
        b=5PtvRLPWdXNsa3jUmb4Pg2nyIz3azkCL/KjhPxTyA6T8mTYXKZEBw+3G/CLWEES0Mq
         FPg6/E2Gy3wvYzoEViALxxPWk7Kcs5g1nltHdLQsC6fkrImjYJto7FDRED2+rVu5RgXd
         XrvyREAyDedKZbkRCxQb/m5ZKIp65vqZkfRuFFG85d/1bc2ddYw+FEDV0AOG764E+QVG
         0F70/rfUhuJti1GiCW5z4qbP+EIhJ4f3417Xpouet1owX7zjT7C/LoydR3CbL7OLv2Ky
         7WXodY7/ChmmuOlK3NaCMusxTzIGQ8vFNli+XfSIWEhSb9aWeeCPdTr+pS++GaSsqK+S
         qkug==
X-Gm-Message-State: AO0yUKX0F9lbXcPy4FB30gtG5al1O4eHDdAOCw1Rmtax5m/2uGCnP4Pk
        BrshLYyXncySyn5tZndP6jw6Ub1vV54VmrdYP8w=
X-Google-Smtp-Source: AK7set9e2wpi2fhVpnXXdAaJPBrJkDCyUb69TE27qGdHi3nkGNX507qm5ctSdro93UcjweZGpZ7FMw==
X-Received: by 2002:a9d:705c:0:b0:694:3972:dbad with SMTP id x28-20020a9d705c000000b006943972dbadmr10379327otj.12.1678387934061;
        Thu, 09 Mar 2023 10:52:14 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:d22f:e7ce:9ab3:d054])
        by smtp.gmail.com with ESMTPSA id o25-20020a9d7199000000b0068657984c22sm63248otj.32.2023.03.09.10.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 10:52:13 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 2/3] net/sched: act_pedit: check static offsets a priori
Date:   Thu,  9 Mar 2023 15:51:57 -0300
Message-Id: <20230309185158.310994-3-pctammela@mojatatu.com>
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

Static key offsets should always be on 32 bit boundaries. Validate them on
create/update time for static offsets and move the datapath validation
for runtime offsets only.

iproute2 already errors out if a given offset and data size cannot be packed
to a 32 bit boundary. This change will make sure users which create/update pedit
instances directly via netlink also error out, instead of finding out
when packets are traversing.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index f4ebe06aeaf2..e42cbfc369ff 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -242,6 +242,12 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		if (cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Pedit offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -400,12 +406,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
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

