Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0476E5D61
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjDRJ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjDRJ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:28:56 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BB56591;
        Tue, 18 Apr 2023 02:28:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681810087; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=lLvySzOabgFP/7Ao7CJlTBRyDWY6A1ilWyhW0ndfEuusPbEDT/0r6cNX0iW6rkVXOG6NWtr+YcioR5CAKESG8PQV1kHmvhgSM4b/qsI74Nid/Aor+bLFdq0n7IQZHqOB6nIIUPVzDQlXI8o6yrqhZ2YliJeGvY17RiBgcZSvpcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681810087; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=iDqp1SgzROa/7M8TqdAaMU2o1J0hj8rCWz0qyNlos7g=; 
        b=TVBBWawTRu16UVXrfJRP+h+QvQU2AGOKSh7y3WQFpUwKF6uiKUW6EnKXM529ta0kbCwCRLGfS+kMeljHzOVNzuThnMP5+7mt5NV2apcWaHw5q6uZhUFPTLcqGnu2fXVdnk2nYvSmIQBy9XYI1HJQAR3pAx1lxhdutoO80dw8Vho=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681810087;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=iDqp1SgzROa/7M8TqdAaMU2o1J0hj8rCWz0qyNlos7g=;
        b=L2sWvgxViPh4NyfAkwuFIx7NalD2FR/IBDd8b8LCwpo/A7XWgzOQ5aHw3UCh6UVg
        89+HHmOSBXo0t3J7QsjLaGCrYPl2Ryhz7RRyqZIAoJCx61K78v4loU0AVXRktEtOH53
        C5+7pH7qQd1tNuFS1pj5axwiG+3i8SY7ZoGo3QqM=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 168181008614670.97003674812629; Tue, 18 Apr 2023 02:28:06 -0700 (PDT)
Message-ID: <e8accb50-6e46-4309-adf3-62f7445e18f2@arinc9.com>
Date:   Tue, 18 Apr 2023 12:27:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC/RFT v1] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
To:     Frank Wunderlich <linux@fw-web.de>, Felix Fietkau <nbd@nbd.name>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>
References: <20230416091038.54479-1-linux@fw-web.de>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230416091038.54479-1-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2023 12:10, Frank Wunderlich wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when receiving
> tagged packets on the secondary MAC, the hardware can sometimes start to emit
> wrong tags on the first MAC as well.
> 
> In order to avoid such issues, drop the feature configuration and use the
> offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
> only use one MAC.

I would change this part to:

In order to avoid such issues, drop the feature configuration and use 
the offload feature only for DSA hardware untagging on MT7621/MT7622 
devices where this feature works properly.

I tried this on linux-next with my defconfig and devicetree [0], on a 
MikroTik RouterBOARD 760iGS. I tried both VLAN configurations possible, 
VLAN subinterface of the eth1 interface, and bridge VLAN filtering on a 
bridge with eth1 joined. In both cases, both sides receive VLAN tagged 
frames whether this patch is applied or not.

My computer is plugged to the RJ45 SFP module which is connected to the 
Qualcomm Atheros AR8031/AR8033 PHY which is connected to MT7621's gmac1.

My computer:
sudo ip l add link enp9s0 name enp9s0.10 type vlan id 10
sudo ip a add 192.168.3.2/24 dev enp9s0.10
sudo ip l set up enp9s0

MT7621 VLAN subinterface test:
ip l add l eth1 name eth1.10 type vlan id 10
ip a add 192.168.3.1/24 dev eth1.10
ip l set up eth1
ip l set up eth1.10
ping 192.168.3.2

MT7621 bridge VLAN filtering test:

ip l del eth1.10
ip l add br0 type bridge vlan_filtering 1
ip l set eth1 master br0
bridge v add vid 10 dev eth1
bridge v add vid 10 dev br0 self
ip l add l br0 name br0.10 type vlan id 10
ip a add 192.168.3.1/24 dev br0.10
ip l set up br0
ip l set up br0.10
ping 192.168.3.2

In conclusion, it's not that VLAN RX offloading is being kept enabled 
for MT7621 because it uses only one MAC. It's because it just works. I 
am assuming this is the same case for MT7622.

With that:

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>

[0] https://github.com/arinc9/linux/commits/test-on-linuxnext

Arınç
