Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFDF47DF56
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346752AbhLWHGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346738AbhLWHGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 02:06:52 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C73C061401;
        Wed, 22 Dec 2021 23:06:52 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 205so4527713pfu.0;
        Wed, 22 Dec 2021 23:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ghizbPSkC70FpvQbKkFnFLkVtFSNbImT6AqOSRoqD1k=;
        b=WsA9nOeMaxJ9sT2kQ+N7knvXqvayh0XbbsjP0fV5ss7oEXavAHQf5D4CIUv7h7+1Ei
         RlpPxkKrD5GPiBCBpHig253hRM1JZUwjcWO0Zi1mY82A/9vIB+zQG1YYCyXVyqSmU4gO
         DSkcivyPv7Qj2nmjHUKwulJ33dIOQdgwFD1Vj6uZ4KL2oLMryPz43RqSBwOzFn+wC4dn
         jPI7QQEd7Ig9Zn+W3k2BK7DCFsREksoagGYugqcOsKu0LXI0ncbm0K0q1Kd4G2uGzTrk
         3x03pJCziTYL3WSsJMJ7hiS9WTDl4aoHkglsGctmrvApCbtnNJDpMu1CFIvXh7oF7rS4
         Cm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ghizbPSkC70FpvQbKkFnFLkVtFSNbImT6AqOSRoqD1k=;
        b=TYWy2Ypo9RZewY/Fncuxsw7zv0OsUl8MXJHp92D/FQIKT9zvc30BMCIxLuDf6TQXgi
         buYhejNc97K7WtKGR3BFn09+gleCT3fwM2JHFfhr+6B3MJwR1ii/q/G63yxcURIE+Hn+
         IDk1EC1S7Z1+t/EqO/s2q9Poo2zOi3jOlJvNrkXrQORjKYw4YoGiANjpccRRTh1BYWxJ
         idy9pMHblIrLD7JIC3j5wUrwor4gdtXUNCa72T0Zo5xbAgOS6HU2+VMfXpLAb1i0p46s
         vQ7iLcEGI6E1SH+sWxeIBF87q5qb4+y2DyIWduPspEhggKo7jgSsndTs7BiOvIeS3UbM
         ZenA==
X-Gm-Message-State: AOAM532NfAKp3DDHjC7ksU3RiXYRZiXFeeFU5e6Hm45J3gM4eiuIy72A
        a1N9ipCql1UTaMtaxJSbBCk=
X-Google-Smtp-Source: ABdhPJx+BcnabImSrPgl11QT3Rxa10O80l/Ndh+IHyBOxs1dBAFjJrgUWJz2E//Joz7x0+n8RodErQ==
X-Received: by 2002:a63:7a05:: with SMTP id v5mr1083463pgc.83.1640243211801;
        Wed, 22 Dec 2021 23:06:51 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:ea45:e65d:d667:f86b])
        by smtp.gmail.com with ESMTPSA id il18sm8196665pjb.37.2021.12.22.23.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 23:06:51 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH netfilter] netfilter: xt_owner: use sk->sk_uid for owner lookup
Date:   Wed, 22 Dec 2021 23:06:42 -0800
Message-Id: <20211223070642.499278-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.34.1.307.g9b7440fafd-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

this makes fchown() affect '-m owner --uid-owner'

Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 86741ec25462 ('net: core: Add a UID field to struct sock.')
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/netfilter/xt_owner.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index e85ce69924ae..3eebd9c7ea4b 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -84,8 +84,8 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	if (info->match & XT_OWNER_UID) {
 		kuid_t uid_min = make_kuid(net->user_ns, info->uid_min);
 		kuid_t uid_max = make_kuid(net->user_ns, info->uid_max);
-		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
-		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
+		if ((uid_gte(sk->sk_uid, uid_min) &&
+		     uid_lte(sk->sk_uid, uid_max)) ^
 		    !(info->invert & XT_OWNER_UID))
 			return false;
 	}
-- 
2.34.1.307.g9b7440fafd-goog

