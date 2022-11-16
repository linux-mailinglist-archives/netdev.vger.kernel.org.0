Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB862B4E1
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 09:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbiKPISQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 03:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiKPIRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 03:17:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ECBBBC
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 00:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668586608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9d1x3IOEClUC0qavYogMQagsbboIJFcHLUHadOyzrg=;
        b=Aprzn6Q/oPGro0eBBOStZMDoMd6NPH/BentloZYBMViuzzrxBTNtfsc8A3hTpsgyZXHXR0
        z0BkJfEmA2HoEEBp9HZa82mJn3JSYUtdhyPqJ/DsrPeiuIPS5ZktHrEmXIfwdQNHqjBn5Z
        jCb6jPThF/dh5ia7joSULRqWifh3bXI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-wIQBQWIKOBG1HOOwGEY4Aw-1; Wed, 16 Nov 2022 03:16:44 -0500
X-MC-Unique: wIQBQWIKOBG1HOOwGEY4Aw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25AF8381494B;
        Wed, 16 Nov 2022 08:16:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A20E140EBF3;
        Wed, 16 Nov 2022 08:16:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 1/3] rxrpc: Fix missing IPV6 #ifdef
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Nov 2022 08:16:40 +0000
Message-ID: <166858660085.2154965.8163437106785496427.stgit@warthog.procyon.org.uk>
In-Reply-To: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
References: <166858659236.2154965.18023032361364343888.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

 net/rxrpc/local_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index a178f71e5082..a943fdf91e24 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -33,7 +33,8 @@ static void rxrpc_encap_err_rcv(struct sock *sk, struct sk_buff *skb, int err,
 {
 	if (ip_hdr(skb)->version == IPVERSION)
 		return ip_icmp_error(sk, skb, err, port, info, payload);
-	return ipv6_icmp_error(sk, skb, err, port, info, payload);
+	if (IS_ENABLED(CONFIG_AF_RXRPC_IPV6))
+		return ipv6_icmp_error(sk, skb, err, port, info, payload);
 }
 
 /*


