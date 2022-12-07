Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B186645CE9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLGOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiLGOuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:50:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDED5802E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:50:17 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670424616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bo2/EVKSy2TU6OrVCoRaEt5X9l9631kaoSr2fn2PMCc=;
        b=NQQO4btqGkkCqNzZQaypTifSSD1EfLk6vSsnB2Mh8XBTFy7MZYhCiBV8kPZTIOTdK8uaFj
        QHlsB4GpvMLDQEpo5EzgfkFqqq3PAa/jVgDj3M9CR1d8+6SL9HDRLr6QHjKDtZRJVCdJrN
        No1ORBxiLcDHzQQhOMveE8owsOP8yhRyqEOjL4FOCbXn0qwnGpS6+rrNIyNscO/+M71+zT
        L2q8iNfprElJXNQrn7miM4Yhqb8gzzTXPvG8BlcRM1ynzsY3C/yvSpBokmYXFOTuCYs7TQ
        NJ6lfNezBLsX1HH7/y/3p8rOyJQnC0j39IznL+1V1V5zr2SEIPDcVm5gfF3QtA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670424616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bo2/EVKSy2TU6OrVCoRaEt5X9l9631kaoSr2fn2PMCc=;
        b=O9gCK13SRcFAH/ixcPxGxTHo7aRvnoxYG/nf7kUp6ogu4b7jl2+XfFdHEkeqU1UcfSZ7QA
        P1CLeKbgti1o26AA==
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
In-Reply-To: <Y5CZp0QJVejOpWSY@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01> <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01> <Y4i/Aeqh94ZP/mA0@lunn.ch>
 <20221206182823.08e5f917@kernel.org> <Y5CZp0QJVejOpWSY@lunn.ch>
Date:   Wed, 07 Dec 2022 15:50:13 +0100
Message-ID: <87v8mne09m.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Dec 07 2022, Andrew Lunn wrote:
> On Tue, Dec 06, 2022 at 06:28:23PM -0800, Jakub Kicinski wrote:
>> On Thu, 1 Dec 2022 15:49:37 +0100 Andrew Lunn wrote:
>> > > The root cause is the MAC using the internal clock as a PTP reference
>> > > (default), which should be allowed since the connection to an extern=
al
>> > > PTP clock is optional from an HW perspective. The internal clock see=
ms
>> > > to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.=
=20=20
>> >=20
>> > I think we need help from somebody who understands PTP on this device.
>> > The clock is clearly out of range, but how important is that to PTP?
>> > Will PTP work if the value is clamped to 0xff? Or should we be
>> > returning -EINVAL and disabling PTP because it has no chance of
>> > working?
>>=20
>> Indeed, we need some more info here :( Like does the PTP actually
>> work with 2.5 MHz clock? The frequency adjustment only cares about=20
>> the addend, what is sub_second_inc thing?
>
> Hi Jakub
>
> I Cc: many of the people who worked on PTP with this hardware, and
> nobody has replied.
>
> I think we should wait a couple more days, and then add a range check,
> and disable PTP for invalid clocks. That might provoke feedback.

Here's the Altera manual:

 https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/func=
tional-description-of-the-emac.html

Table 183 shows the minimum PTP frequencies and also states "Therefore,
a higher PTP clock frequency gives better system performance.".

So, I'd say using a clock of 2.5MHz seems possible, but will result in
suboptimal precision.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOQqCUTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgqqHEACN3H18QjD4TkymuylrEjNYb8zW9BiV
OHGd8WKBysxJlLdLW/lpPhensx6CLtmDdhg1NNZ8LOYiBZ66m2kXMleV7Wk1KvVD
hRuuGDguJczBmYswbgldMIQm0ngDbnbP0y0axubSAnpjskcvhELsPNteCC8o3PyQ
KiM/47ykM+2jQ9TR4y+mtcdliO0r3SrWXq1/N+FXir2uZuMQq/fLsJX3QLpJj6Z4
kL/86Z/WvuVZeLDTkLrCJZrcbDmPeLA7+KQUoWKFpgv9Ey4oqs1HGQcicSmVrla0
NITJx9rJM0NG6BgsangUlRNLcQ7x0ZxKSz2b7zYM5vmvDukmX5N7xX20q0khp8/A
mQc1beOZFn/DTp+vjeFwLz0AyZK+ZPxztUDfHGMNZtFheWUtxGH9oFWTZWWXweng
QDUgGZwlyB7BAucHbBmmyJ8N92sTBbdWjUGoJubGH02NDPBSgzOGLTzzFlfwKxpH
Aix5pFf8IoDHR96w4J9/ZwTInKZWMd4d3y+liiajwzNp3ZNcRnC9Pc/q405LOecA
AFyfMPC8NwI04kk1p+mDIWpIP8QgUbrLCkmgl4VPys8jn0uUJt4eNTqBSyQHar4b
l3fP2hCq/l9bOah7Dt9exaTnxlIBbQRciglzof2MirBxxRnqA9qSdieRwTk0Mfa+
/PSx2MTZMS6nAA==
=Stfm
-----END PGP SIGNATURE-----
--=-=-=--
