Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E270C6621F8
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbjAIJq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbjAIJqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:46:06 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190CD9FD6;
        Mon,  9 Jan 2023 01:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IsQXb0coC4MH8lm3N/KTjIXu0ELkSrGyhN9jJUZYXRg=; b=UfH94avJySRuY6Ha5LtchQXvYM
        Ostvhiogm0+IZ+7oM2akuvihUCNKugyradH2HkziZCGnV3Uxsg/duAsJX8SS6m8lciNAOYeQtwlDF
        I8OSWvdlDxBB7jddWG6vJ88//CmrHXZPDwNJdC6N50GtwYYc7glptEkWzX1+kD04YC6viV5uZQRtZ
        QlFEvs8g/oI073PXNs2bjCPOimhgdvy5HvGJVsp0YiO+zI+l6j1rMAauZG7547JTpTZtG3OSZL/h7
        sB+c7I69mLwMN0OxvhSEoQ6BSCW1pQpjDPi0uK5lD7yKthGzLr4lgfew24uLkd3zsTP1Drleb4cji
        SlmHh6DQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pEohw-002fkB-0b;
        Mon, 09 Jan 2023 09:44:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2BD35300193;
        Mon,  9 Jan 2023 10:44:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EA8D6201BB46C; Mon,  9 Jan 2023 10:44:49 +0100 (CET)
Date:   Mon, 9 Jan 2023 10:44:49 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     tglx@linutronix.de, jstultz@google.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] softirq: don't yield if only expedited handlers are
 pending
Message-ID: <Y7viEa4BC3yJRXIS@hirez.programming.kicks-ass.net>
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222221244.1290833-4-kuba@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 22, 2022 at 02:12:44PM -0800, Jakub Kicinski wrote:
> In networking we try to keep Tx packet queues small, so we limit
> how many bytes a socket may packetize and queue up. Tx completions
> (from NAPI) notify the sockets when packets have left the system
> (NIC Tx completion) and the socket schedules a tasklet to queue
> the next batch of frames.
> 
> This leads to a situation where we go thru the softirq loop twice.
> First round we have pending = NET (from the NIC IRQ/NAPI), and
> the second iteration has pending = TASKLET (the socket tasklet).

So to me that sounds like you want to fix the network code to not do
this then. Why can't the NAPI thing directly queue the next batch; why
do you have to do a softirq roundtrip like this?

> On two web workloads I looked at this condition accounts for 10%
> and 23% of all ksoftirqd wake ups respectively. We run NAPI
> which wakes some process up, we hit need_resched() and wake up
> ksoftirqd just to run the TSQ (TCP small queues) tasklet.
> 
> Tweak the need_resched() condition to be ignored if all pending
> softIRQs are "non-deferred". The tasklet would run relatively
> soon, anyway, but once ksoftirqd is woken we're risking stalls.
> 
> I did not see any negative impact on the latency in an RR test
> on a loaded machine with this change applied.

Ignoring need_resched() will get you in trouble with RT people real
fast.
