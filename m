Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469FA49D6CE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiA0Agm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbiA0Agl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:41 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE137C06161C;
        Wed, 26 Jan 2022 16:36:40 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id p12so1391900edq.9;
        Wed, 26 Jan 2022 16:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UxDNgTAE0cSB8ZQYqqnLx7ARkRkGdeZUWmVAeW7wE8w=;
        b=UxNN2e4QMjiLRB3KjFk+d0964K5zS0bXfNJq5W2+9QhwH7rL8wHwommwe6im9aR0AW
         d+tb1OD2FL48Ue8s8kgOEq0lGC1BKcGReMkE2NUl0EP2iHQmm6n+7cgzkchvY60mB7TX
         CcGrk9IDvDPw/nKbBiEb3GmJF3FDr+PdQU0p2ogqN8nq3drU/dhrN3dsUG9+7+ysLRHc
         3JNN8rFwme1Gw4O85Jv/U5yEB5JsVa0NYWM/2VBvI4cLSnYmdTaWBdQAt42v0OBEw8Xr
         qhnlmOZUxIgwmp92EIscfExtu1NPReSGR1k0nAUlRtueAL6fA3tfQj/8TBysIjZO/7kO
         ostg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxDNgTAE0cSB8ZQYqqnLx7ARkRkGdeZUWmVAeW7wE8w=;
        b=nfNy/UyAvrGe91dPOAcU9R7ZLpwyH96kL4W/B8UfoxVGo0BjEEcIcOUG03K4GVxjKK
         crQ3dYh5VwBxg6QzgE7m9j0Yo/VM1XD83b7hFEKV8s6KXvQ/te2jQNrf7yW3QtkIqJaZ
         Wek214noTo3xBmoocz8vxO3Gj6g5x/J13J+a16GMGBYyhXsdREV+a1/ROYmUljcVh6bl
         nbQlFtQUGc4/gxmmacJIP3oW+f2Ze/hGt0mZlZrd6su/CT+Lwp69ALOnKXAXXBDWVeK4
         4hhoTXlqd39GWoZUtxv/yhuBjmGceFE6TQXQaJa3DOsYYbc5ElUrFijHJVaoJ5y3DXDo
         ct7g==
X-Gm-Message-State: AOAM531wtpUjBivDqd4IbxPRQL86w12wXZPRRywfz74LoLDBOUTUA94z
        thTGyY+wqvXe+DbQjz3CofX2szqcqU8=
X-Google-Smtp-Source: ABdhPJwshQN22vMvwSvlXUoR6HtvGLQALyZ8baZxG/wowQuClI85f3xbh7x0WKqRxzGhByAZEhZxjA==
X-Received: by 2002:a05:6402:2898:: with SMTP id eg24mr1456329edb.142.1643243799013;
        Wed, 26 Jan 2022 16:36:39 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 02/10] udp6: shuffle up->pending AF_INET bits
Date:   Thu, 27 Jan 2022 00:36:23 +0000
Message-Id: <54bfbd199f8e371333082a123de432211248eaae.1643243772.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corked AF_INET for ipv6 socket doesn't appear to be the hottest case,
so move it out of the common path under up->pending check to remove
overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 528b81ef19c9..e221a6957b1f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1363,9 +1363,6 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	if (up->pending == AF_INET)
-		return udp_sendmsg(sk, msg, len);
-
 	/* Rough check on arithmetic overflow,
 	   better check is made in ip6_append_data().
 	   */
@@ -1374,6 +1371,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
 	if (up->pending) {
+		if (up->pending == AF_INET)
+			return udp_sendmsg(sk, msg, len);
 		/*
 		 * There are pending frames.
 		 * The socket lock must be held while it's corked.
-- 
2.34.1

