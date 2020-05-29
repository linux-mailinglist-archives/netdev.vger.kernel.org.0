Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB51E7D74
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgE2MpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:45:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48360 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725901AbgE2MpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590756305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JKsNZS3w5DrPc7+4udTo52fTbfp4sT5cBmkgQAVmUhY=;
        b=Z5Lo2mPGsCALSO2WaLD9qLeOH7vGYr+PckaTWRThHQwl8SPGI5T1mo7CFbzirBJ/w5KNuW
        jOy1BQq8LsrN2Z/6vSkS+ZqgLAOIdX9eU4vY/3rthNILXu68Q1UmmKUp6HCCdbyoNMiTih
        FiklZR6HaLOmEingo8Vd5KBrQrrJ2ME=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-UXtMwtICPYWtwlmRIn7pIA-1; Fri, 29 May 2020 08:45:04 -0400
X-MC-Unique: UXtMwtICPYWtwlmRIn7pIA-1
Received: by mail-ej1-f71.google.com with SMTP id z20so878897ejf.23
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 05:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JKsNZS3w5DrPc7+4udTo52fTbfp4sT5cBmkgQAVmUhY=;
        b=dIBRXp+JKI4VAbHvt+D8v2PdiuumsjZlvbvXosGTB965yyVrvzuiFtNzaLSeFD6DQw
         qyQAz53ATL5yf/AMEK6ZBhghpjmv38vZBKn3kwboZnAZweI1qS8U+FtFPm3eHgTKX+3S
         3543wE1Vji2huvJRjtFEbJKBL9mvNxoN9oxJMXABOIpewaNLhPluQsjSC+dPPS/0PaKi
         RlE1/RCyMsLATq+jjR8faNvj2BR6u6wFTXZenO9J21D1HzvDwlsmIH8CfQXUVxAfx8+m
         mYd1+pd6hoMGeThZRaUAvpzW9q3KSKuqEHA4uI+8KmHewVMAeEUATpxvrKlVhWIR/60i
         6B3w==
X-Gm-Message-State: AOAM530HGd6Rusi/UTySUjWV7QD3QZh43WTLLD8SiDxUZ7IlOjZEAG62
        dL0rp1ADd9vbox3GVyyyIS+yjoj3IwIrzJ5q0DO7syiOYgLWKGORRwLFZibs+t39dggjCZcJvVu
        EkFG+gRMANJgQpFQ3
X-Received: by 2002:a50:a8a2:: with SMTP id k31mr7755746edc.357.1590756302632;
        Fri, 29 May 2020 05:45:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4S38O42re10OXjVsZ35pdB32c21scT45tfTuqunZbtcGru4SRhdBE5KGof/GM6qxoefIDYw==
X-Received: by 2002:a50:a8a2:: with SMTP id k31mr7755737edc.357.1590756302343;
        Fri, 29 May 2020 05:45:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h5sm7238070ejg.124.2020.05.29.05.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 05:45:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 35FB7182019; Fri, 29 May 2020 14:45:01 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: [PATCH net] sch_cake: Take advantage of skb->hash where appropriate
Date:   Fri, 29 May 2020 14:43:44 +0200
Message-Id: <20200529124344.355785-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the other fq-based qdiscs take advantage of skb->hash and doesn't
recompute it if it is already set, sch_cake does not.

This was a deliberate choice because sch_cake hashes various parts of the
packet header to support its advanced flow isolation modes. However,
foregoing the use of skb->hash entirely loses a few important benefits:

- When skb->hash is set by hardware, a few CPU cycles can be saved by not
  hashing again in software.

- Tunnel encapsulations will generally preserve the value of skb->hash from
  before the encapsulation, which allows flow-based qdiscs to distinguish
  between flows even though the outer packet header no longer has flow
  information.

It turns out that we can preserve these desirable properties in many cases,
while still supporting the advanced flow isolation properties of sch_cake.
This patch does so by reusing the skb->hash value as the flow_hash part of
the hashing procedure in cake_hash() only in the following conditions:

- If the skb->hash is marked as covering the flow headers (skb->l4_hash is
  set)

AND

- NAT header rewriting is either disabled, or did not change any values
  used for hashing. The latter is important to match local-origin packets
  such as those of a tunnel endpoint.

The immediate motivation for fixing this was the recent patch to WireGuard
to preserve the skb->hash on encapsulation. As such, this is also what I
tested against; with this patch, added latency under load for competing
flows drops from ~8 ms to sub-1ms on an RRUL test over a WireGuard tunnel
going through a virtual link shaped to 1Gbps using sch_cake. This matches
the results we saw with a similar setup using sch_fq_codel when testing the
WireGuard patch.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c | 65 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 14 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 1496e87cd07b..2a704b25dc6a 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -584,26 +584,48 @@ static bool cobalt_should_drop(struct cobalt_vars *vars,
 	return drop;
 }
 
