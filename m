Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475286EAEEB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbjDUQRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjDUQRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:17:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD5C7294
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682093782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=0tp+aaiy/E7Hvy2jvzMO8gNdfxuSH7jfOPj7r1Xv8Nw=;
        b=Iu3GlUWKO28Nf0y/XenGCuhwZEqJY0/T2cNSm+mmFDxQwibMN3IKtU1S9fqFNmGT0vjVYj
        2YuWftuiuOEKUDDF9RNXV08Ua65N3Zuveaw/DjqEBGATpTjjGZLnzSlJlpxUBjXq0XjtFt
        b7ZKAW9zbZyWOR/iWqGF1z/2MumVDXo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-q_03Udd4PZKnyXWr3yhMzw-1; Fri, 21 Apr 2023 12:16:19 -0400
X-MC-Unique: q_03Udd4PZKnyXWr3yhMzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C66713C1179E;
        Fri, 21 Apr 2023 16:16:18 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C46DE140EBF4;
        Fri, 21 Apr 2023 16:16:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
cc:     dhowells@redhat.com, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] rxrpc: Fix error when reading rxrpc tokens
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <212124.1682093777.1@warthog.procyon.org.uk>
Date:   Fri, 21 Apr 2023 17:16:17 +0100
Message-ID: <212125.1682093777@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Dionne <marc.dionne@auristor.com>

When converting from ASSERTCMP to WARN_ON, the tested condition must
be inverted, which was missed for this case.

This would cause an EIO error when trying to read an rxrpc token, for
instance when trying to display tokens with AuriStor's "tokens" command.

Fixes: 84924aac08a4 ("rxrpc: Fix checker warning")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
---
 net/rxrpc/key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/key.c b/net/rxrpc/key.c
index 8d53aded09c4..33e8302a79e3 100644
--- a/net/rxrpc/key.c
+++ b/net/rxrpc/key.c
@@ -680,7 +680,7 @@ static long rxrpc_read(const struct key *key,
 			return -ENOPKG;
 		}
 
-		if (WARN_ON((unsigned long)xdr - (unsigned long)oldxdr ==
+		if (WARN_ON((unsigned long)xdr - (unsigned long)oldxdr !=
 			    toksize))
 			return -EIO;
 	}

