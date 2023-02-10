Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40F569167B
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBJCGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBJCGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:06:04 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9A76E889;
        Thu,  9 Feb 2023 18:06:04 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id m2so5021936plg.4;
        Thu, 09 Feb 2023 18:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1675994764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U4zl34A3GY3MtISNKsd5orN34wUbJTMGgpN0qaNrO2w=;
        b=nJVu474RyoPPjF3q7Zt+ECiBs7Re0VRmFLqMB/DMKpPO4QixB28rPAbBg+W2tqR27C
         f/5wI6wOQcTy9YFLO8ISScESFKOPKtlxWxojRcVrnhsxBw24d9ZmVijkqYeS6ewhTDOj
         7GKnGvSasgY9u28uof8Ard0UuhCs4dih+G+20TOgCGK+w+LLjOKSf73qpmY4cbMKDAkY
         OsD5igAZ63coYnGQX6tl2VxSpEByJjCJHkXIUQFLDvYXpC3xAfNrMDahWKnyRCMNhhVa
         FBdqb9Xej2eQFRp5cU3GmIigpjBRD89v2C1xufMpErQLuWZO9esqhSEUu8TauLclJhtV
         EVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1675994764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U4zl34A3GY3MtISNKsd5orN34wUbJTMGgpN0qaNrO2w=;
        b=If36fyj350LLly+eqDkVRa++jMddx1dKJCRMjBfzMZzZelBoANyXS/GQdvbSgdJUkM
         SzFdVL+NDEZ91LWbeToUITxg22NP7Bq4k/BMAScm5KiMec6Ld5hSHOlcFDEP9yaHgnvL
         5XEMYX3Hn9salhXTT1MIU+Hh4OY9Wh81C1dK9q1raz/e5e5pJqvII74XsRZWvnk7ODQG
         MNnHfGpk4RtWMuTlL1/+fjPWVZhDp5wCol2iXOugWTVDNCUJBWOr3YbJa1Re0uJtvsuk
         8l/CgavtAz3Qurgopyt9p29//stUFQrX1hdqmw1kl0YMsyPmuD8A3x/tZnp+/oc9D8Tc
         sdBw==
X-Gm-Message-State: AO0yUKWN8p0du4xODFxwOMUSZRBw6Vkq+5OWbnWBpKqdnVoP8gZVXwbb
        W2HkG4UKAfp3GrMRUztKN8A=
X-Google-Smtp-Source: AK7set+hiAD/Ul9BT8YLkMkx5ariCdfhouUWTp5i+SRWw6byhsghYi17pjdURn0CEARdwXpXOa4mOg==
X-Received: by 2002:a05:6a20:7f8e:b0:be:9972:1605 with SMTP id d14-20020a056a207f8e00b000be99721605mr13014088pzj.1.1675994763780;
        Thu, 09 Feb 2023 18:06:03 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id r8-20020a63b108000000b004d4547cc0f7sm1875105pgf.18.2023.02.09.18.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:06:03 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        simon.horman@corigine.com, echaudro@redhat.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v3] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date:   Fri, 10 Feb 2023 10:05:51 +0800
Message-Id: <20230210020551.6682-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

old_meter needs to be free after it is detached regardless of whether
the new meter is successfully attached.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: use goto label and free old_meter outside of ovs lock.

v3: add the label and keep the lock in place.

 net/openvswitch/meter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 6e38f68f88c2..f2698d2316df 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -449,7 +449,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = attach_meter(meter_tbl, meter);
 	if (err)
-		goto exit_unlock;
+		goto exit_free_old_meter;
 
 	ovs_unlock();
 
@@ -472,6 +472,8 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
 	ovs_unlock();
 	nlmsg_free(reply);
-- 
2.34.1

