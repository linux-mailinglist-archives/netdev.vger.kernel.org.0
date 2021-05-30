Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728E39507B
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 12:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhE3Ktv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 06:49:51 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:53642 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhE3Ktu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 06:49:50 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id AA998200E7A2;
        Sun, 30 May 2021 12:48:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be AA998200E7A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622371691;
        bh=UHNbFTXsAWHGOHhSlequTcptYzZNcBmx4DXQjCcQUyM=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=sFEkdTkh5i5zdy0m3MHjCWU1R4vUMdYenjaxQjSnJcLPI3qCAXbvTewFxFp9taQkZ
         QIjUJ1/NrgF2nApiIFZ5+T8SwJ4YDcRR85sZ+I7l/nV69AU2+xQQc6ZeMMPSbBaog4
         1jkgaaOJSVIYJDb9U9+JR8pkhFyM2Gj5aGKCZpmpL/pBLafoD7+gjjK5nk4j1Xf79c
         U2BiKTHVJNslfVGSYZhGgUH6EbZtpPvvc3QmgqCHEYHJjVBXLi8mXZCuuPAnJ7MloE
         SWfHOpCXqmmP6SNFZnv6BsV6Czn4/aR2T7AeoA4cJw2TkjyixpobayG+YZeChC7Hhk
         IsUKlRvaDdhOQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 9CA4A6008D47B;
        Sun, 30 May 2021 12:48:11 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Io2xjwdJVzog; Sun, 30 May 2021 12:48:11 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 86C3A6008D34F;
        Sun, 30 May 2021 12:48:11 +0200 (CEST)
Date:   Sun, 30 May 2021 12:48:11 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <829937119.34112748.1622371691514.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210529140632.57b434b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210527151652.16074-1-justin.iurman@uliege.be> <20210527151652.16074-5-justin.iurman@uliege.be> <20210529140632.57b434b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next v4 4/5] ipv6: ioam: Support for IOAM injection
 with lwtunnels
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for IOAM injection with lwtunnels
Thread-Index: xcPooFwYp/D9BXyukxJU5fOYlu8yGA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 27 May 2021 17:16:51 +0200 Justin Iurman wrote:
>> Add support for the IOAM inline insertion (only for the host-to-host use case)
>> which is per-route configured with lightweight tunnels. The target is iproute2
>> and the patch is ready. It will be posted as soon as this patchset is merged.
>> Here is an overview:
>> 
>> $ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0
>> 
>> This example configures an IOAM Pre-allocated Trace option attached to the
>> fc00::1/128 prefix. The IOAM namespace (ns) is 1, the size of the pre-allocated
>> trace data block is 12 octets (size) and only the first IOAM data (bit 0:
>> hop_limit + node id) is included in the trace (type) represented as a bitfield.
>> 
>> The reason why the in-transit (IPv6-in-IPv6 encapsulation) use case is not
>> implemented is explained on the patchset cover.
>> 
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> 
>> +static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] =
>> {
>> +	[IOAM6_IPTUNNEL_TRACE]	= { .type = NLA_BINARY },
> 
> Please use NLA_POLICY_EXACT_LEN(sizeof(..)), that should avoid the need
> for explicit check in the code.

ACK.

>
>> +};
> 
>> +static int ioam6_build_state(struct net *net, struct nlattr *nla,
>> +			     unsigned int family, const void *cfg,
>> +			     struct lwtunnel_state **ts,
>> +			     struct netlink_ext_ack *extack)
>> +{
>> +	struct nlattr *tb[IOAM6_IPTUNNEL_MAX + 1];
>> +	struct ioam6_lwt_encap *tuninfo;
>> +	struct ioam6_trace_hdr *trace;
>> +	struct lwtunnel_state *s;
>> +	int len_aligned;
>> +	int len, err;
>> +
>> +	if (family != AF_INET6)
>> +		return -EINVAL;
>> +
>> +	err = nla_parse_nested(tb, IOAM6_IPTUNNEL_MAX, nla,
>> +			       ioam6_iptunnel_policy, extack);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	if (!tb[IOAM6_IPTUNNEL_TRACE])
>> +		return -EINVAL;
>> +
>> +	trace = nla_data(tb[IOAM6_IPTUNNEL_TRACE]);
>> +	if (nla_len(tb[IOAM6_IPTUNNEL_TRACE]) != sizeof(*trace))
>> +		return -EINVAL;
>> +
>> +	if (!ioam6_validate_trace_hdr(trace))
>> +		return -EINVAL;
> 
> It'd be good to set the extack message and attribute here. And perhaps
> a message for the case of trace missing.

ACK.
