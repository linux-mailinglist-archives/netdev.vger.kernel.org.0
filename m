Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3FA4C1444
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiBWNei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiBWNeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:34:36 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3590BAB469
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:34:09 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id bg10so52478067ejb.4
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yO9NXPngMi4J8sdhc+FHJvXLkq6gXA4AeF64fqeE28A=;
        b=SNkiJsoNz6FBUYvnMFiwlBn29CuUI8t/Ye7gF4UQ8W2AQPrDDhVQi2dj5DScMQJvxD
         dW5LJW5Ma6Hjaixz/aLVpC6varh17YjVe9fSrm7tI+qit3COnOEe7uDpEoUQde98A1Gp
         oMd7119I8xyaLvjBTdNG88D+ZtM/H/OPTPlrW6A478LGbxAm9XLYAB5K5hBGOsSsZvLs
         l2mesVgUuBms9zb0R4TISdgMxnMnazxZwSi8SNGi83MfLFR79rzjk0ZGqMQOgqgAdhCK
         vZhhEltuFUo1Zf2VlKrQ6L2mSuVjyLe337EwqDaa4R2LCppJarpb41kyAUGxR1U0AABI
         4xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yO9NXPngMi4J8sdhc+FHJvXLkq6gXA4AeF64fqeE28A=;
        b=QnRjUPrRaubXC57Fyb/u2fciL/HaT6I5h3v1VSrkOrcSJlTz4O/W7TJVJ9uRZk5+JR
         SQ+kLDWNkTYT5Z3LHYfzyRFAb7Q4WIn3DNjeDgqqMpLjfsuQnc5OfYLjcBVMssMuFY57
         wBdATOw5kLLsDB5caGXaSXBvg+H8NIJid3iS3bwB+8OPL+4VcGZ49abrHkixWCGCiTJ5
         9ifipDkMoLHQjmEdIRAoDGeWO5tUHghBKSOoMQ1QjZDxJ1xky8WgygM5+zmvW8X8qQbq
         peboPaMrFW0ncLh+5JdECTiLjt5rJVASMzUwndpnOPGQaSHGaLE62g4BE7jpDM28TMKL
         mzWw==
X-Gm-Message-State: AOAM533+vQPPJ3ozBKKo6shS0npMe5wjrI1QWQ5KSi8IAopxqR7+3DtI
        1hb9nHUFF9SvuNVKB/uIlSg+emC4qINwTg==
X-Google-Smtp-Source: ABdhPJzDlQ4GS0risFcOPQHI7/kATxU0VuO01C09quv+NIJ5HJ8wzqTVLJUGTJgFiySCcky8YhF55g==
X-Received: by 2002:a17:906:d9ce:b0:6ce:6a06:c01 with SMTP id qk14-20020a170906d9ce00b006ce6a060c01mr22277502ejb.666.1645623247844;
        Wed, 23 Feb 2022 05:34:07 -0800 (PST)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id j18sm7480534ejc.166.2022.02.23.05.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 05:34:07 -0800 (PST)
From:   Niels Dossche <dossche.niels@gmail.com>
X-Google-Original-From: Niels Dossche <niels.dossche@ugent.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Niels Dossche <niels.dossche@ugent.be>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH net v2] ipv6: prevent a possible race condition with lifetimes
Date:   Wed, 23 Feb 2022 14:19:56 +0100
Message-Id: <20220223131954.6570-1-niels.dossche@ugent.be>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

valid_lft, prefered_lft and tstamp are always accessed under the lock
"lock" in other places. Reading these without taking the lock may result
in inconsistencies regarding the calculation of the valid and preferred
variables since decisions are taken on these fields for those variables.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3f23da8c0b10..6c8ab3e6e6fe 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4998,6 +4998,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
 		goto error;
 
+	spin_lock_bh(&ifa->lock);
 	if (!((ifa->flags&IFA_F_PERMANENT) &&
 	      (ifa->prefered_lft == INFINITY_LIFE_TIME))) {
 		preferred = ifa->prefered_lft;
@@ -5019,6 +5020,7 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 		preferred = INFINITY_LIFE_TIME;
 		valid = INFINITY_LIFE_TIME;
 	}
+	spin_unlock_bh(&ifa->lock);
 
 	if (!ipv6_addr_any(&ifa->peer_addr)) {
 		if (nla_put_in6_addr(skb, IFA_LOCAL, &ifa->addr) < 0 ||
-- 
2.35.1

