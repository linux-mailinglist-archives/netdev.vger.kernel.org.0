Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BB81B9827
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 09:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgD0HOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 03:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgD0HOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 03:14:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A482C061A0F
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 00:14:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k18so6658310pll.6
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 00:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aQ0Hmtb05QO/vAfz4r5C1kdHH58nw+L3b1XDKFZB5uQ=;
        b=fI9WlxdSzJo1/ZtV3gpfV28gT6uRt4LnXBh7rpzivp5eYCT5gGLTw3XKeFtg0rjmYF
         7g8Cw7SET0GiX2WpeXP4OerZbvqykiccn8cQkp9uxKrhU9ekhoZMxAkn4sfnpv+HHqOe
         IjKd9dcBfvXk/FHpwOpTsNQpHi4SFZo3l6HbF6ZodK/ZXNs8JRKgyDGejMWhNJHYErCb
         UYscDbkHlhfmUY5XeQ2vN97yYjXEDOqU/3Gg8NlZbWDD64r/rSJReQe92p2CRU00C3IE
         f0LFrThEalkItYoyDB5p52JgRGRdmWrli4M0Cj5Od1C+s6O1uvg7XyI1vz3mbp4bR9+E
         WKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aQ0Hmtb05QO/vAfz4r5C1kdHH58nw+L3b1XDKFZB5uQ=;
        b=SeYLuJJX1rL6RsA1S44uTLTHp5/73yBnE56P9M+TSG350r7u22fVvVgfzn5KWrSIbY
         JkfqHp9sqm1FlD1ZhduGn4nHxknhIeON3//5KpX72EfF1hy2JCQTbrnOr7KakzAj2fWN
         HsWFhOgq2T2kNkqTGrRvZA38CZr9/ots/k57g8+juNAA2LcsBGwvWYnLQgkX8lLjUY9I
         M5CE8LFUhh5fOo3nPZa3ZvdQ0nJFLPD8WmYlsgTVrpWoagtP03PCSRPWjb1zp2IJ0uDH
         xI80rAcA49II1h6uwqd1f1XRERi5NKgDmeAm/rJ7gXf/E+pGcM92zdce0qCCfO+mFgYk
         NeBg==
X-Gm-Message-State: AGi0PuaGoSwYJDt0TcV4fd3wr5ydXRfFrK7iVT7mEVqm40O1ntqQlw1i
        wu9kFUwX6myPirWR5LrOVwN/Od7L
X-Google-Smtp-Source: APiQypJGKFoo75JQCUs4lvU3JLIYtxZ9PsefIykRLAjeLEqMsvYPi+5VrG2S2DR+IXDvCyn6u96vQA==
X-Received: by 2002:a17:902:70c1:: with SMTP id l1mr20881361plt.298.1587971672264;
        Mon, 27 Apr 2020 00:14:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 10sm11457489pfn.204.2020.04.27.00.14.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 00:14:31 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     David Ahern <dsahern@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        aclaudi@redhat.com
Subject: [PATCH iproute2] xfrm: also check for ipv6 state in xfrm_state_keep
Date:   Mon, 27 Apr 2020 15:14:24 +0800
Message-Id: <a5e26e7eb3172c2ddebdc5b006f3afaf3e4adb5c.1587971664.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As commit f9d696cf414c ("xfrm: not try to delete ipcomp states when using
deleteall") does, this patch is to fix the same issue for ip6 state where
xsinfo->id.proto == IPPROTO_IPV6.

  # ip xfrm state add src 2000::1 dst 2000::2 spi 0x1000 \
    proto comp comp deflate mode tunnel sel src 2000::1 dst \
    2000::2 proto gre
  # ip xfrm sta deleteall
  Failed to send delete-all request
  : Operation not permitted

Note that the xsinfo->proto in common states can never be IPPROTO_IPV6.

Fixes: f9d696cf414c ("xfrm: not try to delete ipcomp states when using deleteall")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/xfrm_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index d68f600..f4bf335 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -1131,7 +1131,8 @@ static int xfrm_state_keep(struct nlmsghdr *n, void *arg)
 	if (!xfrm_state_filter_match(xsinfo))
 		return 0;
 
-	if (xsinfo->id.proto == IPPROTO_IPIP)
+	if (xsinfo->id.proto == IPPROTO_IPIP ||
+	    xsinfo->id.proto == IPPROTO_IPV6)
 		return 0;
 
 	if (xb->offset > xb->size) {
-- 
2.1.0

