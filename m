Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A865A6D48
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbfICPv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:51:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33569 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfICPv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 11:51:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so353665wme.0
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 08:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcej02/ggYKQ23l4EotosdqtLEz7ClY8EjYNWb/wmDI=;
        b=OvimCZPI6HlNyE4N1jNmR/j7cLo1jKG+bTuM/E4/+mW5UiImo2iG4CfgQABNwKQqB7
         6jGD2F2hbTNfFliYrXEecoZk9zJUD20J3SMd5fcBJyoUCo6VVii5YtL/VYAJw4PVNIH2
         gHqVwbf4kyEZY1GO3dRC66bDZAzYfIXKqmfqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcej02/ggYKQ23l4EotosdqtLEz7ClY8EjYNWb/wmDI=;
        b=EjLDMIhJ/bJk2Y4uqbP5gfR7jN4Vw3qEkYaJUjiX1/1V2TjuAKIRNv7NnQ55744YYR
         PRx0zlFm05Tw8Uq5kJr+y13Tb+qyiBwvBzWlIi75EYPOn0dQ9V9KBrXtbXSzMUkvUUpQ
         q2Zk/3hYWsrJ98HVMVT9eqn4iQVAlXIpnV342ErN+XeXIn8eoS4Q0aXVeoMxFLkXZqXP
         pqBa+fJzPzQB5S481pqPM11JzYsa8Dm22WDLcrlQ5nundG9kwiCh8JoXehg7wAwA+IP+
         y49JvzPg6FVzMnrl/UWtjvxkuYwVwUBFcwbZnSRlQvAiMEOcvwSGe92xaafcuk+Dr5Dq
         dk5w==
X-Gm-Message-State: APjAAAWdbse3q1v321Bo8ngf4Ksk05himuz/JprOPLdUkUsfbvdDyd/F
        oq7BTb/GqY6btft+eVflM0cB9g==
X-Google-Smtp-Source: APXvYqw6pB44OUmiVd8sbdp1bEGbbF/VNgm7dDpozVbYPWVrFTTxAwecfqcQMM8MltftzO9qvHU1rg==
X-Received: by 2002:a1c:f703:: with SMTP id v3mr857947wmh.107.1567525884317;
        Tue, 03 Sep 2019 08:51:24 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id g15sm17888446wmk.17.2019.09.03.08.51.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Sep 2019 08:51:23 -0700 (PDT)
Date:   Tue, 3 Sep 2019 18:51:21 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190903185121.56906d31@pixies>
In-Reply-To: <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
References: <20190826170724.25ff616f@pixies>
 <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies>
 <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
 <20190829152241.73734206@pixies>
 <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Sep 2019 16:05:48 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> One quick fix is to disable sg and thus revert to copying in this
> case. Not ideal, but better than a kernel splat:
> 
> @@ -3714,6 +3714,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>         sg = !!(features & NETIF_F_SG);
>         csum = !!can_checksum_protocol(features, proto);
> 
> +       if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag)
> +               sg = false;
> +

Thanks Willem.

I followed this approach, and further refined it based on the conditions
that lead to this BUG_ON:

 - existance of frag_list
 - mangled gso_size (using SKB_GSO_DODGY as a hint)
 - some frag in the frag_list has a linear part that is NOT head_frag,
   or length not equal to the requested gso_size

BTW, doing so allowed me to refactor a loop that tests for similar
conditions in the !(features & NETIF_F_GSO_PARTIAL) case, where an
attempt to execute partial splitting at the frag_list pointer (see
07b26c9454a2 and 43170c4e0ba7).

I've tested this using the reproducer, with various linear skbs in
the frag_list and different gso_size mangling. All resulting 'segs'
looked correct. Did not test on a live system yet.

Comments are welcome.

specifically, I would like to know whether we can
 - better refine the condition where this "sg=false fallback" needs
   to be applied
 - consolidate my new 'list_skb && (type & SKB_GSO_DODGY)' case with
   the existing '!(features & NETIF_F_GSO_PARTIAL)' case

see below:


@@ -3470,6 +3470,27 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	return head_frag;
 }
 
+static inline bool skb_is_nonlinear_equal_frags(struct sk_buff *skb,
+						unsigned int total_len,
+		                                unsigned int frag_len,
+						unsigned int *remain)
+{
+	struct sk_buff *iter;
+
+	skb_walk_frags(skb, iter) {
+		if (iter->len != frag_len && iter->next)
+			return false;
+		if (skb_headlen(iter) && !iter->head_frag)
+			return false;
+
+		total_len -= iter->len;
+	}
+
+	if (remain)
+		*remain = total_len;
+	return total_len == frag_len;
+}
+
 /**
  *	skb_segment - Perform protocol segmentation on skb.
  *	@head_skb: buffer to segment
@@ -3486,6 +3507,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	struct sk_buff *tail = NULL;
 	struct sk_buff *list_skb = skb_shinfo(head_skb)->frag_list;
 	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
+	unsigned int type = skb_shinfo(head_skb)->gso_type;
 	unsigned int mss = skb_shinfo(head_skb)->gso_size;
 	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
 	struct sk_buff *frag_skb = head_skb;
@@ -3510,13 +3532,29 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	sg = !!(features & NETIF_F_SG);
 	csum = !!can_checksum_protocol(features, proto);
 
-	if (sg && csum && (mss != GSO_BY_FRAGS))  {
+	if (sg && (mss != GSO_BY_FRAGS))  {
+		if (list_skb && (type & SKB_GSO_DODGY)) {
+			/* gso_size is untrusted.
+			 * if head_skb has a frag_list that contains a frag
+			 * with a linear (non head_frag) part, or a frag whose
+			 * length doesn't fit requested mss, fallback to skb
+			 * copying by disabling sg.
+			 */
+			if (!skb_is_nonlinear_equal_frags(head_skb, len, mss,
+						          NULL)) {
+				sg = false;
+				goto normal;
+			}
+		}
+
+		if (!csum)
+			goto normal;
+
 		if (!(features & NETIF_F_GSO_PARTIAL)) {
-			struct sk_buff *iter;
 			unsigned int frag_len;
 
 			if (!list_skb ||
-			    !net_gso_ok(features, skb_shinfo(head_skb)->gso_type))
+			    !net_gso_ok(features, type))
 				goto normal;
 
 			/* If we get here then all the required
@@ -3528,17 +3566,10 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			 * the last are of the same length.
 			 */
 			frag_len = list_skb->len;
-			skb_walk_frags(head_skb, iter) {
-				if (frag_len != iter->len && iter->next)
-					goto normal;
-				if (skb_headlen(iter) && !iter->head_frag)
-					goto normal;
-
-				len -= iter->len;
-			}
-
-			if (len != frag_len)
+			if (!skb_is_nonlinear_equal_frags(head_skb, len,
+						          frag_len, &len)) {
 				goto normal;
+			}
 		}
 
 		/* GSO partial only requires that we trim off any excess that
