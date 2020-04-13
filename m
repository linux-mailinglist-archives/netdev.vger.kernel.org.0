Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEA11A6251
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 07:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgDMFEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 01:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgDMFEA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 01:04:00 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFF4C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 22:04:00 -0700 (PDT)
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA142206E9;
        Mon, 13 Apr 2020 05:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586754240;
        bh=XTWuc90/zLwotm2qKopM1ZOgVrTbv6ZhLB3p46Yuhbw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fs6ePEpKiZaCryHkCXaPwaEMrOEXGiEOgvTfGrZLTIbg3NXXl0FZnB7L1TMsoaT5H
         THtiG2uZQJhu7XymsgH2S6LVtgYIt9vtP4UtH6kIK6l3v0Z3VyblejodcL8rK0/ATE
         qMNs5Wl0AJTO0J34RIGyC40TT0QtpgsHJalapjRM=
Date:   Mon, 13 Apr 2020 08:03:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, arjan@linux.intel.com, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org
Subject: Re: [PATCH net v1] net/sched: Don't print dump stack in event of
 transmission timeout
Message-ID: <20200413050357.GF334007@unreal>
References: <20200412060854.334895-1-leon@kernel.org>
 <20200412.211925.400624643622219681.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412.211925.400624643622219681.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 09:19:25PM -0700, David Miller wrote:
>
> This is cause by a device"overwhelmed with traffic"?  Sounds like
> normal operation to me.
>
> That's a bug, and the driver handling the device with this problem
> should adjust how it implements TX timeouts to accomodate this.

From the internal bug description, hope that it makes sense.

-----
A timeout may occur if the amount of the reported bytes higher than the queue limit,
in this case, the kernel closes the queue and only after getting a completion it wil
reopen it.

In the debug we saw that in some situations the driver gets a **delayed completion**,
completions arrive after **1 min**, therefore, the amount of queued bytes exceeds the
DQL max size.

As a result, the kernel after watchdog_timeo calls the driver's timeout function,
that prints timeout to dmesg.

After debugging the issue with FW to understand the root cause of the delayed completions
we understand that since the IB and the TCP traffic are running at the same service level (SL),
the same schedule queue schedules between all the QPs, and in this case if one of the IB QPs get
stuck because of congestion, all other QPs will be stuck (include the TCP QPs) until releasing
the stuck QP.
-----

User separates traffic to different SLs.

Thanks
