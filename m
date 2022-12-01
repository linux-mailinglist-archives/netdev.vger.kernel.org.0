Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E9063F2AE
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiLAOWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiLAOWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:22:07 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EEAFCDB;
        Thu,  1 Dec 2022 06:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=bCMJdqjQT1C+lyPg212mzOe+CN9xuXGYzEqC3PBQOE8=;
        t=1669904526; x=1671114126; b=TpjDliV0e7cUoC/BO2W5sEXPqyCQmZSqmjGj85tO/5RjoHU
        QXKlPrwdMkDd5/pCqg6ioAamxwmKXaxxZ0R35eOzXKzhBSAn/qYFUaIBSvv3uoFd74QSjq7qtMYDQ
        Vl65aTl1nZW19tT286JD2AEKL2IXcfbOVj+1I/SWHLzBGtmVVSs/S3ccXWZ4jRRdV8UPLmcwMALnI
        vr2ULQX7MLiqbGq8DGP3s88MxADiA2T66eRvHFWqOwJIZzvK/gwbYajNsIiO1VFOeQjz0mhXzcGHu
        IenN1uwfnFdkqK60+E4fetCS2JVQ1J1kwm1ERy91zHblqNBAsaOkLohuK0cEfiUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1p0kRq-00E61j-2J;
        Thu, 01 Dec 2022 15:21:58 +0100
Message-ID: <7b5cadba428b153cca5fed84cd4ccc25e31c9334.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: fix a possible memory leak
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Dec 2022 15:21:57 +0100
In-Reply-To: <20221101201931.119136-1-dinguyen@kernel.org>
References: <20221101201931.119136-1-dinguyen@kernel.org>
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

On Tue, 2022-11-01 at 15:19 -0500, Dinh Nguyen wrote:
> Klockworks
>=20
You probably mean "klocwork" :)

>  reported a possible memory leak when
> cfg80211_inform_single_bss_data() return on an error and ies is left
> allocated.
>=20
> Fixes: 0e227084aee3 ("cfg80211: clarify BSS probe response vs. beacon dat=
a")
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  net/wireless/scan.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 806a5f1330ff..3c81dc17e079 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -2015,8 +2015,10 @@ cfg80211_inform_single_bss_data(struct wiphy *wiph=
y,
> =20
>  	signal_valid =3D data->chan =3D=3D channel;
>  	res =3D cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid, t=
s);
> -	if (!res)
> +	if (!res) {
> +		kfree(ies);
>  		return NULL;
> +	}
>=20

To be honest this makes me a bit nervous - the function will take over
ownership of the tmp BSS in many cases if not all. Not saying it doesn't
have a bug, but at least one case inside of it *does* free it even in
the case of returning NULL and then you have a double-free?

So I think you didn't look at the code closely enough. Please do check
and follow up with a proper fix.

johannes
