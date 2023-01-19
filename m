Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0238E672F48
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjASCz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjASCz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:55:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632734490
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:55:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19CB3B82015
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7784EC433EF;
        Thu, 19 Jan 2023 02:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674096923;
        bh=j258qoZ3GGg4YbXufa1eHNKraJ1QERzaX/SpEezJtbw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OGjg+VJSHqpGVmyJ9c702lOcRoQOZuHD11xa7swVXnGFCL8MM7JGXXYbGtOHmif6a
         Eh2CeoDCmPM+GhSYr7Af8ZT43u4KvWaIqVL74K2LoeTN2UtppUReWqm8gVLotAujeG
         FvtFbvz2ws9fkHiLw4QxZZbBPZZy/L9KNPVhVuEN67tSdw38bTnO+LWkPg8LUr4afI
         DXvFwH9fW5v7nJQorACl/Lues1L9/yytKa47/jX7XtPi6Z3kJEzuaOJAEELzJHgWHI
         WRWtVr9DlRbYEp69q072Uoz83TVe+LfK/MNLoe8+3NXFyLQJhJqdwtfD6MiJQ+3jsa
         eckUmjc6d4obw==
Date:   Wed, 18 Jan 2023 18:55:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Frantisek Krenzelok <fkrenzel@redhat.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230118185522.44c75f73@kernel.org>
In-Reply-To: <Y8fEodSWeJZyp+Sh@hog>
References: <cover.1673952268.git.sd@queasysnail.net>
        <20230117180351.1cf46cb3@kernel.org>
        <Y8fEodSWeJZyp+Sh@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 11:06:25 +0100 Sabrina Dubroca wrote:
> 2023-01-17, 18:03:51 -0800, Jakub Kicinski wrote:
> > On Tue, 17 Jan 2023 14:45:26 +0100 Sabrina Dubroca wrote: =20
> > > This adds support for receiving KeyUpdate messages (RFC 8446, 4.6.3
> > > [1]). A sender transmits a KeyUpdate message and then changes its TX
> > > key. The receiver should react by updating its RX key before
> > > processing the next message.
> > >=20
> > > This patchset implements key updates by:
> > >  1. pausing decryption when a KeyUpdate message is received, to avoid
> > >     attempting to use the old key to decrypt a record encrypted with
> > >     the new key
> > >  2. returning -EKEYEXPIRED to syscalls that cannot receive the
> > >     KeyUpdate message, until the rekey has been performed by userspac=
e =20
> >=20
> > Why? We return to user space after hitting a cmsg, don't we?
> > If the user space wants to keep reading with the old key - =F0=9F=A4=B7=
=EF=B8=8F =20
>=20
> But they won't be able to read anything. Either we don't pause
> decryption, and the socket is just broken when we look at the next
> record, or we pause, and there's nothing to read until the rekey is
> done. I think that -EKEYEXPIRED is better than breaking the socket
> just because a read snuck in between getting the cmsg and setting the
> new key.

IDK, we don't interpret any other content types/cmsgs, and for well
behaved user space there should be no problem (right?).
I'm weakly against, if nobody agrees with me you can keep as is.

> > >  3. passing the KeyUpdate message to userspace as a control message
> > >  4. allowing updates of the crypto_info via the TLS_TX/TLS_RX
> > >     setsockopts
> > >=20
> > > This API has been tested with gnutls to make sure that it allows
> > > userspace libraries to implement key updates [2]. Thanks to Frantisek
> > > Krenzelok <fkrenzel@redhat.com> for providing the implementation in
> > > gnutls and testing the kernel patches. =20
> >=20
> > Please explain why - the kernel TLS is not faster than user space,=20
> > the point of it is primarily to enable offload. And you don't add
> > offload support here. =20
>=20
> Well, TLS1.3 support was added 4 years ago, and yet the offload still
> doesn't support 1.3 at all.

I'm pretty sure some devices support it. None of the vendors could=20
be bothered to plumb in the kernel support, yet, tho.
I don't know of anyone supporting rekeying.

> IIRC support for KeyUpdates is mandatory in TLS1.3, so currently the
> kernel can't claim to support 1.3, independent of offloading.

The problem is that we will not be able to rekey offloaded connections.
For Tx it's a non-trivial problem given the current architecture.
The offload is supposed to be transparent, we can't fail the rekey just
because the TLS gotten offloaded.

> Some folks did tests with and without kTLS using nbdcopy and found a
> small but noticeable performance improvement (around 8-10%).
