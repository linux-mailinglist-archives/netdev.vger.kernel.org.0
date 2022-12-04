Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BEF641D91
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 16:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLDPIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 10:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLDPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 10:08:34 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A3D13E1D;
        Sun,  4 Dec 2022 07:08:32 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 96AB11883F96;
        Sun,  4 Dec 2022 15:08:29 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 87D1025003AB;
        Sun,  4 Dec 2022 15:08:29 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 776059EC0020; Sun,  4 Dec 2022 15:08:29 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 04 Dec 2022 16:08:27 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221120150018.qupfa3flq6hoapgj@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
 <6c77f91d096e7b1eeaa73cd546eb6825@kapio-technology.com>
 <20221120150018.qupfa3flq6hoapgj@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <4e098ca82ce29fa0c534a1aa18f72eea@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-20 16:00, Vladimir Oltean wrote:
> On Sun, Nov 20, 2022 at 11:21:08AM +0100, netdev@kapio-technology.com 
> wrote:
>> I have something like this, using 'mvls vtu' from
>> https://github.com/wkz/mdio-tools:
>>  VID   FID  SID  P  Q  F  0  1  2  3  4  5  6  7  8  9  a
>>    0     0    0  y  -  -  =  =  =  =  =  =  =  =  =  =  =
>>    1     2    0  -  -  -  u  u  u  u  u  u  u  u  u  u  =
>> 4095     1    0  -  -  -  =  =  =  =  =  =  =  =  =  =  =
>> 
>> as a vtu table. I don't remember exactly the consequences, but I am 
>> quite
>> sure that fid=0 gave
>> incorrect handling, but there might be something that I have missed as 
>> to
>> other setups.
> 
> Can you please find out? There needs to be an answer as to why 
> something
> which shouldn't happen happens.

Just an update on this, as when running the selftests now, I have 
experienced
the case where fid=0 in the interrupt handler. The reported mac is the 
same
as the one where the handling was successful in the selftest.

So I don't know what causes this fid=0 event, maybe some timing with the 
chip
op when stressed resulting in erroneous reading of fid?
