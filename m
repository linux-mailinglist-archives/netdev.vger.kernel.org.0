Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FCC4B138E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244856AbiBJQxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:53:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbiBJQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:53:05 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F7FD4
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=CA1IBl3OpeIdmti3f51wn9Zcc96/vpRB+dlAooHdVm0=; b=i6DQ1QaeauvohotDFz4vHkWxUQ
        7r851OkDTw8ps2gm+w9tE4pHnOfQ5mGljD+tc0ZboMsxLWuDwa74o/SMjmjq1UdTLyAHNDdfR/S5G
        M+FHj4U2ulat0zN8SqxeVXkaGoXzYgHrMPACu7U3lD9NSo9/LaXmCpcbOZ2KyV7U1054=;
Received: from p200300daa71e0b00d9ae6de683158d49.dip0.t-ipconnect.de ([2003:da:a71e:b00:d9ae:6de6:8315:8d49] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nICgr-0008Sk-03; Thu, 10 Feb 2022 17:53:05 +0100
Message-ID: <e8f1e8f5-8417-84a8-61c3-793fa7803ac6@nbd.name>
Date:   Thu, 10 Feb 2022 17:53:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
References: <20220210142401.4912-1-nbd@nbd.name>
 <20220210142401.4912-2-nbd@nbd.name>
 <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 2/2] net: bridge: add a software fast-path implementation
In-Reply-To: <bc499a39-64b9-ceb4-f36f-21dd74d6272d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10.02.22 16:02, Nikolay Aleksandrov wrote:
> Hi Felix,
> that looks kind of familiar. :) I've been thinking about a similar optimization for
> quite some time and generally love the idea, but I thought we'd allow this to be
> implemented via eBPF flow speedup with some bridge helpers. There's also a lot of low
> hanging fruit about optimizations in bridge's fast-path.
> 
> Also from your commit message it seems you don't need to store this in the bridge at
> all but can use the notifications that others currently use and program these flows
> in the interested driver. I think it'd be better to do the software flow cache via
> ebpf, and do the hardware offload in the specific driver.
To be honest, I have no idea how to handle this in a clean way in the 
driver, because this offloading path crosses several driver/subsystem 
boundaries.

Right now we have support for a packet processing engine (PPE) in the 
MT7622 SoC, which can handle offloading IPv4 NAT/routing and IPv6 routing.
The hardware can also handle forwarding of src-mac/destination-mac 
tuples, but that is currently unused because it's not needed for 
ethernet-only forwarding.

When adding WLAN to the mix, it gets more complex. The PPE has an output 
port that connects to a special block called Wireless Ethernet Dispatch, 
which can be configured to intercept DMA between the WLAN driver (mt76) 
and a PCIe device with MT7615 or MT7915 in order to inject extra packets.

I already have working NAT/routing offload support for this, which I 
will post soon. In order to figure out the path to WLAN, the offloading 
code calls the .ndo_fill_forward_path op, which mac80211 supports.
This allows the mt76 driver to fill in required metadata which gets 
stored in the PPE flowtable.

On MT7622, traffic can only flow from ethernet to WLAN in this manner, 
on newer SoCs, offloading can work in the other direction as well.

So when looking at fdb entries and flows between them, the ethernet 
driver will have to figure out:
- which port number to use in the DSA tag on the ethernet side
- which VLAN to use on the ethernet side, with the extra gotcha that 
ingress traffic will be tagged, but egress won't
- which entries sit behind mac80211 vifs that support offloading through 
WED.
I would also need to add a way to push the notifications through DSA to 
the ethernet driver, because there is a switch inbetween that is not 
involved in the offloading path (PPE handles DSA tagging/untagging).

By the way, all of this is needed for offloading a fairly standard 
configuration on these devices, so not just for weird exotic settings.

If I let the bridge code tracks flows, I can easily handle this by using 
the same kind of infrastructure that netfilter flowtable uses. If I push 
this to the driver, it becomes a lot more complex and messy, in my 
opinion...

- Felix
