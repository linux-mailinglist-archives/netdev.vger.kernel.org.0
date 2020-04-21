Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596F01B1AD8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgDUAm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 20:42:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42266 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726469AbgDUAm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 20:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587429745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=w0NkVU3TNjEifXe3WvjLawOGXnEzBsNxlMBTVKCi8/I=;
        b=ORDSmaz4Hq5LJFMJfa+vtCRRMEDdICpIV6hYV+0KCSCuPel5P9O71UNX9HyG71GiYn0nwo
        mOlhHgKsRVShx0d6dgKshxvFmyy34d503XwD7J8oxZtvJnyrJEMKyvm+hhreO0JdBmqtaU
        MV2hXmDaf5h6xo/fMhRTRAhly0xM5nE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-0qb4jCoiP7OJmWE2xdKL3Q-1; Mon, 20 Apr 2020 20:42:23 -0400
X-MC-Unique: 0qb4jCoiP7OJmWE2xdKL3Q-1
Received: by mail-wr1-f71.google.com with SMTP id i10so6668789wrq.8
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 17:42:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=w0NkVU3TNjEifXe3WvjLawOGXnEzBsNxlMBTVKCi8/I=;
        b=qXSkhblz6/UysGWXEIzXQaePVachmDh+uJLdsK9GSzS4Yw573GKxr7bHnd/vbOaETW
         OqpU+BJjdPxFQXbwuwhaHI4s9o+BQTGk81t+iX38mTefQC18W71Q8h8HL+rN4KthHjXc
         NvDBjAOvBrNoJ/FQXmnV6hmIFXA8MLwdSrP3sK7gsXWAm0secV3gVe9ALKa4jo9XqlEe
         4GGjjS/KfhHY7mFpeRNJF0SfmF6MKcoP/7rI72YVaQGhpHyM1520lQqSZ4WCtaZZxefl
         xobhNr2lRrxKQfx5hdhzYJOnp3QeFrnP98CK6dgyAwJtQbSFG72FHvQAymEQOAylNx+J
         QmUQ==
X-Gm-Message-State: AGi0PubAOz3IpTL8vLfLxhQgOiApXno6lhqkTGHt6QGpmGqA24tySarz
        h8dqRX3f7BDguZjJ2v6T0QW0aa2VieeOIO7Dw5q5FQJieJ4DE7vhp/kElMxV2UktF6SMIrNhgoi
        1gDe+DSAFFVEnPy8h
X-Received: by 2002:adf:e986:: with SMTP id h6mr21099178wrm.256.1587429742400;
        Mon, 20 Apr 2020 17:42:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMHdAwMbl0bBkqMcuJKFNhGzWRL80tdswcBVt5e+NqmPF1FdTfYo2SLeibTLAYgxlSJRwIKg==
X-Received: by 2002:adf:e986:: with SMTP id h6mr21099165wrm.256.1587429742144;
        Mon, 20 Apr 2020 17:42:22 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id q18sm1356366wmj.11.2020.04.20.17.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 17:42:21 -0700 (PDT)
Date:   Tue, 21 Apr 2020 02:42:19 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] netfilter: nat: never update the UDP checksum when it's 0
Message-ID: <335a95d93767f2b58ad89975e4a0b342ee00db91.1587429321.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the UDP header of a local VXLAN endpoint is NAT-ed, and the VXLAN
device has disabled UDP checksums and enabled Tx checksum offloading,
then the skb passed to udp_manip_pkt() has hdr->check == 0 (outer
checksum disabled) and skb->ip_summed == CHECKSUM_PARTIAL (inner packet
checksum offloaded).

Because of the ->ip_summed value, udp_manip_pkt() tries to update the
outer checksum with the new address and port, leading to an invalid
checksum sent on the wire, as the original null checksum obviously
didn't take the old address and port into account.

So, we can't take ->ip_summed into account in udp_manip_pkt(), as it
might not refer to the checksum we're acting on. Instead, we can base
the decision to update the UDP checksum entirely on the value of
hdr->check, because it's null if and only if checksum is disabled:

  * A fully computed checksum can't be 0, since a 0 checksum is
    represented by the CSUM_MANGLED_0 value instead.

  * A partial checksum can't be 0, since the pseudo-header always adds
    at least one non-zero value (the UDP protocol type 0x11) and adding
    more values to the sum can't make it wrap to 0 as the carry is then
    added to the wrapped number.

  * A disabled checksum uses the special value 0.

The problem seems to be there from day one, although it was probably
not visible before UDP tunnels were implemented.

Fixes: 5b1158e909ec ("[NETFILTER]: Add NAT support for nf_conntrack")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/netfilter/nf_nat_proto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 64eedc17037a..a69e6fc16296 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -68,15 +68,13 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 			  enum nf_nat_manip_type maniptype)
 {
 	struct udphdr *hdr;
-	bool do_csum;
 
 	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
-	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
+	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->check);
 
-	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, do_csum);
 	return true;
 }
 
-- 
2.21.1

