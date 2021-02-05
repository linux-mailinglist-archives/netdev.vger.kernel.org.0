Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B3311432
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhBEWBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:01:44 -0500
Received: from 95-165-96-9.static.spd-mgts.ru ([95.165.96.9]:34318 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhBEOye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:34 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 69EC7819BF;
        Fri,  5 Feb 2021 18:09:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1612537798; bh=yFRtgztPp2fq5DB0y3un2d4zKag6mvcVdlCDaHCCsRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8m0jzS1MrqKY/24sClbU9a5UCLW4iiN4w2pz3km+5N226seWem6T1Z8rVVQL6aVy
         dO13hPEpaf3+c3S59qZdNzhYE3bLgq31tmFqT/rxVoMYIDu4PCaIw4NIDHhQ+8Jop2
         0UeGTfsOHNI7YuIz6LahuryKo8ZjAwmnOLMWuTgMcSFoXeQDZ2jNTdiHpf2up8aMJD
         sm6jDTMy34hGG4mm5O9v2L0z8mcxPLdT/AU+T3zZE50cQtj6aJJdyt8T96aRaD9ccm
         1Tf3sFSP/k4oS0ffYhboCSaShz8xIDpBTzmEbfh+OMdG9/Wo1Ge83+pnb9QZfr0oQt
         Kpi4B8plxE+JA==
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
Date:   Fri,  5 Feb 2021 18:09:35 +0300
Message-Id: <20210205150936.23010-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAGngYiUgjsgWYP76NKnrhbQthWbceaiugTFL=UVh_KvDuRhQUw@mail.gmail.com>
References: <CAGngYiUgjsgWYP76NKnrhbQthWbceaiugTFL=UVh_KvDuRhQUw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, February 5, 2021 5:07:22 PM MSK you wrote:
> Hi Sergej,
> 
> On Fri, Feb 5, 2021 at 7:44 AM Sergej Bauer <sbauer@blackbox.su> wrote:
> > Hi Sven
> > I can confirm great stability improvement after your patch
> > "lan743x: boost performance on cpu archs w/o dma cache snooping".
> > 
> > Test machine is Intel Pentium G4560 3.50GHz
> > lan743x with rejected virtual phy 'inside'
> 
> Interesting, so the speed boost patch seems to improve things even on
> Intel...
> 
> Would you be able to apply and test the multi-buffer patch as well?
> To do that, you can simply apply patches [2/6] and [3/6] on top of
> what you already have.
> 

Hi Sven
Tests after applying patches [2/6] and [3/6] are:
$ ifmtu eth7 500
$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 713288
number of lost packets = 286712
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 286712
bit error rate         = 0.286712
average speed: 427.8043 Mbit/s

$ ifmtu eth7 1500
$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 707869
number of lost packets = 292131
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 292131
bit error rate         = 0.292131
average speed: 431.0163 Mbit/s

$ sudo test_ber -l eth7 -c 1000 -n 1000000 -f1500 --no-conf
...
number of sent packets      = 1000000
number of received packets  = 1000000
number of lost packets = 0
number of out of order packets = 0
number of bit errors   = 0
total errors detected  = 0
bit error rate         = 0
average speed: 646.4932 Mbit/s

> Keeping in mind that Bryan has identified an issue with the above
> patch, which will get fixed in v2. So YMMV.
I'll perform tests with v2 as well.
