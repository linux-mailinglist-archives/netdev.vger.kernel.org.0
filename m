Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28CCF13916A
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgAMMvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:51:49 -0500
Received: from mx4.wp.pl ([212.77.101.12]:45366 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgAMMvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 07:51:49 -0500
Received: (wp-smtpd smtp.wp.pl 17450 invoked from network); 13 Jan 2020 13:51:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578919906; bh=Mxm7b8zM02QFZaaphROEcKcn/YEx9WXTuE/NQeKUMUs=;
          h=From:To:Cc:Subject;
          b=rUht59dHg4E9WOMTiWla3X+3rKCaD7tAd0PX3Ue1TBpJntMZkghkbgqQgvWXcoV3i
           Y3oZ3nPg2I1dfYthFTDcGv0gGLDOqhs7ZG3yrNS8xidHYGyWTd9xVUU2ndHKNQkDv9
           cZ39RH3qFpGHmV0OcbokFoBLxDh2D5cypZWD04MY=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <niu_xilei@163.com>; 13 Jan 2020 13:51:46 +0100
Date:   Mon, 13 Jan 2020 04:51:36 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Niu Xilei <niu_xilei@163.com>
Cc:     davem@davemloft.net, tglx@linutronix.de, fw@strlen.de,
        peterz@infradead.org, steffen.klassert@secunet.com,
        bigeasy@linutronix.de, jonathan.lemon@gmail.com, pabeni@redhat.com,
        anshuman.khandual@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pktgen: create packet use IPv6 source address
 between src6_min and src6_max.
Message-ID: <20200113045136.4d59dded@cakuba>
In-Reply-To: <20200113112103.6766-1-niu_xilei@163.com>
References: <20200113112103.6766-1-niu_xilei@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: b6ed76e7110333e816cd291da4871436
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [oWMU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subject line could use some rewording, I think.

On Mon, 13 Jan 2020 19:21:02 +0800, Niu Xilei wrote:
> Pktgen can use only one IPv6 source address from output device, or src6 command
> setting. In pressure test we need create lots of session more than 65536.If
> IPSRC_RND flag is set, generate random source address between src6_min and src6_max.
> 
> Signed-off-by: Niu Xilei <niu_xilei@163.com>
> 
> Changes since v1:
>  - only create IPv6 source address over least significant 64 bit range

> +/* generate ipv6 source addr */
> +static inline void set_src_in6_addr(struct pktgen_dev *pkt_dev)

Please just use "static" instead of "static inline". The compiler will
be clever enough to decide the inlining.

> +{
> +	__be64 min6_h, min6_l, max6_h, max6_l, addr_l, *t;
> +	u64 min6, max6, rand, i;
> +	struct in6_addr addr6;
> +
> +	memcpy(&min6_h, pkt_dev->min_in6_saddr.s6_addr, 8);
> +	memcpy(&min6_l, pkt_dev->min_in6_saddr.s6_addr + 8, 8);
> +	memcpy(&max6_h, pkt_dev->max_in6_saddr.s6_addr, 8);
> +	memcpy(&max6_l, pkt_dev->max_in6_saddr.s6_addr + 8, 8);
> +
> +	/* only generate source address in least significant 64 bits range
> +	 * most significant 64 bits must be equal
> +	 */
> +	if (max6_h != min6_h)
> +		return;
> +
> +	addr6 = pkt_dev->min_in6_saddr;
> +	t = (__be64 *)addr6.s6_addr + 1;
> +	min6 = be64_to_cpu(min6_l);
> +	max6 = be64_to_cpu(max6_l);
> +
> +	if (min6 < max6) {

Since this code is executed on every packet, would it be possible to
pre-compute the decision if the IPv6 address is to be generated or not?
We have 4 memcpy()s and 2 byte swaps, and the conditions never change,
so it could be computed at setup time, right?

> +		if (pkt_dev->flags & F_IPSRC_RND) {
> +			do {
> +				prandom_bytes(&rand, sizeof(rand));
> +				rand = rand % (max6 - min6) + min6;
> +				addr_l = cpu_to_be64(rand);
> +				memcpy(t, &addr_l, 8);
> +			} while (ipv6_addr_loopback(&addr6) ||
> +				 ipv6_addr_v4mapped(&addr6) ||
> +				 ipv6_addr_is_multicast(&addr6));
> +		} else {
> +			addr6 = pkt_dev->cur_in6_saddr;
> +			i = be64_to_cpu(*t);
> +			if (++i > max6)
> +				i = min6;
> +			addr_l = cpu_to_be64(i);
> +			memcpy(t, &addr_l, 8);
> +		}
> +	}
> +	pkt_dev->cur_in6_saddr = addr6;
> +}
