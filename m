Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD9A6377F3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKXLtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiKXLta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:49:30 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A66193F9;
        Thu, 24 Nov 2022 03:49:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id t25-20020a1c7719000000b003cfa34ea516so4362011wmi.1;
        Thu, 24 Nov 2022 03:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KWfj56pFXj1HTsSt2vtLzvRq7ahqzIR48ZMo4DRqEeY=;
        b=I7f0FQe64ZYl5Lvmn1JKId9c+MghKklHNQtOPw1msJG0fE40JL2mXsujNZNlvgiS+6
         ljQeF5b1coULk1oz0gI1nDd5GCd8oF0pD9dk6N/QrIPVibX+BsSi3eQ1osAx4hZ0KMj5
         RF/w8ay2QDO7hgAfEOh7VJ8g3Q4OQBFBLP42Qba3SWPWb+ay9MqixKjgMalUoxOzofpd
         o2+XD3vqFZU0xszWit8exEzymNAWdE1x8agJiF2KlrcLPnbbyClKOpG4GeE5AlV79fzv
         sfGlJnOs08oTfC+/pU/clhI+vMrSQjP+14sdSmXLG7TXkbsZ1X4/G3agoxyjdOu226OE
         G2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KWfj56pFXj1HTsSt2vtLzvRq7ahqzIR48ZMo4DRqEeY=;
        b=xG81gWnbgAmjV7dquv2oppyjikHRn27+DxOH9uFglg8lsyiHSWmi+9VnSlG+pKDG5F
         2ndV85z/ik2TO/TcUNK4YZAkx98AwvpPN3iTlywDbypZKEy9rq1MerMSLVTwly+xDi1l
         sDrDd123tcR2bnrV7RI3SdTL5owJw3Q0drDSDrh59a0EYqBbNMET0NeiaQxthNlIugXq
         c/Yz0LzH6Q/4GDJyKqo/mNhl0k0StsvZnUG5Vt8OY2lB0LGFnb/Er89jV0Oj4wt53uPD
         DM9bizKNH6nh8j2kaq0edYc//QMljdIvqHikbwSV5SkOt9+HhPqV1Pj5AvVzrtGWuLZz
         T5Cw==
X-Gm-Message-State: ANoB5pkdSGztQVTft88wxnAa/Eafi5/1VTdHVZyHDar7Ds7bMwX0qcTP
        L2dewqQBMaFCddWExzZQZCme60s1Jyk=
X-Google-Smtp-Source: AA0mqf5sC1IJZpUnd2RiJHs5ipNZyZyCV6ATcBIL0NgqHymWFFEyOq3K2NkU5jL7Wa729EL58ORVhg==
X-Received: by 2002:a05:600c:3d16:b0:3c6:de4a:d768 with SMTP id bh22-20020a05600c3d1600b003c6de4ad768mr10082720wmb.61.1669290567905;
        Thu, 24 Nov 2022 03:49:27 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c468b00b003cfd10a33afsm5727643wmo.11.2022.11.24.03.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:49:26 -0800 (PST)
Date:   Thu, 24 Nov 2022 12:48:23 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: setsockopt: fix IPV6_UNICAST_IF option for connected
 sockets
Message-ID: <20221124114713.GA73129@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the behaviour of ip6_datagram_connect to consider the interface
set by the IPV6_UNICAST_IF socket option, similarly to udpv6_sendmsg.

This change is the IPv6 counterpart of the fix for IP_UNICAST_IF.
The tests introduced by that patch showed that the incorrect
behavior is present in IPv6 as well.
This patch fixes the broken test.

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/r/202210062117.c7eef1a3-oliver.sang@intel.com

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv6/datagram.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 7c7155b48f17..c3999f9e3545 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -42,24 +42,30 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
+	int oif;
 
 	memset(fl6, 0, sizeof(*fl6));
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->daddr = sk->sk_v6_daddr;
 	fl6->saddr = np->saddr;
-	fl6->flowi6_oif = sk->sk_bound_dev_if;
+	oif = sk->sk_bound_dev_if;
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
 	fl6->flowlabel = np->flow_label;
 	fl6->flowi6_uid = sk->sk_uid;
 
-	if (!fl6->flowi6_oif)
-		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
+	if (!oif)
+		oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	if (!fl6->flowi6_oif && ipv6_addr_is_multicast(&fl6->daddr))
-		fl6->flowi6_oif = np->mcast_oif;
+	if (!oif) {
+		if (ipv6_addr_is_multicast(&fl6->daddr))
+			oif = np->mcast_oif;
+		else
+			oif = np->ucast_oif;
+	}
 
+	fl6->flowi6_oif = oif;
 	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 }
 
-- 
2.36.1

