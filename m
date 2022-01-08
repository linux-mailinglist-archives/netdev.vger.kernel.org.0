Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ACA4884A0
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 17:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiAHQoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 11:44:39 -0500
Received: from mx4.wp.pl ([212.77.101.11]:22739 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234726AbiAHQof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 11:44:35 -0500
Received: (wp-smtpd smtp.wp.pl 15411 invoked from network); 8 Jan 2022 17:44:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641660270; bh=2ziz++hZNvKYQewm3YU3czmOHDf77wlaj2YlXPBb/FI=;
          h=Subject:To:From;
          b=iYl9E6IGZTkdeTeBaiDrGkK9aQJrz4mzXiRCm+rbVb4aADC81PlgjsuPicSUk4ycl
           ez+RbyYDczhLctJqKoq6+dLIF0AWfWSl6yTk36GM6g5ctWY5Xwl6LhNSxyeyvDPa/c
           q7Vvri8bCekILR504ACoa2X2b1UDk8W0mssPZH84=
Received: from riviera.nat.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <eric.dumazet@gmail.com>; 8 Jan 2022 17:44:30 +0100
Message-ID: <7b491825-8359-86d0-7c1c-6b3cf3c67146@wp.pl>
Date:   Sat, 8 Jan 2022 17:44:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next 3/3] net: lantiq_xrx200: convert to build_skb
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>, tsbogend@alpha.franken.de,
        hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220104151144.181736-1-olek2@wp.pl>
 <20220104151144.181736-4-olek2@wp.pl>
 <0db849a8-2708-6412-301d-fe77b2cf8d00@gmail.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
In-Reply-To: <0db849a8-2708-6412-301d-fe77b2cf8d00@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: b5337672c9c80cb619e6e0e18deaab85
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [EbPE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Enric,

On 1/4/22 18:42, Eric Dumazet wrote:
> 
> On 1/4/22 07:11, Aleksander Jan Bajkowski wrote:
>> We can increase the efficiency of rx path by using buffers to receive
>> packets then build SKBs around them just before passing into the network
>> stack. In contrast, preallocating SKBs too early reduces CPU cache
>> efficiency.
>>
>> NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):
>>
>>     Down        Up
>> Before    577 Mbps    648 Mbps
>> After    624 Mbps    695 Mbps
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
> 
> 
> Not sure why GRO is not yet implemented in this driver...
> 
> 


I changed netif_receive_skb() to napi_gro_receive() and did
some tests. I don't see any performance difference. Are any
further changes needed to support GRO?

Maybe this is because this MAC is connected to a DSA switch
and the napi_gro_receive() function cannot aggregate packets
until the DSA tag is removed. 
