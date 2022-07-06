Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC3F568F38
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiGFQdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiGFQdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:33:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA07DFC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:33:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x10so12623418edd.13
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 09:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KK048VZ34M5ovDSBwkVNDS37dZN4r1BawpIWdHDsBxw=;
        b=lGYB2M1EDalfV7ktJkLqCTM10Yx4UcG/pUzsEvIcJIoKbtjmX/FqeprKk6WLb+WdQO
         b+0Rp8XhAp/QekrdQVgUMyKMkimdqduPiQi7+ZB2I0Y1/LEmJpa2AkgvEwM2iRxOXybL
         hvBakOwb8bvPokbDMZtyE57znMJMXzamFD45WSBRqeXh5Icoj+d77GYyHYqu7fFsY47D
         8l4vDTXYnDZMsYdyH6EJtHL3qevJzJnybWY/DAk22jkGal2JcLYWe6GMl8qVpOCYK9Cg
         2O3e0GyDnLWG6QdnX7IgUjzpN9dRIq7WXg5R8/hDhngWwPrByaw/+6pu9vqiX31d9zdC
         8KFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KK048VZ34M5ovDSBwkVNDS37dZN4r1BawpIWdHDsBxw=;
        b=qoxg62i/FwkJYfHJdcAnytY0XgmEr48XjZciq0ZQFuWUkCfjY62fa26Khc+ayqgOtO
         rXtAsSlCPrGNbf9GiSIpoc6bBKaviNk5+mIpWAZ5YRzgEF9yumS0iy6t+Z9K+BD5QZD4
         9qQFANoRfkRTzwFouYYzYN3yjsGYItF+BsgdiUo0DhahHC+DoHmjtGACoE0wZebBkNrx
         FP6hemIRu6sDJbOKyW4ngduUCNMsCwFP1hdPtEr3jVMYYuoW9XvJVhAVXDrfPb0Vv8mh
         2IYqATUX0+2iD50/8CvZKLl3sQ5nd8eXjvusl0dgND03GFaSjS3oquo30kkLYmRoE5aV
         v/fg==
X-Gm-Message-State: AJIora+cOrC08jgvYbon2OHUAe8dVRlusmEZlUhgOkjYP7RH7IQOGyIp
        Db6Gxfd1a4F0SCLzMzjetW6IGEkMYoLEEtQqyBo=
X-Google-Smtp-Source: AGRyM1tdwjlBX0ZU46u8LzVeI1gVX93uMldhQ2OaNkZTNdJvAxWXFVytKoyBHNnyF1cjBT89WB+pfdfqJdH8THhkQlM=
X-Received: by 2002:a05:6402:27c8:b0:435:d40e:c648 with SMTP id
 c8-20020a05640227c800b00435d40ec648mr55456417ede.200.1657125209327; Wed, 06
 Jul 2022 09:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com> <20220705173114.2004386-4-vladimir.oltean@nxp.com>
In-Reply-To: <20220705173114.2004386-4-vladimir.oltean@nxp.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 6 Jul 2022 18:33:18 +0200
Message-ID: <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Jul 5, 2022 at 7:32 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> Stop protecting DSA drivers from switchdev VLAN notifications emitted
> while the bridge has vlan_filtering 0, by deleting the deprecated bool
> ds->configure_vlan_while_not_filtering opt-in. Now all DSA drivers see
> all notifications and should save the bridge PVID until they need to
> commit it to hardware.
>
> The 2 remaining unconverted drivers are the gswip and the Microchip KSZ
> family. They are both probably broken and would need changing as far as
> I can see:
>
> - For lantiq_gswip, after the initial call path
>   -> gswip_port_bridge_join
>      -> gswip_vlan_add_unaware
>         -> gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
>   nobody seems to prevent a future call path
>   -> gswip_port_vlan_add
>      -> gswip_vlan_add_aware
>         -> gswip_switch_w(priv, idx, GSWIP_PCE_DEFPVID(port));
Thanks for bringing this to my attention!

I tried to reproduce this issue with the selftest script you provided
(patch #1 in this series).
Unfortunately not even the ping_ipv4 and ping_ipv6 tests from
bridge_vlan_unaware.sh are working for me, nor are the tests from
router_bridge.sh.
I suspect that this is an issue with OpenWrt: I already enabled bash,
jq and the full ip package, vrf support in the kernel. OpenWrt's ping
command doesn't like a ping interval of 0.1s so I replaced that with
an 1s interval.

I will try to get the selftests to work here but I think that
shouldn't block this patch.


Best regards,
Martin
