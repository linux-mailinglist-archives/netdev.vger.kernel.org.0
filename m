Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E0A5B5C9F
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiILOs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 10:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiILOsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 10:48:25 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F322F3B7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 07:48:24 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w16so5401473eji.9
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 07:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date;
        bh=bu91Jo4qZYYKaFz+IgsQe57RKQEYi1IMyZ/qm1m5MSA=;
        b=n6uxG9+5tCDOXUmd5HLcQjWjKe7s6Ts+bs2zJCX1RxPvjp/GZMhAN/+4o/m4pGBbkE
         5WSqIo0sONvNACbll987bVhEVXh4396agkyg9XDcqy3WSDJ66QNl4eZ9SSmHSuJGdnDS
         yBqwP4M7xqi1vxqijr74ml4p4tjjd7BFi84fTwm1CkaCfp0LrwKiW6wP8EY0LyV2N5mq
         kp72RBAD12ID3IqJbBZdLv3xwSn247h8n2J+qyx3085wCpBo6ctZp/88gem1wghhpLE+
         Gn7vZnO7aQDS4oUQB2eB05N9CwyhiYHEuDW68Aaw0Dm1BbL5UQ0voyjMAF70JytnHDWF
         5ODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bu91Jo4qZYYKaFz+IgsQe57RKQEYi1IMyZ/qm1m5MSA=;
        b=tlpgDRVceeUykF7t2rQjZGaE3eY3LGkNS0TmiCFW+OXvKWTBd1jhu9z+34AIuGEz4z
         0xd/XJRCZnS/beTORK69SWUBth0OiwmfAu6etvZMYFIdWZ6w/qmoeiRLJE54NsrrCm0g
         xZ9kFsr8lhrV+q6iN9MQcfjJvgpr8grbhbd3IaixYj2hE+9+14D1hGtDa3irlYVy1JoC
         AT0vyC5lW1VGA9o6cQY3uYXAIkA/CZ6W7wevDIfh2ZBNhWlDv+vVgZDuJ7cTvYjgSlom
         lLoBwbhFQDnUoBM7CT/C6jaAMK7WPTQqSuOwtrofRTmcMEHJbrwPQWVRSMz0mOUWlfLA
         MHkg==
X-Gm-Message-State: ACgBeo0+3aO6iwSGq2ppSyRjACwJISb8bYsRw59mYi15Wwb+3FZiZifd
        rXRV7YAxxI5rQT9601axj7U=
X-Google-Smtp-Source: AA6agR41L9iuTlOE2WniCiXnoDcF3D9eywWcSlDl7HvstytviLkR1SM7L7s7c7PQk8E5rFxVoKc/Xw==
X-Received: by 2002:a17:907:2c4f:b0:77d:f3eb:f079 with SMTP id hf15-20020a1709072c4f00b0077df3ebf079mr2921012ejc.356.1662994102412;
        Mon, 12 Sep 2022 07:48:22 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id g2-20020a50ec02000000b0043bea0a48d0sm5849647edr.22.2022.09.12.07.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 07:48:21 -0700 (PDT)
Date:   Sun, 11 Sep 2022 20:48:49 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH] net-next: gro: Fix use of skb_gro_header_slow
Message-ID: <20220911184835.GA105063@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the cited commit, the function ipv6_gro_receive was accidentally
changed to use skb_gro_header_slow, without attempting the fast path.
Fix it.

Fixes: 35ffb6654729 ("net: gro: skb_gro_header helper function")
Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/ipv6/ip6_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d37a8c97e6de..f00fd67fd0c4 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -219,7 +219,7 @@ INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
 
 	off = skb_gro_offset(skb);
 	hlen = off + sizeof(*iph);
-	iph = skb_gro_header_slow(skb, hlen, off);
+	iph = skb_gro_header(skb, hlen, off);
 	if (unlikely(!iph))
 		goto out;
 
-- 
2.36.1

