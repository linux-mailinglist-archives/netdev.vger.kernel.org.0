Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A6E308563
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhA2F6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 00:58:09 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:38131 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2F6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 00:58:06 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l5MlS-0007Q7-Mb; Fri, 29 Jan 2021 06:56:14 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l5MlR-0001XU-Hr; Fri, 29 Jan 2021 06:56:13 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 8D7AC240041;
        Fri, 29 Jan 2021 06:56:12 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 02A5A240040;
        Fri, 29 Jan 2021 06:56:12 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id CD22B229C8;
        Fri, 29 Jan 2021 06:56:10 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Jan 2021 06:56:10 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Organization: TDT AG
In-Reply-To: <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
Message-ID: <3f67b285671aaa4b7903733455a730e1@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1611899774-0000A9C4-665386D1/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-28 23:06, Xie He wrote:
> On Thu, Jan 28, 2021 at 11:47 AM Jakub Kicinski <kuba@kernel.org> 
> wrote:
>> 
>> Noob question - could you point at or provide a quick guide to 
>> layering
>> here? I take there is only one netdev, and something maintains an
>> internal queue which is not stopped when HW driver stops the qdisc?
> 
> Yes, there is only one netdev. The LAPB module (net/lapb/) (which is
> used as a library by the netdev driver - hdlc_x25.c) is maintaining an
> internal queue which is not stopped when the HW driver stops the
> qdisc.
> 
> The queue is "write_queue" in "struct lapb_cb" in
> "include/net/lapb.h". The code that takes skbs out of the queue and
> feeds them to lower layers for transmission is at the "lapb_kick"
> function in "net/lapb/lapb_out.c".
> 
> The layering is like this:
> 
> Upper layer (Layer 3) (net/x25/ or net/packet/)
> 
> ^
> | L3 packets (with control info)
> v
> 
> The netdev driver (hdlc_x25.c)
> 
> ^
> | L3 packets
> v
> 
> The LAPB Module (net/lapb/)
> 
> ^
> | LAPB (L2) frames
> v
> 
> The netdev driver (hdlc_x25.c)
> 
> ^
> | LAPB (L2) frames
> | (also called HDLC frames in the context of the HDLC subsystem)
> v
> 
> HDLC core (hdlc.c)
> 
> ^
> | HDLC frames
> v
> 
> HDLC Hardware Driver

@Xie: Thank you for the detailed presentation.

> 
>> Sounds like we're optimizing to prevent drops, and this was not
>> reported from production, rather thru code inspection. Ergo I think
>> net-next will be more appropriate here, unless Martin disagrees.
> 
> Yes, I have no problem in targeting net-next instead. Thanks!

I agree.
