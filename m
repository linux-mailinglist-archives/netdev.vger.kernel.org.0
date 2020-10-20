Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFDB29395D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 12:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393342AbgJTKvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 06:51:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392242AbgJTKvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 06:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603191067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fIajhDaxv8mNezIzz6CRmGgwrL/Oe6HKl2u4NZJHNuc=;
        b=eef/WBCVuJwh+nASwzthf7MpVJrVcqmdFRhMima9/TIdI8GTXxz7wPTgoEs+nhTQRFIeos
        y0eb9AurBxN6DQlKH/zp8GTar+SzE0YRtCRMWNF+s/0LqKif2e1BcE5j06cjxNUfT32QFj
        6WPYUZSDr+Mjyq+KQ6cakNkhatJFnD0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-YQPQVMrOPuK7udS9ZHOYhA-1; Tue, 20 Oct 2020 06:51:05 -0400
X-MC-Unique: YQPQVMrOPuK7udS9ZHOYhA-1
Received: by mail-ed1-f72.google.com with SMTP id j6so463424edh.4
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 03:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fIajhDaxv8mNezIzz6CRmGgwrL/Oe6HKl2u4NZJHNuc=;
        b=rs2mmmdAYLKFLUBI6z/XBosnpRezpZpElUYu8l/OjIOSpVnOD427vVMO7Cs8/vrU5n
         sCPVonmuVhpBIKe6cds/MwvUJcGeFK09hFi3HrSooYgEaW4Ah+FvPgYTBFwEv3umR7vs
         D4Bpg/zPv8qqkDiLKde3vE51KIxMNgMA3aHGC6Rvj0fbh9eI+5hpG0+kjrnimvcdsjtx
         +v+sVPoIvURV9Xvfy/Vel3+sV4Dh+H3uMInZqwvCDkAGsXkBk0Q0yFEAQs25qwURUNQ5
         Tt2k3teeM0gwYipFJNeeTxD7Rl27gPOUK3FPL1iOjTJrbze5K03Ja6szJKI9XBH0kyNl
         bRbg==
X-Gm-Message-State: AOAM5309xdvx6/UyKgXgOluxxr52DTl7IaQ6W6Kn5YAi79qbStuMQCMl
        U9sxXPduPy6cMgApxNKlEzqS5Jipaf2KHVNZJ9FR/nWhasarDA81Mzm7LvxhsfYlpREGa9LVeQZ
        Hv+SZVhXqSDN9dEhV
X-Received: by 2002:a05:6402:31ac:: with SMTP id dj12mr2133985edb.20.1603191064452;
        Tue, 20 Oct 2020 03:51:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtPsV13iNano4mHMiAGGBm9pzeIHM7JjUY0Xk6r3cXIfaxfmxxzY/1AKGICIGQfqH8GvEQ7Q==
X-Received: by 2002:a05:6402:31ac:: with SMTP id dj12mr2133972edb.20.1603191064190;
        Tue, 20 Oct 2020 03:51:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id bk13sm2091048ejb.58.2020.10.20.03.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 03:51:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 614521838FF; Tue, 20 Oct 2020 12:51:03 +0200 (CEST)
Subject: [PATCH bpf v2 2/3] bpf_fib_lookup: optionally skip neighbour lookup
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Tue, 20 Oct 2020 12:51:03 +0200
Message-ID: <160319106331.15822.2945713836148003890.stgit@toke.dk>
In-Reply-To: <160319106111.15822.18417665895694986295.stgit@toke.dk>
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The bpf_fib_lookup() helper performs a neighbour lookup for the destination
IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
that the BPF program will deal with this condition, either by passing the
packet up the stack, or by using bpf_redirect_neigh().

