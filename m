Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFC5AAB2E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 20:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbfIESg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 14:36:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37216 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfIESg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 14:36:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so3350966wro.4
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 11:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LUtFTWcoH9Wa00NdUp1MJqfK28DnqzwScRV0Z3qhU9Y=;
        b=WFQTW3F+Ua1O4q0fY+wZ7rU0lfpr+zNq2vZcmAX8sEmjfo1chXK4vpdXATM7FRB4wB
         N8Dq/hQL2qql6LXIONgd+j/UjODugdCi7r5ZO/nvkK98t1sTXKW0pLYbXk5/s4MLKCXP
         BY7JbdpI50vBA71HZFx9I1d4nrEUxIBhv0lZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LUtFTWcoH9Wa00NdUp1MJqfK28DnqzwScRV0Z3qhU9Y=;
        b=KZt7vQvCHee70+TPvQOXa2kHU18jYp2tRJr6+TeBzc8CnbgSKeFpyI9ya60Oolyq05
         7loq9SSHaZ3ztVQHUlrIGUMfugfJ3an8qYaqCSxRufO7nDhvp79/xQTXw5vh0hHk+3rM
         D8POevaIzPuga+MryRZ00cka0xeO0jDD6e4LXYcJHX4OZhcjml47hbQUWhT7ScpsD66i
         n2WX8i+Qi2uvm2EbNHzS2pk01Yfbt0GGNBoYEi+VJciUqetmIeA/4u5qx37FEDg/bJdc
         TX3YN2fB4zuHRyg+khpJc2V4Oug+6Gjy968k+OFu7Q8Ob9XqCCLd/sGyE6xjv1HOK4OQ
         mi1w==
X-Gm-Message-State: APjAAAVxJVFBH6l3VtqIJ++vo8V89FxWOusObvd3gl1ut2X14UPYT+hS
        xUSi487/fDHx43/rqrP1PsS1Pg==
X-Google-Smtp-Source: APXvYqxm8tywSmT64Gkrt5Dh2krTdjNqG6Boz/sLCpFLfNvLN9CBu5h90+3dus1t86lrvg5C33e4gw==
X-Received: by 2002:adf:f186:: with SMTP id h6mr3735091wro.274.1567708616437;
        Thu, 05 Sep 2019 11:36:56 -0700 (PDT)
Received: from pixies.home ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id o12sm3780036wmh.43.2019.09.05.11.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 11:36:55 -0700 (PDT)
From:   Shmulik Ladkani <shmulik@metanetworks.com>
X-Google-Original-From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     eyal@metanetworks.com, netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net] net: gso: Fix skb_segment splat when splitting gso_size mangled skb having linear-headed frag_list
Date:   Thu,  5 Sep 2019 21:36:33 +0300
Message-Id: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
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
 net/core/skbuff.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea8e8d332d85..c4bd1881acff 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3678,6 +3678,24 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	sg = !!(features & NETIF_F_SG);
 	csum = !!can_checksum_protocol(features, proto);
 
+	if (mss != GSO_BY_FRAGS &&
+	    (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
+		/* gso_size is untrusted.
+		 *
+		 * If head_skb has a frag_list with a linear non head_frag
+		 * item, and head_skb's headlen does not fit requested
+		 * gso_size, fall back to copying the skbs - by disabling sg.
+		 *
+		 * We assume checking the first frag suffices, i.e if either of
+		 * the frags have non head_frag data, then the first frag is
+		 * too.
+		 */
+		if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag &&
+		    (mss != skb_headlen(head_skb) - doffset)) {
+			sg = false;
+		}
+	}
+
 	if (sg && csum && (mss != GSO_BY_FRAGS))  {
 		if (!(features & NETIF_F_GSO_PARTIAL)) {
 			struct sk_buff *iter;
-- 
2.19.1

