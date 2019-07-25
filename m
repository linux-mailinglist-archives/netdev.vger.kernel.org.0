Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D4C7511E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfGYO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbfGYO3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 10:29:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E454F83F4C;
        Thu, 25 Jul 2019 14:29:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-49.rdu2.redhat.com [10.10.120.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DC9D1001281;
        Thu, 25 Jul 2019 14:29:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAKv+Gu_bJfs3zc90CbmXXo17+CYMVK+bo7OyJ-RYA=AiU38Fvg@mail.gmail.com>
References: <CAKv+Gu_bJfs3zc90CbmXXo17+CYMVK+bo7OyJ-RYA=AiU38Fvg@mail.gmail.com> <156406148519.15479.13870345028835442313.stgit@warthog.procyon.org.uk>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] rxrpc: Fix -Wframe-larger-than= warnings from on-stack crypto
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21522.1564064970.1@warthog.procyon.org.uk>
Date:   Thu, 25 Jul 2019 15:29:30 +0100
Message-ID: <21523.1564064970@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 25 Jul 2019 14:29:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Given that this part of the driver only uses synchronous crypto, and
> only using a hardcoded algo and mode [pcbc(fcrypt)], of which only a
> generic C implementation exists, may I suggest that we switch to a
> library based approach instead?
> 
> That way, we can get rid of the crypto API overhead here, and IMO, we
> can drop support for this cipher from the crypto API entirely.

Ummm...  I'm not entirely sure.  At some point, I need to look at implementing
the rxgk security class to allow gss to be used.  That can in theory support
any kerberos cipher suite (which don't include pcbc or fcrypt).  I don't yet
know how much code I could theoretically share with rxkad.c.

However, since pcbc and fcrypt are only used by rxkad.c, it might make sense
to move them to net/rxrpc/ and hard code them in rxkad.c - though I'd prefer
to make an attempt on rxgk first.

David
