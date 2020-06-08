Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197371F19A2
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgFHNEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728245AbgFHNEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:04:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F47AC08C5C2;
        Mon,  8 Jun 2020 06:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hDfl9IsRghEWVJoDVqBLE/AuuV3u8XXNAFRfV7G4TqA=; b=oV6qX4/MZ4my1YN/7oLFRRQoCc
        7I6YbB1bWx3aFtHY6Ag5nAtegMeMGKQdOfe9JpOWKMcY/RXgPxZTh/Y5rv5bQzeNvN9qiC/XJ9tO/
        /Qs/RIEWGObA50XStykBzLrqhVmy8NVZSqr2jWsvm1/O+FrgFvpawobvHuquKt3JDQDsTYAYJ3yLO
        m7Rwzw+7OslnwUsslSRI30YrfzoXO1Z4p2MSqTO13+1NlaSRwDHxZ6vsSTJC2IkAev6T0ozPUUg/s
        u+CwI4fKVgLkMA6yjn013etsmPOcaHK+rP3LlfBgi7d7mWDjtMdKrZRVfs8oom7//fg6dso29HYEl
        yec3u0Qw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jiHS4-00064f-N1; Mon, 08 Jun 2020 13:04:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9E3F5301DFC;
        Mon,  8 Jun 2020 15:04:30 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5937520E0606E; Mon,  8 Jun 2020 15:04:30 +0200 (CEST)
Date:   Mon, 8 Jun 2020 15:04:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com
Cc:     frederic@kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: liquidio vs smp_call_function_single_async()
Message-ID: <20200608130430.GB2531@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm going through the smp_call_function_single_async() users, and
stumbled over your liquidio thingy. It does:

		call_single_data_t *csd = &droq->csd;

		csd->func = napi_schedule_wrapper;
		csd->info = &droq->napi;
		csd->flags = 0;

		smp_call_function_single_async(droq->cpu_id, csd);

which is almost certainly a bug. What guarantees that csd is unused when
you do this? What happens, if the remote CPU is already running RX and
consumes the packets before the IPI lands, and then this CPU gets
another interrupt.

AFAICT you then call this thing again, causing list corruption.
