Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343CC6195BF
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbiKDMCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiKDMCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:02:10 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C40B2CE39;
        Fri,  4 Nov 2022 05:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=sGvcrdWq8O2i5HDw8YsZKUYGlsaOL9jNfb01fsYG9Jw=;
        t=1667563329; x=1668772929; b=WHvfrc1Y+x8veCMyjIt47B2qLuvsIwvg8T/J+p7div1/JK0
        vJerCY03sNTbiCxTebiJJ1Gey4cicSjpsIUZzat7WnmlKCx3wdRKs2uw2nuRY6mqYztxM3T5o0wJK
        d1sXz8JOKVXhSjgOzkIt+PRvPXwgsGGdoTO5up91fplsF684fPWHUvkl5Gkua6+mIdijpZGTzc/jU
        WAmKL750LfbG8OnhxitkdKE3dR4xMuuwTnXsyXclHnB4TeWYCVgEbBx+ySFOLCsZuOCJe2PXLn5xW
        4nfHYwQkUSXmVBA64Tj8Fm4GkrUtfJ1HlrqYfJPVfSxy/9DEHrmWxayCdaHsUYyg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oqvOW-008pi5-1d;
        Fri, 04 Nov 2022 13:01:56 +0100
Message-ID: <0132b2d13965997e03a98a0f32eabc15e5769462.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: rsi: Fix handling of 802.3 EAPOL frames sent
 via control port
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Vasut <marex@denx.de>, linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Date:   Fri, 04 Nov 2022 13:01:54 +0100
In-Reply-To: <20221104114412.9711-1-marex@denx.de>
References: <20221104114412.9711-1-marex@denx.de>
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

On Fri, 2022-11-04 at 12:44 +0100, Marek Vasut wrote:
>=20
> Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
> the rsi_91x driver, check the ethertype of the encapsulated frame,
> and in case it is ETH_P_PAE, transmit the frame via high-priority
> queue just like other ETH_P_PAE frames.

[...]

> NOTE: I am really unsure about the method of finding out the exact
>       place of ethernet header in the encapsulated packet and then
>       extracting the ethertype from it. Is there maybe some sort of
>       helper function for that purpose ?

[...]

> +bool rsi_is_tx_eapol(struct sk_buff *skb)
> +{
> +	struct ethhdr *eth_hdr;
> +	unsigned int hdr_len;
> +
> +	if (skb->protocol =3D=3D cpu_to_be16(ETH_P_PAE))
> +		return true;
> +
> +	if (skb->protocol =3D=3D cpu_to_be16(ETH_P_802_3)) {
> +		hdr_len =3D ieee80211_get_hdrlen_from_skb(skb) +
> +			  sizeof(rfc1042_header) - ETH_HLEN + 2;
> +		eth_hdr =3D (struct ethhdr *)(skb->data + hdr_len);
> +		if (eth_hdr->h_proto =3D=3D cpu_to_be16(ETH_P_PAE))
> +			return true;

This seems unnecessary, maybe mac80211 should set it correctly in the
first place, but anyway you should be able to just generally check

	IEEE80211_SKB_CB(skb)->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO

instead of looking at the skb->protocol.

johannes
