Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC73E650495
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 21:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiLRUAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 15:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiLRUAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 15:00:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2BD12A
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 11:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671393597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HeZta9/Ah5Mnc2zLRYpzsO5rZrKVrqZpclQQ8FYgfxk=;
        b=OLdLitP+HTZk0tROdTgpC8phHYPJ+2ochyUbYd6zXCmPCiOuXGChimSmYB9YkfOpuVWmzJ
        a94bDdsn4YkEsNBTlJWIxWkVx86AT4uDCpNAV0j2wfHW0lwlP7yJxYTWIBnv64rG5e5tXf
        7pdeUfIVtlHJq2dw4NTbcti4g42dLIw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-Kttk09cSMJKjUDIsQWsG3A-1; Sun, 18 Dec 2022 14:59:56 -0500
X-MC-Unique: Kttk09cSMJKjUDIsQWsG3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A788A3C0D19A;
        Sun, 18 Dec 2022 19:59:55 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8FAC492C14;
        Sun, 18 Dec 2022 19:59:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20221218120951.1212-1-hdanton@sina.com>
References: <20221218120951.1212-1-hdanton@sina.com> <20221216001958.1149-1-hdanton@sina.com> <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 7/9] rxrpc: Fix I/O thread stop
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1003224.1671393594.1@warthog.procyon.org.uk>
Date:   Sun, 18 Dec 2022 19:59:54 +0000
Message-ID: <1003225.1671393594@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> In line with
> 
> 	if (condition)
> 		return;
> 	add to wait queue
> 	if (!condition)
> 		schedule();
> 
> this change should look like
> 
>    		if (!skb_queue_empty(&local->rx_queue) ...)
>  			continue;
> 
>  		if (kthread_should_stop())
>    			if (!skb_queue_empty(&local->rx_queue) ...)
>  				continue;
> 			else
>   				break;
> 
> as checking condition once barely makes sense.

Really, no.  The condition is going to expand to have a whole bunch of things
in it and I don't want to have it twice, e.g.:

                if (!skb_queue_empty(&local->rx_queue) ||
                   READ_ONCE(local->events) ||
                    !list_empty(&local->call_attend_q) ||
                    !list_empty(&local->conn_attend_q) ||
                    !list_empty(&local->new_client_calls) ||
		    test_bit(RXRPC_CLIENT_CONN_REAP_TIMER,
			     &local->client_conn_flags)) {
			...

Hmmm...  I wonder if kthread_should_stop() needs a barrier associated with
it.  It's just a test_bit(), so the compiler can cache the results of all
these tests - or reorder them.

David

