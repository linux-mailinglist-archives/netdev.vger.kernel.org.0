Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5B56C202D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCTSng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjCTSnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:43:17 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB6B3C79E;
        Mon, 20 Mar 2023 11:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=C8FeRadYDnvzZ/bAurGOxXqZGb263UdMJpdekcM+TXg=;
        t=1679337333; x=1680546933; b=FUJgMgRv4mHBS5nOEWpTSmisA2rXrHyHTCbArKUnlVKAqUI
        SfG1cRNiSFBOoOb7TQyS7hsGRvKsuLafcZiv2YxtwMC6IPW0UVf3XQguj77snPgfzzVI8WOfM5bAd
        0tlgtXrS83AQAq9mEFMlPeeQyzWWoLugGEVIZbaUFH1lqqodAb6gPgoOTXHBwCcqSxKnHTIh2qK01
        fW1+LBGw2mtoJwVvW/4PJgEp75Y9LkYMEeEJA0jADPP50o50CU9kxnYKy6qK9V2JozJ4TzoBcWzFg
        domG77IkWDyGvDRlmiJCwwNFXxPVjZm5ZZBT5DvN4Xo4fUnnyS2t0SoOjfgTsQxw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1peKLU-0096HN-1I;
        Mon, 20 Mar 2023 19:35:00 +0100
Message-ID: <0ec5fe8b6945ee545b335ef2f3bee75b0af458d0.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: iwlwifi: dvm: Add struct_group for struct
 iwl_keyinfo keys
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kees Cook <keescook@chromium.org>
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Berg <benjamin.berg@intel.com>,
        Sriram R <quic_srirrama@quicinc.com>,
        lukasz.wojnilowicz@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Date:   Mon, 20 Mar 2023 19:34:59 +0100
In-Reply-To: <641897bd.630a0220.174d9.9d11@mx.google.com>
References: <20230218191056.never.374-kees@kernel.org>
         <3181a89b49e571883525172a7773b12f046e8b09.camel@sipsolutions.net>
         <641897bd.630a0220.174d9.9d11@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

> >=20
> > >  	case WLAN_CIPHER_SUITE_TKIP:
> > >  		key_flags |=3D STA_KEY_FLG_TKIP;
> > >  		sta_cmd.key.tkip_rx_tsc_byte2 =3D tkip_iv32;
> > >  		for (i =3D 0; i < 5; i++)
> > >  			sta_cmd.key.tkip_rx_ttak[i] =3D cpu_to_le16(tkip_p1k[i]);
> > > -		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
> > > +		memcpy(&sta_cmd.key.keys, keyconf->key, keyconf->keylen);
> >=20
> > And that's actually a bug, we should've copied only 16 bytes, I guess.
> > DVM didn't support MIC offload anyway (at least the way Linux uses the
> > firmware, though I thought it doesn't at all), so we don't need the MIC
> > RX/TX keys in there, but anyway the sequence counter values are not par=
t
> > of the key material on the host.
> >=20
> > I don't think I have a machine now to test this with (nor a TKIP AP, of
> > course, but that could be changed) - but I suspect that since we
> > actually calculate the TTAK above, we might not even need this memcpy()
> > at all?
>=20
> It's the latter that is triggered in the real world, though. See the
> referenced URL and also now on bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217214
> i.e.: drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1103
>=20
> So keyconf->keylen is coming in as 32. If this is a bug, I'm not sure
> where/how to fix it.

Yes, I know it's coming in as such - I believe it should be copying 16
bytes instead of the full keylen. TKIP keys are comprised of 16 bytes
encryption/decryption key and 8 bytes TX/RX MIC keys for a total of 32,
but since the device doesn't do MIC calculations, it only needs the
first 16 bytes here (if even that, since we also give it the P1K which
is derived from the TK...? maybe not even that)

But I guess we should test it ... not sure I still have a machine that
takes these NICs (I do have NICs).

johannes
