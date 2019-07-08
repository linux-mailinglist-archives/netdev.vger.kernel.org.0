Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B383E62AB5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405222AbfGHVNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:13:49 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58130 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732264AbfGHVNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:13:49 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 77083891A9;
        Tue,  9 Jul 2019 09:13:46 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1562620426;
        bh=MHtjdP6J7S4FAJZ1f9txr8+U6dEpel/MdY3bP6vOnYs=;
        h=From:To:CC:Subject:Date:References;
        b=gpDon7dQPuvlEuHytEDAyDWqRFRag3vPmIt2FDQfd6ZjwWYILDi1g6AVhop9rO9bD
         CnmDOT8JsYKEjlFHbHJpmOOb+HcK90RgAkuPuj7SXmGvpY9+i8jkykSLwGOMsxRZbl
         dDhcQA7TKB6MUziI4wgWFMddyRd3yaGiq863YtI78O2X0h/zC34eTg92M56f0Ce9aa
         HGeN250STPgfhsCJy3MyBJOPHW+cewOhXEH32W4NhDr/nxE4rTRgDfZtScNe2fWsOa
         fAbeVPoQZz18uV3adlUfi/wTx+8boZ9p6mqqwkvNZJfQxU3NXuWuOQFol26ZiBeO4l
         8EKuszybvEyuA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d23b2090001>; Tue, 09 Jul 2019 09:13:45 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1156.6; Tue, 9 Jul 2019 09:13:46 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Tue, 9 Jul 2019 09:13:46 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "jon.maloy@ericsson.com" <jon.maloy@ericsson.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tipc: ensure skb->lock is initialised
Thread-Topic: [PATCH] tipc: ensure skb->lock is initialised
Thread-Index: AQHVNRbM8H0dBbuBFkyTwxApCbaMkw==
Date:   Mon, 8 Jul 2019 21:13:45 +0000
Message-ID: <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/07/19 8:43 AM, Chris Packham wrote:=0A=
> On 8/07/19 8:18 PM, Eric Dumazet wrote:=0A=
>>=0A=
>>=0A=
>> On 7/8/19 12:53 AM, Chris Packham wrote:=0A=
>>> tipc_named_node_up() creates a skb list. It passes the list to=0A=
>>> tipc_node_xmit() which has some code paths that can call=0A=
>>> skb_queue_purge() which relies on the list->lock being initialised.=0A=
>>> Ensure tipc_named_node_up() uses skb_queue_head_init() so that the lock=
=0A=
>>> is explicitly initialised.=0A=
>>>=0A=
>>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
>>=0A=
>> I would rather change the faulty skb_queue_purge() to __skb_queue_purge(=
)=0A=
>>=0A=
> =0A=
> Makes sense. I'll look at that for v2.=0A=
> =0A=
=0A=
Actually maybe not. tipc_rcast_xmit(), tipc_node_xmit_skb(), =0A=
tipc_send_group_msg(), __tipc_sendmsg(), __tipc_sendstream(), and =0A=
tipc_sk_timeout() all use skb_queue_head_init(). So my original change =0A=
brings tipc_named_node_up() into line with them.=0A=
=0A=
I think it should be safe for tipc_node_xmit() to use =0A=
__skb_queue_purge() since all the callers seem to have exclusive access =0A=
to the list of skbs. It still seems that the callers should all use =0A=
skb_queue_head_init() for consistency.=0A=
