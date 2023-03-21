Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3126C347B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjCUOkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjCUOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:39:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2346D4FA83
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679409551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=te2wjPxLotIIBWis0C4qhukl42NU3760NpTaXDtKkAA=;
        b=Dq94Dd9LrlN10j8wjjCheUfWqTK8Rvp0tyG9mGg47KbX3/EdW9OGIs9vMQOO/2fNP8zMzz
        KHQXwix14OPXBqTmc+jCQ+Lm4ydhEF3uZ7V51EUwGQbBOuf38uYv1HSbCFImyRcmD8dIUX
        64B7fOm39aen9n6CicpAJ9PUfRRBY58=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-Vq7D5osPPy28frlS3jK66g-1; Tue, 21 Mar 2023 10:39:08 -0400
X-MC-Unique: Vq7D5osPPy28frlS3jK66g-1
Received: by mail-wm1-f71.google.com with SMTP id bi5-20020a05600c3d8500b003edda1368d7so2829904wmb.8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 07:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679409547;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=te2wjPxLotIIBWis0C4qhukl42NU3760NpTaXDtKkAA=;
        b=CNfMuQofP1dBrOQPVrA+PaXAFwhZPVJw+tbRYl9FlFuc8qSim/PfXSdj2z0Bz4zPAP
         pRqJ3ZXH3ov2igMWj3eZUlkb1nAh6xETEMnyylsWVyl52uUZvwDV5UOO2IqxxOLbaV0q
         y+bgbtejdbhrX43GsDfNo+ngAkC1BBdu5/dnScFGbk31ueO3BzMpGsxzsJ6ncltYAUh7
         y5h9DUGStif7mt4jq9anVHRwMKm0YvawyVq2tfnYJgBf3E6me4hS1iNPuvSXVXzSM+iX
         IPizynyCpQZlaQi7Mggscsq/LN8gNPT7Zhl3U0Ns+QmPUMeLe5SJzl3+SMFMHqi61a3G
         7OhQ==
X-Gm-Message-State: AO0yUKVnINeu4Ob2F6cqlFzIj2+M6Dt3MuJWb1FryseVPWa6wHPBpFNc
        EuFrP/bVMpt2jkpfij12/WgWlNXTz/i77D9qav4JYzjHxPasTx9WX7LjylqJRQguXrNKzrGOraF
        UmCj8/PcSyQXgKGwO
X-Received: by 2002:a05:600c:4744:b0:3ed:ebcb:e2c6 with SMTP id w4-20020a05600c474400b003edebcbe2c6mr2966528wmo.3.1679409547710;
        Tue, 21 Mar 2023 07:39:07 -0700 (PDT)
X-Google-Smtp-Source: AK7set8Jpe5k8eJaSDWziJnwP3NQWvprpto6X93PPJIuPivb6Bx6XPYOeMSt783Ld3ERpqKIUsu/Vg==
X-Received: by 2002:a05:600c:4744:b0:3ed:ebcb:e2c6 with SMTP id w4-20020a05600c474400b003edebcbe2c6mr2966505wmo.3.1679409547445;
        Tue, 21 Mar 2023 07:39:07 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-19.dyn.eolo.it. [146.241.244.19])
        by smtp.gmail.com with ESMTPSA id k15-20020a05600c1c8f00b003ed793d9de0sm2618439wms.1.2023.03.21.07.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:39:07 -0700 (PDT)
Message-ID: <7589589f340f1ecb49bc8ed852e1e2dddb384700.camel@redhat.com>
Subject: Re: [PATCH net v2 2/2] smsc911x: avoid PHY being resumed when
 interface is not up
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 21 Mar 2023 15:39:05 +0100
In-Reply-To: <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
         <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-20 at 10:20 +0100, Wolfram Sang wrote:
> SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
> 'mac_managed_pm'. However, setting it needs to be moved from init to
> probe, so mdiobus PM functions will really never be called (e.g. when
> the interface is not up yet during suspend/resume). The errno is changed
> because ENODEV has a special meaning when returned in probe().
>=20
> Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend an=
d resume")
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> Changes since v1:
> * no change
>=20
> In smsc911x_mii_probe(), I remove the sanity check for 'phydev' because
> it was already done in smsc911x_mii_init(). Let me know if this is
> acceptable or if a more defensive approach is favoured.

Since this is a fix, I would keep the old check, too.

> @@ -1108,6 +1102,15 @@ static int smsc911x_mii_init(struct platform_devic=
e *pdev,
>  		goto err_out_free_bus_2;
>  	}
> =20
> +	phydev =3D phy_find_first(pdata->mii_bus);
> +	if (!phydev) {
> +		netdev_err(dev, "no PHY found\n");
> +		err =3D -ENOENT;
> +		goto err_out_free_bus_2;

Why don't you call mdiobus_unregister() in this error path?

mdiobus_register() completed successfully a few lines above.

Cheers,

Paolo

