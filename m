Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50C52A4353
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 11:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgKCKlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 05:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgKCKlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 05:41:35 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190CC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 02:41:35 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e18so6576038edy.6
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 02:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=DdP01kHO5B04yVuNt92/IDiHRHDJ7JwNe7PcFsJrYmk=;
        b=WvCv/rZn7Xvbbi5AK8cMax1kEf84lelp7CX450VvDwPOgcVQ2RpYm8Dh7Wq/Ln6WoX
         tdB4SqFPpGd25SMRFXtMo3kTEwO/iNgQQRG5tJaADoea9Fv4ZYD/4izHMroAeKCUTiIN
         B04g4P89FiERa+nmTNMxwQxvtQTGYiZFR8qEvMd8cPknkegK39gXHdrivl//Nw8XLQZd
         Zar3DSbmhtENCqILCSeRzrDrvNSMnXW778crhXOcVFtUvK9JeddZJJsLIpaRne0kEV0y
         Cu/0Jd55Tn6Ux4EX3YyFr7xEv/k9MXA6G0D5REDNRFq63YbxkU6L/xKPcYpModljMEf6
         gfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DdP01kHO5B04yVuNt92/IDiHRHDJ7JwNe7PcFsJrYmk=;
        b=VLD/f9GIzXBU4B8FcsWwGg7DcBTDHJB+EuyBwee6o+MooSGLHXH5/8MeXcHWc4y89z
         /5dakvAsV07DJ4f3IEz07DuftH3qtEFLNAAmI64S70w5lwOuZIPuzc9rOrd7DzFpWSiz
         +gYv7ykDnjf85CQzGj4b+RmFA3CsVYKWTkwl3eCiUABqVOD/BLHcjh2BBZxnVnak4PJQ
         0nTbzs0G+atz7mJ+HprXsaEmt8c3JxKA0SCyDp2kG8rSSCqeZ4/be89YUgCiInv/KB1B
         cJmbwMwIrx7ELridUrp+U0weODKTJejUyPKkP4p7hlyDfJaLQRBGvE3G8L7/EdR6Rwe4
         GD/Q==
X-Gm-Message-State: AOAM530Q4RuRsaMQVaBWqJTJ/u1bAJHSlmn4xW1BU6kajiEjr0PQmJhO
        wBbdUoyZgU9FJk5prO72e6E=
X-Google-Smtp-Source: ABdhPJwECbZL4FTydIr6k0DNz8tCGiFSNfZVjGgABin9vsplOCC+ehjYJufbqSmi2qUKtyEx3NaXxw==
X-Received: by 2002:a05:6402:144b:: with SMTP id d11mr21397779edx.195.1604400094105;
        Tue, 03 Nov 2020 02:41:34 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:6c3b:b371:86f7:b3f1])
        by smtp.gmail.com with ESMTPSA id bx12sm8357175ejc.71.2020.11.03.02.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 02:41:33 -0800 (PST)
Date:   Tue, 3 Nov 2020 11:41:33 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
Message-ID: <20201103104133.GA1573211@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the legacy usage of hard_header_len for SIT tunnels while
already using infrastructure from net/ipv4/ip_tunnel.c the
calculation of the path MTU in tnl_update_pmtu is incorrect.
This leads to unnecessary creation of MTU exceptions for any
flow going over a SIT tunnel.

As SIT tunnels do not have a header themsevles other than their
transport (L3, L2) headers we're leaving hard_header_len set to zero
as tnl_update_pmtu is already taking care of the transport headers
sizes.

This will also help avoiding unnecessary IPv6 GC runs and spinlock
contention seen when using SIT tunnels and for more than
net.ipv6.route.gc_thresh flows.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv6/sit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 5e2c34c0ac97..5e7983cb6154 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1128,7 +1128,6 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
-		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
 		dev->mtu = tdev->mtu - t_hlen;
 		if (dev->mtu < IPV6_MIN_MTU)
 			dev->mtu = IPV6_MIN_MTU;
@@ -1426,7 +1425,6 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->priv_destructor	= ipip6_dev_free;
 
 	dev->type		= ARPHRD_SIT;
-	dev->hard_header_len	= LL_MAX_HEADER + t_hlen;
 	dev->mtu		= ETH_DATA_LEN - t_hlen;
 	dev->min_mtu		= IPV6_MIN_MTU;
 	dev->max_mtu		= IP6_MAX_MTU - t_hlen;
-- 
2.25.1

