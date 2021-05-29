Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B9394E36
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 23:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhE2VIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 17:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhE2VIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 17:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F00860FDC;
        Sat, 29 May 2021 21:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622322393;
        bh=lkjGZN8dF3qMW4E5XCw2CrHmT6ge5TOA70W6HnwQLq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFE0+9XLKqlENGvsYcbiBzynV+J/AORhHlPR3vQnaeFUIIGHsaxHG3vZAlDeCT56w
         QaFx9pT5vw58pegBi05C4wY1IGIrocM8t3l7XCrFu9hnQWdiSbcQ5NcmwVcqjCTQwk
         AcXTRSjYvjTNJTysvExl42+Bb0vXoPglFIS0ch1cZFkmBa3mBEZ/2Mxg2sBI4I1Mhb
         jARb9Q38KJ0ui2gSR5q7MxwebGfi6at+M1NjUwFP71ZZQlpSTLuzYRDgC9+AE5NEEi
         5AlltYMNEFCv2D4u2RIVVyAnCXj/OyidfRkg+e1vte39VQdAXCLAs4BuxPmuvf76/w
         vYCTQDH3SeQTg==
Date:   Sat, 29 May 2021 14:06:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 4/5] ipv6: ioam: Support for IOAM injection
 with lwtunnels
Message-ID: <20210529140632.57b434b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527151652.16074-5-justin.iurman@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-5-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:16:51 +0200 Justin Iurman wrote:
> Add support for the IOAM inline insertion (only for the host-to-host use case)
> which is per-route configured with lightweight tunnels. The target is iproute2
> and the patch is ready. It will be posted as soon as this patchset is merged.
> Here is an overview:
> 
> $ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0
> 
> This example configures an IOAM Pre-allocated Trace option attached to the
> fc00::1/128 prefix. The IOAM namespace (ns) is 1, the size of the pre-allocated
> trace data block is 12 octets (size) and only the first IOAM data (bit 0:
> hop_limit + node id) is included in the trace (type) represented as a bitfield.
> 
> The reason why the in-transit (IPv6-in-IPv6 encapsulation) use case is not
> implemented is explained on the patchset cover.
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

> +static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
> +	[IOAM6_IPTUNNEL_TRACE]	= { .type = NLA_BINARY },

Please use NLA_POLICY_EXACT_LEN(sizeof(..)), that should avoid the need
for explicit check in the code.

> +};

> +static int ioam6_build_state(struct net *net, struct nlattr *nla,
> +			     unsigned int family, const void *cfg,
> +			     struct lwtunnel_state **ts,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[IOAM6_IPTUNNEL_MAX + 1];
> +	struct ioam6_lwt_encap *tuninfo;
> +	struct ioam6_trace_hdr *trace;
> +	struct lwtunnel_state *s;
> +	int len_aligned;
> +	int len, err;
> +
> +	if (family != AF_INET6)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested(tb, IOAM6_IPTUNNEL_MAX, nla,
> +			       ioam6_iptunnel_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[IOAM6_IPTUNNEL_TRACE])
> +		return -EINVAL;
> +
> +	trace = nla_data(tb[IOAM6_IPTUNNEL_TRACE]);
> +	if (nla_len(tb[IOAM6_IPTUNNEL_TRACE]) != sizeof(*trace))
> +		return -EINVAL;
> +
> +	if (!ioam6_validate_trace_hdr(trace))
> +		return -EINVAL;

It'd be good to set the extack message and attribute here. And perhaps
a message for the case of trace missing.

> +	len = sizeof(*tuninfo) + trace->remlen * 4;
> +	len_aligned = ALIGN(len, 8);

