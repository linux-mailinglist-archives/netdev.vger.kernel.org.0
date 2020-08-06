Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD623E18B
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgHFSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgHFSzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 14:55:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4FA6206A2;
        Thu,  6 Aug 2020 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596740114;
        bh=DtdBmO/qxCQOdPUNsgftzN8R4iy9ce5fBEY+o4umB4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q8JOFhBmXomisJOslFjUrz9PfB//cIVLHdux1jbhZMntwYN1xj8KIN0iUEwucD13x
         EOJJF+/m4jHr1LAwQ1C9uBPBWNMraANt4+TipmY2R8xCMqF9efkNo0ZeLjntQ0RdC7
         MgyB2yLWNIw67sZ78CA6B0wYl95cWKcNW8+lYnqo=
Date:   Thu, 6 Aug 2020 11:55:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH v2] net: add support for threaded NAPI polling
Message-ID: <20200806115511.6774e922@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200806095558.82780-1-nbd@nbd.name>
References: <20200806095558.82780-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Aug 2020 11:55:58 +0200 Felix Fietkau wrote:
> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
> poll function does not perform well. Since NAPI poll is bound to the CPU it
> was scheduled from, we can easily end up with a few very busy CPUs spending
> most of their time in softirq/ksoftirqd and some idle ones.
> 
> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
> same except for using netif_threaded_napi_add instead of netif_napi_add.
> 
> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
> thread.
> 
> With threaded NAPI, throughput seems stable and consistent (and higher than
> the best results I got without it).

I'm still trying to wrap my head around this.

Am I understanding correctly that you have one IRQ and multiple NAPI
instances?

Are we not going to end up with pretty terrible cache locality here if
the scheduler starts to throw rx and tx completions around to random
CPUs?

I understand that implementing separate kthreads would be more LoC, but
we do have ksoftirqs already... maybe we should make the NAPI ->
ksoftirq mapping more flexible, and improve the logic which decides to
load ksoftirq rather than make $current() pay?

Sorry for being slow.
