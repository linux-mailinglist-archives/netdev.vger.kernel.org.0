Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37075671961
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjARKm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjARKku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:40:50 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D959FC9243;
        Wed, 18 Jan 2023 01:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=jYg9LvvVEHETjpBFwWfEGQdkZKWS+2ZpMIXB1mZyxrM=;
        t=1674035141; x=1675244741; b=aQ0KEnOhdVStYBJdWU8ZC8Jl7zr9UjfPHM0IbYVvJWI0HAM
        2Axe5LBIkP6aoxE/dImdB8JHcN31UOH5bYqTpQdIKrTAyWhSZ6Y9DIDSMrHTBwIBSp6Rze8g1IAWn
        dxXvcAIKmFGg0uobKMAVVktEBWei34epw2ccnPOYMIJay5kckY95ZImWTdCruVhy3x2vsXhJPTIo2
        ZtUy5hyrU15Kwdf4aSRnm0X40f2AdrSHJEpTEzrcCOHSEj9T8VrXirBp6GMNKs/rLCSYKc1G/2ooP
        p5/8AbbtNtFskyZ2kBc6zHcseKy0JaGF19WnQ9SDvyl2HD0lTM7aDAwtmzRCgmew==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pI50X-005Y8E-3D;
        Wed, 18 Jan 2023 10:45:26 +0100
Message-ID: <e33356c3b654db03030d371e38f02c6019e9c1a7.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mac80211: fix memory leak in
 ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     sara.sharon@intel.com, luciano.coelho@intel.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Date:   Wed, 18 Jan 2023 10:45:24 +0100
In-Reply-To: <20221202043838.2324539-1-shaozhengchao@huawei.com>
References: <20221202043838.2324539-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Fri, 2022-12-02 at 12:38 +0800, Zhengchao Shao wrote:
>=20
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1326,6 +1326,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  					      hw->rate_control_algorithm);
>  	rtnl_unlock();
>  	if (result < 0) {
> +		ieee80211_txq_teardown_flows(local);
>  		wiphy_debug(local->hw.wiphy,
>  			    "Failed to initialize rate control algorithm\n");
>  		goto fail_rate;
> @@ -1364,6 +1365,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
> =20
>  		sband =3D kmemdup(sband, sizeof(*sband), GFP_KERNEL);
>  		if (!sband) {
> +			ieee80211_txq_teardown_flows(local);
>  			result =3D -ENOMEM;
>  			goto fail_rate;
>  		}

I don't understand - we have a fail_rate label here where we free
everything.

What if we get to fail_wiphy_register, don't we leak it in the same way?

johannes
