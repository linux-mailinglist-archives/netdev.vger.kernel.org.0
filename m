Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D3130A7F7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhBAMtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:49:53 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:14964 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhBAMts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:49:48 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6YcW-0002U3-V9; Mon, 01 Feb 2021 13:47:57 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6YcW-000JY7-4m; Mon, 01 Feb 2021 13:47:56 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 943B0240041;
        Mon,  1 Feb 2021 13:47:55 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 1F4B5240040;
        Mon,  1 Feb 2021 13:47:55 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B33CA2007C;
        Mon,  1 Feb 2021 13:47:54 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 13:47:54 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
Organization: TDT AG
In-Reply-To: <CAJht_EPGk871aqK-1+=W7vGZrX8QY8LDVF26jkFjm3veeQmPWw@mail.gmail.com>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
 <204c18e95caf2ae84fb567dd4be0c3ac@dev.tdt.de>
 <CAJht_EPGk871aqK-1+=W7vGZrX8QY8LDVF26jkFjm3veeQmPWw@mail.gmail.com>
Message-ID: <abe3a003ad7fd68d3ecae5246e8d5137@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1612183676-00013921-746CED97/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-01 11:49, Xie He wrote:
> On Mon, Feb 1, 2021 at 2:05 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> What kind of packages do you mean are corrupted?
>> ETH_P_X25 or ETH_P_HDLC?
> 
> I mean ETH_P_X25. I was using "lapbether.c" to test so there was no 
> ETH_P_HDLC.
> 
>> I have also sent a patch here in the past that addressed corrupted
>> ETH_P_X25 frames on an AF_PACKET socket:
>> 
>> https://lkml.org/lkml/2020/1/13/388
>> 
>> Unfortunately I could not track and describe exactly where the problem
>> was.
> 
> Ah... Looks like we had the same problem.
> 
>> I just wonder when/where is the logically correct place to copy the 
>> skb.
>> Shouldn't it be copied before removing the pseudo header (as I did in 
>> my
>> patch)?
> 
> I think it's not necessary to copy it before removing the pseudo
> header, because "skb_pull" will not change any data in the data
> buffer. "skb_pull" will only change the values of "skb->data" and
> "skb->len". These values are not shared between clones of skbs, so
> it's safe to change them without affecting other clones of the skb.
> 
> I also choose to copy the skb in the LAPB module (rather than in the
> drivers) because I see all drivers have this problem (including the
> recently deleted x25_asy.c driver), so it'd be better to fix this
> issue in the LAPB module, for all drivers.

OK.

Acked-by: Martin Schiller <ms@dev.tdt.de>

