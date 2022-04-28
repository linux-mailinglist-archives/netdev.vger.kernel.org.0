Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F1F5131E2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344921AbiD1LA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344881AbiD1LAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:00:52 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23737939A2;
        Thu, 28 Apr 2022 03:57:38 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id t6so6249550wra.4;
        Thu, 28 Apr 2022 03:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Um7nfo9XPd/rjD8amGsCD9u/7MH/cL46Hqd0sO1U0M=;
        b=JyPrwcyF8T9Eff+fQ9huPKkq+0WIAHNOPon9U7CNftVgbHGH1pVjRsUl1MNJNE8VkF
         RXCGQ3NwpBkmR+i1TB73wUX0CMQ+2mxr6jEnRe4SMiS23IgZAgjziDTcjtxb9MZn9m5J
         LO0sPwKYJoFlKy0feN8/rJVmaGhcFWY/Ac/VGNESNSor8MF6jN4iOyONTQlfOa9dyxQ7
         f6MkAYLthGIlUxvSpqr3UlBohxcI5oMH7Opguox2Rlm12AtAOY5bTKJjRnk17twzY/89
         OXRUC57id0QUdKSCnSq+zuVMZcBf1OuVYT7Ds/FDKWFMFgODtEw4XolHYUvC6YQlDwUp
         fGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Um7nfo9XPd/rjD8amGsCD9u/7MH/cL46Hqd0sO1U0M=;
        b=dWjDCVa3XlnQ57ix986T72XvalnDb1xFgQBai5CCTMW9ii/NGYXQu01fCbxH/ISxS9
         g4DmtPzUUhqcNnV0Dbs7YPafjV4yt8TZ+5ae8iBQzfaCKfNemFNi8m3wHgVrmLbwfBzZ
         SD4MoIZze2K6zHEzCs4Ub5nkCk+bFh+cR7jGiprM1vIPA/DMdJZIu4ooEcXwfASUaYyF
         1Fr25PiCyNkIBpzI815b3OklwjbpnjC1RqSVWwTU4Esll873PPDuOU8NfmL/5abKybec
         iYjAJhR5NS4B/9plZ3hvlku2G0k/yworAX0mRD+rH51maDOo/VGri0RuLPRiD5H+kx9N
         RIZg==
X-Gm-Message-State: AOAM533/PpR7DaJ+6Hwvz5xJSMOsRxuxuEdH5mEMKgYLHtaiVDPf+vOE
        yjZbizIf8kelYM87aq+DJvyxhecOLJs=
X-Google-Smtp-Source: ABdhPJxbWrCfVQ76VD+tkju8CQX+VznsSkNPVjEMltG6HBvAtcBCwftL+5GYQWFubiXA2t8NYZTlJA==
X-Received: by 2002:adf:e10e:0:b0:206:2d7:b4de with SMTP id t14-20020adfe10e000000b0020602d7b4demr25260940wrz.497.1651143456538;
        Thu, 28 Apr 2022 03:57:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm7547wmi.33.2022.04.28.03.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:57:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 06/11] udp/ipv6: optimise out daddr reassignment
Date:   Thu, 28 Apr 2022 11:56:37 +0100
Message-Id: <e66e22f3f148e3bd5911fe4483af39088a74e684.1651071843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
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

There is nothing that checks daddr placement in udpv6_sendmsg(), so the
check reassigning it to ->sk_v6_daddr looks like a not needed anymore
artifact from the past. Remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 1f05e165eb17..34c5919afa3e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1417,14 +1417,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 		}
 
-		/*
-		 * Otherwise it will be difficult to maintain
-		 * sk->sk_dst_cache.
-		 */
-		if (sk->sk_state == TCP_ESTABLISHED &&
-		    ipv6_addr_equal(daddr, &sk->sk_v6_daddr))
-			daddr = &sk->sk_v6_daddr;
-
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    sin6->sin6_scope_id &&
 		    __ipv6_addr_needs_scope_id(__ipv6_addr_type(daddr)))
-- 
2.36.0

