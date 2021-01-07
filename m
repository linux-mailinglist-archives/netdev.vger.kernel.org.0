Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921142ECE6C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhAGLHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:07:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34492 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbhAGLHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 06:07:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610017555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ja4lCqAp9N8i8WMvPXY5Cq4BQKvkC5CsZ086gZcQxCo=;
        b=dhoM8Y0tOAViONsDX0amY89PbILECC8AGsP3YV/M/e23H0vDU1A4VgFdW6EMBKzV3iRTUZ
        36tMIuSZNz/PCz4HNPbsN/VoZNItekNKHpASz1NE6h8V6/vVg6VdfqDbJ/31zlcmC1Yush
        fUWL/6csIYiV6Kba9Y/04OySAEsQ63A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-4RZSmP4NNIGWOUMAbhobqw-1; Thu, 07 Jan 2021 06:05:51 -0500
X-MC-Unique: 4RZSmP4NNIGWOUMAbhobqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31880107ACE8;
        Thu,  7 Jan 2021 11:05:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-8.rdu2.redhat.com [10.10.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 055095D9D7;
        Thu,  7 Jan 2021 11:05:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210107051434.12395-1-baptiste.lepers@gmail.com>
References: <20210107051434.12395-1-baptiste.lepers@gmail.com>
To:     Baptiste Lepers <baptiste.lepers@gmail.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rxrpc: Call state should be read with READ_ONCE() under some circumstances
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <773321.1610017548.1@warthog.procyon.org.uk>
Date:   Thu, 07 Jan 2021 11:05:48 +0000
Message-ID: <773322.1610017548@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Baptiste Lepers <baptiste.lepers@gmail.com> wrote:

> The call state may be changed at any time by the data-ready routine in
> response to received packets, so if the call state is to be read and acted
> upon several times in a function, READ_ONCE() must be used unless the call
> state lock is held.

I'm going to add:

    As it happens, we used READ_ONCE() to read the state a few lines above the
    unmarked read in rxrpc_input_data(), so use that value rather than
    re-reading it.

to the commit message, if that's okay by you.

David

