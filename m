Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967076BF21E
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbjCQUGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCQUGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:32 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E501DCA4F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:12 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id a23-20020a4ad5d7000000b005250867d3d9so945612oot.10
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679083572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNIltoAtE8byOMyYGGGlKSXDXoyOLtzko+GuK2RWSh4=;
        b=S3Awux1L6NphsvbEUtuyHKL/zfxX+JiyEAeC3DJupcqN0sf6rg3C/fy9nP9bKiGHb1
         ivjz5tkELvyVRn9N6UngECSDWOFTDVHkLXBnkbfwXwOHTz89p6kJcZY53hQW1XTxikEF
         8iLwPwmBqVgaTGvMIoetvMtV1YH4HcPBmR4rJ+GOHawFzHxEwAm7TnVQMlvlPBv6Gnb+
         KZ/Prrpd/BCwmhP4dO9QM1i0ZeEIBLe4aCMnvVCqs2GjPkPsuN5NdA0pnI+GclhHQSzD
         fUSTsUzf5tox2Bagk6rt4/yfh5r/KSmCQP0IqJduGUrUFJGhGzDU8r2omg9p++jYGx5g
         AwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNIltoAtE8byOMyYGGGlKSXDXoyOLtzko+GuK2RWSh4=;
        b=BgT0KW+c+9gsyhp7sLkZKmsKMx7DDh00NRWde7o6nqmfNfXlHJqfIfrJbQLlOJHnTH
         B+AEEZtiE/9u+L9iAYZL2WLmS1EuWGBCb74S5XkUgzvZS6KS8qIYsW67CaCyOmwLH8+T
         isMRTkJ0Ir8dIjT/YysXU4B45EhiH/7uKWEQZnQEhmTE03njAAMHV1KfOmlUNOqikZHy
         CsYrv8PRxyXVXSbFFEbf+Vav0O+/mjZWaizWGfW42FkD5dWdmkWEo3WyNp6soFLf/Aqk
         Pe/NTwb3ev8zXSMKU2cwlzcUeUA3uGzpahZT8xQqFeAi8Ost7K83pw0aDJGkgxaxRQPa
         kkHg==
X-Gm-Message-State: AO0yUKXqsr0E6Fth7wjdWAqtDQz11h2re/pT6Em59Fv+GtutIRYCZS8J
        LMkAjnhbeexNoztwvmhBdhu+icRw/r8v0kvh+eI=
X-Google-Smtp-Source: AK7set9xphw25U5a4vI3nhu55ehWbc20Wv6hRO1kawSXQtI5YG0/RABnuJ0L4F8XfTekwb0cW86xmw==
X-Received: by 2002:a4a:49cb:0:b0:538:242e:803a with SMTP id z194-20020a4a49cb000000b00538242e803amr571316ooa.0.1679083572169;
        Fri, 17 Mar 2023 13:06:12 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id z8-20020a056830128800b00698a88cfad1sm1304209otp.68.2023.03.17.13.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:06:11 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 4/4] net/sched: act_pedit: rate limit datapath messages
Date:   Fri, 17 Mar 2023 16:51:35 -0300
Message-Id: <20230317195135.1142050-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317195135.1142050-1-pctammela@mojatatu.com>
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 73414cbb6215..197ddc22d3e5 100644
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

