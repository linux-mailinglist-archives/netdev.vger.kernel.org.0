Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3940B2F4676
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbhAMIZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:25:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727141AbhAMIZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610526239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tZ5zssNLjbWPBBlPoWwdC0E0uJ9x0pd9V4VxEY62kGU=;
        b=cy4sjbebPZDqujdvVG2jSgiTW+cFbamH8wgFvIyxlMLFsThcCBLAEI0YAaa2aYGpsI5pOf
        D6Hju2y3p3a2bPIaJYepZhuyr20pjZe1LLUhd041uznAanASI+PRabXmt6K+mQAdjuReTo
        7w92mK5C8vhSQT/R2aTqp2CmPC0CMNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-lLBpzd3jM66giHU3uJ5AJQ-1; Wed, 13 Jan 2021 03:23:57 -0500
X-MC-Unique: lLBpzd3jM66giHU3uJ5AJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BCED1005D4C;
        Wed, 13 Jan 2021 08:23:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 562C050F7D;
        Wed, 13 Jan 2021 08:23:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210112182533.13b1c787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210112182533.13b1c787@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <161046715522.2450566.488819910256264150.stgit@warthog.procyon.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Baptiste Lepers <baptiste.lepers@gmail.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Call state should be read with READ_ONCE() under some circumstances
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2630108.1610526234.1@warthog.procyon.org.uk>
Date:   Wed, 13 Jan 2021 08:23:54 +0000
Message-ID: <2630109.1610526234@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> On Tue, 12 Jan 2021 15:59:15 +0000 David Howells wrote:
> > From: Baptiste Lepers <baptiste.lepers@gmail.com>
> > 
> > The call state may be changed at any time by the data-ready routine in
> > response to received packets, so if the call state is to be read and acted
> > upon several times in a function, READ_ONCE() must be used unless the call
> > state lock is held.
> > 
> > As it happens, we used READ_ONCE() to read the state a few lines above the
> > unmarked read in rxrpc_input_data(), so use that value rather than
> > re-reading it.
> > 
> > Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Fixes: a158bdd3247b ("rxrpc: Fix call timeouts")
> 
> maybe?

Ah, yes.  I missed there wasn't a Fixes line.  Can you add that one in, or do
I need to resubmit the patch?

David

