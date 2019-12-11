Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEB311AD41
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfLKOUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:20:34 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38833 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfLKOUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:20:34 -0500
Received: by mail-pl1-f194.google.com with SMTP id a17so1103775pls.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cW2qhaCWIP/7V8DBuGOvc6Ai8luUyTP8UuFcnaFoYV0=;
        b=h3AF5TZLcwNBT/uhOK8Rre1vJoz05JQnK/80h1VuJLdol3lHJMDE353QUJYJMpyMyX
         ismSQOYYRlkdtcFfjU6rfjsqBPrpeCpRL+mui330uCWbRMluEcUZVLE9nTEOoFPs61uH
         ygFetGaVmA4QpPUPMJ0arRUmjrUTgvaX0+YfDrD5yjHM3Jzneo1qdF0bVVpSS/G+lPm5
         PLwlBF7v5Q8w9AoTZAd1dYNPycVgyMv3lk5Jk3YKNkpwE+CCfrqEKbiFToddu1i2panO
         xSeqyahLCP4tVCP1+tJS/987oF/eNwVQSLxvZG5Qpuz9hyjF4+tpxW8MsryLqx/Bvw9p
         oE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cW2qhaCWIP/7V8DBuGOvc6Ai8luUyTP8UuFcnaFoYV0=;
        b=RNtYYM8Ix9JdmTzYMZnU3Uz2Up51C0Oi0GPacTFA/OzyH9DwbyrqqiHEBztKMJb1Km
         ucuf8Vm+XFv+eeiE9eYkGniNTGYdVa2jKSZtms2qeemt1MhE0FdaZWZ75gaVZd1NAtjx
         nlNvdE969sjybD+YPAkE2oPvwsjrcm9TGGsITiAsEl2D5hR7i91bVdvfxqOGscjK+DTh
         pCbxPKAagwOpgKc/tC5a/XisbuIDx2H+j4OhvM6pT4RMZKep9oCMuCu828zAxTMO8txN
         wsKzqVBcpin05EK81BScolIVsklZqm2B75V1BCge4Dzzr10nHS4C8JPabDuJ2SWDnKoE
         FbbA==
X-Gm-Message-State: APjAAAVBYUOdyHbnp/RpTBRE6Oo+rc6YDVcYwl7jZThHTOzAwODOmKSK
        bWmalZ89xs6Ku14bGMz2Jrck9pt8KH8=
X-Google-Smtp-Source: APXvYqx1NOXeA7I04Xao1v0iMSvyDZ6ohKCsPlWRF6OhXfFQKJD6x9PywcVJV5Nzc3V9MTfr5E5ucA==
X-Received: by 2002:a17:902:b187:: with SMTP id s7mr1716066plr.97.1576074033142;
        Wed, 11 Dec 2019 06:20:33 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b10sm3533047pff.59.2019.12.11.06.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:20:32 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv6/addrconf: only check invalid header values when NETLINK_F_STRICT_CHK is set
Date:   Wed, 11 Dec 2019 22:20:16 +0800
Message-Id: <20191211142016.13215-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In patch 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit
handlers") we add strict check for inet6_rtm_getaddr(). But we did the
invalid header values check before checking if NETLINK_F_STRICT_CHK is
set. This may break backwards compatibility if user already set the
ifm->ifa_prefixlen, ifm->ifa_flags, ifm->ifa_scope in their netlink code.

I didn't move the nlmsg_len check becuase I thought it's a valid check.

Reported-by: Jianlin Shi <jishi@redhat.com>
Fixes: 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit handlers")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/addrconf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 98d82305d6de..39d861d00377 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5231,16 +5231,16 @@ static int inet6_rtm_valid_getaddr_req(struct sk_buff *skb,
 		return -EINVAL;
 	}
 
+	if (!netlink_strict_get_check(skb))
+		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
+					      ifa_ipv6_policy, extack);
+
 	ifm = nlmsg_data(nlh);
 	if (ifm->ifa_prefixlen || ifm->ifa_flags || ifm->ifa_scope) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid values in header for get address request");
 		return -EINVAL;
 	}
 
-	if (!netlink_strict_get_check(skb))
-		return nlmsg_parse_deprecated(nlh, sizeof(*ifm), tb, IFA_MAX,
-					      ifa_ipv6_policy, extack);
-
 	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*ifm), tb, IFA_MAX,
 					    ifa_ipv6_policy, extack);
 	if (err)
-- 
2.19.2

