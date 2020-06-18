Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA341FDFCF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 03:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbgFRBnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730793AbgFRBng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 21:43:36 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409AAC06174E;
        Wed, 17 Jun 2020 18:43:36 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v19so780275qtq.10;
        Wed, 17 Jun 2020 18:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=uLeNQByXmfCLbkfFUJI38G+xX0LS1+m6Dp/pbkK2cqE=;
        b=uMmVVjHNrJUxxR3TZEt/J4FtQ0DWcqd00+UbmOgvkHtJI6tgEtBZygEio9Xllu0K60
         jtINJGFfcO2Ao8vr0tN4delYcKWzT/AipR4TuhTwb3I6WGaUgW3qxvXi77tI56WENIk3
         QVZUe9sjmxLD5/ZFwB+8QsH7zLEyj1jCN0NXZa37+8PSdIrvy32thJ/Thox91q21A5mj
         8wx2+jjr+iJrBzv+zi7q3IHLfgMa61tEavfz61cJTvyNGL7thAuILTOC91IpDZzFnLF7
         5EhS7kiKMm94RgYPCu0ZUkowU2/VOBwr6GyyxE5ipKoLu6CAhidii+fEG8Zz9Q5Y2TDr
         03vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=uLeNQByXmfCLbkfFUJI38G+xX0LS1+m6Dp/pbkK2cqE=;
        b=Sex3fKjB/9SPdOf1MiuDPcwCoFvlahcISDL1LFYH3jLdjPgzDdjUYkDNMYcopbyqrX
         CEh8O4qzVTDCP79kr1Seh31yhnU/5FujCuCeg8fnJRodab9EwnEuGQUXZg6ApA45X9By
         FfK2h7Oc0Np3QEr3ibGAYh+I09v7xqTqPqM9HoeHoFSfbIc55NKjcqnNSkwOB+X05AE8
         jp3z//tfv9GtOvv4EOfsDVmFHxneOTUXfs2KOMV5vArwNxh18yNlh6kOL/H0tou3mRD8
         xiVehYebEzjp0YY21NxvPMW0y3HNF/1SctMHUBXsqukOq5PTRtz4XM4cKQgybZmIq2Sf
         H5Lw==
X-Gm-Message-State: AOAM532Pj9AeMSePl42c/X4JaA+jZybt2DXk46pW4GVob6QlXHmFnLNW
        w/KU9tlZEv+qhq7imXza0Mk=
X-Google-Smtp-Source: ABdhPJwufN5cF/crq/Tsi2c1S3zDUcgqiIxLkYsEVW/I9TCIRC58jXHvD5dk2+YV6E0Pzlw306vSCQ==
X-Received: by 2002:ac8:4281:: with SMTP id o1mr2102273qtl.322.1592444614758;
        Wed, 17 Jun 2020 18:43:34 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:9c3:b47c:c995:4853])
        by smtp.googlemail.com with ESMTPSA id x54sm1821885qta.42.2020.06.17.18.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 18:43:34 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/sched] Fix null pointer deref skb in tc_ctl_action
Date:   Wed, 17 Jun 2020 21:43:28 -0400
Message-Id: <20200618014328.28668-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add null check for skb

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/sched/act_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 8ac7eb0a8309..fd584821d75a 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1473,9 +1473,12 @@ static const struct nla_policy tcaa_policy[TCA_ROOT_MAX + 1] = {
 static int tc_ctl_action(struct sk_buff *skb, struct nlmsghdr *n,
 			 struct netlink_ext_ack *extack)
 {
+	if (!skb)
+		return 0;
+
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_ROOT_MAX + 1];
-	u32 portid = skb ? NETLINK_CB(skb).portid : 0;
+	u32 portid = NETLINK_CB(skb).portid;
 	int ret = 0, ovr = 0;
 
 	if ((n->nlmsg_type != RTM_GETACTION) &&
-- 
2.17.1

