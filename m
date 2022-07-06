Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6AC569302
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiGFUEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiGFUE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:04:29 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2657E1C92F
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 13:04:27 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4LdVqq0fWnz9sSS;
        Wed,  6 Jul 2022 22:04:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1657137863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=avIO1ujrB/F+98eENe21GMcHEUTEprVL85O/GLe3NoA=;
        b=N8RjyeRNutvijHjk+BQBHQTYWKX/9ArKUCtd2tL2CvQRn0sX2ZFptlo0WkY0+j/OH6Vjt1
        NtfsEnEJkgWQFskkoQoP+v0itOgonMG/+iq0lQvEiKN5VzNi4rrHeJfp6ul3s5aGv4f8Xo
        fYOsqLI+1UryqMrZ86Rr4pGyhGMDu+MmhVsC83AXRmeFiZ7rtANXWGdHzAIkQ5opSEioQK
        1hNElGbSZT8kl/2wyJ4M6bIrp4D4L26Ck4EkNUU7FMyckRiVfsnGu4+mi7acxJFSuo/qW2
        wnixQmEcKxPVIOkcXXw2b40cjaox0Q4MqmfZo+3OD0r0OZHJejEa9fWirefgMQ==
Message-ID: <172da611-2997-e900-bcbd-6227102f494e@hauke-m.de>
Date:   Wed, 6 Jul 2022 22:04:19 +0200
MIME-Version: 1.0
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
In-Reply-To: <20220706164552.odxhoyupwbmgvtv3@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/22 18:45, Vladimir Oltean wrote:
> Hi Martin,
> 
> On Wed, Jul 06, 2022 at 06:33:18PM +0200, Martin Blumenstingl wrote:
>> Hi Vladimir,
>>
>> On Tue, Jul 5, 2022 at 7:32 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>>>
>>> Stop protecting DSA drivers from switchdev VLAN notifications emitted
>>> while the bridge has vlan_filtering 0, by deleting the deprecated bool
>>> ds->configure_vlan_while_not_filtering opt-in. Now all DSA drivers see
>>> all notifications and should save the bridge PVID until they need to
>>> commit it to hardware.
>>>
>>> The 2 remaining unconverted drivers are the gswip and the Microchip KSZ
>>> family. They are both probably broken and would need changing as far as
>>> I can see:
>>>
>>> - For lantiq_gswip, after the initial call path
>>>    -> gswip_port_bridge_join
>>>       -> gswip_vlan_add_unaware
>>>          -> gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
>>>    nobody seems to prevent a future call path
>>>    -> gswip_port_vlan_add
>>>       -> gswip_vlan_add_aware
>>>          -> gswip_switch_w(priv, idx, GSWIP_PCE_DEFPVID(port));
>> Thanks for bringing this to my attention!
>>
>> I tried to reproduce this issue with the selftest script you provided
>> (patch #1 in this series).
>> Unfortunately not even the ping_ipv4 and ping_ipv6 tests from
>> bridge_vlan_unaware.sh are working for me, nor are the tests from
>> router_bridge.sh.
>> I suspect that this is an issue with OpenWrt: I already enabled bash,
>> jq and the full ip package, vrf support in the kernel. OpenWrt's ping
>> command doesn't like a ping interval of 0.1s so I replaced that with
>> an 1s interval.
>>
>> I will try to get the selftests to work here but I think that
>> shouldn't block this patch.
> 
> Thanks for the willingness to test!
> 
> Somehow we should do something to make sure that the OpenWRT devices are
> able to run the selftests, because there's a large number of DSA switches
> intended for that segment and we should all be onboard (easily).
> 
> I wonder, would it be possible to set up a debian chroot?

OpenWrt takes many packages like ping from busybox, but OpenWrt can also 
install the full versions. Adding a package which packs the self tests 
from the kernel and has the needed applications as dependencies would be 
nice. It would be nice to have such a thing in the OpenWrt package feed 
then we can easily test switches.

A debian chroot should be possible, but Debian supports MIPS32 BE only 
till Debian 10, I do not know if this recent enough. The GSWIP driver 
only works on SoCs with a MIPS32 BE CPU, I think this is similar for 
some other switches too. There are some old manuals in the Internet on 
how to run Debian on such systems.

Hauke
