Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD32B3E3B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 09:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgKPICG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 03:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727973AbgKPICF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 03:02:05 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C38C0613CF;
        Mon, 16 Nov 2020 00:02:05 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q5so13389919pfk.6;
        Mon, 16 Nov 2020 00:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9Y1yLZPbBL2X5WIYzh0MGolabV4K2PbjAEx9PhCuf+Q=;
        b=kpM8zXJ/HI3JAXzLtyf43BKIVH0eKHa0+/czdTViRIu70kSn8YwBwt5Rin3vQ1B/V5
         7rXATO838psjNSblinn929eJATjAnVZjiR9bnBk7hZCcLju6mVRew6AJMrt7wFc1Fl7S
         Z4caCceE4pIaUUNt8DXbXosT+gL+8NBJSi+6VSoqKw3MwAzoY9hX8xE/41NgWxBDT2cz
         VytAjDZDgdc1kgxYrOIabmqd6Nab8eg0PTEn3nDiLhbeERmkgdQNx0QEg16oqQ+mrgae
         1m0uVRk2yg2jAyfXUj0VOdFRGT45FT3oSt4te7MN+DRJpItPZs1OXwD4UwfwkMWN3IGD
         R89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9Y1yLZPbBL2X5WIYzh0MGolabV4K2PbjAEx9PhCuf+Q=;
        b=LkYT4hJrH67LJBYpx57gTh5Tt94fcfTBzvBTge8zHr+x11mlFRSbbdyRT5jby3DWv4
         y/Y2S8GxxuBj/9Iwa5Hlk3h9KLcnuVwJIsvQvoZ7tjmXrnsHFNjTP1FifFVTV89uolth
         kjnsE90LxoiEggHM/EQUfqoqvhWGrfdWSpKIkj23kLRgnUJ5uaVw0z57J+k5L5Mq0luF
         N2S0QBHMapTQa+7eGBnMmULSIPuie6QAfMVRX5x5DA07tXA/6zYQQg2UNKh6XkNLybod
         ooS/kIbRxHY7aW5JI4pUKYV8mXe7+da/wyVjj/KOYM3H5NQAQb7ld8fFMbraFD9VRd/9
         zEwg==
X-Gm-Message-State: AOAM530tApaQ5VBKHuO0vPl9IUIo+Zh3BfBlJ3Zt9n1xkEIn9L2M0AJm
        jGzEWRAZF1Hd8zZcjbtsl5k=
X-Google-Smtp-Source: ABdhPJzhWi0/OjAlz2/BIbIgxQj1UreWhYu3egSm7uojQxyPCrwoHDeQL3pL61qwOodl2i14XkH5LA==
X-Received: by 2002:a62:8857:0:b029:18b:cf28:9bbe with SMTP id l84-20020a6288570000b029018bcf289bbemr12903100pfd.45.1605513725298;
        Mon, 16 Nov 2020 00:02:05 -0800 (PST)
Received: from localhost.localdomain ([8.210.202.142])
        by smtp.gmail.com with ESMTPSA id w10sm15031227pgj.91.2020.11.16.00.01.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 00:02:04 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] ipvs: replace atomic_add_return()
Date:   Mon, 16 Nov 2020 16:01:47 +0800
Message-Id: <1605513707-7579-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

atomic_inc_return() looks better

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 2 +-
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index c0b8215..54e086c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2137,7 +2137,7 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
 		pkts = sysctl_sync_threshold(ipvs);
 	else
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_inc_return(&cp->in_pkts);
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
 		ip_vs_sync_conn(ipvs, cp, pkts);
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 16b4806..9d43277 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -615,7 +615,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	cp = cp->control;
 	if (cp) {
 		if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-			pkts = atomic_add_return(1, &cp->in_pkts);
+			pkts = atomic_inc_return(&cp->in_pkts);
 		else
 			pkts = sysctl_sync_threshold(ipvs);
 		ip_vs_sync_conn(ipvs, cp, pkts);
@@ -776,7 +776,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (!cp)
 		return;
 	if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_inc_return(&cp->in_pkts);
 	else
 		pkts = sysctl_sync_threshold(ipvs);
 	goto sloop;
-- 
1.9.1

