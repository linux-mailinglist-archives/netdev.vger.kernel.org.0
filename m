Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0F647244
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiLHOzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLHOzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:55:05 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D549D2D1;
        Thu,  8 Dec 2022 06:55:04 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ja4-20020a05600c556400b003cf6e77f89cso4405024wmb.0;
        Thu, 08 Dec 2022 06:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RqKvZUHndgJsmYSWYtOw+ggxUD/rVpTNob38zsmbVZU=;
        b=MfpArdTIjl5P7RM6yxK+K3jPBoMjzdFj25G54OM4bTeC9GGq6t2dd9oOyg9mVTplwN
         h0WLRH/L7RqOlTvTosGi5lhb++ui5We0HehEpipMR8Oy1Qcq2gvVrBiHVzfMNUZw/P1Z
         8PMvPde4vN9/cJ9J/ph0lO88SxbmExnGQt2E8JyWgth4tCXVR3i4fHEBPtPk3JQyLuW6
         03coqD/kwwGCMd3UuwtMVvu5CqDru9MUcZeokLcL+ePBF4VPX331564D1hsO4Jee8IxE
         7DNM/lpumpGaUyh7glFSD7hpQhC7D2ufgvJ93klU+zuKYrENH4aP5o56btx3gEcaFI9N
         0bBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RqKvZUHndgJsmYSWYtOw+ggxUD/rVpTNob38zsmbVZU=;
        b=22LWCjzecCZpqcyWwJUWOIbiTXmLmkraBJb7a5TcevWdy5Zv/0kRJv2niiEW816ux7
         DdYLu377DrNPuWDHLQCyIteTZgCfJ0XcsSLdt8FqGNcqHBL9MTklGs9KMCoPQMel6QEF
         BH4DTWedwTmevsBts5p2XP81szY8tMLazyAH4FZGd5RZ7JDooc10eq+Jq/lgUCOnu9uO
         ES7WEnnEBi38jbyLUqZj2GvFtplbogOlDXIXnXZaPbSPufUA/rG8diGff/ssHMJ0/3s3
         UZvW5USTU4inesNaFcAXkB5Llz+bkHP4LOldjtzz3FUN1R4T0ahvqZ1tvthZ2bIQPCTl
         ChsQ==
X-Gm-Message-State: ANoB5pmg4/ZQs/nwxZspB3DBBfRcsljQHLnZg4wpuXE3i0esencB9Hpu
        WlFzIMGb5wNkbe9OIEVXC+Q=
X-Google-Smtp-Source: AA0mqf5P6Hz7S/ua1E0aOellTp+0U2q5kIljZ/RQMIdYNFelzJwnvzeSOD06yYOPFcgOZudrGSFthA==
X-Received: by 2002:a05:600c:1685:b0:3d1:f687:1fd0 with SMTP id k5-20020a05600c168500b003d1f6871fd0mr1833043wmn.12.1670511303112;
        Thu, 08 Dec 2022 06:55:03 -0800 (PST)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id z13-20020a05600c220d00b003cf71b1f66csm5118588wml.0.2022.12.08.06.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 06:55:02 -0800 (PST)
Date:   Thu, 8 Dec 2022 15:54:46 +0100
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: setsockopt: fix IPV6_UNICAST_IF option for connected
 sockets
Message-ID: <20221208145437.GA75680@debian>
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
Fixes: 0e4d354762ce ("net-next: Fix IP_UNICAST_IF option behavior for connected sockets")

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv6/datagram.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 7c7155b48f17..e624497fa992 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -42,24 +42,29 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
+	int oif = sk->sk_bound_dev_if;
 
 	memset(fl6, 0, sizeof(*fl6));
 	fl6->flowi6_proto = sk->sk_protocol;
 	fl6->daddr = sk->sk_v6_daddr;
 	fl6->saddr = np->saddr;
-	fl6->flowi6_oif = sk->sk_bound_dev_if;
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

