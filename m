Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F94623EDE
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKJJol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiKJJoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:44:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB211A12
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668073420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4ZaRcF8WI9Tne3FYST1W1k4nO0dwOoYM2AmTRWkoH5o=;
        b=VIehum8fjN8w3j0Eye5ysp/nR3cGfE8ESIs2+ZGfyhpHOy5IPa8ypsigvp5O7jKKYiEbct
        TDY3u7ENOpbLmbNxRoDmuZ+TTBrxRWsHP97Bmqsb/CBKShKb6rQkoTaXdi53SHmyM7QsXc
        MC1PHRkV4aPLS4tuTlTZ0uWd8pPxPbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-iivNsXE6NhaXahNe1XOXkw-1; Thu, 10 Nov 2022 04:43:37 -0500
X-MC-Unique: iivNsXE6NhaXahNe1XOXkw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57A3C85A583;
        Thu, 10 Nov 2022 09:43:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9670B7AE5;
        Thu, 10 Nov 2022 09:43:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next] rxrpc: Fix missing IPV6 #ifdef
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Nov 2022 09:43:34 +0000
Message-ID: <166807341463.2904467.10141806642379634063.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_encap_err_rcv() to make the call to ipv6_icmp_error conditional
on IPV6 support being enabled.

Fixes: b6c66c4324e7 ("rxrpc: Use the core ICMP/ICMP6 parsers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
---

 net/rxrpc/local_object.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index a178f71e5082..25cdfcf7b415 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -33,7 +33,9 @@ static void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
 {
 	if (ip_hdr(skb)->version == IPVERSION)
 		return ip_icmp_error(sk, skb, err, port, info, payload);
+#ifdef CONFIG_AF_RXRPC_IPV6
 	return ipv6_icmp_error(sk, skb, err, port, info, payload);
+#endif
 }
 
 /*


