Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D79348E13
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCYKeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhCYKeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:34:05 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD0FC06174A;
        Thu, 25 Mar 2021 03:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zX4w/YCkqpoXy6bZV/Ut/Ci2wQiJmAv2JfLAPxQJFqE=; b=Ia8EkU18A2xNwsyK3OpzgjLKLN
        5CoFQt5FqnnsFZdgK9ZQAHhiC//FyW9i1ap51uUVLdvmTahmQPtEpeO1O0QXweTu1njJ1rf/oomaz
        bhhfmOoH9d118Fg1dbfcniJgUstgdh4CnwLGfZzXH6BAtG8O4ej9hHECFYAPeiA8J+Fg=;
Received: from p4ff13c8d.dip0.t-ipconnect.de ([79.241.60.141] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lPNJL-0003xC-IU; Thu, 25 Mar 2021 11:33:55 +0100
To:     Rakesh Pillai <pillair@codeaurora.org>,
        'Ben Greear' <greearb@candelatech.com>,
        'Brian Norris' <briannorris@chromium.org>
Cc:     'Johannes Berg' <johannes@sipsolutions.net>,
        'Rajkumar Manoharan' <rmanohar@codeaurora.org>,
        'ath10k' <ath10k@lists.infradead.org>,
        'linux-wireless' <linux-wireless@vger.kernel.org>,
        'Linux Kernel' <linux-kernel@vger.kernel.org>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org,
        'Doug Anderson' <dianders@chromium.org>,
        'Evan Green' <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
 <d79ae05e-e75a-de2f-f2e3-bc73637e1501@nbd.name>
 <04d7301d5ad7555a0377c7df530ad8522fc00f77.camel@sipsolutions.net>
 <1f2726ff-8ba9-5278-0ec6-b80be475ea98@nbd.name>
 <06a4f84b-a0d4-3f90-40bb-f02f365460ec@candelatech.com>
 <CA+ASDXOotYHmtqOvSwBES6_95bnbAbEu6F7gQ5TjacJWUKdaPw@mail.gmail.com>
 <47d8be60-14ce-0223-bdf3-c34dc2451945@candelatech.com>
 <633feaed-7f34-15d3-1899-81eb1d6ae14f@nbd.name>
 <003701d7215b$a44ae030$ece0a090$@codeaurora.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
Message-ID: <e7dc6d97-bab2-3bd4-685a-a8b5e25c18d9@nbd.name>
Date:   Thu, 25 Mar 2021 11:33:53 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <003701d7215b$a44ae030$ece0a090$@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-03-25 10:45, Rakesh Pillai wrote:
> Hi Felix / Ben,
> 
> In case of ath10k (snoc based targets), we have a lot of processing in the NAPI context.
> Even moving this to threaded NAPI is not helping much due to the load.
> 
> Breaking the tasks into multiple context (with the patch series I posted) is helping in improving the throughput.
> With the current rx_thread based approach, the rx processing is broken into two parallel contexts
> 1) reaping the packets from the HW
> 2) processing these packets list and handing it over to mac80211 (and later to the network stack)
> 
> This is the primary reason for choosing the rx thread approach.
Have you considered the possibility that maybe the problem is that the
driver doing too much work?
One example is that you could take advantage of the new 802.3 decap
offload to simplify rx processing. Worked for me on mt76 where a
dual-core 1.3 GHz A64 can easily handle >1.8 Gbps local TCP rx on a
single card, without the rx NAPI thread being the biggest consumer of
CPU cycles.

And if you can't do that and still consider all of the metric tons of
processing work necessary, you could still do this:
On interrupts, spawn a processing thread that traverses the ring and
does the preparation work (instead of NAPI).
From that thread you schedule the threaded NAPI handler that processes
these packets further and hands them to mac80211.
To keep the load somewhat balanced, you can limit the number of
pre-processed packets in the ring.

- Felix
