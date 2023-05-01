Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED5D6F3907
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjEAUMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 16:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjEAUMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 16:12:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B67726B6
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 13:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=i91UJvIyt1dxQGEhk5hBzZBEpzjeHJip8MynuPiCH58=; b=PQ
        eSUDHG07+W90lVGg3FVqAFjnBfIPVxo2teVYwwYDZqDCW1g6xk/1SLTKEuRRQKyPuqX1vlpzyzgIp
        xKLlgaxRV4HHmCPdy4BG3tm3YSg2Qe6Lyt4yp6jlpXiZdjHaIYsXrdB15swbMhHqgDnwBYZoNR16F
        glEembjX/TmIyfc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ptZsr-00BeVO-Go; Mon, 01 May 2023 22:12:29 +0200
Date:   Mon, 1 May 2023 22:12:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ron Eggler <ron.eggler@mistywest.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Unable to TX data on VSC8531
Message-ID: <b2e5bbf6-de38-47e5-9b93-6811979cf180@lunn.ch>
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <73139af8-03a7-4788-bbf1-f76b963acb37@lunn.ch>
 <44fe99ec-42a0-688f-16a0-0a3be3750290@mistywest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44fe99ec-42a0-688f-16a0-0a3be3750290@mistywest.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> After a fresh rebootI executed:
> 
> # ping 192.168.1.222 -c 1
> 
> and see the following:
> 
> # ifconfig
> eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
>         inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
>         ether be:a8:27:1f:63:6e  txqueuelen 1000  (Ethernet)
>         RX packets 469  bytes 103447 (101.0 KiB)
>         RX errors 0  dropped 203  overruns 0  frame 0
>         TX packets 0  bytes 0 (0.0 B)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>         device interrupt 170
> 
> eth1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
>         ether fe:92:66:6c:4e:24  txqueuelen 1000  (Ethernet)
>         RX packets 0  bytes 0 (0.0 B)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 0  bytes 0 (0.0 B)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>         device interrupt 173
> 
> lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
>         inet 127.0.0.1  netmask 255.0.0.0
>         loop  txqueuelen 1000  (Local Loopback)
>         RX packets 1  bytes 112 (112.0 B)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 1  bytes 112 (112.0 B)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> 
> it appears like the ping got sent to the loopback device instead of the
> eth0, is this possible?

It is unlikely. Loopback is used for lots of things. Rather than -c 1,
leave it running. There should be an arp sent around once a
second. See if the statistics for lo go up at that rate.

> I got the following:
> 
> # mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 100baseTx-FD, link ok
>   registers for MII PHY 0:
>     1040 796d 0007 0572 01e1 45e1 0007 2801
>     0000 0300 4000 0000 0000 0000 0000 3000
>     9000 0000 0008 0000 0000 0000 3201 1000
>     0000 a020 a000 0000 802d 0021 0400 0000
>   product info: vendor 00:01:c1, model 23 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD flow-control

So you have the register values to answer Horatiu question.

   Andrew
