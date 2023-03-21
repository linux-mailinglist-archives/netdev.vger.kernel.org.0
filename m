Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6C86C30B3
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjCULsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjCULr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:47:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8A6474DC
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679399236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ibGB1JRKL8bh0FPECVe+ULtI0MnnMCaLaB2uuMNLuQ=;
        b=Ph8za3TJ1/1Xp3/f+IkQZ/QiOMv813h3dghEC7VBQMUmYynJpQ8wB9tSpF6IoV+VQivhPi
        yMeW9w1DFlVmXBHEw8frU/cnCchzN7DSvEtZDXaOo/gn/813Ks9vs8HmHKf8dURSGkmdM7
        tkGWm+8iNBFsXTQ37uXK1M8yuBpogxc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-ThCdlZ1tONy6Kp4BmQMf1g-1; Tue, 21 Mar 2023 07:47:13 -0400
X-MC-Unique: ThCdlZ1tONy6Kp4BmQMf1g-1
Received: by mail-qv1-f72.google.com with SMTP id z14-20020a0cd78e000000b005adc8684170so7390707qvi.3
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679399232;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ibGB1JRKL8bh0FPECVe+ULtI0MnnMCaLaB2uuMNLuQ=;
        b=y/NGVuUDwSVO2KtjJjkYucp1I5btIAC+t0vUld5tokZGfnmjV6mcP7zRJZT9z+iJS5
         D+DsQ/uP8wyPTpV6UD4asQYt9E8rq7c3mvYHpS/zU8KMmD/C40pt+nPsVZZerGxy8dXd
         Co2epIqMeW0WyhQSED4mJ/RVOI4X80r2W7RxbWY7HagV3Kzqw9mUuVHTB6SX49rw4j01
         s+4nEmeOrbBoV6tUPpBPP5d5h/1SKFfpD5Pb7iBLk6k86uiQlgFXugEWSFb8g7/jXfGV
         2+eChlPEgMRnAGH5VFwVSxmZQyV+RIvPpscpMI/D8GqTgGvv9KzqT97a7hwsHI+MBtap
         OyBA==
X-Gm-Message-State: AO0yUKWh7gC4po2Jh8HziJUdzCH+aW750053IgzHCC7YHwm/URF8yByq
        BU5IfBLXM7QG90v0DE8M7liclDDDlD8ZheKAQtFE4T2Kv1SyNnIQlwgVI4NiWYtO2o9u1T9g7gf
        KRBj+PS1vjkeXrwj1
X-Received: by 2002:a05:622a:4cd:b0:3e2:4280:bc58 with SMTP id q13-20020a05622a04cd00b003e24280bc58mr3604112qtx.3.1679399232613;
        Tue, 21 Mar 2023 04:47:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set+C2o/G+F0fJuALBsWLTswMBX4UegjfDSgvFxPo6rppyVR01xZdpgQ8uk4WBPDWl6+W1DiAzw==
X-Received: by 2002:a05:622a:4cd:b0:3e2:4280:bc58 with SMTP id q13-20020a05622a04cd00b003e24280bc58mr3604089qtx.3.1679399232378;
        Tue, 21 Mar 2023 04:47:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-19.dyn.eolo.it. [146.241.244.19])
        by smtp.gmail.com with ESMTPSA id 9-20020ac85649000000b003bfc355c3a6sm8094078qtt.80.2023.03.21.04.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 04:47:11 -0700 (PDT)
Message-ID: <9c2a6d714969b0151da4e3aaaf4fa2b7c4e9f616.camel@redhat.com>
Subject: Re: [PATCH net-next] net: dsa: qca8k: remove assignment of
 an_enabled in pcs_get_state()
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org
Date:   Tue, 21 Mar 2023 12:47:08 +0100
In-Reply-To: <E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk>
References: <E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk>
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

Hello,

On Sun, 2023-03-19 at 12:33 +0000, Russell King (Oracle) wrote:
> pcs_get_state() implementations are not supposed to alter an_enabled.
> Remove this assignment.
>=20
> Fixes: b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLI=
B")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Any special reason to target the net-next tree? the fixes commit is
quite old, and this looks like a -net candidate to me?!?

Thanks!

Paolo

