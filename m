Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0D2F8D02
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 11:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbhAPKqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 05:46:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726513AbhAPKp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 05:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610793873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X3P58FzWAjIu2IDmPongSGOru5Zt1SOBsMLJaMpQ4Es=;
        b=FNezWhq/NpqW3nDmgWecdmvvW6rZ5oEzc2dxiNwOV6ni63WjasB64NIhxvEmjXx4iSRFs4
        8Vnel2ftcFIysqqTB4B4dxR0M86SWlxAqihcyOpMoMEzL4anW1zZKBLMbbJJkzWxJjoEU9
        yZrrDH2bEu9a8uA8qSTrmWYc9/zwu1g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-bRNuCiAwMhun7GW7Jbtdww-1; Sat, 16 Jan 2021 05:44:30 -0500
X-MC-Unique: bRNuCiAwMhun7GW7Jbtdww-1
Received: by mail-wr1-f71.google.com with SMTP id i4so5436913wrm.21
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 02:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X3P58FzWAjIu2IDmPongSGOru5Zt1SOBsMLJaMpQ4Es=;
        b=EEhY2J0veYsHHk6g3WC6br+rV/ii0EcknqFJv1Z05H0Rcq9YhZQ3xaKZWXHR09L3Yb
         aGWX3lNvkONkGatYBOkB7MM0sdyvJba0wcHINAzFT1ubDd4hZ03UF883Ugv/0oxd3Rie
         tGFAvVi8zje1xU6/FoIqguAQT5jVQdMBTRqOsNq2NN//JZNep3IQp3hsp3otpFbUkXbz
         gEqqSv8xU8n8oyebEsg5iBs8OTQ96xzD3nIC1FJWtT6YvGMtSWxp+JdLyca3MgHojvnU
         dQxTpL2HvWCMowypZxufwShv2W32587QqbgoJoSksQrVoUNH2XmideojG6QkdTl70Z+A
         BBxw==
X-Gm-Message-State: AOAM531WOb9MSPJdx2fQ8VSGY62mbWWPyFSnSKqcr9ejp6frzwbjCznQ
        rx2LO50urIKlIYGy/gpLUXCTNXogXiv2IErKeAmFfy5CXSkIBh8FpxyyD9HRB9Fvfl7MDQa3mZR
        QOQeapU3fXTRRLCl5
X-Received: by 2002:adf:9467:: with SMTP id 94mr17817073wrq.235.1610793869139;
        Sat, 16 Jan 2021 02:44:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkG2nP8RP1LElkpfe6X3a3wWRvLfB+7Ed9kwP/lO6yJtUoAPExzUaiRhDGrdpDqALIgbmIDg==
X-Received: by 2002:adf:9467:: with SMTP id 94mr17817063wrq.235.1610793868942;
        Sat, 16 Jan 2021 02:44:28 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id d1sm6920142wru.73.2021.01.16.02.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 02:44:28 -0800 (PST)
Date:   Sat, 16 Jan 2021 11:44:26 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH net 2/2] netfilter: rpfilter: mask ecn bits before fib lookup
Message-ID: <68bdd9383165b264dda2157cd4793d2b723d6438.1610790904.git.gnault@redhat.com>
References: <cover.1610790904.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1610790904.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RT_TOS() only masks one of the two ECN bits. Therefore rpfilter_mt()
treats Not-ECT or ECT(1) packets in a different way than those with
ECT(0) or CE.

Reproducer:

  Create two netns, connected with a veth:
  $ ip netns add ns0
  $ ip netns add ns1
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up
  $ ip -netns ns0 address add 192.0.2.10/32 dev veth01
  $ ip -netns ns1 address add 192.0.2.11/32 dev veth10

  Add a route to ns1 in ns0:
  $ ip -netns ns0 route add 192.0.2.11/32 dev veth01

  In ns1, only packets with TOS 4 can be routed to ns0:
  $ ip -netns ns1 route add 192.0.2.10/32 tos 4 dev veth10

  Ping from ns0 to ns1 works regardless of the ECN bits, as long as TOS
  is 4:
  $ ip netns exec ns0 ping -Q 4 192.0.2.11   # TOS 4, Not-ECT
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 5 192.0.2.11   # TOS 4, ECT(1)
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 6 192.0.2.11   # TOS 4, ECT(0)
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 7 192.0.2.11   # TOS 4, CE
    ... 0% packet loss ...

  Now use iptable's rpfilter module in ns1:
  $ ip netns exec ns1 iptables-legacy -t raw -A PREROUTING -m rpfilter --invert -j DROP

  Not-ECT and ECT(1) packets still pass:
  $ ip netns exec ns0 ping -Q 4 192.0.2.11   # TOS 4, Not-ECT
    ... 0% packet loss ...
  $ ip netns exec ns0 ping -Q 5 192.0.2.11   # TOS 4, ECT(1)
    ... 0% packet loss ...

  But ECT(0) and ECN packets are dropped:
  $ ip netns exec ns0 ping -Q 6 192.0.2.11   # TOS 4, ECT(0)
    ... 100% packet loss ...
  $ ip netns exec ns0 ping -Q 7 192.0.2.11   # TOS 4, CE
    ... 100% packet loss ...

After this patch, rpfilter doesn't drop ECT(0) and CE packets anymore.

Fixes: 8f97339d3feb ("netfilter: add ipv4 reverse path filter match")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index cc23f1ce239c..8cd3224d913e 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.daddr = iph->saddr;
 	flow.saddr = rpfilter_get_saddr(iph->daddr);
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
-	flow.flowi4_tos = RT_TOS(iph->tos);
+	flow.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
 	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
 
-- 
2.21.3

