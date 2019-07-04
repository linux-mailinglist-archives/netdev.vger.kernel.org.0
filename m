Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F218C5F8D4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfGDNFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:05:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34236 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbfGDNFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 09:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7doTKV97OLObJ2URRWGKRUEPdTwo2Fw8thDoTxcupKw=; b=mNMoh5UHOzTLQeigOfF3xqnij
        V7pMqlyctC/O1GnPHjnn8z5Fj3baBhoKbj2jxTskM6fNiw4nx04+RbL79UDYdhkmvwxwpw7F2vwfd
        yiG9XHVVS8O2syI2TK2dnodXYyLpuU4Pm/kx7LWinbeYf6qd7DCcwAA+hbpFZMxRC7g3Fo+2GzhWl
        weq5IXicaKO6A+y1/df97Aa+/wVMsgJPrSAmFAQ/MFkXSICiNla+G6g2yweWYw0o9YTL1WMerRV6A
        mk+m5uipbxFIrfNh6sJ3kFc4baf4llrZmNEYY3YXVwCxO+x6C115sWSpL0vF2nNgZN6KsnxpKFxq5
        sEIndIz3g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hj1QE-0003YF-R2; Thu, 04 Jul 2019 13:05:11 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 42B4120AF0744; Thu,  4 Jul 2019 15:05:09 +0200 (CEST)
Date:   Thu, 4 Jul 2019 15:05:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190704130509.GO3402@hirez.programming.kicks-ass.net>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907040314.x643EUoA017906@aserv0122.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees wrote:
> +int dt_bpf_attach(int event_id, int bpf_fd)
> +{
> +	int			event_fd;
> +	int			rc;
> +	struct perf_event_attr	attr = {};
> +
> +	attr.type = PERF_TYPE_TRACEPOINT;
> +	attr.sample_type = PERF_SAMPLE_RAW;
> +	attr.sample_period = 1;
> +	attr.wakeup_events = 1;
> +	attr.config = event_id;
> +
> +	/* Register the event (based on its id), and obtain a fd. */
> +	event_fd = perf_event_open(&attr, -1, 0, -1, 0);
> +	if (event_fd < 0) {
> +		perror("sys_perf_event_open");
> +		return -1;
> +	}
> +
> +	/* Enable the probe. */
> +	rc = ioctl(event_fd, PERF_EVENT_IOC_ENABLE, 0);

AFAICT you didn't use attr.disabled = 1, so this IOC_ENABLE is
completely superfluous.

> +	if (rc < 0) {
> +		perror("PERF_EVENT_IOC_ENABLE");
> +		return -1;
> +	}
> +
> +	/* Associate the BPF program with the event. */
> +	rc = ioctl(event_fd, PERF_EVENT_IOC_SET_BPF, bpf_fd);
> +	if (rc < 0) {
> +		perror("PERF_EVENT_IOC_SET_BPF");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
