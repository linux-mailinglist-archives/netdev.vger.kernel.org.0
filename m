Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B4C2B8BE0
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgKSHCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:02:33 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:59813 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbgKSHCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:02:32 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfdxZ-0000G6-Lp; Thu, 19 Nov 2020 08:02:25 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfdxY-00041v-LI; Thu, 19 Nov 2020 08:02:24 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 2842F240041;
        Thu, 19 Nov 2020 08:02:24 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 9AFCD240040;
        Thu, 19 Nov 2020 08:02:23 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 0E83620115;
        Thu, 19 Nov 2020 08:02:23 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Nov 2020 08:02:22 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/6] net/x25: netdev event handling
Organization: TDT AG
In-Reply-To: <CAJht_EPB5g5ahHrVCM+K8MZG9u5bmqfjpB9-UptTt+bWqhyHWw@mail.gmail.com>
References: <20201118135919.1447-1-ms@dev.tdt.de>
 <CAJht_EPB5g5ahHrVCM+K8MZG9u5bmqfjpB9-UptTt+bWqhyHWw@mail.gmail.com>
Message-ID: <ae263ce5b1b31bfa763f755bdb3ef962@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1605769345-000013A4-5B5B5D59/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 15:47, Xie He wrote:
> On Wed, Nov 18, 2020 at 5:59 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> ---
>> Changes to v2:
>> o restructure complete patch-set
>> o keep netdev event handling in layer3 (X.25)
> 
> But... Won't it be better to handle L2 connections in L2 code?
> 
> For example, if we are running X.25 over XOT, we can decide in the XOT
> layer whether and when we reconnect in case the TCP connection is
> dropped. We can decide how long we wait for responses before we
> consider the TCP connection to be dropped.
> 
> If we still want "on-demand" connections in certain L2's, we can also
> implement it in that L2 without the need to change L3.
> 
> Every L2 has its own characteristics. It might be better to let
> different L2's handle their connections in their own way. This gives
> L2 the flexibility to handle their connections according to their
> actual link characteristics.
> 
> Letting L3 handle L2 connections also makes L2 code too related to /
> coupled with L3 code, which makes the logic complex.

OK, I will give it a try. But we need to keep the possibility to
initiate and terminate the L2 connection from L3.

In the on demand scenario i mentioned, the L2 should be connected when
the first L3 logical channel goes up and needs to be disconnected, when
the last L3 logical channel on an interface is cleared.

> 
>> o add patch to fix lapb_connect_request() for DCE
>> o add patch to handle carrier loss correctly in lapb
>> o drop patch for x25_neighbour param handling
>>   this may need fixes/cleanup and will be resubmitted later.
>> 
>> Changes to v1:
>> o fix 'subject_prefix' and 'checkpatch' warnings
>> 
>> ---
>> 
>> Martin Schiller (6):
>>   net/x25: handle additional netdev events
>>   net/lapb: fix lapb_connect_request() for DCE
>>   net/lapb: handle carrier loss correctly
>>   net/lapb: fix t1 timer handling for DCE
>>   net/x25: fix restart request/confirm handling
>>   net/x25: remove x25_kill_by_device()
