Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B8663134D
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 11:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiKTKVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 05:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiKTKVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 05:21:11 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2441C6D973;
        Sun, 20 Nov 2022 02:21:10 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D619218838C6;
        Sun, 20 Nov 2022 10:21:08 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id C375125002DE;
        Sun, 20 Nov 2022 10:21:08 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id B97969EC0020; Sun, 20 Nov 2022 10:21:08 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 20 Nov 2022 11:21:08 +0100
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
In-Reply-To: <20221115222312.lix6xpvddjbsmoac@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <6c77f91d096e7b1eeaa73cd546eb6825@kapio-technology.com>
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

On 2022-11-15 23:23, Vladimir Oltean wrote:
>> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c 
>> b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> index 8a874b6fc8e1..0a57f4e7dd46 100644
>> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> @@ -12,6 +12,7 @@
>> 
>>  #include "chip.h"
>>  #include "global1.h"
>> +#include "switchdev.h"
>> 
>>  /* Offset 0x01: ATU FID Register */
>> 
>> @@ -426,6 +427,8 @@ static irqreturn_t 
>> mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>>  	if (err)
>>  		goto out;
>> 
>> +	mv88e6xxx_reg_unlock(chip);
>> +
> 
> I concur with Ido's suggestion to split up changes which are only
> tangentially related as preparatory patches, with the motivation which
> you explained over email as the commit message. Also, the current "out"
> label needs to become something like "out_unlock", and a new "out"
> created, for the error path jumps below, that don't have the register
> lock held.
> 
>>  	spid = entry.state;
>> 
>>  	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
>> @@ -446,6 +449,12 @@ static irqreturn_t 
>> mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>>  				    entry.mac, entry.portvec, spid);
>>  		chip->ports[spid].atu_miss_violation++;
>> +
>> +		if (fid && chip->ports[spid].mab)
>> +			err = mv88e6xxx_handle_violation(chip, spid, &entry,
>> +							 fid, MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
> 
> The check for non-zero FID looks strange until one considers that FID 0
> is MV88E6XXX_FID_STANDALONE. But then again, since only standalone 
> ports
> use FID 0 and standalone ports cannot have the MAB/locked feature 
> enabled,
> I consider the check to be redundant. We should know for sure that the
> FID is non-zero.
> 

I have something like this, using 'mvls vtu' from 
https://github.com/wkz/mdio-tools:
  VID   FID  SID  P  Q  F  0  1  2  3  4  5  6  7  8  9  a
    0     0    0  y  -  -  =  =  =  =  =  =  =  =  =  =  =
    1     2    0  -  -  -  u  u  u  u  u  u  u  u  u  u  =
4095     1    0  -  -  -  =  =  =  =  =  =  =  =  =  =  =

as a vtu table. I don't remember exactly the consequences, but I am 
quite sure that fid=0 gave
incorrect handling, but there might be something that I have missed as 
to other setups.


