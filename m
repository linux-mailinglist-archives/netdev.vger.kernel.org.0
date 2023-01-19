Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2565E673A91
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjASNl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjASNk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:40:56 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B987D7ED4F;
        Thu, 19 Jan 2023 05:40:51 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id az20so5796755ejc.1;
        Thu, 19 Jan 2023 05:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CMUIb1i0SSdDUFm8HTvgf+j8Q/DCD4qb7qVJ4MpR8lA=;
        b=ltXuOqJStljPEx7a0w7qyAjctJe7dK6RY9rL4/dpx3UYCCW/y+hXlnJ6JXBE1/6UMm
         wNhYSlQT3psCg19LcU26IAbPv3U6PUpXAm0Yao3Gfb+DnWKgJ7iBTqDh7Zxd3WjdhLsy
         WTsTU2xnEwf2x5fhIXnD9AJoaEOZih+T+kZ66KArBpEqwPi4+N+zf2C6k7OcCzYo3pd/
         93zFhngN9bpX+6Nj1ajAB9G06ZBJI/JlcM6ALBLE/NMPE5KKJFmYUknXD9rvj3QV8qb0
         L0wKPUrzmmMB+qE6/k2hZvRQSjLB8/W9bBErfoV5lCc3LdfGgxYZGgJsPiUjDqedf9h9
         8AaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CMUIb1i0SSdDUFm8HTvgf+j8Q/DCD4qb7qVJ4MpR8lA=;
        b=meyEJ0wYG2mHf8eKB0K3bdXOj9a8MU0ji6EaFlAKNVENnbt6EXGYymtI+wFOJCh4fq
         GK3IPdy1eGN+YTUFpBYSq5h7QkIH7cJT9Q7D4teE2CGC8oLnb9o4SZ3UmjZvUVUAh3cc
         tZbMERtE/guI8NScHqMTDv7AjA6EGOCRpmAGD1CDRvTavf8k8qhNxGeT2yHR5zEzrPx6
         lslbFcGNRHQ03k7VOODgXqvxpxeQELnQCCKMrHLn5oWYHcAcyoqheIh3zKJ1wdJxixNz
         /4MdLN6zLHb9ogP4/OfT73CwiLEtrWiJbuOIfK06xP5uAYcjb8LKANX+P3I2ElXhUjsV
         f7uA==
X-Gm-Message-State: AFqh2kpgO6BYH/UrNApvGMg9gNdWbvM9KWt5NMve/VSEnDmptNPy0doS
        KcqJIIvO6kp9wlfMvi5h5bGwUZEOVgwZBQ==
X-Google-Smtp-Source: AMrXdXvoisaos0uvpIRTVO1Xu0IEbvRYgK0FMqujJlTGucYpw+e7l7NBIrphN11N0xxhCFy5OCgoaQ==
X-Received: by 2002:a17:906:8995:b0:872:b18a:1ac8 with SMTP id gg21-20020a170906899500b00872b18a1ac8mr9553206ejc.4.1674135650187;
        Thu, 19 Jan 2023 05:40:50 -0800 (PST)
Received: from bulach.nilcons.com ([2001:1620:5344::4])
        by smtp.gmail.com with ESMTPSA id kw17-20020a170907771100b0084c4b87aa18sm16394335ejc.37.2023.01.19.05.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 05:40:48 -0800 (PST)
From:   Gergely Risko <gergely.risko@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Gergely Risko <gergely.risko@gmail.com>, stable@vger.kernel.org
Subject: [PATCH net] ipv6: fix reachability confirmation with proxy_ndp
Date:   Thu, 19 Jan 2023 14:40:41 +0100
Message-Id: <20230119134041.951006-1-gergely.risko@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When proxying IPv6 NDP requests, the adverts to the initial multicast
solicits are correct and working.  On the other hand, when later a
reachability confirmation is requested (on unicast), no reply is sent.

This causes the neighbor entry expiring on the sending node, which is
mostly a non-issue, as a new multicast request is sent.  There are
routers, where the multicast requests are intentionally delayed, and in
these environments the current implementation causes periodic packet
loss for the proxied endpoints.

The root cause is the erroneous decrease of the hop limit, as this
is checked in ndisc.c and no answer is generated when it's 254 instead
of the correct 255.

Cc: stable@vger.kernel.org
Fixes: 46c7655f0b56 ("ipv6: decrease hop limit counter in ip6_forward()")
Signed-off-by: Gergely Risko <gergely.risko@gmail.com>
Tested-by: Gergely Risko <gergely.risko@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/ip6_output.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 60fd91bb5171..c314fdde0097 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -547,7 +547,20 @@ int ip6_forward(struct sk_buff *skb)
 	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0) {
-			hdr->hop_limit--;
+			/* It's tempting to decrease the hop limit
+			 * here by 1, as we do at the end of the
+			 * function too.
+			 *
+			 * But that would be incorrect, as proxying is
+			 * not forwarding.  The ip6_input function
+			 * will handle this packet locally, and it
+			 * depends on the hop limit being unchanged.
+			 *
+			 * One example is the NDP hop limit, that
+			 * always has to stay 255, but other would be
+			 * similar checks around RA packets, where the
+			 * user can even change the desired limit.
+			 */
 			return ip6_input(skb);
 		} else if (proxied < 0) {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
-- 
2.39.0

