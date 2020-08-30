Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40008256CEB
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgH3IqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:46:16 -0400
Received: from mail.as201155.net ([185.84.6.188]:37980 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgH3IqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:46:14 -0400
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:53482 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1kCIyY-0000uM-1Z; Sun, 30 Aug 2020 10:46:10 +0200
X-CTCH-RefID: str=0001.0A782F20.5F4B6752.0053,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=btgaD8OM+XEl/nlOUjoTEOvtlP3oq0NPEqqvQ3/x1QE=;
        b=ByXpHFZPksnhXUMviQUnT3ytFz+iDOsVTFapQPA3Jfh4AR3+79gwQSaHWH/K2ifeUKtMcKf9qoYET8a+X3LBzEVEM+93+dzSRFKWf0r36vpaZ1V1jVEttFfU+daLrBg3+vrPvJkjDyI+Vc/TPrmrxfBFTfK+dWqsCGD7dJFOCYQ=;
Subject: Re: [PATCH v3 1/2] net: add support for threaded NAPI polling
To:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
References: <20200821190151.9792-1-nbd@nbd.name>
 <20200821184924.5b5c421c@kicinski-fedora-PC1C0HJN>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <bb520bbe-3e6e-949f-e534-53f1425f91eb@dd-wrt.com>
Date:   Sun, 30 Aug 2020 10:46:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101
 Thunderbird/80.0
MIME-Version: 1.0
In-Reply-To: <20200821184924.5b5c421c@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f1f:f100:b19f:3da:e3e1:1617]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1kCIyY-000Pfo-37; Sun, 30 Aug 2020 10:46:10 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 22.08.2020 um 03:49 schrieb Jakub Kicinski:
> On Fri, 21 Aug 2020 21:01:50 +0200 Felix Fietkau wrote:
>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>> was scheduled from, we can easily end up with a few very busy CPUs spending
>> most of their time in softirq/ksoftirqd and some idle ones.
>>
>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>
>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>> thread.
>>
>> With threaded NAPI, throughput seems stable and consistent (and higher than
>> the best results I got without it).
>>
>> Based on a patch by Hillf Danton
> I've tested this patch on a non-NUMA system with a moderately
> high-network workload (roughly 1:6 network to compute cycles)
> - and it provides ~2.5% speedup in terms of RPS but 1/6/10% worse
> P50/P99/P999 latency.
>
> I started working on a counter-proposal which uses a pool of threads
> dedicated to NAPI polling. It's not unlike the workqueue code but
> trying to be a little more clever. It gives me ~6.5% more RPS but at
> the same time lowers the p99 latency by 35% without impacting other
> percentiles. (I only started testing this afternoon, so hopefully the
> numbers will improve further).
>
> I'm happy for this patch to be merged, it's quite nice, but I wanted
> to give the heads up that I may have something that would replace it...
>
> The extremely rough PoC, less than half-implemented code which is really
> too broken to share:
> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/log/?h=tapi

looks interesting. keep going

Sebastian

>
