Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09BE62A8F
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405188AbfGHUnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:43:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:58083 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732034AbfGHUnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:43:51 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id DF9D3886BF;
        Tue,  9 Jul 2019 08:43:48 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1562618628;
        bh=fBOgWho/L+jCIgMTzoizCUsTLsw86EQjS5wwOnSKlCM=;
        h=From:To:CC:Subject:Date:References;
        b=RzIIhyQJSjMe1wCLFmqIk7+BC0oBIsFfacQO6/LwbF3g4EU9OOG91aB7m70uimJyW
         RwXnQjiCuTNBqiVSOTzapcVrJTq1dQdjp90M4/GS8pKW3+qJzspXt7Yg5tz2b/ZGDT
         /R/P382uvTxR4Utb7COQ1A6R3rtQig6PZ15E1R5I/FMo9KqGbY2N9yhoscJCiN5P4M
         XXMNgPYPYI5TazhF1PGeewwpf4q5uD0iOnxJUjxmBMic0ye5grvrFy7Jg8NacJyTGq
         SYoQAYx+tEMJiqufV5SzDAHHYFZ5rTSH7zxB0E+cbHXu4xHrnE1A5/jmTslbITLteZ
         j8fWMHFOMpHGg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d23ab040001>; Tue, 09 Jul 2019 08:43:48 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Tue, 9 Jul 2019 08:43:48 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Tue, 9 Jul 2019 08:43:48 +1200
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
Date:   Mon, 8 Jul 2019 20:43:47 +0000
Message-ID: <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
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

On 8/07/19 8:18 PM, Eric Dumazet wrote:=0A=
> =0A=
> =0A=
> On 7/8/19 12:53 AM, Chris Packham wrote:=0A=
>> tipc_named_node_up() creates a skb list. It passes the list to=0A=
>> tipc_node_xmit() which has some code paths that can call=0A=
>> skb_queue_purge() which relies on the list->lock being initialised.=0A=
>> Ensure tipc_named_node_up() uses skb_queue_head_init() so that the lock=
=0A=
>> is explicitly initialised.=0A=
>>=0A=
>> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
> =0A=
> I would rather change the faulty skb_queue_purge() to __skb_queue_purge()=
=0A=
> =0A=
=0A=
Makes sense. I'll look at that for v2.=0A=
