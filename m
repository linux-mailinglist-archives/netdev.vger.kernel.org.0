Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02038310B52
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhBEMrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 07:47:51 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:33112 "EHLO
        blackbox.su" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S231602AbhBEMp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 07:45:26 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 569F881490;
        Fri,  5 Feb 2021 15:44:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1612529082; bh=YBLbmCIIx0JTGjU650VQNiKxdC5G6nlB0kRiKx3uBas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTdURH27Dm552FQVsJnrk0vj4lMxn7OmI8U85ppjNjpFwsZC0lcr6q6jjLr5/jBtP
         6sUO1HnMRUN4MCXlCKZoCmyMjCnVuqeyyiftfLdXrijaPk3nBDCwk/bGP7Nz2zJOdW
         4B3vpPMfdECgl+9RhnQnskGADzQEr56AjaXtZnXBBknBhTWtTJyTkRXqTy6ll/T2F5
         jZCJ1GCt9MuCEEvvsrDoln4k8dxbOQgTivQFAvhRi/7bUOJoKdGIvdOHWamGE3Tw8O
         Z3g5Hcqh/RAsN5+fXnZ0hJiz1b/SOE7Maz8oS41rwgmd6ZQT8/paHiYzmmwVPU5LD4
         fSid9XILDFmUA==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     thesven73@gmail.com
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, rtgbnm@gmail.com,
        tharvey@gateworks.com, anders@ronningen.priv.no,
        sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP LAN743X ETHERNET
        DRIVER), "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:MICROCHIP LAN743X ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs w/o dma cache snooping
Date:   Fri,  5 Feb 2021 15:44:19 +0300
Message-Id: <20210205124419.8575-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210129195240.31871-2-TheSven73@gmail.com>
References: <20210129195240.31871-2-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven
I can confirm great stability improvement after your patch
"lan743x: boost performance on cpu archs w/o dma cache snooping".
Please note, that test_ber opens raw sockets as
s = socket(AF_PACKET, SOCK_RAW, ETH_P_ALL)
and resulting 'average speed' is a average egress speed.

Test machine is Intel Pentium G4560 3.50GHz
lan743x with rejected virtual phy 'inside'

What I had before:
$ ifmtu eth7 500
$ test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 289017
number of lost packets = 710983
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 710983
bit error rate         = 0.710983
average speed: 429.3799 Mbit/s

$ ifmtu eth7 1500
$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f1500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 577194
number of lost packets = 422806
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 422806
bit error rate         = 0.422806
average speed: 644.6557 Mbit/s
---

and what I had after your patch:
$ ifmtu eth7 500
$ test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 711329
number of lost packets = 288671
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 288671
bit error rate         = 0.288671
average speed: 429.2263 Mbit/s

$ ifmtu eth7 1500
$ test_ber -l eth7 -c 1000 -n 1000000 -f1500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 644.5405 Mbit/s
