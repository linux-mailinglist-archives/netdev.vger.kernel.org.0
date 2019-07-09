Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4A6636C7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGINUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:20:44 -0400
Received: from mx-relay92-hz2.antispameurope.com ([94.100.136.192]:36284 "EHLO
        mx-relay92-hz2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfGINUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:20:44 -0400
Received: from b2b-92-50-72-125.unitymedia.biz ([92.50.72.125]) by mx-relay92-hz2.antispameurope.com;
 Tue, 09 Jul 2019 15:20:42 +0200
Received: from [192.168.101.59] (192.168.101.59) by eks-ex.eks-engel.local
 (192.168.100.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1034.26; Tue, 9 Jul
 2019 15:20:38 +0200
Subject: Re: i.mx6ul with DSA in multi chip addressing mode - no MDIO access
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>
References: <21680b63-2d87-6841-23eb-551e58866719@eks-engel.de>
 <20190703155518.GE18473@lunn.ch>
 <d1181129-ec9d-01c1-3102-e1dc5dec0378@eks-engel.de>
 <20190704132756.GB13859@lunn.ch>
 <00b365da-9c7a-a78a-c10a-f031748e0af7@eks-engel.de>
 <20190704155347.GJ18473@lunn.ch>
 <ba64f1f9-14c7-2835-f6e7-0dd07039fb18@eks-engel.de>
 <20190705143647.GC4428@lunn.ch>
 <5e35a41c-be0e-efd4-cb69-cf5c860b872e@eks-engel.de>
 <20190708145733.GA9027@lunn.ch>
From:   Benjamin Beckmeyer <beb@eks-engel.de>
Message-ID: <0d595637-0081-662d-2812-0a174ee1a901@eks-engel.de>
Date:   Tue, 9 Jul 2019 15:20:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708145733.GA9027@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [192.168.101.59]
X-ClientProxiedBy: eks-ex.eks-engel.local (192.168.100.30) To
 eks-ex.eks-engel.local (192.168.100.30)
X-cloud-security-sender: beb@eks-engel.de
X-cloud-security-recipient: netdev@vger.kernel.org
X-cloud-security-Virusscan: CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay92-hz2.antispameurope.com with 44693962156
X-cloud-security-connect: b2b-92-50-72-125.unitymedia.biz[92.50.72.125], TLS=1, IP=92.50.72.125
X-cloud-security: scantime:1.305
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Hi Andrew,
>> I got it working a little bit better. When I'm fast enough I can read
>> the registers I want but it isn't a solution.
> Why do you need to read registers?
>
> What you actually might be interested in is the debugfs patches in
> Viviens github tree.
>
>> Here is an output of the tracing even with my custom accesses.
>> mii -i 2 0 0x9b60; mii -i 2 1
>> phyid:2, reg:0x01 -> 0xc801
>>
>> Do you know how to delete EEInt bit? It is always one. And now all 
>> accesses coming from the kworker thread. Maybe this is your polling 
>> function?
> EEInt should clear on read for older chips. For 6390, it might be
> necessary to read global 2, register 0x13, index 03.
>  
>> I view the INT pin on an oscilloscope but it never changed. So maybe
>> this is the problem. We just soldered a pull-up to that pin but it 
>> still never changend. Maybe you have an idea?
> The EEInt bit is probably masked. So it will not generate in
> interrupt.
>
>> So what I think is, because of the EEInt bit is never set back to one 
>> i will poll it as fast as possible.
> Is it forever looping in mv88e6xxx_g1_irq_thread_work? Or is it the
> polling code, mv88e6xxx_irq_poll() firing every 100ms?
>
> 	Andrew

Hi Andrew,
good news first, it seems to be running ;-).

The interrupt GPIO pin was not correctly configured in the device tree.

For now we have around 68 accesses per second, I think this is okay 
because we even have indirect access, so the bus must be more busy.

What do you think about it?

Why we need access to the bus is because we have some software which was 
using the DSDT driver and now we want to switch to the UMSD driver.
But we hope that we can forget about all the UMSD driver stuff and the 
DSDT driver stuff as well and just use the DSA part from the kernel.
To be honest, so far I don't know what functions we need from the driver
which aren't supported by the DSA.

Thanks again for your help and patience.

Cheers,
Benny

