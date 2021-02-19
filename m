Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EED131F5D1
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 09:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBSI0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 03:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbhBSI0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 03:26:30 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88EEC061574;
        Fri, 19 Feb 2021 00:25:49 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lD16b-005ENE-7X; Fri, 19 Feb 2021 09:25:41 +0100
Message-ID: <55e82d3019ea7f5dce3e1df88ee9188d47ae81f5.camel@sipsolutions.net>
Subject: Re: [PATCH] [v13] wireless: Initial driver submission for pureLiFi
 STA devices
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Fri, 19 Feb 2021 09:25:40 +0100
In-Reply-To: <CWXP265MB17995C134CFC5BD3E39A7C08E0849@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20210212115030.124490-1-srini.raju@purelifi.com>
         (sfid-20210212_125300_396085_B8C8E2C0),<ceb485a8811719e1d4f359b48ae073726ab4b3ba.camel@sipsolutions.net>
         <CWXP265MB17995C134CFC5BD3E39A7C08E0849@CWXP265MB1799.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-02-19 at 05:15 +0000, Srinivasan Raju wrote:
> Hi,
> 
> Please find a few responses to the comments , We will fix rest of the comments and submit v14 of the patch.
> 
> > Also, you *really* need some validation here, rather than blindly
> > trusting that the file is well-formed, otherwise you immediately have a
> > security issue here.
> 
> The firmware is signed and the harware validates the signature , so we are not validating in the software.

That wasn't my point. My point was that the kernel code trusts the
validity of the firmware image, in the sense of e.g. this piece:

> +     no_of_files = *(u32 *)&fw_packed->data[0];

If the firmware file was corrupted (intentionally/maliciously or not), this could now be say 0xffffffff.

> +     for (step = 0; step < no_of_files; step++) {

> +             start_addr = *(u32 *)&fw_packed->data[4 + (step * 4)];

But you trust it completely and don't even check that "4 + (step * 4)"
fits into the length of the data!

That's what I meant. Don't allow this to crash the kernel.

> > > +static const struct plf_reg_alpha2_map reg_alpha2_map[] = {
> > > +     { PLF_REGDOMAIN_FCC, "US" },
> > > +     { PLF_REGDOMAIN_IC, "CA" },
> > > +     { PLF_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
> > > +     { PLF_REGDOMAIN_JAPAN, "JP" },
> > > +     { PLF_REGDOMAIN_SPAIN, "ES" },
> > > +     { PLF_REGDOMAIN_FRANCE, "FR" },
> > > +};
> > You actually have regulatory restrictions on this stuff?
> 
> Currently, There are no regulatory restrictions applicable for LiFi ,
> regulatory_hint setting is only for wifi core 

So why do you have PLF_REGDOMAIN_* things? What does that even mean
then?

> > OTOH, I can sort of see why/how you're reusing wifi functionality here,
> > very old versions of wifi even had an infrared PHY I think.
> > 
> > Conceptually, it seems odd. Perhaps we should add a new band definition?
> > 
> > And what I also asked above - how much of the rate stuff is completely
> > fake? Are you really doing CCK/OFDM in some (strange?) way?
> 
> Yes, your understanding is correct, and we use OFDM.
> For now we will use the existing band definition.

OFDM over infrared, nice.

Still, I'm not convinced we should piggy-back this on 2.4 GHz.

NL80211_BAND_1THZ? ;-)

Ok, I don't know what wavelength you're using, of course...

But at least thinking about this, wouldn't we be better off if we define
NL80211_BAND_INFRARED or something? That way, at least we can tell that
it's not going to interoperate with real 2.4 GHz, etc.

OTOH, this is a bit of a slippery slow - what if somebody else designs
an *incompatible* infrared PHY? I guess this is not really standardised
at this point.

Not really sure about all this, but I guess we need to think about it
more.

What are your reasons for piggy-backing on 2.4 GHz? Just practical "it's
there and we don't care"?

johannes

