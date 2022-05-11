Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7035522EBA
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiEKIug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiEKIud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:50:33 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C86A2181CD;
        Wed, 11 May 2022 01:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=K9S0p/PZ8mVH19diTHdZftm0WUxvYRUVPKuMIoWWr6A=; b=gqqRzYAyEQaZPglJ6z5hwVhmcy
        ti0G3HCYz7sxUTKH6vXINCJA/N7H7NrCT7ghoWlveD5910asAltd71LxWbLjTQYXZJiVb+lD2XIVF
        Q5YP3XqAugpioX/H9Vuw2lQqxASCD96KfQxSsxTbfzofUXvfyy5ANESzjP4VZ1SGusDA=;
Received: from p200300daa70ef200e12105daa054647e.dip0.t-ipconnect.de ([2003:da:a70e:f200:e121:5da:a054:647e] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1noi30-00040B-O3; Wed, 11 May 2022 10:50:18 +0200
Message-ID: <376b13ac-d90b-24e0-37ed-a96d8e5f80da@nbd.name>
Date:   Wed, 11 May 2022 10:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
 <20220510222101.od3n7gk3cofwhbks@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
In-Reply-To: <20220510222101.od3n7gk3cofwhbks@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Vladimir,


On 11.05.22 00:21, Vladimir Oltean wrote:
> It sounds as if this is masking a problem on the receiver end, because
> not only does my enetc port receive the packet, it also replies to the
> ARP request.
> 
> pc # sudo tcpreplay -i eth1 arp-broken.pcap
> root@debian:~# ip addr add 192.168.42.1/24 dev eno0
> root@debian:~# tcpdump -i eno0 -e -n --no-promiscuous-mode arp
> tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
> listening on eno0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
> 22:18:58.846753 f4:d4:88:5e:6f:d2 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.42.1 tell 192.168.42.173, length 46
> 22:18:58.846806 00:04:9f:05:f4:ab > f4:d4:88:5e:6f:d2, ethertype ARP (0x0806), length 42: Reply 192.168.42.1 is-at 00:04:9f:05:f4:ab, length 28
> ^C
> 2 packets captured
> 2 packets received by filter
> 0 packets dropped by kernel
> 
> What MAC/driver has trouble with these packets? Is there anything wrong
> in ethtool stats? Do they even reach software? You can also use
> "dropwatch -l kas" for some hints if they do.
For some reason I can't reproduce the issue of ARPs not getting replies 
anymore.
The garbage data is still present in the ARP packets without my patch 
though. So regardless of whether ARP packets are processed correctly or 
if they just trip up on some receivers under specific conditions, I 
believe my patch is valid and should be applied.

Who knows, maybe the garbage padding even leaks some data from previous 
packets, or some other information from within the switch.

- Felix