-static void cake_update_flowkeys(struct flow_keys *keys,
+static bool cake_update_flowkeys(struct flow_keys *keys,
 				 const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conntrack_tuple tuple = {};
-	bool rev = !skb->_nfct;
+	bool rev = !skb->_nfct, upd = false;
+	__be32 ip;
 
 	if (tc_skb_protocol(skb) != htons(ETH_P_IP))
-		return;
+		return false;
 
 	if (!nf_ct_get_tuple_skb(&tuple, skb))
-		return;
+		return false;
 
-	keys->addrs.v4addrs.src = rev ? tuple.dst.u3.ip : tuple.src.u3.ip;
-	keys->addrs.v4addrs.dst = rev ? tuple.src.u3.ip : tuple.dst.u3.ip;
+	ip = rev ? tuple.dst.u3.ip : tuple.src.u3.ip;
+	if (ip != keys->addrs.v4addrs.src) {
+		keys->addrs.v4addrs.src = ip;
+		upd = true;
+	}
+	ip = rev ? tuple.src.u3.ip : tuple.dst.u3.ip;
+	if (ip != keys->addrs.v4addrs.dst) {
+		keys->addrs.v4addrs.dst = ip;
+		upd = true;
+	}
 
 	if (keys->ports.ports) {
-		keys->ports.src = rev ? tuple.dst.u.all : tuple.src.u.all;
-		keys->ports.dst = rev ? tuple.src.u.all : tuple.dst.u.all;
+		__be16 port;
+
+		port = rev ? tuple.dst.u.all : tuple.src.u.all;
+		if (port != keys->ports.src) {
+			keys->ports.src = port;
+			upd = true;
+		}
+		port = rev ? tuple.src.u.all : tuple.dst.u.all;
+		if (port != keys->ports.dst) {
+			port = keys->ports.dst;
+			upd = true;
+		}
 	}
+	return upd;
+#else
+	return false;
 #endif
 }
 
@@ -624,23 +646,36 @@ static bool cake_ddst(int flow_mode)
 static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 		     int flow_mode, u16 flow_override, u16 host_override)
 {
+	bool hash_flows = (!flow_override && !!(flow_mode & CAKE_FLOW_FLOWS));
+	bool hash_hosts = (!host_override && !!(flow_mode & CAKE_FLOW_HOSTS));
+	bool nat_enabled = !!(flow_mode & CAKE_FLOW_NAT_FLAG);
 	u32 flow_hash = 0, srchost_hash = 0, dsthost_hash = 0;
 	u16 reduced_hash, srchost_idx, dsthost_idx;
 	struct flow_keys keys, host_keys;
+	bool use_skbhash = skb->l4_hash;
 
 	if (unlikely(flow_mode == CAKE_FLOW_NONE))
 		return 0;
 
-	/* If both overrides are set we can skip packet dissection entirely */
-	if ((flow_override || !(flow_mode & CAKE_FLOW_FLOWS)) &&
-	    (host_override || !(flow_mode & CAKE_FLOW_HOSTS)))
+	/* If both overrides are set, or we can use the SKB hash and nat mode is
+	 * disabled, we can skip packet dissection entirely. If nat mode is
+	 * enabled there's another check below after doing the conntrack lookup.
+	  */
+	if ((!hash_flows || (use_skbhash && !nat_enabled)) && !hash_hosts)
 		goto skip_hash;
 
 	skb_flow_dissect_flow_keys(skb, &keys,
 				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
-	if (flow_mode & CAKE_FLOW_NAT_FLAG)
-		cake_update_flowkeys(&keys, skb);
+	/* Don't use the SKB hash if we change the lookup keys from conntrack */
+	if (nat_enabled && cake_update_flowkeys(&keys, skb))
+		use_skbhash = false;
+
+	/* If we can still use the SKB hash and don't need the host hash, we can
+	 * skip the rest of the hashing procedure
+	 */
+	if (use_skbhash && !hash_hosts)
+		goto skip_hash;
 
 	/* flow_hash_from_keys() sorts the addresses by value, so we have
 	 * to preserve their order in a separate data structure to treat
@@ -679,12 +714,14 @@ static u32 cake_hash(struct cake_tin_data *q, const struct sk_buff *skb,
 	/* This *must* be after the above switch, since as a
 	 * side-effect it sorts the src and dst addresses.
 	 */
-	if (flow_mode & CAKE_FLOW_FLOWS)
+	if (hash_flows && !use_skbhash)
 		flow_hash = flow_hash_from_keys(&keys);
 
 skip_hash:
 	if (flow_override)
 		flow_hash = flow_override - 1;
+	else if (use_skbhash)
+		flow_hash = skb->hash;
 	if (host_override) {
 		dsthost_hash = host_override - 1;
 		srchost_hash = host_override - 1;
-- 
2.26.2

