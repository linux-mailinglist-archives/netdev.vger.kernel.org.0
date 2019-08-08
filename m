Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60C685DD8
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbfHHJHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:07:42 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:55278 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbfHHJHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:07:42 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2019 05:07:40 EDT
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id DDE61100111;
        Thu,  8 Aug 2019 11:02:11 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id B22BB326;
        Thu,  8 Aug 2019 11:02:11 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.20.112)
X-Spam-Status: 
X-Spam-Level: 0
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id EE0E62A5;
        Thu,  8 Aug 2019 11:02:09 +0200 (CEST)
Date:   Thu, 8 Aug 2019 11:02:09 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jakub Jankowski <shasta@toxcorp.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 04/42] netfilter: conntrack: always store
 window size un-scaled
Message-ID: <20190808090209.wb63n6ibii4ivvba@intra2net.com>
References: <20190802132302.13537-1-sashal@kernel.org>
 <20190802132302.13537-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802132302.13537-4-sashal@kernel.org>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello together,

You wrote on Fri, Aug 02, 2019 at 09:22:24AM -0400:
> From: Florian Westphal <fw@strlen.de>
> 
> [ Upstream commit 959b69ef57db00cb33e9c4777400ae7183ebddd3 ]
> 
> Jakub Jankowski reported following oddity:
> 
> After 3 way handshake completes, timeout of new connection is set to
> max_retrans (300s) instead of established (5 days).
> 
> shortened excerpt from pcap provided:
> 25.070622 IP (flags [DF], proto TCP (6), length 52)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
> 26.070462 IP (flags [DF], proto TCP (6), length 48)
> 10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
> 27.070449 IP (flags [DF], proto TCP (6), length 40)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0
> 
> Turns out the last_win is of u16 type, but we store the scaled value:
> 512 << 8 (== 0x20000) becomes 0 window.
> 
> The Fixes tag is not correct, as the bug has existed forever, but
> without that change all that this causes might cause is to mistake a
> window update (to-nonzero-from-zero) for a retransmit.
> 
> Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
> Reported-by: Jakub Jankowski <shasta@toxcorp.com>
> Tested-by: Jakub Jankowski <shasta@toxcorp.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Also:
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

;)

We've hit the issue with the wrong conntrack timeout at two different sites,
long-lived connections to a SAP server over IPSec VPN were constantly dropping.

For us this was a regression after updating from kernel 3.14 to 4.19.
Yesterday I've applied the patch to kernel 4.19.57 and the problem is fixed.

The issue was extra hard to debug as we could just boot the new kernel
for twenty minutes in the evening on these productive systems.

The stable kernel patch from last Friday came right on time. I was just
about the replay the TCP connection with tcpreplay, so this saved
me from another week of debugging. Thanks everyone!

Best regards,
Thomas Jarosch
