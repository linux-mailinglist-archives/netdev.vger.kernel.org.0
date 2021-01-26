Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2409304CCF
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 23:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbhAZWze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728522AbhAZFL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 00:11:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1051C0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:11:15 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id g15so1540331pjd.2
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=8zI0z6PsRTynRKh6e71DfIuyhsI8vL8xX2yQHpfIqAA=;
        b=uvd0W8d5cTnC7sD0n7v9hurT+og+/OH3aNWzkiel61DMS6A/2SoVzIkSqOMn0/7O/s
         bIadlKwQh04D9n5fS5ZyvrTdSjGTyywHKbF39+O+MMwdxZXq4swhQA0ytf08CXCSdVF/
         mkPracklWGZcXQMyLMWsTiaJgEu1mrze1TLTtcUrNEgs/DwXbdXeP0+jVPvZj6ubDvHk
         Ms1xN3H9RAdwiKRBC1nSPbhXF4SZzMC7iZtZkEz3zOAXQMY/fQ2SYuRyXZjblX9gPpHK
         VZykJS05QK8iRsMRpbpMQXQbS+HugJxzZJJQCR0ojHNuJNZ83iH7RzWDHAEP8ynP4Xxc
         MqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=8zI0z6PsRTynRKh6e71DfIuyhsI8vL8xX2yQHpfIqAA=;
        b=LNQ32n8d4tnSkJW1vCljZQoq0TMEtnRMdroTJ2wH8g+9lpNbrDkcIW1X9eKN3Itbd3
         OflgyKO72OpW9317uV3MkJwuhwsu1hh0EQRAg+/UJC+H3kcYNzQZnqovH4nmd0vOtFhj
         3Vyi2Mg4Y+cMe+1LxJ+tvsFcf0xEhIzzm5YEBTQOi0mZFVM90smivA+UiqoOodjWJQFY
         7sHJYqp6caFyf/ixbHxcQ1C3PKDPFC1ql2uWlkTH5utE2dIL+m+x8H9+/5N7k2E2yDcS
         oTBwEpIg5DmGXqf6g+jo+FKV6TFiukPBp+aQ2H9wvX1XJmTUpcR/nb7hnghtF0DkwsZB
         00Bg==
X-Gm-Message-State: AOAM533zkcG8L86wovd1tn6o84qaKNoXWjbDqMYacLAeVNqRelqW4YHb
        OTR3jIs8j9TjRqJCHngxAyF8sp0RnaJb+w==
X-Google-Smtp-Source: ABdhPJxgHMLD1DbGkUlvNU+qOen+kwmNANMxPhU3aQLLx0MGt4WJb1V8l5Z3kJ9dsBv1kJy7uk06kw==
X-Received: by 2002:a17:902:242:b029:dc:3baf:2033 with SMTP id 60-20020a1709020242b02900dc3baf2033mr4318158plc.36.1611637875040;
        Mon, 25 Jan 2021 21:11:15 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 68sm19336822pfg.90.2021.01.25.21.11.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jan 2021 21:11:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCHv4 net-next 2/2] rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
Date:   Tue, 26 Jan 2021 13:10:49 +0800
Message-Id: <ac09d0f99a9f7ba1bdfa933eb5fc08740dd0346c.1611637639.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com>
References: <cover.1611637639.git.lucien.xin@gmail.com>
 <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611637639.git.lucien.xin@gmail.com>
References: <cover.1611637639.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing encap_enable/increasing encap_needed_key, up->encap_enabled
is not set in rxrpc_open_socket(), and it will cause encap_needed_key
not being decreased in udpv6_destroy_sock().

This patch is to improve it by just calling udp_tunnel_encap_enable()
where it increases both UDP and UDPv6 encap_needed_key and sets
up->encap_enabled.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/rxrpc/local_object.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 8c28810..93e05d2 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -135,11 +135,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	udp_sk(usk)->gro_receive = NULL;
 	udp_sk(usk)->gro_complete = NULL;
 
-	udp_encap_enable();
-#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
-	if (local->srx.transport.family == AF_INET6)
-		udpv6_encap_enable();
-#endif
+	udp_tunnel_encap_enable(local->socket);
 	usk->sk_error_report = rxrpc_error_report;
 
 	/* if a local address was supplied then bind it */
-- 
2.1.0

