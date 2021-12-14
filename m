Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001C6473E14
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 09:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhLNINi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 03:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhLNINi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 03:13:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5483FC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 00:13:38 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639469615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZW7geBRCfWjV/5pAeBSqMdrg80omPfo6Nu/+6zCNoNQ=;
        b=hx9m7oWdNk3dxyYGnRpaFIT8HE4MIbgLsASmy86Nbakl93tG9VyaIYNU9DW4BO3eKAHgGJ
        hLcVQvFR3UlvyjsCmbxfFR3mKAecUd2TfRGdHZLZrOjNM+d4xX0PsTR4n+yXksYPbHXeAU
        chC5BJzn3WgsDG40TWRdMJUoirkhCgCBki/h/yfpmFogTlmYpbri915pZfXKz18NsgSyVR
        Lur2LvEeGAg8+sid9HSMkzaqo0wyr6/IppHfQE1AeOxhPCVG/yocahSq0+kjdz3jGO6xXo
        tzvGOu6y2BVC3N4zDN8P8h3qlB5+ezcXpJQbj1splrAxyCguCYn1pmlrbP6nsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639469615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZW7geBRCfWjV/5pAeBSqMdrg80omPfo6Nu/+6zCNoNQ=;
        b=EdVZF/KvOPdEi/DEUy052MfVKhLkPvzxT73xq5vqYZSFx6/Xasj78kF0GPXPEQT+2eZ28w
        5S03AzYibfmEfqCA==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: hellcreek: Allow PTP on blocked ports
In-Reply-To: <20211213121406.GB14042@hoboy.vegasvil.org>
References: <20211213101810.121553-1-kurt@linutronix.de>
 <20211213121406.GB14042@hoboy.vegasvil.org>
Date:   Tue, 14 Dec 2021 09:13:34 +0100
Message-ID: <87zgp338pd.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Richard,

On Mon Dec 13 2021, Richard Cochran wrote:
> On Mon, Dec 13, 2021 at 11:18:10AM +0100, Kurt Kanzenbach wrote:
>
>> @@ -1055,7 +1058,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
>>  		.portmask     = 0x03,	/* Management ports */
>>  		.age	      = 0,
>>  		.is_obt	      = 0,
>> -		.pass_blocked = 0,
>> +		.pass_blocked = 1,
>
> This one should stay blocked.

You're right. I confirmed with Hirschmann. Only peer delay measurements
should be allowed on blocked ports. In addition, we also have to add
static entries for STP with pass_blocked bit set. Furthermore, the UDP
entries are missing as well. Currently it only works for 802.1AS even
though the driver happily announces V2_EVENT capability.

I'll clean it up and resend properly.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmG4Ui4THGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwptwOEAC6KrHeFZPcRvnPfYDIpM4/k1MKOCiJ
xlnBc3qjY9fOydNraMGAseYNGoWT3gABs9rv/vix/bhpVg1de6KVRrrwUc5nMWVQ
NRh0Td92lUcVURHKJoKKiGHr2tRchyHvbg5Nm/aYKtjz7kfCq0u0+6UeTMw1ixsa
i/ZavuEGiiC2QcaIZnxb39EarU4ooQQVMx4tdIHyrtBovK9lhZ0fWeIx8OYJmPrz
58axJxGz/G9zraBt5smpz61DVxapxQOeLjwcJbdoEa5X8sp9GAyZAW7yGZ4vUNHE
FEaEGypm2q0qHDtJc9OVdb6Xd+EQo90p+lQVDOZpzeosmt/klIPvuVVql4SPSAtz
fMg7VAX+ZnGxwBfjtD0sBxL0Kp3ljDvle4JxWOJo2bK7qdmuWPmsAP57rM/5tgoZ
0NLCZJNReWD/T13NVmB+6EYTYtPOm/6Y+zDwKuTPwZGPF4DsUrOJn1fS4lP1JcFM
qLw98fBSbIrfwU6tsTMD/ETPhS1TSNoCMBgvGnauInBmrS5IXq+tCYvIMI1vdzQa
3as+Szv5jpyhygloqmmp9zkDV0n5K6ehquY5+vAF8lyp8rVDXQkGE09pzQn2CTMe
wkk3w86SoPcBrocCaN6QfV0XM1IC1+8Prub9CIRmhzyRm2+tAOAtLKVfp2HjT4H2
DBRoEQsczCNxUA==
=6f/J
-----END PGP SIGNATURE-----
--=-=-=--
