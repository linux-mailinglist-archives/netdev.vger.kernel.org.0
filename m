Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602E7267678
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgIKXQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgIKXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:16:31 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613BCC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:16:31 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b12so11799452edz.11
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 16:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JR9lPLn5RCmqsBa8cQx+PzYUJNkIn26uBfnSoFSja0=;
        b=lbtgqIWcrer7xl2sFgHVE1O88LQaLEMa7WHJ9nCEWB0tzMcbbRJnGbKjKusq7AlxHY
         qqrJ6YIW4wRwMbTnEHbcBzvfLP5NSu35MMMSjWApzdHLDgrqvNNeIXY3Pt+PHIDWxZeV
         LCYubgO2Gr8lEgm+WMGSxsJMqNmXA4Uai766WYPO8NKQ1XyIE9jkSGmqpHQY6Tvv79t2
         a/LoKJN5/0/Qw6I1NZJSMFRzkbpF0SK1rocwrWA1VeZgvSRj2XJxU/5R6vtR9udGb+dR
         /c+O+FCtovdEl7O8848W+0MPfKyLNTy1d34xzhPye5u6gAMe2gCjcVdK+YzmQnEUXipx
         v+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1JR9lPLn5RCmqsBa8cQx+PzYUJNkIn26uBfnSoFSja0=;
        b=AuGVatW356WAM4/xhdn4ilWxyPsXZzmpJyPBktEFJkQkB+70BFeb4R04BsX07DPDXJ
         eTptsKODdi8Q4hvlzO9E/gQ4BEsqTtWWhbbOfuRVsoDVwn13ggLC1Itp88Xck47/jBJM
         TGOib05UNNyeDv6w67+tVl7o2+rj8G8dzhgPtgTuMLq3qBJfw8DTA8QixaNJ/bCxJIFq
         GoDumrEWMg8Aeix+e05Ayj4pWyL9KtjQmPK+cqgV505YWffj+KHog27KYj56Nz9TZi1m
         /OfnVAERXrLhXQblYE4axY3nwTukG4O/cDftsYEAcXfEnki9z5yQeE9yQ0zOoLYT2QzS
         5dkA==
X-Gm-Message-State: AOAM531jTI6fP/q5U7EfopYDCNojTTb1t/XZ5HEsuAFW7FToSjC+KBfm
        n1HM+nV50QrrXGiz6Qmydpg=
X-Google-Smtp-Source: ABdhPJzpz7K6HpL3b3kv8SA109bqvpNsOu8I5rr331kCbhc/UCFWfIXod5d7rLCpP2b9jqUKrY2qag==
X-Received: by 2002:aa7:c387:: with SMTP id k7mr4975082edq.242.1599866190046;
        Fri, 11 Sep 2020 16:16:30 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id 40sm2960118edr.67.2020.09.11.16.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 16:16:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, roopa@nvidia.com,
        nikolay@nvidia.com, stephen@networkplumber.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: bridge: pop vlan from skb if filtering is disabled but it's a pvid
Date:   Sat, 12 Sep 2020 02:16:19 +0300
Message-Id: <20200911231619.2876486-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the bridge untags VLANs from its VLAN group in
__allowed_ingress() only when VLAN filtering is enabled.

When installing a pvid in egress-tagged mode, DSA switches have a
problem:

ip link add dev br0 type bridge vlan_filtering 0
ip link set swp0 master br0
bridge vlan del dev swp0 vid 1
bridge vlan add dev swp0 vid 1 pvid

When adding a VLAN on a DSA switch interface, DSA configures the VLAN
membership of the CPU port using the same flags as swp0 (in this case
"pvid and not untagged"), in an attempt to copy the frame as-is from
ingress to the CPU.

However, in this case, the packet may arrive untagged on ingress, it
will be pvid-tagged by the ingress port, and will be sent as
egress-tagged towards the CPU. Otherwise stated, the CPU will see a VLAN
tag where there was none to speak of on ingress.

When vlan_filtering is 1, this is not a problem, as stated in the first
paragraph, because __allowed_ingress() will pop it. But currently, when
vlan_filtering is 0 and we have such a VLAN configuration, we need an
8021q upper (br0.1) to be able to ping over that VLAN.

Make the 2 cases (vlan_filtering 0 and 1) behave the same way by popping
the pvid, if the skb happens to be tagged with it, when vlan_filtering
is 0.

There was an attempt to resolve this issue locally within the DSA
receive data path, but even though we can determine that we are under a
bridge with vlan_filtering=0, there are still some challenges:
- we cannot be certain that the skb will end up in the software bridge's
  data path, and for that reason, we may be popping the VLAN for
  nothing. Example: there might exist an 8021q upper with the same VLAN,
  or this interface might be a DSA master for another switch. In that
  case, the VLAN should definitely not be popped even if it is equal to
  the default_pvid of the bridge, because it will be consumed about the
  DSA layer below.
- the bridge API only offers a race-free API for determining the pvid of
  a port, br_vlan_get_pvid(), under RTNL.

And in fact this might not even be a situation unique to DSA. Any driver
that receives untagged frames as pvid-tagged is now able to communicate
without needing an 8021q upper for the pvid.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/bridge/br_vlan.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index d2b8737f9fc0..ecfdb9cd3183 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -580,7 +580,23 @@ bool br_allowed_ingress(const struct net_bridge *br,
 	 * permitted.
 	 */
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED)) {
+		u16 v;
+
 		BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
+
+		/* See comment in __allowed_ingress about how skb can end up
+		 * here not having a hwaccel tag
+		 */
+		if (unlikely(!skb_vlan_tag_present(skb) &&
+			     skb->protocol == br->vlan_proto)) {
+			skb = skb_vlan_untag(skb);
+			if (unlikely(!skb))
+				return false;
+		}
+
+		if (!br_vlan_get_tag(skb, &v) && v == br_get_pvid(vg))
+			__vlan_hwaccel_clear_tag(skb);
+
 		return true;
 	}
 
-- 
2.25.1

