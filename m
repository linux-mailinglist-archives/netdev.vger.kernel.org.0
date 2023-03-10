Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738C46B4D18
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCJQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjCJQeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:34:24 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC16EBF8A;
        Fri, 10 Mar 2023 08:31:53 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 871281BF213;
        Fri, 10 Mar 2023 16:31:48 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     Diederik de Haas <didi.debian@cknow.org>, 1032367@bugs.debian.org,
        Marc <dkm+reportbug@kataplop.net>
Subject: Re: brcm/brcmfmac4356-pcie.bin failed with error -2
Date:   Fri, 10 Mar 2023 17:31:39 +0100
Message-ID: <5417930.k8YVOmb3Wj@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <2716728.5R3jveeIG6@prancing-pony>
References: <2716728.5R3jveeIG6@prancing-pony>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8112054.d6L16D4Qj6";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart8112054.d6L16D4Qj6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Subject: Re: brcm/brcmfmac4356-pcie.bin failed with error -2
Date: Fri, 10 Mar 2023 17:31:39 +0100
Message-ID: <5417930.k8YVOmb3Wj@prancing-pony>
Organization: Connecting Knowledge
In-Reply-To: <2716728.5R3jveeIG6@prancing-pony>
References: <2716728.5R3jveeIG6@prancing-pony>
MIME-Version: 1.0

On Thursday, 9 March 2023 19:17:10 CET Diederik de Haas wrote:
> In https://bugs.debian.org/1032367 we have a user who reported that the
> brcm/brcmfmac4356-pcie.bin firmware file failed to load with a new firmware-
> brcm80211 package, while it succeeded with an old one.
> 
> In
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> / I found 2 commits that seem relevant:
> - 04f71fe564552c22dc7ece0d2b8afc11b33de392 where various cypress firmware
> and clm_blob files (including 4356) were added to the *cypress* directory.
> - 0f0aefd733f70beae4c0246edbd2c158d5ce974c which removed old brcm firmware
> files that have a newer cypress variant ...  from the *brcm* directory.
> 
> So in essence a bunch of firmware files were moved from 'brcm' dir to
> 'cypress'.
> 
> I don't know how the firmware file loading mechanism works, but could it be
> that it (also) needs to look in the new (cypress) location for those files?

I am now reasonably certain that that is indeed the issue.

I asked the reporter of the issue to create symlinks and that 'fixed' it:

On Friday, 10 March 2023 13:07:22 CET dkm@kataplop.net wrote:
> March 10, 2023 10:57 AM, "Diederik de Haas" <didi.debian@cknow.org> wrote:
> > I'm 99% sure this would be a *workaround*, but let's verify anyway:
> > In the /lib/firmware directory, create a symlink from
> > brcm/brcmfmac4356-pcie.bin to cypress/cyfmac4356-pcie.bin
> 
> As expected, it works with the symlink :)

AFAICT in drivers/net/wireless/broadcom/brcm80211/brcmfmac/ there is pcie.c 
and firmware.[c|h] and it uses BRCMF_FW_DEFAULT_PATH (="brcm/") to construct 
the location of the firmware files.

Now that several firmware files are stored in a different directory ('cypress') 
and also have a different file 'prefix' ('cyfmac') the firmware files that are 
stored in/moved to the cypress directory are no longer found.

Cheers,
  Diederik
--nextPart8112054.d6L16D4Qj6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZAtbawAKCRDXblvOeH7b
bn2rAP0a8yEG1dUVuyDIVHSB9yY1ys4T3IioxYmz/VnyP43vxQD9FJCOxvtVSl8A
26jvD+gxWSqW6Sf9vSnF3gfHZ+hZuQw=
=n2Q+
-----END PGP SIGNATURE-----

--nextPart8112054.d6L16D4Qj6--



