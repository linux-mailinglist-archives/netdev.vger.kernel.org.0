Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91EC3419F3
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhCSK21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhCSK2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:28:08 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58561C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 03:28:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id e14so2746098plj.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 03:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tUGv5JC/EIkDt9J+6fRK4EIIisCxXokbgNEt1JbaMzw=;
        b=ZObWhi2GFNyxaXPs6K6q0fq8MaHNqZlJg8+jfEC0vhLdQkQsXH9VuMQ1nBtS5PzPFa
         Bw3jV40vPsDYVrcAyllv0CH6ErwCsWCJZPPkQtv2SEJj+4T3cxS80rEOAZphh/8ZifAk
         zKDoiZ1ka1dm1mJhihtvv2ExUDzCh9YU2+Lnb/K4Yr8ytoplWjH6OMEomL4ICISIhVqy
         Je2GcMHlv5KPQ3d1i7BCeAAilEQEHABG5aTHAAfjKTApadm9mWSqmzy/5oq6LxeUd2wa
         8VHbEy3BZn5/nDJu+AXNv9EvDDN4yUhR9x9QElK9uVLEJcx/v04rdf3Jxz7OrKBUBxRI
         qZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tUGv5JC/EIkDt9J+6fRK4EIIisCxXokbgNEt1JbaMzw=;
        b=SeTT3tc+qqAEp+Xlef+ShBVR+4poSh9gUHDNvTFqzAyWnYgso1wKgQ94x7F76c5VUA
         /9pCdoj/jH9sYY3m/zwRwiKFBiHlK/OAzUin9HMDuShfJGhfv64ryUgk/ZcDrzV4kbTl
         mQxneRr9KlrDxq2GSb7DKqE1rAN466xn5yKGWS2bISgeri2CLb3y+oztmTY5p64U+2gL
         HDEDsFDh4uBBbxtZ+YkKJB757O0ms5hoc/nIjKmKY4SFGlxVWHe84gcRnOiw/w6+9tD3
         10bViowXq/nZgW4HP83ESVvG+Mq71NXYtK4ffdxqJyrUZ7lKlT3vMVv/IJhAaBIQcybc
         N/eA==
X-Gm-Message-State: AOAM531FuGd/WPiXrT2iRv9YRHEbmuz1jDlj4jUFe5N5nZqG2/N+FuS6
        u5aIS5IjC/XXtSlzK6bfHFLxhW5/pzZ19g==
X-Google-Smtp-Source: ABdhPJwnCUWS6QNrz4kVo/a59mvpI/HieUNkFdbjBpa/WUeMsVtHLO6RmH/MhvsNqCmfv1qjZn/uQA==
X-Received: by 2002:a17:90a:1463:: with SMTP id j90mr9191008pja.205.1616149686590;
        Fri, 19 Mar 2021 03:28:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fr23sm4932157pjb.22.2021.03.19.03.28.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Mar 2021 03:28:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH ipsec] xfrm: BEET mode doesn't support fragments for inner packets
Date:   Fri, 19 Mar 2021 18:27:58 +0800
Message-Id: <6d1bc4971f1095fcd277714e827c52882fa2c9b1.1616149678.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BEET mode replaces the IP(6) Headers with new IP(6) Headers when sending
packets. However, when it's a fragment before the replacement, currently
kernel keeps the fragment flag and replace the address field then encaps
it with ESP. It would cause in RX side the fragments to get reassembled
before decapping with ESP, which is incorrect.

In Xiumei's testing, these fragments went over an xfrm interface and got
encapped with ESP in the device driver, and the traffic was broken.

I don't have a good way to fix it, but only to warn this out in dmesg.

Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_output.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index b81ca11..e4cb0ff 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -660,6 +660,12 @@ static int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ip_is_fragment(ip_hdr(skb))) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv4 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm4_tunnel_check_size(skb);
 	if (err)
 		return err;
@@ -705,8 +711,15 @@ static int xfrm6_tunnel_check_size(struct sk_buff *skb)
 static int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	unsigned int ptr = 0;
 	int err;
 
+	if (x->outer_mode.encap == XFRM_MODE_BEET &&
+	    ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL, NULL) >= 0) {
+		net_warn_ratelimited("BEET mode doesn't support inner IPv6 fragments\n");
+		return -EAFNOSUPPORT;
+	}
+
 	err = xfrm6_tunnel_check_size(skb);
 	if (err)
 		return err;
-- 
2.1.0

