Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22487AB4D7
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391340AbfIFJYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:24:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50342 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbfIFJYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:24:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id c10so5740176wmc.0
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 02:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yUcd4S+zm0+jtK7zRu7jP8L6UWwUXcJefrwtUq7Fewg=;
        b=Olp/rY322yVcE6UB+GsR19BQ5buWIH+IwlXioIJ+DCSjzEm0qbpmSrj99toH9q79nz
         3P1nxR2yj2onzLII1A0oWzcgkKaSgp42J/V1IgQ6w+o3oQrZ2o9wlM94oUENZ1FVP1Nd
         D8OQFcQo//yS+dEPj/YJh9eF3lamzYO/tDmYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yUcd4S+zm0+jtK7zRu7jP8L6UWwUXcJefrwtUq7Fewg=;
        b=nnTewxQT6XpV2K76rXH3qGr/U6NN/2vuoofehebPF0zYnQUQFKAcW2WjHy4TxUmMRl
         owkQImiqx4WpoI+v0HzviJV0Joo0X6sk+zAtKUvVmO2nRj+moYZ6IKeJSCgDa6McT0FU
         s++2J+iXcMXCRfl+O8RND6paml9POmBK6PYliKMf7+8m9ahOwSJZ0A50oz3MR94aZE/g
         ErH2MMfe60phW6+JAtmJskMQggdo5HLGZXCeByEAuJ9Y2/CnE61JAVTNW1zn2QEEl/+Y
         ovc2SAarj3Qi9jQ7cedEo7wajyxTZxRw65IQVI3oPVKVHmvr4Zx72vjDEdrQsEsUVy08
         3vdQ==
X-Gm-Message-State: APjAAAU5uCMQenbGnrjPW4FD0zP0/sJx/6BP88S1VEpQCmVFYiTeLtDA
        OgjrWYj5ciZz97qq4UYtb0FmyA==
X-Google-Smtp-Source: APXvYqwj4TEGAncFlIT2zELJctwJr1MUyMU/0ZOKpk54EoR/5vX6aLlJHM+/K53LPjhnuCgq8nnRhg==
X-Received: by 2002:a7b:ca4b:: with SMTP id m11mr6157196wml.144.1567761838079;
        Fri, 06 Sep 2019 02:23:58 -0700 (PDT)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id x6sm8508081wmf.38.2019.09.06.02.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 02:23:57 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, eyal@metanetworks.com,
        shmulik@metanetworks.com,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [PATCH v2 net] net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list
Date:   Fri,  6 Sep 2019 12:23:50 +0300
Message-Id: <20190906092350.13929-1-shmulik.ladkani@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Historically, support for frag_list packets entering skb_segment() was
limited to frag_list members terminating on exact same gso_size
boundaries. This is verified with a BUG_ON since commit 89319d3801d1
("net: Add frag_list support to skb_segment"), quote:

    As such we require all frag_list members terminate on exact MSS
    boundaries.  This is checked using BUG_ON.
    As there should only be one producer in the kernel of such packets,
    namely GRO, this requirement should not be difficult to maintain.

However, since commit 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper"),
the "exact MSS boundaries" assumption no longer holds:
An eBPF program using bpf_skb_change_proto() DOES modify 'gso_size', but
leaves the frag_list members as originally merged by GRO with the
original 'gso_size'. Example of such programs are bpf-based NAT46 or
NAT64.

This lead to a kernel BUG_ON for flows involving:
 - GRO generating a frag_list skb
 - bpf program performing bpf_skb_change_proto() or bpf_skb_adjust_room()
 - skb_segment() of the skb

See example BUG_ON reports in [0].

In commit 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb"),
skb_segment() was modified to support the "gso_size mangling" case of
a frag_list GRO'ed skb, but *only* for frag_list members having
head_frag==true (having a page-fragment head).

Alas, GRO packets having frag_list members with a linear kmalloced head
(head_frag==false) still hit the BUG_ON.

This commit adds support to skb_segment() for a 'head_skb' packet having
a frag_list whose members are *non* head_frag, with gso_size mangled, by
disabling SG and thus falling-back to copying the data from the given
'head_skb' into the generated segmented skbs - as suggested by Willem de
Bruijn [1].

Since this approach involves the penalty of skb_copy_and_csum_bits()
when building the segments, care was taken in order to enable this
solution only when required:
 - untrusted gso_size, by testing SKB_GSO_DODGY is set
   (SKB_GSO_DODGY is set by any gso_size mangling functions in
    net/core/filter.c)
 - the frag_list is non empty, its item is a non head_frag, *and* the
   headlen of the given 'head_skb' does not match the gso_size.

[0]
https://lore.kernel.org/netdev/20190826170724.25ff616f@pixies/
https://lore.kernel.org/netdev/9265b93f-253d-6b8c-f2b8-4b54eff1835c@fb.com/

[1]
https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/

Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
v2: reorder the test conditions, as suggested by Alexander Duyck
---
 net/core/skbuff.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea8e8d332d85..d540d00b93a9 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3670,6 +3670,25 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	int pos;
 	int dummy;
 
+	if (list_skb && !list_skb->head_frag && skb_headlen(list_skb) &&
+	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
+		/* gso_size is untrusted, and we have a frag_list with a linear
+		 * non head_frag head.
+		 *
+		 * (we assume checking the first list_skb member suffices;
+		 * i.e if either of the list_skb members have non head_frag
+		 * head, then the first one has too).
+		 *
+		 * If head_skb's headlen does not fit requested gso_size, it
+		 * means that the frag_list members do NOT terminate on exact
+		 * gso_size boundaries. Hence we cannot perform skb_frag_t page
+		 * sharing. Therefore we must fallback to copying the frag_list
+		 * skbs; we do so by disabling SG.
+		 */
+		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
+			features &= ~NETIF_F_SG;
+	}
+
 	__skb_push(head_skb, doffset);
 	proto = skb_network_protocol(head_skb, &dummy);
 	if (unlikely(!proto))
-- 
2.19.1

