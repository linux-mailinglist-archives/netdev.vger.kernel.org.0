Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214CB2515A9
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgHYJmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHYJmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:42:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74090C061574;
        Tue, 25 Aug 2020 02:42:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598348523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+Ss+1fob1O6FWxjtF6nrsXHbKK8dvDZbAhYL4hFrIA=;
        b=cr0TmoiU6ip2MXdtuJMHbf+/qDvLAgwTQYErKTnmX5SNIaMEGNYwvGWAr3U6QVad3Z585b
        VtkpgavkL9ZPUzBejWqpNxtTf1ofg+cd/ZwrexuAsSgK/fFRpSF3cxARgKSv2998anUH5f
        YLJNBNgUnDZpp/Hs8BpPey7R+4MA7Rr3Q5NW7T6lXTGaOvPyF8fBMtIOU1nt9EjpheqR+y
        VOLPrmdIc+bqYVjLbBgQve7o+jfNRe9dFBGSp0ut5rPRLIuR35tx4m3B2ID4csQXy3mlNQ
        dNlo/Hcf209QeiptBRYRE6XcjS7J/2kFl/8uo5iw4R6lPhL44yl559zr7JgxHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598348523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+Ss+1fob1O6FWxjtF6nrsXHbKK8dvDZbAhYL4hFrIA=;
        b=4sUO7BIbXUi7pGUUyxjGhPiLsadhTbX/cN/SKVZELKKvcHby7SYioronJ6nCQ2SbrrS25R
        dxPaP/hlQgdJeAAQ==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 5/8] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <87y2m3txox.fsf@intel.com>
References: <20200820081118.10105-1-kurt@linutronix.de> <20200820081118.10105-6-kurt@linutronix.de> <20200822143922.frjtog4mcyaegtyg@skbuf> <87imd8zi8z.fsf@kurt> <87y2m3txox.fsf@intel.com>
Date:   Tue, 25 Aug 2020 11:42:02 +0200
Message-ID: <875z9712qd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Aug 24 2020, Vinicius Costa Gomes wrote:
> Hi Kurt,
>
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
>>>> +static void hellcreek_setup_tc_mapping(struct hellcreek *hellcreek,
>>>> +				       struct net_device *netdev)
>>>> +{
>>>> +	int i, j;
>>>> +
>>>> +	/* Setup mapping between traffic classes and port queues. */
>>>> +	for (i = 0; i < netdev_get_num_tc(netdev); ++i) {
>>>> +		for (j = 0; j < netdev->tc_to_txq[i].count; ++j) {
>>>> +			const int queue = j + netdev->tc_to_txq[i].offset;
>>>> +
>>>> +			hellcreek_select_prio(hellcreek, i);
>>>> +			hellcreek_write(hellcreek,
>>>> +					queue << HR_PRTCCFG_PCP_TC_MAP_SHIFT,
>>>> +					HR_PRTCCFG);
>>>> +		}
>>>> +	}
>>>> +}
>>>
>>> What other driver have you seen that does this?
>>>
>>
>> Probably none.
>>
>> With TAPRIO traffic classes and the mapping to queues can be
>> configured. The switch can also map traffic classes. That sounded like a
>> good match to me.
>
> The only reason I could think that you would need this that *right now*
> taprio has pretty glaring oversight: that in the offload parameters each entry
> 'gate_mask' reference the "Traffic Class" (i.e. bit 0 is Traffic Class
> 0), and it really should be the HW queue.
>
> I have a patch that does the conversion on taprio before talking to the
> driver. Do you think it would help you avoid doing this on the driver
> side?

I think so. As Vladimir pointed out, the driver should setup an identity
mapping which I already did by default.

Can you point me your patch?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9E3OoACgkQeSpbgcuY
8KZ8dxAAxgttX/K0rFFtRu/2uiG0DqMlOfsa6okj35BVMrZYHKyeMh0Z79vSvu3b
3dP3zk4AzDnWwvv2EriOJndGUouB+5PSh+elxQiaDplbsGRYwFt64PHeazGFrXmg
Ze/eiqLFNj9dWVVKWwK9dlY8OZN+TMTlykBfLMkjtCS988b7pXj7UiYpAidyQ/pR
JAmJG/WIkWZPnv976FwHfaji0kHTKlHdm+RxqI6xkFR6fiQelXansUHGW4VVl+/J
TnvGF+RDss5MiWz1DYnCQC6xir9IsVVp6hJqhzZnnOd4TnoViMSF0XwQpIL0x+OY
AZod/eAlrQdAEzlj6bW0NA8anVxSBy2Wc0EfdOnsyw/NQ7gyKAZwqITOPZbz43GR
oSys/Gq3j+2BgTrpzB/nxKwB2EMDy3D0+lH/l0yWcJFXjRgGAWFrx5Jq2iTq/ttp
PDN+VwMWD371pPRtvqjONZkCVSx4HzC7u3K0oFr9m2OSY0BcVExMtqsUgC9Zr1sQ
ZHULIPQrJ21CiiMHv6Z26KknKxXzrTh4LY9G2M8k+Lo8A2rTnUT5ZzPdPwDlFFTz
hD7FZZowi3PJ8Qe5ABf9McUtfXnc+goDiVFAliBq+gRMF/fo94G42o4TVaiTDmFL
fy6wNzn3gOO4VsXPKFUDzYsgJcyvUS1O5FjpoJr1CD1BUzBIBw4=
=sWPu
-----END PGP SIGNATURE-----
--=-=-=--
