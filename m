Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8C30A527
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhBAKOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:14:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232943AbhBAKOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612174361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JzU/btitmBexa+6BHnO0UL9EhKJmr7ZPhN0nWZC0+oY=;
        b=KopkFXOrTxka/iEOUZg0EDR7RGOxSRMAdl4LGiT9PoUcX8OZKKpkEl8PMZbnmGe7d8xJJ0
        X+t1NsOXO3+Hp3JWwe2ONvcY0OSS3UNc2E+OkG6IvzOMVr5hUjGHRoBNF4fHNwbLUY5iJU
        zaRhrAc/KEgiZjKxeuvbZPxJ9mQDFAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-A1uj297bOYCiXNEDgPOeKQ-1; Mon, 01 Feb 2021 05:12:40 -0500
X-MC-Unique: A1uj297bOYCiXNEDgPOeKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC835800D53;
        Mon,  1 Feb 2021 10:12:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B51562461;
        Mon,  1 Feb 2021 10:12:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210201094403.1979-1-hdanton@sina.com>
References: <20210201094403.1979-1-hdanton@sina.com> <0000000000007b460105ba41c908@google.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com,
        syzbot <syzbot+174de899852504e4a74a@syzkaller.appspotmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com
Subject: Re: KASAN: use-after-free Read in rxrpc_send_data_packet
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4107617.1612174356.1@warthog.procyon.org.uk>
Date:   Mon, 01 Feb 2021 10:12:36 +0000
Message-ID: <4107618.1612174356@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> --- a/net/rxrpc/call_object.c
> +++ b/net/rxrpc/call_object.c
> @@ -549,6 +549,7 @@ void rxrpc_release_call(struct rxrpc_soc
>  	if (call->security)
>  		call->security->free_call_crypto(call);
>  
> +	cancel_work_sync(&call->processor);
>  	rxrpc_cleanup_ring(call);
>  	_leave("");
>  }

It's probably better to do the cancellation before we call
->free_call_crypto().

Two other alternatives would be to lock in rxrpc_cleanup_ring() or just remove
that call of rxrpc_cleanup_ring() and leave it to rxrpc_cleanup_call() (which
calls it anyway).  The latter might be the best option as the work function
holds a ref on the call.

Clearing the ring in rxrpc_release_call() is more of an optimisation, meant to
recycle skbuffs sooner, but I would hope that the call would be destroyed
quickly after this point anyway.

David

