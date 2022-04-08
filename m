Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1544F8F22
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiDHGns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 02:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbiDHGnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 02:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3EC89100A56
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 23:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649400097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=brClZdBOJIi3Tjs12ZgAohDLSo6wNWWbtj768wAr3+o=;
        b=GmI4vaYDOVCHmhV0gifksVNLXENRqxEobA/hFuq7q6dGlPoZfa4Exw/UipaIbqhYNbr+Yx
        qyoXaGTWgX/U8fUg+xhveU1uUJG+qkGq4ZNWQUfe7DjGtCxtTeY3sDHHq5vVaFGR/1476L
        V6/PvdzQxkugdfOA+BW0JbiE3tmcvTY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-i-2C-uuqNLiiBmry1Lu7GQ-1; Fri, 08 Apr 2022 02:41:33 -0400
X-MC-Unique: i-2C-uuqNLiiBmry1Lu7GQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A79263803931;
        Fri,  8 Apr 2022 06:41:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DC8F40E80E1;
        Fri,  8 Apr 2022 06:41:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220404183439.3537837-1-eric.dumazet@gmail.com>
References: <20220404183439.3537837-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     dhowells@redhat.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] rxrpc: fix a race in rxrpc_exit_net()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <583131.1649400090.1@warthog.procyon.org.uk>
Date:   Fri, 08 Apr 2022 07:41:30 +0100
Message-ID: <583132.1649400090@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

[Note that your patch is appl/octet-stream for some reason.]

> 	rxnet->live = false;
> -	del_timer_sync(&rxnet->peer_keepalive_timer);
>  	cancel_work_sync(&rxnet->peer_keepalive_work);
> +	del_timer_sync(&rxnet->peer_keepalive_timer);

That fixes that problem, but introduces another.  The timer could be in the
throes of queueing the worker:

	CPU 1			CPU 2
	====================	=====================
				if (rxnet->live)
				<INTERRUPT>
	rxnet->live = false;
 	cancel_work_sync(&rxnet->peer_keepalive_work);
				rxrpc_queue_work(&rxnet->peer_keepalive_work);
	del_timer_sync(&rxnet->peer_keepalive_timer);

I think keeping the first del_timer_sync() that you removed and the one after
the cancel would be sufficient.

David

