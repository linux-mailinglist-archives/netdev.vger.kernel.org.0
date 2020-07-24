Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C976E22C32E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 12:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgGXKeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 06:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgGXKeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 06:34:03 -0400
X-Greylist: delayed 548 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Jul 2020 03:34:03 PDT
Received: from iam.tj (soggy.cloud [IPv6:2a01:7e00:e000:151::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2345FC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 03:34:03 -0700 (PDT)
Received: from [10.0.40.34] (unknown [51.155.44.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by iam.tj (Postfix) with ESMTPSA id C984134076;
        Fri, 24 Jul 2020 11:24:53 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=elloe.vision; s=2019;
        t=1595586294; bh=ZnWqvcfN4s55KZbf5LltMXcohyLygqb7IumUJThWPoI=;
        h=To:Cc:References:Subject:From:Date:In-Reply-To:From;
        b=yTmT+y7VeOX8m982nfNPNiqL9VbLfFmyDZ/hLKssIGIRWXNVFO0nUuyAfSnBIab7s
         VFZoGiSf/qne6fiRF0iXtufAiu6EVQIEcbT2wiLotfk4uAg4fUIQk1+wlGiu+5bpop
         5EzHfzFEHxlF7bvM+GgAISxrmjRrbbPGyuiy4T0VLiXtT1QOhKxShM24tzdOFTCGMM
         e/JegFPgj2O6WSH4waXPDIji4Y0ybl+wtZZmGUYmqHsZJ8wCGEKicNLIAR0Sujgccu
         FrzwPDm2K9xEnfeO++8eq/nvk9YilDxjJI6QzfahLVSuvScDytCu+LsadqituEvq6e
         q3PM7E8qC5ppQ==
To:     netdev@vger.kernel.org
Cc:     chris.packham@alliedtelesis.co.nz, andrew@lunn.ch,
        f.fainelli@gmail.com, marek.behun@nic.cz, vivien.didelot@gmail.com
References: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
Subject: Re: dsa: mv88e6xxx losing DHCPv6 solicit packets / IPv6 multicast
 packets?
From:   "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Organization: Elloe CIC
Message-ID: <0538958b-44b8-7187-650b-35ce276e9d83@elloe.vision>
Date:   Fri, 24 Jul 2020 11:24:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> As another thought do you know what DHCPv6 client/server is being
> used.
> There was a fairly recent bugfix for busybox that was needed because
>the v6 code was using the wrong MAC address.

I'm the customer experiencing this issue. It appears unrelated to the
DHCP server software. On the Turris Mox with Debian 10 we have
isc-dhcp-server 4.4.1-2. Clients are Xubuntu 20.04 withNetworkManager
1.22.10-1ubuntu2.1 using isc-dclient 4.4.1-2.1ubuntu5.

Quoting from another email I sent to Turris:

We've now done more testing and CONFIRMED the Mox is losing DHCPv6
solicit packets.

Specifically, it seems the 88E6190 hardware switches in the Peridot
module is swallowing IPv6 multicast packets (sent to ff02::1:2 ).

We tested this by mirroring the Mox LAN port on an external switch and
saw the DHCPv6 solicit packet egress the switch but the Mox kernel
didn't see it ingress (using tcpdump).


