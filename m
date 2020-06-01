Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75101E9C4A
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 06:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgFAEA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 00:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFAEA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 00:00:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D1C08C5C0;
        Sun, 31 May 2020 21:00:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id v2so2813062pfv.7;
        Sun, 31 May 2020 21:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LVKJu03U8Q8qevPDyP1VjaDzcYQ7HNfppqfKazJ9gIg=;
        b=FLg4lbyNni935s9Fw0W5D6kuelexVZE9u6jNbaqOmyjPtGL31JVgulJs4xJxsUHQuH
         7EVZCSTNOLki4tKQbBR5zElqHWeYtEF5/JA8mm6R0oCbFwX0iAni8BkBYMKqx57+iht1
         6Nf3vpI7ZNjbdgoJFbhNNNgs6zWQ0Izlth9iT/jj4/akheIjYfcI+DjYBImkrqcAQAmT
         HZr1exU2+cf/9E7sOjfnG1pqmpFqu/azRf1X735cBM6ZAATHZXKy2XfmSyFuMBirPdSS
         4zs9I0OOZaxqQ/FQXR6qigAw+zD2Hlkqm+fn986uTMj42oqOEgNMpNCdmC+TKsb+hqLW
         nzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LVKJu03U8Q8qevPDyP1VjaDzcYQ7HNfppqfKazJ9gIg=;
        b=Cj9RDJm0I8wOSzMAsRB0WcNOOQ4R+ZeMPQC5orV7e0A+bPHI3pgSA/gXSnRw6N5mNW
         puvaD7yqqWPcXs/NLq+Uaygg+bRgKGRZG6aOTh31Z/jHOwDIAeeeQ3GRAutIexQYPAS0
         H0jsJr98aTZr7/CRl+CS+0EUdJTDzthx7njVNEt8Ut5GHM84FWEWOa/9OSGp5MDQsxi+
         9UbwSP01+kZdbwPIPNuXpjp4QlC7UmvxUvn0kMlRlbdQOIvgQtE8Glw3UTPjp9eJD5gy
         i+xYtfTxxLlGtFUnJmj05AGjD3wU8TmAgx60HE0+gctMWvnV0pQbgwtYqM1eq9fLvkRz
         i6Yw==
X-Gm-Message-State: AOAM531y6xLQWqYBFwudILvnlu5GwoljSOCXrlqYXXSoaEbRUearpuca
        Jmc+LipgoAqYwDTaVcyMeILp4tWobcKzLA==
X-Google-Smtp-Source: ABdhPJypj3srXr6HIOCY52BYOx0RYWtMHK8UXKgORFkIOn6rEUi25GtJtexPPu67jjLbHfR+LUmoSQ==
X-Received: by 2002:a63:7407:: with SMTP id p7mr18365207pgc.268.1590984058598;
        Sun, 31 May 2020 21:00:58 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v129sm13235321pfv.18.2020.05.31.21.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 21:00:57 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     John Haxby <john.haxby@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipv6: fix IPV6_ADDRFORM operation logic
Date:   Mon,  1 Jun 2020 11:55:03 +0800
Message-Id: <20200601035503.3594635-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socket option IPV6_ADDRFORM supports UDP/UDPLITE and TCP at present.
Previously the checking logic looks like:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol != IPPROTO_TCP)
	break;

After commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation"), TCP
was blocked as the logic changed to:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;
	break;
else
	break;

Then after commit 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
UDP/UDPLITE were blocked as the logic changed to:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;

if (sk->sk_protocol != IPPROTO_TCP)
	break;

Fix it by using Eric's code and simply remove the break in TCP check, which
looks like:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;
else
	break;

Fixes: 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/ipv6_sockglue.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b5..5af97b4f5df3 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -183,14 +183,15 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 					retv = -EBUSY;
 					break;
 				}
-			}
-			if (sk->sk_protocol == IPPROTO_TCP &&
-			    sk->sk_prot != &tcpv6_prot) {
-				retv = -EBUSY;
+			} else if (sk->sk_protocol == IPPROTO_TCP) {
+				if (sk->sk_prot != &tcpv6_prot) {
+					retv = -EBUSY;
+					break;
+				}
+			} else {
 				break;
 			}
-			if (sk->sk_protocol != IPPROTO_TCP)
-				break;
+
 			if (sk->sk_state != TCP_ESTABLISHED) {
 				retv = -ENOTCONN;
 				break;
-- 
2.25.4

