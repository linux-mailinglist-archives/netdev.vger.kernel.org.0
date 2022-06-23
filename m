Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB4557D89
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiFWOIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiFWOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:08:44 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84611427ED
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:43 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-101cdfddfacso18658415fac.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sPGtAbICdqoYk+i3IaNbimna5/VO0BaqFlmX61ALys0=;
        b=v/Tsc2BsvF5SypJZHEjqaLVgbhPFxm18R7cFE8ToCRgo98cdK5j0IS7Y/th9y9pqMW
         mEm7123UwUM+zwDVYZi4yZffX73TBeW30EoHR5uXKkBi1yJsp4lk1Y68FxKkrFIugoml
         kcbgq8Jc7EP03PQVh8KxVdHl3Hx//HXpYWc1mobg2aElxG1vocAtiUuDK9T34qxKuiYE
         XETWrFgceclk93I9+skSZ+CZ+vHYBEdNTFObcVPZvCo/KBcosi98goUW+7W0UdmxiH6w
         AATmNn5UcR+gU+F8pfHRX9s0VHQ7WoepH6oK2hqniAUJEtojplPicGi7JkNO5rZZ1Ljc
         4Hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sPGtAbICdqoYk+i3IaNbimna5/VO0BaqFlmX61ALys0=;
        b=kZZJklcVoXkEbrXXkpgUo7hFe3OjtztUEutwm0yBn3btRf5qpRre7vPVp51S2kWpgx
         dQJsptciBcgMoxu0VAp8Iu7aWFT79wRT85Mr76T6fdYeQ3KxvKNsHPJD/oPnjrbhPuhO
         3rbZt8WRndL8Ex5j6jOu15uWG5rnOAVnxeFHwKiIXwHNnySVZfLLM9fe+iYDUjEh/rey
         NC8xDNKLS1467zGxMfhuDCDnrpPq90o5kOnWPYpTb7JjYRtRYBe8lRWeO0TaWiOTeiSl
         hyOvsM0181gvvZ9vBoi/+m3NR5ov/8EhL780zTQKtZW2V3mTbndBIlDMqYToEoUKhCrg
         WHtQ==
X-Gm-Message-State: AJIora8Sc7gP123xpwzB37FaeJrf6izoHp7LVyYhzgKJ9MRkw6xE2BO/
        5xy4Z+XrlVoaU6Spb1eosJAJvg==
X-Google-Smtp-Source: AGRyM1tHi9uztca3iWEdPvl58kI7Kr8cWrkmOrR+GcDx0k2WMPqr0c+D6udW4FuiCY1Qp5XQLVd8nA==
X-Received: by 2002:a05:6870:a19f:b0:fe:51a2:c022 with SMTP id a31-20020a056870a19f00b000fe51a2c022mr2617286oaf.54.1655993322803;
        Thu, 23 Jun 2022 07:08:42 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:7002:4b2f:1099:d9a9:ed70:bc8f])
        by smtp.gmail.com with ESMTPSA id c83-20020aca3556000000b0032b99637366sm12760903oia.25.2022.06.23.07.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:08:41 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net 1/2] net/sched: act_api: Notify user space if any actions were flushed before error
Date:   Thu, 23 Jun 2022 11:07:41 -0300
Message-Id: <20220623140742.684043-2-victor@mojatatu.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623140742.684043-1-victor@mojatatu.com>
References: <20220623140742.684043-1-victor@mojatatu.com>
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

If during an action flush operation one of the actions is still being
referenced, the flush operation is aborted and the kernel returns to
user space with an error. However, if the kernel was able to flush, for
example, 3 actions and failed on the fourth, the kernel will not notify
user space that it deleted 3 actions before failing.

This patch fixes that behaviour by notifying user space of how many
actions were deleted before flush failed and by setting extack with a
message describing what happened.

Fixes: 55334a5db5cd ("net_sched: act: refuse to remove bound action outside")

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 net/sched/act_api.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index da9733da9868..817065aa2833 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -588,7 +588,8 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 }
 
 static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
-			  const struct tc_action_ops *ops)
+			  const struct tc_action_ops *ops,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *nest;
 	int n_i = 0;
@@ -604,20 +605,25 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	if (nla_put_string(skb, TCA_KIND, ops->kind))
 		goto nla_put_failure;
 
+	ret = 0;
 	mutex_lock(&idrinfo->lock);
 	idr_for_each_entry_ul(idr, p, tmp, id) {
 		if (IS_ERR(p))
 			continue;
 		ret = tcf_idr_release_unsafe(p);
-		if (ret == ACT_P_DELETED) {
+		if (ret == ACT_P_DELETED)
 			module_put(ops->owner);
-			n_i++;
-		} else if (ret < 0) {
-			mutex_unlock(&idrinfo->lock);
-			goto nla_put_failure;
-		}
+		else if (ret < 0)
+			break;
+		n_i++;
 	}
 	mutex_unlock(&idrinfo->lock);
+	if (ret < 0) {
+		if (n_i)
+			NL_SET_ERR_MSG(extack, "Unable to flush all TC actions");
+		else
+			goto nla_put_failure;
+	}
 
 	ret = nla_put_u32(skb, TCA_FCNT, n_i);
 	if (ret)
@@ -638,7 +644,7 @@ int tcf_generic_walker(struct tc_action_net *tn, struct sk_buff *skb,
 	struct tcf_idrinfo *idrinfo = tn->idrinfo;
 
 	if (type == RTM_DELACTION) {
-		return tcf_del_walker(idrinfo, skb, ops);
+		return tcf_del_walker(idrinfo, skb, ops, extack);
 	} else if (type == RTM_GETACTION) {
 		return tcf_dump_walker(idrinfo, skb, cb);
 	} else {
-- 
2.36.1

