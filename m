Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DE2292732
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgJSMZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgJSMZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:25:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A991C0613CE;
        Mon, 19 Oct 2020 05:25:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j8so5620504pjy.5;
        Mon, 19 Oct 2020 05:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=sWpwlHAU56NfFriE3E2sIUTxcft80+7U4FjmNnOj/UKHRvVW0KANSazqWybWpeAuN7
         QTS+Vlo9zTfxgVRuV6aTMCw4YVQTWhZlZTxxyFpfVVS7xLhRoO6RHSftr84qgKWhjXVf
         Ebg4LEQ3fs5Su3sjty0vhfBnTTjx4cQUkX/PS8UaO7XMrvkqIePoLGqa+PvBZI9Syzo2
         rkEL5pK0ARJAHGId+Jhsqy0K/XGHwNmhseS+6VWcWEcunAW/NuM2E0Lj4NF/9fFptFgW
         Z9q55e55aoz4yAGj3NvywnyxPV9xnr8FcGrxsyYwVEqBcd/hEi5j3UBqrmiQrsjJ+s39
         wGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=jGFHohiLMKmOcbBELvAHtKl6/eKf2Rs4EotDZ5VjkE0=;
        b=WUhQzQPrE7YP+7S9GfCfVXazASVI1wgVlmfeuB7ic/iMtDqVLXMJJJfP4UjH0P/fjK
         GHxIhkBRnLOh8TMhB/YlX5W5Bszn9XGeYZNSernMSOCO1eeXh8dPgldzxgVPzwt3vofE
         CLTNw2FHQK0SAg6jcZTQUj4tUb5LEM5qePgy1tbKJjbt0Z8Y0tAC2f0mY0ioeQEMYCaF
         viMuRO7Qb1Z3TxvKxeWdIr2nLeI/0nqPcncJIdyHSwvRgpGtTMG9sKLWSAJr3GvwWq6Z
         q0zgLdnt43WDAot1Hj2yNVOMQqDbAGDUTKSA3eRFxR2SSE8Kp9y1ZOz6O9VEB/HybGem
         QqjA==
X-Gm-Message-State: AOAM532ItEAHIZ/PlrcHWTPLsVypxgqvkEJhL7W5ePnpoUoKo/iOFboz
        0cfBJhcpCSKJTNnndZgh50FQv8sJxX0=
X-Google-Smtp-Source: ABdhPJywoHkGOh1UZ4H+46xwoc824w3L1ii9tB/MCA8M5yIc/mSvLVnXmEqotHHRyGBk4W7DuLqwbw==
X-Received: by 2002:a17:902:708a:b029:d4:cf7c:6c59 with SMTP id z10-20020a170902708ab02900d4cf7c6c59mr16795320plk.52.1603110350282;
        Mon, 19 Oct 2020 05:25:50 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ga19sm11721302pjb.3.2020.10.19.05.25.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:25:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 01/16] udp: check udp sock encap_type in __udp_lib_err
Date:   Mon, 19 Oct 2020 20:25:18 +0800
Message-Id: <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a chance that __udp4/6_lib_lookup() returns a udp encap
sock in __udp_lib_err(), like the udp encap listening sock may
use the same port as remote encap port, in which case it should
go to __udp4/6_lib_err_encap() for more validation before
processing the icmp packet.

This patch is to check encap_type in __udp_lib_err() for the
further validation for a encap sock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23..ca04a8a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -702,7 +702,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 	sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
 			       iph->saddr, uh->source, skb->dev->ifindex,
 			       inet_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udp_encap_needed_key)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691..cde9b88 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -560,7 +560,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
-	if (!sk) {
+	if (!sk || udp_sk(sk)->encap_type) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
 		if (static_branch_unlikely(&udpv6_encap_needed_key)) {
-- 
2.1.0

