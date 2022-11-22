Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5264A63496D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiKVVgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiKVVgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:36:03 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F30CC6057;
        Tue, 22 Nov 2022 13:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=REnOO6pdZKaSYowgojxsI/6VyW5I6orQgYoQL3HrlV0=;
        t=1669152962; x=1670362562; b=MiDXpUhnbIbyBE9t9sy2tBOfAiynpq4c4NljKBx/4xbx8dm
        FE1PANNZPhQsL6ss7+CA5dsbuPRwGXB0EZQ/BwHZfNPIVGjyNZW85j41I8nYeyjY3dF1D4QTZgKvU
        Ii5N4oFDGWVlVgwcbiL0fHRgzi2C6KE9rBUkD0T8+g76JgHuGSh/rpSenaIHOVPsojJzhHCpvkQBf
        e5i5vzPHPVTXTI56Nwax7AHc7RT7/4Zg3lD5Y+1bwU7y2/o2tTV/vk7EN/BGJMvt0t8IWAvJaWcvM
        nVw6ZYgSOdLOY0Nlx5lV0UfpMk3Ivq9ckru9JwQyfl2u+lmcJUUZApBV/4lqlzuA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oxavq-006Twm-0z;
        Tue, 22 Nov 2022 22:35:54 +0100
Message-ID: <379c3360c8e675532e48d7f2e6cc99f4f98c0fbe.camel@sipsolutions.net>
Subject: Re: Variables being modified but not used in
 net/wireless/lib80211_crypt_tkip.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Colin King (gmail)" <colin.i.king@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 22 Nov 2022 22:35:53 +0100
In-Reply-To: <aeec15d5-6f7a-2c4f-0f90-72c52d082ce8@gmail.com>
References: <aeec15d5-6f7a-2c4f-0f90-72c52d082ce8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry it took me so long to get to this ...

This is ancient code, FWIW, and likely almost never used :-)

> I was reviewing some clang scan build static analysis results and found=
=20
> an interesting warning:
>=20
> Source: net/wireless/lib80211_crypt_tkip.c
>=20
> net/wireless/lib80211_crypt_tkip.c:667:7: warning: variable 'iv32' set=
=20
> but not used [-Wunused-but-set-variable]
>                  u32 iv32 =3D tkey->tx_iv32;
>=20
> The variables iv32 and iv16 are being decremented, but are not=20
> referenced after that. The seq[] array is being updated with the=20
> pre-decremented values. Is that correct?
>=20
>          if (seq) {
>                  /* Return the sequence number of the last transmitted=
=20
> frame. */
>                  u16 iv16 =3D tkey->tx_iv16;
>                  u32 iv32 =3D tkey->tx_iv32;
>                  if (iv16 =3D=3D 0)
>                          iv32--;
>                  iv16--;
>                  seq[0] =3D tkey->tx_iv16;
>                  seq[1] =3D tkey->tx_iv16 >> 8;
>                  seq[2] =3D tkey->tx_iv32;
>                  seq[3] =3D tkey->tx_iv32 >> 8;
>                  seq[4] =3D tkey->tx_iv32 >> 16;
>                  seq[5] =3D tkey->tx_iv32 >> 24;
>          }
>=20

By the comment, that's not correct, and should use iv16/iv32 in the
seq[] assignments, since lib80211_tkip_hdr() increments tx_iv16/32
*after* setting it in the frame.

That said only some really ancient ioctls can even reach this
(prism2_ioctl_giwencodeext, prism2_ioctl_get_encryption) and then it
will be used by hostapd only in AP mode (also likely less used than
client mode) to send the seqno of the GTK on GTK rekeying to the client,
and then the client will (hopefully) use it to drop replays ...

So looks like worst case the client would drop a single frame because of
this, unless of course that frame was anyway already transmitted while
the whole rekeying was in progress...

johannes
