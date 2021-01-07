Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897FE2EC9E4
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 06:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbhAGFPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 00:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbhAGFPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 00:15:33 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7341C0612F0
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 21:14:52 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 15so4040887pgx.7
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 21:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NLprhE221W8Y44gf25+2XoRY56lX8csC/Px69mDE28k=;
        b=iZ03kWM+ntzj/gXfWg7gi/xd3cFsL5prZYrUG4dbqxrU0Ltvj8PdOmTYreSR76eXrV
         m+HaziQpXjNfKDoDX+nLcxmPJi90cUogjCkQ8RdEQhEnOaWDJWpRaaSlil/1n1mHjBrE
         DJDFFvfUuykWinkYYlVYebeSKnmQFxf12SVcHK0bWw7m93tDM0cyAB0j5RrPyrD2pQJx
         Sez+bbsxcYXHaB6enOqXmV2nES/DHNvVT+VjKfI8fNDvqsrIS/8ck3vWPIj3rk7n0JYZ
         kNC13fGx0K8estrJTYl1HLORYBrreWjuhKUSoZUq8Rj7O81znFdZiS1GuNPeJWhkH3zH
         atSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NLprhE221W8Y44gf25+2XoRY56lX8csC/Px69mDE28k=;
        b=Hhz9Zmnt5Aiq2Za6YQHaTLCZUXtrEhw6x/oefLWR3jQ/WfB6Sp4p5Eo3C1nFFdywb6
         TvAJxU5fYmh/1olJjB4Y7zstak/QETHWfgMJl6bCMe+apfT+02dPj6TJ7hVApVJj2Pb7
         TLuZ4tZ2nymsPfRUFWkshFyQrHZFk6cvRMCTjG49++B6zVwlL6/tanvpZTLEYq8IqIB1
         wAcWTYJ7YW7sy9kPinKBk/vpyOH0hvAmfBymraYYB4q95VRLRzkiwybbtZDilISYVPkf
         VlQrI53+Q5XHI9Od1PEjUrDKdnMdc10BcB/IRM+tM47X7W1tFrpzZJDO+Z9mcLDmaSu8
         SfNw==
X-Gm-Message-State: AOAM530KJfJ2zzXSV3mAAi9pYocBRy+yfacEvRRoLeLjpueb6zOAmEZv
        PhaPfqol5+59ypGuXIHug4FcH31EyDnQRg==
X-Google-Smtp-Source: ABdhPJxzcr7ZF04cbJD5K1qJMe2UtGefvTS/I9BMHJAu99YAlpjMoJvT6BN56iubuesLcMdk+towOQ==
X-Received: by 2002:a63:d650:: with SMTP id d16mr80089pgj.277.1609996492469;
        Wed, 06 Jan 2021 21:14:52 -0800 (PST)
Received: from localhost (natp-s01-129-78-56-229.gw.usyd.edu.au. [129.78.56.229])
        by smtp.gmail.com with ESMTPSA id m13sm4089247pff.21.2021.01.06.21.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 21:14:51 -0800 (PST)
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>
Subject: [PATCH] rxrpc: Call state should be read with READ_ONCE() under some circumstances
Date:   Thu,  7 Jan 2021 16:14:34 +1100
Message-Id: <20210107051434.12395-1-baptiste.lepers@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call state may be changed at any time by the data-ready routine in
response to received packets, so if the call state is to be read and acted
upon several times in a function, READ_ONCE() must be used unless the call
state lock is held.

Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
---
 net/rxrpc/input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 667c44aa5a63..dc201363f2c4 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -430,7 +430,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		return;
 	}
 
-	if (call->state == RXRPC_CALL_SERVER_RECV_REQUEST) {
+	if (state == RXRPC_CALL_SERVER_RECV_REQUEST) {
 		unsigned long timo = READ_ONCE(call->next_req_timo);
 		unsigned long now, expect_req_by;
 
-- 
2.17.1