The neighbour lookup is done via a hash table (through ___neigh_lookup_noref()),
which incurs some overhead. If the caller knows this is likely to fail
anyway, it may want to skip that and go unconditionally to
bpf_redirect_neigh(). For this use case, add a flag to bpf_fib_lookup()
that will make it skip the neighbour lookup and instead always return
BPF_FIB_LKUP_RET_NO_NEIGH (but still populate the gateway and target
ifindex).

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/uapi/linux/bpf.h       |   10 ++++++----
 net/core/filter.c              |   16 ++++++++++++++--
 tools/include/uapi/linux/bpf.h |   10 ++++++----
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 9668cde9d684..4bfd3c72dae6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4841,12 +4841,14 @@ struct bpf_raw_tracepoint_args {
 	__u64 args[0];
 };
 
-/* DIRECT:  Skip the FIB rules and go to FIB table associated with device
- * OUTPUT:  Do lookup from egress perspective; default is ingress
+/* DIRECT:      Skip the FIB rules and go to FIB table associated with device
+ * OUTPUT:      Do lookup from egress perspective; default is ingress
+ * SKIP_NEIGH:  Skip neighbour lookup and return BPF_FIB_LKUP_RET_NO_NEIGH on success
  */
 enum {
-	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
-	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_DIRECT	  = (1U << 0),
+	BPF_FIB_LOOKUP_OUTPUT	  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index fa09b4f141ae..9791e6311afa 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5382,6 +5382,9 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		if (nhc->nhc_gw_family)
 			params->ipv4_dst = nhc->nhc_gw.ipv4;
 
+		if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+			return BPF_FIB_LKUP_RET_NO_NEIGH;
+
 		neigh = __ipv4_neigh_lookup_noref(dev,
 						 (__force u32)params->ipv4_dst);
 	} else {
@@ -5389,6 +5392,10 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 
 		params->family = AF_INET6;
 		*dst = nhc->nhc_gw.ipv6;
+
+		if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+			return BPF_FIB_LKUP_RET_NO_NEIGH;
+
 		neigh = __ipv6_neigh_lookup_noref_stub(dev, dst);
 	}
 
@@ -5501,6 +5508,9 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	params->rt_metric = res.f6i->fib6_metric;
 	params->ifindex = dev->ifindex;
 
+	if (flags & BPF_FIB_LOOKUP_SKIP_NEIGH)
+		return BPF_FIB_LKUP_RET_NO_NEIGH;
+
 	/* xdp and cls_bpf programs are run in RCU-bh so rcu_read_lock_bh is
 	 * not needed here.
 	 */
@@ -5518,7 +5528,8 @@ BPF_CALL_4(bpf_xdp_fib_lookup, struct xdp_buff *, ctx,
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT |
+		      BPF_FIB_LOOKUP_SKIP_NEIGH))
 		return -EINVAL;
 
 	switch (params->family) {
@@ -5555,7 +5566,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 	if (plen < sizeof(*params))
 		return -EINVAL;
 
-	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT))
+	if (flags & ~(BPF_FIB_LOOKUP_DIRECT | BPF_FIB_LOOKUP_OUTPUT |
+		      BPF_FIB_LOOKUP_SKIP_NEIGH))
 		return -EINVAL;
 
 	switch (params->family) {
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 9668cde9d684..4bfd3c72dae6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4841,12 +4841,14 @@ struct bpf_raw_tracepoint_args {
 	__u64 args[0];
 };
 
-/* DIRECT:  Skip the FIB rules and go to FIB table associated with device
- * OUTPUT:  Do lookup from egress perspective; default is ingress
+/* DIRECT:      Skip the FIB rules and go to FIB table associated with device
+ * OUTPUT:      Do lookup from egress perspective; default is ingress
+ * SKIP_NEIGH:  Skip neighbour lookup and return BPF_FIB_LKUP_RET_NO_NEIGH on success
  */
 enum {
-	BPF_FIB_LOOKUP_DIRECT  = (1U << 0),
-	BPF_FIB_LOOKUP_OUTPUT  = (1U << 1),
+	BPF_FIB_LOOKUP_DIRECT	  = (1U << 0),
+	BPF_FIB_LOOKUP_OUTPUT	  = (1U << 1),
+	BPF_FIB_LOOKUP_SKIP_NEIGH = (1U << 2),
 };
 
 enum {

