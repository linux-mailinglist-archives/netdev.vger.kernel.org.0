Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0BE6BD3F5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjCPPhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjCPPhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:37:15 -0400
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694D0BD4C7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:06 -0700 (PDT)
Received: by mail-yb1-f201.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so2195855ybg.15
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HteXYOXcXimDaI1L+NcIoxiVb7PNOf4hx6ZWPdNaGDk=;
        b=ndfQ9wYr+JQ9fiL420GbCh0jE5jaqWli1f6dtNAv30wfDNI+2DdyNsPRyYbq8Kw/TT
         YqIhJrf84+ZpQpn8l1tAWLqp8yNAkLOkeP2tSIzHfF5ZlMBpUvNqg313eq2aL969JhAE
         XluxxSmlY5G7WCtN7buwwDH2sMndyN7cFOYNi3XeNXV+2ot4geea7qUuBbC1IO4sxfTm
         zDlv3DK3UcRA30en5d8e4klS6pJVv5NirmSW9+h6OfBF46iw3YAjubjdwKiJCSOm50JL
         fpimv0pgFJKwLnhi2/EXKLKADjFRKVEOxYqcmZWHW2Hsr8Tm0SMe28rwZTWcjAOpSJLK
         A+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980732;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HteXYOXcXimDaI1L+NcIoxiVb7PNOf4hx6ZWPdNaGDk=;
        b=z6a7obopj5RCgzQ4d78473kIj8mY2Ge+El58vr6GZ8ix/lhb7XDp2GrpH4fplnqTHK
         y1D623ILkIALi9bK9M21Wgd9HsXm5MK9rbWPQxvCtuw0q++x4iIOjG2dXTjbZ3mSKnl3
         ErRnAzZMBh4m1pc3ppJ1BZAU6/4JtKSr7ZG7ZCkaIExDnuFP7HAlAHRHvXJ3PbXrYTW4
         GMT0h+io85ZeEj/sFc7XyqdF2d+5hiIRerWixHhIvBDJTSkcvOQYbanB7S40xzVgScgj
         BW+y0ZtojIicRO2gNhkJuZFhqcxbTU+RRBegIPCcPGcV9dN5SgC6/iMiVA0m7IROK6lA
         fCDA==
X-Gm-Message-State: AO0yUKX25v0vYV1V6sE8sVh0JPGyFm2G5T3x+luZY5GMylGnuCLDDIHE
        e3nse87UI78NY+IJk6AyX84sgBRNYJjn9Q==
X-Google-Smtp-Source: AK7set8FaNt/Vr9Kb5K3Io7WmKNQLKWGjPGA3G2RNXyQuWZr5yH3KoEbbj8drGG+V7cfmKZhZYxXp72BwzkcLQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:18ce:b0:b4d:ee98:4ff7 with SMTP
 id ck14-20020a05690218ce00b00b4dee984ff7mr4485421ybb.2.1678980732650; Thu, 16
 Mar 2023 08:32:12 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:31:59 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-6-edumazet@google.com>
Subject: [PATCH v2 net-next 5/8] udp6: constify __udp_v6_is_mcast_sock()
 socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies __udp_v6_is_mcast_sock() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/ipv6/udp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ab4ae886235ac9557219c901c5041adfa8b026ef..d350e57c479299e732bd3595c1964acddde2d876 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -805,12 +805,12 @@ static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static bool __udp_v6_is_mcast_sock(struct net *net, struct sock *sk,
+static bool __udp_v6_is_mcast_sock(struct net *net, const struct sock *sk,
 				   __be16 loc_port, const struct in6_addr *loc_addr,
 				   __be16 rmt_port, const struct in6_addr *rmt_addr,
 				   int dif, int sdif, unsigned short hnum)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	if (!net_eq(sock_net(sk), net))
 		return false;
-- 
2.40.0.rc2.332.ga46443480c-goog

