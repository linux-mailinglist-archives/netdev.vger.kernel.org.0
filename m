Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665EE6EB399
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjDUVZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233156AbjDUVZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:25:50 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0A9268C
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:49 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-546ee6030e5so1283343eaf.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112348; x=1684704348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GKSKugCB6BQUzFHp+91QqPMtVs0x3EKY9rqmE0Nbn+Y=;
        b=rePEyzzisI5fuvTa221k10/hysmtbMxvEAhwS2IFeMZUZrQzFTCi5RZXgq6us6vhZr
         aOb+m3maKSE6iU+yYwqOTBdhcenyirqYNKQnktDNi+hC3o2sKXsnJfUl9SBoopTLvz+t
         2daCLzazsnKSwrhSNT4YFlHFHPvaxIodAzLT88mGdVCMLDL6twHJKMxUSHEkumJvdeRP
         IF0jkS1I4EI3UUYrNL2oDECu2Z2PlN1NZK3flzNppiz1rNQFtcaKGyGdRei+wkMTy2UQ
         6wE6UylS8ttPX+picUcq6l0yxrvH4v9MZe2sgpE7fojglIReGrzaJqw16rMWkIQBF3Vw
         URnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112348; x=1684704348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GKSKugCB6BQUzFHp+91QqPMtVs0x3EKY9rqmE0Nbn+Y=;
        b=gs5n3g4+DZ6W0dIf59Ar/gMjsrFa7VwnDiJLnJifplQp29uLZ9xfHHjOvCCVTE0q99
         Nz76eFox2DBqWK15F6GOkC+YcMuilcsF3lSZtUKJxnByDYN3cA2BhwQlP5vmgZQK8arE
         UW9p2r7/QuWLWzCn6K4KAimBpSlSK2EPB2RXL1gGFjjJbX5cRTWiK+m40FCGHaCzCpth
         D6NgIB5uSuWynOnxqdsFuXS0feOmN/qJhn/LlExwYayjy9OhxzGKjxSJfPFCCMQ8Gybx
         NDRZ2HMT6YBJ3tm37UN3+aWRm74E1PN4pS4SHldGHD47FmTqKb+yaJ4CLRABDI8pHZP+
         Arrg==
X-Gm-Message-State: AAQBX9dQ0Kc8sKfnuiwpAvcYFoL9g1WbyAB7PQvGfb1CarFI55aQbXfV
        +NawOxKJhg6JqRoMcXkAI3RMdRQl2IklMJFfRBE=
X-Google-Smtp-Source: AKy350ZGasDTjesWy5B/20F637d0h73MEZQgc+SP9ZBt9lNveRvICh2dA1IBBMdFqECQgyHISse2aw==
X-Received: by 2002:a05:6820:188d:b0:547:6105:e090 with SMTP id bm13-20020a056820188d00b005476105e090mr1119083oob.4.1682112348302;
        Fri, 21 Apr 2023 14:25:48 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:47 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 3/5] net/sched: act_pedit: check static offsets a priori
Date:   Fri, 21 Apr 2023 18:25:15 -0300
Message-Id: <20230421212516.406726-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
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
 net/sched/act_pedit.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 24976cd4e4a2..cc4dfb01c6c7 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -251,8 +251,16 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	memcpy(nparms->tcfp_keys, parm->keys, ksize);
 
 	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
+		u32 offmask = nparms->tcfp_keys[i].offmask;
 		u32 cur = nparms->tcfp_keys[i].off;
 
+		/* The AT option can be added to static offsets in the datapath */
+		if (!offmask && cur % 4) {
+			NL_SET_ERR_MSG_MOD(extack, "Offsets must be on 32bit boundaries");
+			ret = -EINVAL;
+			goto put_chain;
+		}
+
 		/* sanitize the shift value for any later use */
 		nparms->tcfp_keys[i].shift = min_t(size_t,
 						   BITS_PER_TYPE(int) - 1,
@@ -261,7 +269,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
+		cur += (0xff & offmask) >> nparms->tcfp_keys[i].shift;
 
 		/* Each key touches 4 bytes starting from the computed offset */
 		nparms->tcfp_off_max_hint =
@@ -411,12 +419,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
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

