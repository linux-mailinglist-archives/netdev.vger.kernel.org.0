Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4313D1B2223
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDUI5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUI5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:57:54 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6D3C061A0F
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 01:57:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t9so1100896pjw.0
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aquYh4pU/4+7/1HXgDG98yftKqcnfXoiWswEo35HNkk=;
        b=k/4l0tiGfspz6eRuom16UQHBnnx/VD5jPLRj2X3ngQJr6iekEMylVmJJkwvwt7lRE3
         0rVjXemxiwj8S2WNXBtLG7cLlyAyLeIMazgdB9qbwchbeosN8g2S3syhJmqcIe3IsD89
         ri1bkCdlPnq6xjE9ci6UCyfQeviyUvCqB1pAF1shPKPNfScUslDokcHhUns6e3w88aVl
         7Uu2VVdSlzc3xI5bT5t92r5legpJIOa8+AOW5ZztTc1Ts1sxB/hMkkx3ikyvftNrC97P
         YUI7u4Um93mrHiHGvyad1W9ddBA51MR0j5rr20eOaV8dF84IZj5qJNAEYxU5qCJAldqp
         s2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aquYh4pU/4+7/1HXgDG98yftKqcnfXoiWswEo35HNkk=;
        b=UxC2yilUFyR/AyBtZ+Lnci8iRsyZIqmB1FPszA/hzG8VeXQ1n/3tUJDBI7djGYf3VD
         e/DyO2H8X48bj8TChnDiYo+EmDPRiP4F80iPy/rJfimTz/4KG9Dcv030agey3NIyVrL4
         L70m64G2Pd4px9rbzMOReyuaS3geUp6ieY7bY9VIMaqqeQtnmgbf/VArA8Qx29PeYuOc
         M9b+KGRzrkMLbExz/j/7eTZSTiVRSpy+GbAfblwS4PHWnQYMgrEPHyDRHd1fgdbRwykv
         XXdx2voJa5omHNispjtFJJ/Yim3lqEVu6P6OxdwxIuF/vrM9z4lxrgsTpfhDW2c6WeWw
         U9kg==
X-Gm-Message-State: AGi0PubxHDyh+9JZ1syQAhD0SzFgyg6DzCF/rk/j9yynlzR5UVfGS3Pq
        G3eU6DpS7hQkCGDnKpcVQAHHk2da
X-Google-Smtp-Source: APiQypLmagXqUmLc15vw2utF9W/CnbaNHAj3wIoIl6u760OcGFvh04Wcea+vRIURR+gJkwVNM5xU3g==
X-Received: by 2002:a17:90a:fd94:: with SMTP id cx20mr4199886pjb.157.1587459472867;
        Tue, 21 Apr 2020 01:57:52 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b9sm1831700pfp.12.2020.04.21.01.57.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 01:57:52 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] xfrm: fix a warning in xfrm_policy_insert_list
Date:   Tue, 21 Apr 2020 16:57:44 +0800
Message-Id: <b328381f956215debcaa2fb70c6a10159ba1f5db.1587459464.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This waring can be triggered simply by:

  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 1 mark 0 mask 0x10  #[1]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x1   #[2]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x10  #[3]

Then dmesg shows:

  [ ] WARNING: CPU: 1 PID: 7265 at net/xfrm/xfrm_policy.c:1548
  [ ] RIP: 0010:xfrm_policy_insert_list+0x2f2/0x1030
  [ ] Call Trace:
  [ ]  xfrm_policy_inexact_insert+0x85/0xe50
  [ ]  xfrm_policy_insert+0x4ba/0x680
  [ ]  xfrm_add_policy+0x246/0x4d0
  [ ]  xfrm_user_rcv_msg+0x331/0x5c0
  [ ]  netlink_rcv_skb+0x121/0x350
  [ ]  xfrm_netlink_rcv+0x66/0x80
  [ ]  netlink_unicast+0x439/0x630
  [ ]  netlink_sendmsg+0x714/0xbf0
  [ ]  sock_sendmsg+0xe2/0x110

The issue was introduced by Commit 7cb8a93968e3 ("xfrm: Allow inserting
policies with matching mark and different priorities"). After that, the
policies [1] and [2] would be able to be added with different priorities.

However, policy [3] will actually match both [1] and [2]. Policy [1]
was matched due to the 1st 'return true' in xfrm_policy_mark_match(),
and policy [2] was matched due to the 2nd 'return true' in there. It
caused WARN_ON() in xfrm_policy_insert_list().

This patch is to fix it by removing the 1st 'return true', as it should
not be how value and mask work.

Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_policy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 297b2fd..3db2db6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1438,9 +1438,6 @@ static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
 {
 	u32 mark = policy->mark.v & policy->mark.m;
 
-	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-		return true;
-
 	if ((mark & pol->mark.m) == pol->mark.v &&
 	    policy->priority == pol->priority)
 		return true;
-- 
2.1.0

