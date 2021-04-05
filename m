Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD0354726
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbhDETbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhDETbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 15:31:05 -0400
Received: from discovery.labus-online.de (discovery.labus-online.de [IPv6:2a01:4f8:231:4262::1001])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC29C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 12:30:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by discovery.labus-online.de (Postfix) with ESMTP id F14F9112004F;
        Mon,  5 Apr 2021 21:30:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freifunk-rtk.de;
        s=modoboa; t=1617651057;
        bh=LcAhXDRx4FpyQfdBRJYtNs7hffOq2LGsi5zEFKzZvUE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=LxhjjqBWkvhc9b/KmZvoVoT4P7bBS2sp8zJQ8mMsZdSq7VJNKZMrEpW2oBSl/sb96
         QrGrK5KlAYQe0BZR9k11GL2vSjxxgkCB6f4sq0Bpsw18HeW8S1YNZ0Y/o/wZsVTcad
         zq0/ljwDawAvMgGnd2wltWrdo9M/PssoDHz13SsMrxrSbLFP7nK2PjTBhiwrPKQTVh
         KAj8surukLgJ68nBK442B4Spk3iyOMH6gihysgiljlOuIViy0GC+OWsW0LneloHroF
         gp2He+uMBiq/T0S5PdmrxYGkWPxCE5hOJh8Y++hSlVHjrdJ1K4nh6fTPlFi9+ofckK
         4RT1tuDXbpKOQ==
X-Virus-Scanned: Debian amavisd-new at discovery.labus-online.de
Received: from discovery.labus-online.de ([127.0.0.1])
        by localhost (mail.labus-online.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uRVNB07Um1Sr; Mon,  5 Apr 2021 21:30:52 +0200 (CEST)
Received: from [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9] (unknown [IPv6:2a02:908:1966:3a60:b62e:99ff:fe91:d1a9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by discovery.labus-online.de (Postfix) with ESMTPSA;
        Mon,  5 Apr 2021 21:30:52 +0200 (CEST)
Subject: Re: stmmac: zero udp checksum
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, mschiffer@universe-factory.net
References: <cfc1ede9-4a1c-1a62-bdeb-d1e54c27f2e7@freifunk-rtk.de>
 <YGsQQUHPpuEGIRoh@lunn.ch>
 <98fcc1a7-8ce2-ac15-92a1-8c53b0e12658@freifunk-rtk.de>
 <YGs+DeFzhVh7UlEh@lunn.ch>
From:   Julian Labus <julian@freifunk-rtk.de>
Message-ID: <27b53d2d-28d3-e183-37f6-07762c5b7322@freifunk-rtk.de>
Date:   Mon, 5 Apr 2021 21:30:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGs+DeFzhVh7UlEh@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.04.21 18:42, Andrew Lunn wrote:
> Have you looked at where it actually drops the packet?
> Is it one of
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/norm_desc.c#L95
> 
> or
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/stmicro/stmmac/enh_desc.c#L87
> 
> It could be, you need to see if the checksum has fail, then check if
> the checksum is actually zero, and then go deeper into the frame and
> check if it is a vxlan frame. It could be the linux software checksum
> code knows about this vxlan exception, so you can just run that before
> deciding to drop the frame.
> 
> 	Andrew

No, I've not yet checked where the packet is actually dropped. This is 
my first time debugging a network problem in the kernel and I have 
little to no knowledge how this rx offloading works. But I don't think 
it happens in norm_desc.c#L95 as I would expect the ipc_csum_error 
counter to increase. But the only counters in "ethtool -S" which are 
increasing are mmc_rx_udp_err and mmc_rx_udp_err_octets. I'll try to get 
more information.

Julian
