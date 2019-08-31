Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26256A456A
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfHaQpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 12:45:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbfHaQpf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 12:45:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 697273082DDD;
        Sat, 31 Aug 2019 16:45:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F27475D6A5;
        Sat, 31 Aug 2019 16:45:33 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20190831135906.6028-1-hdanton@sina.com>
References: <20190831135906.6028-1-hdanton@sina.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix lack of conn cleanup when local endpoint is cleaned up [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8377.1567269933.1@warthog.procyon.org.uk>
Date:   Sat, 31 Aug 2019 17:45:33 +0100
Message-ID: <8378.1567269933@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sat, 31 Aug 2019 16:45:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hillf Danton <hdanton@sina.com> wrote:

> > -		if (rxnet->live) {
> > +		if (rxnet->live && !conn->params.local->dead) {
> >  			idle_timestamp = READ_ONCE(conn->idle_timestamp);
> >  			expire_at = idle_timestamp + rxrpc_connection_expiry * HZ;
> >  			if (conn->params.local->service_closed)
> 
> Is there any chance out there that this reaper starts running one minute
> after the dead local went into graveyard?

It's certainly possible that that can happen.  The reaper is per
network-namespace.

conn->params.local holds a ref on the local endpoint.

It may be worth wrapping the "local->dead = true;" in rxrpc_local_destroyer()
in rxnet->conn_lock.

David
