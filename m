Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E38634B18
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 00:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiKVX1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 18:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiKVX1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 18:27:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF6A13F53
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 15:27:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t9-20020a5b03c9000000b006cff5077dc9so14777573ybp.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 15:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N4Pb5W255LH0BWY4yuGbMLQMKFxJAPzH0I4oKHVGlwI=;
        b=tVENbIig4zypZwKmQ8inC+vVevHwdkxN3+2CDSJoyit+ZLSa3OQ4M0yZm3xuNJO/iV
         pvnLbIBWaitur/9N2aB6j/szXg4KaoROCYpX4flHftkXwcK66thm3kcTyd9bnlipNvSp
         PWPoohMT/PRh0llw7fLXgxR7OhfPTw7AJrhwAlpxgp6UAFE0IaCqZtX8mubLKclEz6wc
         2O4cPZ0Cl0jpm+/fTry6Zz5GDpQNezmUf/49rA72ZIM4HFA+XHecxlsB3MMRZ0OoLlJH
         Vc09rEmxO4npluR0WxsxMhFasByZzrilkdWYFt8ntObt6mdFvGtnhr3GuYwcmN8npbbc
         Q87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4Pb5W255LH0BWY4yuGbMLQMKFxJAPzH0I4oKHVGlwI=;
        b=aCMDSh8OxkZJp1E+zauYmhWVLdGYMeug5hHGETmHCtg6uuNnaHShedd1f4n6EdFw4o
         UdfFDhO29hIwDk4E4VICQIoPeX+jaOyj3BMpLniIcsZyp5ESldIc6yIgQIslDfKccTW7
         VbiodlndABOr240m36XIfJoU7IBmMTkGmvyOGmdM5YIO+UCNUa32DBEckzzwzXnIB0Rg
         wwPDaghokk4Jmk2GGjYPH701v37PBxEkd3I1j8B2NbvER9qIGX+B3K6ivUD3A9INGuTI
         mCLzc/nupvQb/JE00GdZyuZxKk5uezmVi/gQTLtJYuWaSbJ9Cvi//ob6/R2vKLiIEfDJ
         KIXw==
X-Gm-Message-State: ANoB5pmA1wAimmu//krBYebmLhk5ykSoBDxBtYwSgQzjoqAWHVeLy79C
        MIIlEYoJDIIeg+Fm6wNlQup98hewIsXnTOU=
X-Google-Smtp-Source: AA0mqf42bfNpTOml3MJHabsYQcaCcTsvpPcVIO5IEruG4W+jbp53gU1Gfr3f/2CEFTxs1utakT5+0Rxl3Wr/twU=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:d85f:1168:cf63:556b])
 (user=lixiaoyan job=sendgmr) by 2002:a25:738a:0:b0:6ca:18d4:db86 with SMTP id
 o132-20020a25738a000000b006ca18d4db86mr24881575ybc.111.1669159663938; Tue, 22
 Nov 2022 15:27:43 -0800 (PST)
Date:   Tue, 22 Nov 2022 15:27:39 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122232740.3180560-1-lixiaoyan@google.com>
Subject: [PATCH net-next 1/2] IPv6/GRO: generic helper to remove temporary
 HBH/jumbo header in driver
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6/TCP and GRO stacks can build big TCP packets with an added
temporary Hop By Hop header.

Is GSO is not involved, then the temporary header needs to be removed in
the driver. This patch provides a generic helper for drivers that need
to modify their headers in place.

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 include/net/ipv6.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d383c895592a..a11d58c85c05 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -500,6 +500,39 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
 	return jhdr->nexthdr;
 }
 
+/* Return 0 if HBH header is successfully removed
+ * Or if HBH removal is unnecessary (packet is not big TCP)
+ * Return error to indicate dropping the packet
+ */
+static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
+{
+	const int hophdr_len = sizeof(struct hop_jumbo_hdr);
+	int nexthdr = ipv6_has_hopopt_jumbo(skb);
+	struct ipv6hdr *h6;
+
+	if (!nexthdr)
+		return 0;
+
+	if (skb_cow_head(skb, 0))
+		return -1;
+
+	/* Remove the HBH header.
+	 * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
+	 */
+	memmove(skb->data + hophdr_len,
+		skb->data,
+		ETH_HLEN + sizeof(struct ipv6hdr));
+
+	skb->data += hophdr_len;
+	skb->len -= hophdr_len;
+	skb->network_header += hophdr_len;
+
+	h6 = ipv6_hdr(skb);
+	h6->nexthdr = nexthdr;
+
+	return 0;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
-- 
2.38.1.584.g0f3c55d4c2-goog

