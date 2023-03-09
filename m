Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730C06B216A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjCIK3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCIK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:29:31 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE07F193E8
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:29:28 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F403FE000C;
        Thu,  9 Mar 2023 10:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678357766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=za1oFw2Q+Z11YaSIDdfKxMRcWfEH+FQY2CVWvKf888s=;
        b=Snpk6CEx0V0Z4/wT7s2e9opaGEqnotAYFhkcZlXzu+Thpev6fzayz+UiAFn0CYplxBjASN
        x+JMPHHxcqPgBXBwKs9e65pGpHjYD93dwWVFTw+0qDcEM3ZVpVe9QisVeQoEnp8TkAP2Jx
        ApnwdQjqLO7EyIOiBFNICic+r2dd4Y9fNVxFw+yjyiJWyvsljxEALqPgP18EduPFO5ZbSg
        4dn5d1hvoyJQnV97mxsZtJQjY8naUzPb7PvSIYPlj2sJ8sDFQLrfu4RFYSFXD5mk+mUhvw
        dB/1pprX8xMjj1hJ+ifvTe5f5h3SlY1g39owrMiHqUx+nqOFTpsW/2JztGuCJg==
Date:   Thu, 9 Mar 2023 11:29:24 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: Defer probe if MAC address source
 is not yet ready
Message-ID: <20230309112924.2087e345@xps-13>
In-Reply-To: <5432f8f2da54d0ffc4e4e28fb88ac14f5bb682de.camel@redhat.com>
References: <20230307192927.512757-1-miquel.raynal@bootlin.com>
        <5432f8f2da54d0ffc4e4e28fb88ac14f5bb682de.camel@redhat.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

pabeni@redhat.com wrote on Thu, 09 Mar 2023 11:12:18 +0100:

> On Tue, 2023-03-07 at 20:29 +0100, Miquel Raynal wrote:
> > NVMEM layouts are no longer registered early, and thus may not yet be
> > available when Ethernet drivers (or any other consumer) probe, leading
> > to possible probe deferrals errors. Forward the error code if this
> > happens. All other errors being discarded, the driver will eventually
> > use a random MAC address if no other source was considered valid (no
> > functional change on this regard).
> >=20
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com> =20
>=20
> The patch LGTM, but if feels like a fix more than a new feature re-
> factor. Any special reason to target the net-next tree?

That's a good question, right now nvmem support can only be built-in,
there is no EPROBE_DEFER situation that can arise when reading from an
nvmem device. The introduction of nvmem layouts has been reported due
to their lack of "modularization". Support is being upstreamed right
now in the nvmem tree and this brings two subtleties in one: nvmem cell
reads can now return -EPROBE_DEFER when coming from layouts because=20
they are no longer populated very early in the boot process.

Hence IMHO this patch does not "fix" anything as there is currently
nothing broken in 6.3. But as layouts and modules get in the Linux
kernel (6.4-final), users of these layouts (like this driver) should
also handle this new case. Having this patch be merged into linux-next
after the introduction of the nvmem changes has almost no impact. It
just slightly delays the moment in time when MAC addresses can be
retrieved from specific nvmem layouts.

IOW, I believe targeting the net-next tree is fine, but feel free to
take it into net if you prefer.

Thanks,
Miqu=C3=A8l
