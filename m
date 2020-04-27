Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B791B94FB
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 03:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD0Bev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 21:34:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:64530 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgD0Beu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 21:34:50 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 03R1XD3l012617
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Sun, 26 Apr 2020 18:33:14 -0700 (PDT)
Received: from [128.224.162.174] (128.224.162.174) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 26 Apr
 2020 18:33:13 -0700
Subject: Re: ethtool -s always return 0 even for errors
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     <linville@tuxdriver.com>
References: <20200423094547.2066-1-yi.zhao@windriver.com>
 <20200423133649.GF6778@lion.mk-sys.cz>
From:   Yi Zhao <yi.zhao@windriver.com>
Message-ID: <8d966634-f269-0bd3-83bc-627944c34814@windriver.com>
Date:   Mon, 27 Apr 2020 09:33:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423133649.GF6778@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [128.224.162.174]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/23/20 9:36 PM, Michal Kubecek wrote:
> On Thu, Apr 23, 2020 at 05:45:47PM +0800, Yi Zhao wrote:
>> The ethtool -s returns 0 when it fails with an error (stderr):
>>
>> $ ethtool -s eth0 duplex full
>> Cannot advertise duplex full
>> $ echo $?
>> 0
>> $ ethtool -s eth0 speed 10
>> Cannot advertise speed 10
>> $ echo $?
>> 0
> These two are not really errors, just warnings. According to comments in
> the code, the idea was that requesting speed and/or duplex with
> autonegotiation enabled (either already enabled or requested to be
> enabled) and no explicit request for advertised modes (no "advertise"
> keyword), ethtool should enable exactly the modes (out of those
> supported by the device) which match requested speed and/or duplex
> value(s). The messages you see above are warnings that this logic is not
> implemented and all parameters are just passed to kernel and probably
> ignored (depends on the driver).
>
> Actually, with kernel 5.6 (with CONFIG_ETHTOOL_NETLINK=y) and ethtool
> built from git (or 5.6 once released), these commands work as expected:
>
> lion:/home/mike/work/git/ethtool # ./ethtool eth0
> Settings for eth0:
> ...
>          Advertised link modes:  10baseT/Half 10baseT/Full
>                                  100baseT/Half 100baseT/Full
>                                  1000baseT/Full
> ...
>          Auto-negotiation: on
> ...
> lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 speed 100
> lion:/home/mike/work/git/ethtool # ./ethtool eth0
> Settings for eth0:
> ...
>          Advertised link modes:  100baseT/Half 100baseT/Full
> ...
> lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 duplex full
> lion:/home/mike/work/git/ethtool # ./ethtool eth0
> Settings for eth0:
> ...
>          Advertised link modes:  10baseT/Full
>                                  100baseT/Full
>                                  1000baseT/Full
> ...
> lion:/home/mike/work/git/ethtool # ./ethtool -s eth0 speed 100 duplex full
> lion:/home/mike/work/git/ethtool # ./ethtool eth0
> Settings for eth0:
> ...
>          Advertised link modes:  100baseT/Full
> ...
>
>> $ ethtool -s eth1 duplex full
>> Cannot get current device settings: No such device
>>    not setting duplex
>> $ echo $?
>> 0
> The problem here is that for historical reasons, "ethtool -s" may issue
> up to three separate ioctl requests (or up to four netlink requests with
> new kernel and ethtool), depending on which parameters you request on
> command line. Each of them can either succeed or fail and you can even
> see multiple error messages:
>
> lion:/home/mike/work/git/ethtool # ethtool -s foo phyad 3 wol um msglvl 7
> Cannot get current device settings: No such device
>    not setting phy_address
> Cannot get current wake-on-lan settings: No such device
>    not setting wol
> Cannot get msglvl: No such device
>
> Currently, do_sset() always returns 0. While it certainly feels wrong to
> return 0 if all requests fail (including your case where there was only
> one request and it failed), it is much less obvious what should we
> return if some of the requests succeed and some fail.


Thank you for the detailed explanation.


//Yi

>
> Michal
