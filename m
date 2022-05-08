Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D7B51EEB5
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbiEHPod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234977AbiEHPob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:44:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A821D1114
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:40:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4291A611E9
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 15:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35A1C385A4;
        Sun,  8 May 2022 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652024439;
        bh=AIRJRbkLv3JmajIHXK47icEM9MSjkIYfeBsdpm53zDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAsxA1gUDx5Db56zfvT605zgWFCya4ebd4IsszNEzLoyfjcM9wLRXZyFRZbB5RW1t
         g92st3PB47KjAvQ1Lq8FJmVDPVs1N4i+KsK/gkUAuJ4AWOOez3Z4/lxAptuh1fn/Ne
         SRHFlLibnkTbXrh+6HuoYcpv8ujCpmfFGunv3iAuiPuRW29mL3NEQ9hpmCqEbKCwLn
         +eIwYUEhVxXJta6s3qghLCIH+MUH7qyO+oAKFnxJ4qdkOV1O49PhsYvonM/Tels5CQ
         VKhAwbzBVdB+rK149nnOzhCS36wHhsYxBbAbPMhYKFeQfkKcK+gjaEZZmqVB+LEKQQ
         kiat4kISld6/g==
Date:   Sun, 8 May 2022 18:40:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lior Nahmanson <liorna@nvidia.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 00/3] Introduce MACsec offload SKB extension
Message-ID: <Ynfkc7CxqF29VTBv@unreal>
References: <20220508090954.10864-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220508090954.10864-1-liorna@nvidia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 08, 2022 at 12:09:51PM +0300, Lior Nahmanson wrote:
> This patchset introduces MACsec SKB extension to lay the ground
> for MACsec HW offload.
> 
> MACsec is an IEEE standard (IEEE 802.1AE) for MAC security.
> It defines a way to establish a protocol independent connection
> between two hosts with data confidentiality, authenticity and/or
> integrity, using GCM-AES. MACsec operates on the Ethernet layer and
> as such is a layer 2 protocol, which means it’s designed to secure
> traffic within a layer 2 network, including DHCP or ARP requests.
> 
> Linux has a software implementation of the MACsec standard and
> HW offloading support.
> The offloading is re-using the logic, netlink API and data
> structures of the existing MACsec software implementation.
> 
> For Tx:
> In the current MACsec offload implementation, MACsec interfaces are
> sharing the same MAC address of their parent interface by default.
> Therefore, HW can't distinguish if a packet was sent from MACsec
> interface and need to be offloaded or not.
> Also, it can't distinguish from which MACsec interface it was sent in
> case there are multiple MACsec interface with the same MAC address.
> 
> Used SKB extension, so SW can mark if a packet is needed to be offloaded
> and use the SCI, which is unique value for each MACsec interface,
> to notify the HW from which MACsec interface the packet is sent.
> 
> For Rx:
> Like in the Tx changes, packet that don't have SecTAG
> header aren't necessary been offloaded by the HW.
> Therefore, the MACsec driver needs to distinguish if the packet
> was offloaded or not and handle accordingly.
> Moreover, if there are more than one MACsec device with the same MAC
> address as in the packet's destination MAC, the packet will forward only
> to this device and only to the desired one.
> 
> Used SKB extension and marking it by the HW if the packet was offloaded
> and to which MACsec offload device it belongs according to the packet's
> SCI.
> 
> 1) patch 0001-0002, Add support to SKB extension in MACsec code:
> net/macsec: Add MACsec skb extension Tx Data path support
> net/macsec: Add MACsec skb extension Rx Data path support
> 
> 2) patch 0003, Move some MACsec driver code for sharing with various
> drivers that implements offload:
> net/macsec: Move some code for sharing with various drivers that
> implements offload

Can you please post diffstat and patch list of the series?
As a reply to this cover letter.

As an example:
https://lore.kernel.org/netdev/20220508153049.427227-1-andrew@lunn.ch/T/#m3c6fbfaa6c4e8c841e8bbb7e8953daefd2a53cd9

Thanks
