Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB263952CE
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhE3UDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 16:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhE3UDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 16:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E026C60FF0;
        Sun, 30 May 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622404933;
        bh=6ppSoreE6YTa5lmem3dbF5W0goCXH/bzGIUWyyMQU9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rg/TMZAPn5NxwRdkQ8jdxz+ZTV2hK1KI/IL/BUi1DPJJLrGKSRm0Wj67BHQPb1kLS
         XYvnDX67r9HIuBXT40bZ1vgX1mQ2+aV/CvwyRLVSY+cmo9a5cNxBGaBNOeBVWiaMKY
         jRO1RZKlofJPRx7vulyxUcr6A11chJwBXWvb/7A3ZSUE6tbX220qR+LUPasjsUWIqC
         /NYxlvZTEzUcNy+RkwOgiqgSm1RYZtfJH9CMwTVUjw33Lm9bihf7WVRLVA+iRV75x2
         ovbmBpCXNgLFApg5zwvG9HzSjQi/n9ugGwDFWIzXjkr9/GMmND+C3/NLdHMvPXF6/y
         MHDPQ7DxpXCBA==
Date:   Sun, 30 May 2021 13:02:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 2/5] ipv6: ioam: Data plane support for
 Pre-allocated Trace
Message-ID: <20210530130212.327a0a0c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-3-justin.iurman@uliege.be>
        <20210529140555.3536909f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <1678535209.34108899.1622370998279.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 12:36:38 +0200 (CEST) Justin Iurman wrote:
> >> A per-interface sysctl ioam6_enabled is provided to process/ignore IOAM
> >> headers. Default is ignore (= disabled). Another per-interface sysctl
> >> ioam6_id is provided to define the IOAM (unique) identifier of the
> >> interface. Default is 0. A per-namespace sysctl ioam6_id is provided to
> >> define the IOAM (unique) identifier of the node. Default is 0.  
> > 
> > Last two sentences are repeated.  
> 
> One describes net.ipv6.conf.XXX.ioam6_id (per interface) and the
> other describes net.ipv6.ioam6_id (per namespace). It allows for
> defining an IOAM id to an interface and, also, the node in general.

I see it now, please rephrase.

> >> @@ -929,6 +932,50 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
> >>  	return false;
> >>  }
> >>  
> >> +/* IOAM */
> >> +
> >> +static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
> >> +{
> >> +	struct ioam6_trace_hdr *trace;
> >> +	struct ioam6_namespace *ns;
> >> +	struct ioam6_hdr *hdr;
> >> +
> >> +	/* Must be 4n-aligned */
> >> +	if (optoff & 3)
> >> +		goto drop;
> >> +
> >> +	/* Ignore if IOAM is not enabled on ingress */
> >> +	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
> >> +		goto ignore;
> >> +
> >> +	hdr = (struct ioam6_hdr *)(skb_network_header(skb) + optoff);
> >> +
> >> +	switch (hdr->type) {
> >> +	case IOAM6_TYPE_PREALLOC:
> >> +		trace = (struct ioam6_trace_hdr *)((u8 *)hdr + sizeof(*hdr));
> >> +		ns = ioam6_namespace(ipv6_skb_net(skb), trace->namespace_id);  
> > 
> > Shouldn't there be validation that the header is not truncated or
> > malformed before we start poking into the fields?  
> 
> ioam6_fill_trace_data is responsible (right after that) for checking
> the header and making sure the whole thing makes sense before
> inserting data. But, first, we need to parse the IOAM-Namespace ID to
> check if it is a known (defined) one or not, and therefore either
> going deeper or ignoring the option. Anyway, maybe I could add a
> check on hdr->opt_len and make sure it has at least the length of the
> required header (what comes after is data).

Right, don't we also need to check hdr->opt_len vs trace->remlen?

BTW the ASCII art in patch 1 looks like node data is filled in in order
but:

+	data = trace->data + trace->remlen * 4 - trace->nodelen * 4 - sclen * 4;

Looks like we'd start from the last node data?
