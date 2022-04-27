Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80107511B0C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbiD0Okk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiD0Oki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:40:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E53832981;
        Wed, 27 Apr 2022 07:37:08 -0700 (PDT)
Date:   Wed, 27 Apr 2022 16:36:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     gal@nvidia.com, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/1] netfilter: conntrack: skip verification
 of zero UDP checksum
Message-ID: <YmlVAXceuasAJjnN@salvia>
References: <20220405234739.269371-2-kevmitch@arista.com>
 <20220408043341.416219-1-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220408043341.416219-1-kevmitch@arista.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 09:33:40PM -0700, Kevin Mitchell wrote:
> The checksum is optional for UDP packets in IPv4. However nf_reject
> would previously require a valid checksum to elicit a response such as
> ICMP_DEST_UNREACH.
> 
> Add some logic to nf_reject_verify_csum to determine if a UDP packet has
> a zero checksum and should therefore not be verified. Explicitly require
> a valid checksum for IPv6 consistent RFC 2460 and with the non-netfilter
> stack (see udp6_csum_zero_error).
>
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> ---
>  include/net/netfilter/nf_reject.h   | 27 +++++++++++++++++++++++----
>  net/ipv4/netfilter/nf_reject_ipv4.c | 10 +++++++---
>  net/ipv6/netfilter/nf_reject_ipv6.c |  4 ++--
>  3 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
> index 9051c3a0c8e7..f248c1ff8b22 100644
> --- a/include/net/netfilter/nf_reject.h
> +++ b/include/net/netfilter/nf_reject.h
> @@ -5,12 +5,34 @@
>  #include <linux/types.h>
>  #include <uapi/linux/in.h>
>  
> -static inline bool nf_reject_verify_csum(__u8 proto)
> +static inline bool nf_reject_verify_csum(struct sk_buff *skb, int dataoff,
> +					  __u8 proto)
>  {
>  	/* Skip protocols that don't use 16-bit one's complement checksum
>  	 * of the entire payload.
>  	 */
>  	switch (proto) {
> +		/* Protocols with optional checksums. */
> +		case IPPROTO_UDP: {
> +			const struct udphdr *udp_hdr;
> +			struct udphdr _udp_hdr;
> +
> +			/* Checksum is required in IPv6
> +			 * see RFC 2460 section 8.1
> +			 */

Right, but follow up work say otherwise?

https://www.rfc-editor.org/rfc/rfc6935
https://www.rfc-editor.org/rfc/rfc6936

Moreover, conntrack and NAT already allow for UDP zero checksum in IPv6.

I'm inclined to stick to the existing behaviour for consistency, ie.
allow for zero checksum in IPv6 UDP.
