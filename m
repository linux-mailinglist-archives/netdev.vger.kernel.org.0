Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5AD3923D1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 02:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhE0Afg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 20:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhE0Aff (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 20:35:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DEA06139A;
        Thu, 27 May 2021 00:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622075643;
        bh=hMUHcuQJzhC7R4YDpWAJ9HVvuTRnWFnfXpLpndKR5A4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jIUA9aaT3eKo+V+MIfmF32QY/6ZLicL7p8ajShVSoWR7pQvDCk55Lvl8MuCYbGfFC
         H0Iilo3WWiAuqXBwX+ecH3Belo9ILPF6ufSMEyfgKZxzWtwbkjdbq9paZ8y8+7aGXU
         r2b6A5b08bwvRwYyc/xrOkjY4S8RYTjRxpDz3EfpHlo6Bj5lbWg/Zd+8rZiMUapKwM
         1+4Rwi5a+24kPgSU2f1M+rx2BbRtkfDykPQ+YG+UxJi04Ei3ipqQB3h6IA/WAjizvL
         2H2/L+zx0sc7W69PIKIWDFa0ZPBz8zKt7azG2Ne/10MiaF33M7ajGwGRNjq65do/Qm
         2ubrFAg+vzuBA==
Date:   Wed, 26 May 2021 17:34:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [RESEND PATCH net-next v3 4/5] ipv6: ioam: Support for IOAM
 injection with lwtunnels
Message-ID: <20210526173402.28ce9ef0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526171640.9722-5-justin.iurman@uliege.be>
References: <20210526171640.9722-1-justin.iurman@uliege.be>
        <20210526171640.9722-5-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 19:16:39 +0200 Justin Iurman wrote:
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

Please address the warnings from checkpatch --strict on this patches.

For all patches please make sure you don't use static inline in C
files, and let the compiler decide what to inline by itself.

> +	if (trace->type.bit0) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit1) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit2) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit3) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit4) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit5) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit6) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit7) trace->nodelen += sizeof(__be32) / 4;
> +	if (trace->type.bit8) trace->nodelen += sizeof(__be64) / 4;
> +	if (trace->type.bit9) trace->nodelen += sizeof(__be64) / 4;
> +	if (trace->type.bit10) trace->nodelen += sizeof(__be64) / 4;
> +	if (trace->type.bit11) trace->nodelen += sizeof(__be32) / 4;

Seems simpler to do:

	nodelen += hweight16(field & MASK1) * (sizeof(__be32) / 4);
	nodelen += hweight16(field & MASK2) * (sizeof(__be64) / 4);
