Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9993D9C90
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhG2EX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2EX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:23:27 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9979CC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:23:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ca5so8359015pjb.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JYmM1PPgd4m/UVC0Uv+s8j70kYQ2+cdyylIZCdjsdy0=;
        b=J3udGRsDMy2KBZqoT/IAY9IVFwn5g6FrReMz5OKq4q+cm7C+v81phmU5y7OUq0yS6p
         oFUtgo1CyFQq4ct8nXqCRFam+XIWjlTs5v9te5rwfnoppjtAcNpk9pAkC7mhM0ynx8se
         newv+u04Ua3Oa3KHpxFdpOUE1FySfxjo88rTY/rPZbwerSFa3Xd653J/TtdxN7Ol7xzW
         GGwW/aRCiMZuBKPFQPVolwZNbCONc73iIY8ckdvj3hAiEJ3sASnZo5ATzC+f2+2fEM/D
         6HG7XPDL09puy4E6uqPdxL3s8djbNErHGVl8Ry37fJcibExGdudSsXRemDPGB34zCL25
         Q7Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JYmM1PPgd4m/UVC0Uv+s8j70kYQ2+cdyylIZCdjsdy0=;
        b=eYcF4rlQ0uwCkncraPY+UeHUiymuyhfFC+XjZKkuPRKgEPcvdf7RoxOn4f+gOsRKvN
         +GN63FkbLyF/niPUrQUiOEfzHjmNiIroiKifEcTCsHwGrEmuBS67xLLJrRDG+WkaqE4w
         V0n830rJ3ziDwsLtzekmZwY2vTkOKezl7q/x73SrGLfKHjU2U9dg099cX5qElMM/1rOp
         e9NrjIJ7cSo6DcaZV58cftzctySKcKlnfxM1Y6qQxpY6/3KN3zNZxj7ZhnPvIZgS5mb5
         9UChpLGURJpnOHE5+LVgClqylELXs5F3Vmwrtzl3ilU+P9IxovCO4DyNKG+KgH/bs7Yo
         NDMA==
X-Gm-Message-State: AOAM531Lo5MM5MQgrlQrDDNKg21bF29TpUfVCFeEPWKM1KuI3/Efb5wB
        wIFdbab1Qxevg3y11cbN9dE=
X-Google-Smtp-Source: ABdhPJzVy4WEAjebbXnJURS7OjYavsR4tECcJkK/luwa0SU04k/hV2a65s1jJ5zBG2x1nGU/VN2Jdg==
X-Received: by 2002:a65:5087:: with SMTP id r7mr2180473pgp.160.1627532604165;
        Wed, 28 Jul 2021 21:23:24 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w18sm1427674pjg.50.2021.07.28.21.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:23:23 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: dsa: sja1105: make sure untagged
 packets are dropped on ingress ports with no pvid
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
 <20210728215429.3989666-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <047854fe-a850-d105-1b62-6cbb49823fc4@gmail.com>
Date:   Wed, 28 Jul 2021 21:23:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728215429.3989666-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2021 2:54 PM, Vladimir Oltean wrote:
> Surprisingly, this configuration:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp2 master br0
> bridge vlan del dev swp2 vid 1
> 
> still has the sja1105 switch sending untagged packets to the CPU (and
> failing to decode them, since dsa_find_designated_bridge_port_by_vid
> searches by VID 1 and rightfully finds no bridge VLAN 1 on a port).
> 
> Dumping the switch configuration, the VLANs are managed properly:
> - the pvid of swp2 is 1 in the MAC Configuration Table, but
> - only the CPU port is in the port membership of VLANID 1 in the VLAN
>    Lookup Table
> 
> When the ingress packets are tagged with VID 1, they are properly
> dropped. But when they are untagged, they are able to reach the CPU
> port. Also, when the pvid in the MAC Configuration Table is changed to
> e.g. 55 (an unused VLAN), the untagged packets are also dropped.
> 
> So it looks like:
> - the switch bypasses ingress VLAN membership checks for untagged traffic
> - the reason why the untagged traffic is dropped when I make the pvid 55
>    is due to the lack of valid destination ports in VLAN 55, rather than
>    an ingress membership violation
> - the ingress VLAN membership cheks are only done for VLAN-tagged traffic
> 
> Interesting. It looks like there is an explicit bit to drop untagged
> traffic, so we should probably be using that to preserve user expectations.
> 
> Note that only VLAN-aware ports should drop untagged packets due to no
> pvid - when VLAN-unaware, the software bridge doesn't do this even if
> there is no pvid on any bridge port and on the bridge itself. So the new
> sja1105_drop_untagged() function cannot simply be called with "false"
> from sja1105_bridge_vlan_add() and with "true" from sja1105_bridge_vlan_del.
> Instead, we need to also consider the VLAN awareness state. That means
> we need to hook the "drop untagged" setting in all the same places where
> the "commit pvid" logic is, and it needs to factor in all the state when
> flipping the "drop untagged" bit: is our current pvid in the VLAN Lookup
> Table, and is the current port in that VLAN's port membership list?
> VLAN-unaware ports will never drop untagged frames because these checks
> always succeed by construction, and the tag_8021q VLANs cannot be changed
> by the user.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
