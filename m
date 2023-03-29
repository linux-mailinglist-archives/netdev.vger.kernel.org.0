Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE20A6CF5BA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 23:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjC2V4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 17:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjC2V4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 17:56:44 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1F7AB;
        Wed, 29 Mar 2023 14:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vy5VjshajBzuksThs9FDAC6+Bs0LWo20nMqtVEhg39Y=;
        t=1680126993; x=1681336593; b=QMMNvxM+z4VDBTPGLtZYHNQm4T6xvOD8LRNYDE378jW+nGM
        VQPgB0m12MEMAv+u6VEuGy+QGD3fZTqeysTmGXaOaWXtUB5R0uSt63uOZCd2a8bpkpOfN4SrNkTUY
        DNSYEW5XXPPkC3+NS8cftKAUqyvh3bdTlEr0XIjxFXJMf7gwOkgQHP3DrAjfCKLHQv0f0yjkSStiN
        iGzKP0+esFVzqi84gQ7A7f6Wst86ISQozU3IP1wIcZD3+WDv5DLuueDwFbQBWB5EtXP19+Bhenj+9
        ZjQ82D40RcEOGH35bBM4pwnm5rlqiqa6w5FwNj1ki5lFOeWjNeAAhlBERP6zAsvg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phdmS-000Fbe-0C;
        Wed, 29 Mar 2023 23:56:32 +0200
Message-ID: <34e43da3694e2d627555af0149ebe438e1ed2938.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 2/2] mac80211: use the new drop reasons
 infrastructure
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 29 Mar 2023 23:56:31 +0200
In-Reply-To: <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
         <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple of comments that I didn't want to inline into the patch...

>=20
> +	/** @SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE: mac80211 drop reasons
> +	 * for unusable frames, see net/mac80211/drop.h

Not sure if that should be in net/mac80211/drop.h, or better
include/net/mac80211-drop.h or something.

> +static const char * const drop_reasons_monitor[] =3D {
> +#define V(x)	#x,
> +	[0] =3D "RX_DROP_MONITOR",
> +	MAC80211_DROP_REASONS_MONITOR(V)

We could, and perhaps should, add some prefix here, so the strings
become something like SKB_DROP_REASON_MAC80211_MONITOR_...

The only annoying thing with that is we'd probably then want to generate
the "RX_DROP_M_" prefix for the constants in the DEF() macros in the
header file, which might make elixir/ctags/... even worse - but it's
probably already pretty bad for it anyway.

> +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR)=
;
> +	drop_reasons_unregister_subsys(SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE=
);
> +
>  	rcu_barrier();

This is making me think that perhaps we don't want synchronize_rcu()
inside drop_reasons_unregister_subsys(), since I have two now and also
already have an rcu_barrier() ... so maybe just document that it's
needed?

> +++ b/net/mac80211/rx.c
> @@ -1826,7 +1826,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data=
 *rx)
>  				cfg80211_rx_unexpected_4addr_frame(
>  					rx->sdata->dev, sta->sta.addr,
>  					GFP_ATOMIC);
> -			return RX_DROP_MONITOR;
> +			return RX_DROP_M_4ADDR_NDP;

This was coded up too hastily, it should've been called
RX_DROP_M_UNEXPECTED_4ADDR.

> +++ b/net/mac80211/wpa.c
> @@ -550,7 +550,7 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_dat=
a *rx,
>  		if (res < 0 ||
>  		    (!res && !(status->flag & RX_FLAG_ALLOW_SAME_PN))) {
>  			key->u.ccmp.replays++;
> -			return RX_DROP_UNUSABLE;
> +			return RX_DROP_U_REPLAY;

I did wonder if we should distinguish CCMP/GCMP/... for replays, MIC
failures etc., but haven't really quite decided yet. With drop_monitor
you'd have the frame (I think?) and that makes it easy to see what it
was. It's also not really all that relevant for the drop reasons
infrastructure discussion.

johannes
