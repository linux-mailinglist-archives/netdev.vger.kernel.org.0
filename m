Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE38D614A3F
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiKAMBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiKAMBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:01:40 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5630A63F0;
        Tue,  1 Nov 2022 05:01:39 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h9so19857368wrt.0;
        Tue, 01 Nov 2022 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dDiFLbcCPs9I3+qSQ2/UHfejkBwzWQ533NU4ZUsGCPY=;
        b=AECDTUUM7wPd78XMLMkzvlsVEc+oowtP7u+lfBMn+oxn2MelQNpZ5WiTFK+33zC9oQ
         AoIHVqndwGCRvMZwS0ecfzu2a1jw0yI15Y+BULVfPJQNRQIcq13MojBOtutuZIj5W+V/
         GaZH5hxLK5yG9DZKgcgNu6/WqrUd7+meIfaLdVf96San3sh8Nxy9Mej8yr+lcIKGiqX7
         80MxdWmkR0YhVa/FrIi3kIZvXHLjsusAGUrPXZDRdJ4Rzo0RLyoLOZyIQgm1N9F8I1HI
         zVRSO+lZurvyBZ8qJrme6uzzK7Ewv+LR4m97k8uKsXnLeKURdMMTU/qMEXRDrpJUTytB
         PrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dDiFLbcCPs9I3+qSQ2/UHfejkBwzWQ533NU4ZUsGCPY=;
        b=GGvcz1uauXsZIaX7KvpyKauRp5Pgrhe4CXWR7HrcgoL1dgxopmUsU1DA6p8fyEBfdx
         n7bC4foXOQudM26Ms72mIyc0hRbmeDMtlTPnwGxRhOyrFdJtwR6QDxqfuWx+1d85n9UK
         p16sEOZuOJncVSa+iobcmLa+rxr1QNGNZjsd9zvFD3jyFFYy4p8VcvOat4Wu5cn8Mdiz
         jEXN0F82btvYFsm60ZiumA/02IM94Zu8uRUJZsWKg43cD1W3g/vYvcHcD7pEm142JEy7
         WaB6kN8gD2CLFrF6Nt47ahEfT4zoJm74MX2ZFEpDsQw0rKgTdKOPbUK4PqjfsIdj19ax
         2lqg==
X-Gm-Message-State: ACrzQf2leJwQBrEoNNXy6eAZwVXfv5kaR8EwtTzIjekhhAaJHgzl00DB
        rPSKsuz/DuotnXFQRCxqyxk=
X-Google-Smtp-Source: AMsMyM4IPeCSlhIxX9MDs5ZpryesBGdS/XtcwW29lM+9nZKxAkZNflGe+Tq7Ive1xQtRrsJ597EcfA==
X-Received: by 2002:adf:dbc5:0:b0:22c:c605:3b81 with SMTP id e5-20020adfdbc5000000b0022cc6053b81mr11287837wrj.218.1667304097843;
        Tue, 01 Nov 2022 05:01:37 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id m13-20020adffe4d000000b0022afcc11f65sm9911489wrs.47.2022.11.01.05.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 05:01:37 -0700 (PDT)
Date:   Mon, 24 Oct 2022 07:17:49 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
        richardbgobert@gmail.com, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] gro: avoid checking for a failed search
Message-ID: <20221024051744.GA48642@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After searching for a protocol handler in dev_gro_receive, checking for
failure is redundant. Skip the failure code after finding the 
corresponding handler.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 net/core/gro.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index bc9451743307..a4e1b5a5be64 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -522,13 +522,13 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 		pp = INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
 					ipv6_gro_receive, inet_gro_receive,
 					&gro_list->list, skb);
-		break;
+		rcu_read_unlock();
+		goto found;
 	}
 	rcu_read_unlock();
+	goto normal;
 
-	if (&ptype->list == head)
-		goto normal;
-
+found:
 	if (PTR_ERR(pp) == -EINPROGRESS) {
 		ret = GRO_CONSUMED;
 		goto ok;
-- 
2.20.1

