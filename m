Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647AD30D619
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbhBCJRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:17:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233248AbhBCJQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:16:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612343666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5sRAuFOAQ8g9QCLhqMZlsPaNp+x4wcLZINLiQF+Gi1I=;
        b=iV0QlyV6VRvaUlCFN8ArUu8+BqXM5faU2JgLlccSCQCxU4oz78NEDDCy2YQiLSkCHcmrCI
        t9IRtJdEggbZFFlhx5OOyNcm7XkDsS5oHLrVwXMRwws9+k47ZIGEaSv22n7flYdwlkfCMG
        ut1X0cZ8yshkPG1VeQPcvnxSJVJc20c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-r3ENqYO-PuedMYYx5VkksQ-1; Wed, 03 Feb 2021 04:14:22 -0500
X-MC-Unique: r3ENqYO-PuedMYYx5VkksQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4321E107ACE3;
        Wed,  3 Feb 2021 09:14:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC3FE722C9;
        Wed,  3 Feb 2021 09:14:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com>
References: <CADvbK_dJJjiQK+N0U04eWCU50DRbFLNqHSi7Apj==d3ygzkz6g@mail.gmail.com> <cover.1611637639.git.lucien.xin@gmail.com> <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com> <645990.1612339208@warthog.procyon.org.uk>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        vfedorenko@novek.ru
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <655775.1612343656.1@warthog.procyon.org.uk>
Date:   Wed, 03 Feb 2021 09:14:16 +0000
Message-ID: <655776.1612343656@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> BTW, I'm also thinking to use udp_sock_create(), the only problem I can
> see is it may not do bind() in rxrpc_open_socket(), is that true? or we
> can actually bind to some address when a local address is not supplied?

If a local address isn't explicitly bound to the AF_RXRPC socket, binding the
UDP socket to a random local port is fine.  In fact, sometimes I want to
explicitly bind an rxrpc server socket to a random port.  See fs/afs/rxrpc.c
function afs_open_socket():

	/* bind the callback manager's address to make this a server socket */
	memset(&srx, 0, sizeof(srx));
	srx.srx_family			= AF_RXRPC;
	srx.srx_service			= CM_SERVICE;
	srx.transport_type		= SOCK_DGRAM;
	srx.transport_len		= sizeof(srx.transport.sin6);
	srx.transport.sin6.sin6_family	= AF_INET6;
	srx.transport.sin6.sin6_port	= htons(AFS_CM_PORT);
	...
	ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
	if (ret == -EADDRINUSE) {
		srx.transport.sin6.sin6_port = 0;

		^^^ That's hoping to get a random port bound.

		ret = kernel_bind(socket, (struct sockaddr *) &srx, sizeof(srx));
	}
	if (ret < 0)
		goto error_2;

The client cache manager server socket here is used to receive notifications
back from the fileserver.  There's a standard port (7001) for the service, but
if that's in use, we can use any other port.  The fileserver grabs the source
port from incoming RPC requests - and then uses that when sending 3rd-party
change notifications back.

If you could arrange for a random port to be assigned in such a case (and
indicated back to the caller), that would be awesome.  Possibly I just don't
need to actually use bind in this case.

David

