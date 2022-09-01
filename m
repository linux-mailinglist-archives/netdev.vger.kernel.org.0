Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD05A96B9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiIAM1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233504AbiIAM0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:26:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBB3126DD5
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662035206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JTTZDB9pqqMlPFmzio4pJ+ZLsLWDUIAy1xWN+IXpLg=;
        b=SJxZUUnC2uL1hikAuV9YHRRMZXInED05EG6Hhshcz8N0rdOVO92oj4/3/oN4a1DxzVjkPg
        RtxipoYBvNUqxNkUMR3+CHlmAb+Cl6/nLdUhuNARnP4CsacezfNbVgyZJ/cuIzCplaTXz3
        m3/3Dwi0hqnojdZRrDN9Kcly9CCCs/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-OPtNyI7CNEy4R-Eq_rVtyw-1; Thu, 01 Sep 2022 08:26:41 -0400
X-MC-Unique: OPtNyI7CNEy4R-Eq_rVtyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7531185A794;
        Thu,  1 Sep 2022 12:26:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC522166B26;
        Thu,  1 Sep 2022 12:26:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net v3 2/6] rxrpc: Fix an insufficiently large sglist in
 rxkad_verify_packet_2()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 13:26:39 +0100
Message-ID: <166203519965.271364.793413451600531844.stgit@warthog.procyon.org.uk>
In-Reply-To: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
References: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxkad_verify_packet_2() has a small stack-allocated sglist of 4 elements,
but if that isn't sufficient for the number of fragments in the socket
buffer, we try to allocate an sglist large enough to hold all the
fragments.

However, for large packets with a lot of fragments, this isn't sufficient
and we need at least one additional fragment.

The problem manifests as skb_to_sgvec() returning -EMSGSIZE and this then
getting returned by userspace.  Most of the time, this isn't a problem as
rxrpc sets a limit of 5692, big enough for 4 jumbo subpackets to be glued
together; occasionally, however, the server will ignore the reported limit
and give a packet that's a lot bigger - say 19852 bytes with ->nr_frags
being 7.  skb_to_sgvec() then tries to return a "zeroth" fragment that
seems to occur before the fragments counted by ->nr_frags and we hit the
end of the sglist too early.

Note that __skb_to_sgvec() also has an skb_walk_frags() loop that is
recursive up to 24 deep.  I'm not sure if I need to take account of that
too - or if there's an easy way of counting those frags too.

Fix this by counting an extra frag and allocating a larger sglist based on
that.

Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/rxkad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 258917a714c8..78fa0524156f 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -540,7 +540,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	 * directly into the target buffer.
 	 */
 	sg = _sg;
-	nsg = skb_shinfo(skb)->nr_frags;
+	nsg = skb_shinfo(skb)->nr_frags + 1;
 	if (nsg <= 4) {
 		nsg = 4;
 	} else {


