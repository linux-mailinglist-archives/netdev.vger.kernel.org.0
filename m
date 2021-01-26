Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8830470E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 19:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbhAZROO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:14:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390795AbhAZJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611652010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ghtUFEOYpSSPIDpUH58mcSLQd3/VKd/stkAx2Vi5wEE=;
        b=Uh6RDEiK+kkFgUv++YhgAZlqGsCwnYb0vrS6oROu5/cwK5ch8bAkrnxFEjVd3jIVudOmDn
        x3wYGM2uefmx1l821ySjPp0I7EpIOjDnvCIUfT4jJKa/9UidTba1eBnn7wgT0wOLGiBUyT
        uyHVFywXacdiE9tLgCmTWPUQ9IpqfkA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-mFhOR-9PO065HkMnB_sZgg-1; Tue, 26 Jan 2021 04:06:45 -0500
X-MC-Unique: mFhOR-9PO065HkMnB_sZgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D1558066EA;
        Tue, 26 Jan 2021 09:06:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9086E5D9DC;
        Tue, 26 Jan 2021 09:06:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <ac09d0f99a9f7ba1bdfa933eb5fc08740dd0346c.1611637639.git.lucien.xin@gmail.com>
References: <ac09d0f99a9f7ba1bdfa933eb5fc08740dd0346c.1611637639.git.lucien.xin@gmail.com> <cover.1611637639.git.lucien.xin@gmail.com> <77cd57759f66c642fb0ed52be85abde201f8bfc9.1611637639.git.lucien.xin@gmail.com> <cover.1611637639.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     dhowells@redhat.com, network dev <netdev@vger.kernel.org>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCHv4 net-next 2/2] rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2673305.1611651999.1@warthog.procyon.org.uk>
Date:   Tue, 26 Jan 2021 09:06:39 +0000
Message-ID: <2673306.1611651999@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:

> -	udp_encap_enable();
> -#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
> -	if (local->srx.transport.family == AF_INET6)
> -		udpv6_encap_enable();
> -#endif
> +	udp_tunnel_encap_enable(local->socket);

You need this too:

	--- a/net/rxrpc/local_object.c
	+++ b/net/rxrpc/local_object.c
	@@ -16,6 +16,7 @@
	 #include <linux/hashtable.h>
	 #include <net/sock.h>
	 #include <net/udp.h>
	+#include <net/udp_tunnel.h>
	 #include <net/af_rxrpc.h>
	 #include "ar-internal.h"

With that, it seems to work still:

	Acked-and-tested-by: David Howells <dhowells@redhat.com>

David

