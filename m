Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD61E985F
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEaPJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 11:09:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21948 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728228AbgEaPJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 11:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590937751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yDUA+JUdTjFPwNW7cVcL/jAUJqXfAJ27+Lah22MRRXo=;
        b=WPeZmC8nC9xsv8EOqxJPzixC55QKQDXq03vAgwYxNs8Q07QULIn9RW9X3FLy43LA9VHSbC
        AxH6LiqOxokbESOTAfaI84LoEYzS/V9mzyOoToHB6DCtWaZOOufu/x10t/kWkqfET4qwb4
        ufmXErZJJWN1caS32IC3bCyhhzueuII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-k7yVd-fmPneHxU-Pj9uOIA-1; Sun, 31 May 2020 11:09:07 -0400
X-MC-Unique: k7yVd-fmPneHxU-Pj9uOIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AF5A835B40;
        Sun, 31 May 2020 15:09:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-138.rdu2.redhat.com [10.10.112.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFD5F60F8D;
        Sun, 31 May 2020 15:09:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAFAFadCErKJ0mjkyKrVCCDAV7oShdA22O-TD6VEmFM0Mwfqahg@mail.gmail.com>
References: <CAFAFadCErKJ0mjkyKrVCCDAV7oShdA22O-TD6VEmFM0Mwfqahg@mail.gmail.com>
To:     gaurav singh <gaurav1086@gmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] conn_client: Add check for rxpc channel
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1159569.1590937744.1@warthog.procyon.org.uk>
Date:   Sun, 31 May 2020 16:09:04 +0100
Message-ID: <1159570.1590937744@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Note that "conn_client:" isn't a suitable tag for the subject.  You should use
"rxrpc:" instead.

How did you find this by the way?  You shouldn't get a NULL pointer there.
Either the call is waiting for a channel to be assigned (in which case the
condition on:

	if (!list_empty(&call->chan_wait_link)) {

will be true) or it should have been assigned a channel, in which case chan
will not be NULL.

Note that the function takes the lock under which this is managed
(conn->channel_lock) across this, so it shouldn't change.

Even __rxrpc_disconnect_call(), which is called to implicitly close out a call
that gets superseded on its channel, doesn't stop
rxrpc_disconnect_client_call() from finding the channel.

David

