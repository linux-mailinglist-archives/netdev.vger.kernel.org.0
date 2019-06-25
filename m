Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEFA553D0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbfFYP5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:57:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731329AbfFYP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:57:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8099B607DE; Tue, 25 Jun 2019 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561478272;
        bh=XqgNOLlTUfn4LH2MAryEaw/gXzDyn3gYQlANzZbh2ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G0Eyj/ti9sagWAhSCxoF72RKgGu7rJhdgnXEXSq7ZNQBnIFiWUQFSZY8D/cMbLJjT
         dRwpc6yAyhpPi/SgwlYIzDRM6tNQbXYlAsr1Afwzj0yUD1nJvPWEghIXgLaThuDQqw
         05v3iNc6CntJYy5Ul+uSX8kxFnPfIxoJJ+ni5Bpo=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from chinagar-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chinagar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6FFFC6016D;
        Tue, 25 Jun 2019 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561478271;
        bh=XqgNOLlTUfn4LH2MAryEaw/gXzDyn3gYQlANzZbh2ms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oG/gj0I8zsbWli2gmZkSGi/vItUD6Owya/TkG+UronQyXn7sTRjXX/Fac3I8sVqE8
         jMftLlBpCcqc4zVe0pvPqX1gZF7wuD3xt/Sk8zHWr6PNGsAgsETpY3JhkdVnlfLXrO
         4BXYgi8b52GCussbW84A6u85+bApQqyVN6NIysxk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6FFFC6016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=chinagar@codeaurora.org
Date:   Tue, 25 Jun 2019 21:27:35 +0530
From:   Chinmay Agarwal <chinagar@codeaurora.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     sharathv@codeaurora.org, kapandey@codeaurora.org
Subject: Re: Warnings generated from tcp_sacktag_write_queue.
Message-ID: <20190625155734.GA31551@chinagar-linux.qualcomm.com>
References: <20190625130706.GA6891@chinagar-linux.qualcomm.com>
 <ab6bb900-e9b7-f2b2-0a56-d1c9e14d2db6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab6bb900-e9b7-f2b2-0a56-d1c9e14d2db6@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 04:24:14PM +0200, Eric Dumazet wrote:
> 
> 
> On 6/25/19 6:07 AM, Chinmay Agarwal wrote:
> > Dear All,
> > 
> > We are hitting the following WARN_ON condition:
> > 
> > 	WARN_ON((int)tcp_packets_in_flight(tp) < 0);
> > 
> > 	tcp_packets_in_flight =  packets_out –( lost_out +
> > 	sacked_out ) + retrans_out  (This value is coming -ve)
> > 
> > The tcp socket being used is in fin_wait_1 state.
> > The values for variables just before the crash:
> > packets_out = 0,
> > retrans_out = 28,
> > lost_out = 38,
> > sacked_out = 8
> > 
> > 
> > The only place I can find the packets_out value being set as 0 is:
> > 
> > void tcp_write_queue_purge(struct sock *sk)
> > {
> > ...
> > 
> > 	tcp_sk(sk)->packets_out = 0;
> >         inet_csk(sk)->icsk_backoff = 0;
> > }
> > 
> > Is there some code flow where packets_out can be set to 0 and other
> > values can remain unchanged?
> > If not, is there some scenario which may lead to "tcp_write_queue_purge"
> > called and not followed up by "tcp_clear_retrans"?
> > 
> > According to my understanding we should call "tcp_clear_retrans" after
> > setting packets_out to 0.
> > 
> > [ 1950.556150] Call trace:
> > [ 1950.558689] tcp_sacktag_write_queue+0x704/0x72c
> > [ 1950.561313] init: Untracked pid 10745 exited with status 0
> > [ 1950.563441] tcp_ack+0x3a4/0xd40
> > [ 1950.563447] tcp_rcv_state_process+0x1e8/0xbbc
> > [ 1950.563457] tcp_v4_do_rcv+0x18c/0x1cc
> > [ 1950.563461] tcp_v4_rcv+0x84c/0x8a8
> > [ 1950.563471] ip_protocol_deliver_rcu+0xdc/0x190
> > [ 1950.563474] ip_local_deliver_finish+0x64/0x80
> > [ 1950.563479] ip_local_deliver+0xc4/0xf8
> > [ 1950.563482] ip_rcv_finish+0x214/0x2e0
> > [ 1950.563486] ip_rcv+0x2fc/0x39c
> > [ 1950.563496] __netif_receive_skb_core+0x698/0x84c
> > [ 1950.563499] __netif_receive_skb+0x3c/0x7c
> > [ 1950.563503] process_backlog+0x98/0x148
> > [ 1950.563506] net_rx_action+0x128/0x388
> > [ 1950.563519] __do_softirq+0x20c/0x3f0
> > [ 1950.563528] irq_exit+0x9c/0xa8
> > [ 1950.563536] handle_IPI+0x174/0x278
> > [ 1950.563540] gic_handle_irq+0x124/0x1c0
> > [ 1950.563544] el1_irq+0xb4/0x12c
> > [ 1950.563556] lpm_cpuidle_enter+0x3f4/0x430
> > [ 1950.563561] cpuidle_enter_state+0x124/0x25c
> > [ 1950.563565] cpuidle_enter+0x30/0x40
> > [ 1950.563575] call_cpuidle+0x3c/0x60
> > [ 1950.563579] do_idle+0x190/0x228
> > [ 1950.563583] cpu_startup_entry+0x24/0x28
> > [ 1950.563588] secondary_start_kernel+0x12c/0x138
> > 
> 
> 
> You do not provide what exact kernel version you are using,
> this is probably the most important information we need.
> 

The kernel version used is 4.14.
