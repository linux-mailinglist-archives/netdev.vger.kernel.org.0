Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2993273AF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfEWBBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:01:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:00:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1269115043931;
        Wed, 22 May 2019 18:00:59 -0700 (PDT)
Date:   Wed, 22 May 2019 18:00:58 -0700 (PDT)
Message-Id: <20190522.180058.887469871482412864.davem@davemloft.net>
To:     sunilmut@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, mikelley@microsoft.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hv_sock: perf: loop in send() to maximize
 bandwidth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <BN6PR21MB0465FA591662A8B580AEF7D9C0000@BN6PR21MB0465.namprd21.prod.outlook.com>
References: <BN6PR21MB0465FA591662A8B580AEF7D9C0000@BN6PR21MB0465.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 18:00:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Muthuswamy <sunilmut@microsoft.com>
Date: Wed, 22 May 2019 23:10:44 +0000

> Currently, the hv_sock send() iterates once over the buffer, puts data into
> the VMBUS channel and returns. It doesn't maximize on the case when there
> is a simultaneous reader draining data from the channel. In such a case,
> the send() can maximize the bandwidth (and consequently minimize the cpu
> cycles) by iterating until the channel is found to be full.
> 
> Perf data:
> Total Data Transfer: 10GB/iteration
> Single threaded reader/writer, Linux hvsocket writer with Windows hvsocket
> reader
> Packet size: 64KB
> CPU sys time was captured using the 'time' command for the writer to send
> 10GB of data.
> 'Send Buffer Loop' is with the patch applied.
> The values below are over 10 iterations.
 ...
> Observation:
> 1. The avg throughput doesn't really change much with this change for this
> scenario. This is most probably because the bottleneck on throughput is
> somewhere else.
> 2. The average system (or kernel) cpu time goes down by 10%+ with this
> change, for the same amount of data transfer.
> 
> Signed-off-by: Sunil Muthuswamy <sunilmut@microsoft.com>

Applied.
