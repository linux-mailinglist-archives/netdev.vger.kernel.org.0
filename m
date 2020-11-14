Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF3B2B2FE9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKNS5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKNS5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 13:57:37 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64D1920715;
        Sat, 14 Nov 2020 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605380256;
        bh=PAyzDPS7sK5Oi6ZwHPvzaPXV7iWsAXileTQtEazOcFs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gi3aBqqS4v+2hX2ZNDFt9S2JQ9cLdDK983q/sgw21wi0tjmUYl0DepctUER8a0WhT
         jxpbj8fh6ccT6He0Q6IBCVYJ4/cU7nOEvQpivMvd6eBfpVuNUs3UEOK6AszRwPJci7
         JmQ+IEylHKhyXp6upi5NE9p8fQivZz2nhQ75R2L8=
Date:   Sat, 14 Nov 2020 10:57:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Georg Kohmann <geokohma@cisco.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH net v4] ipv6/netfilter: Discard first fragment not
 including all headers
Message-ID: <20201114105735.4e3bde7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111115025.28879-1-geokohma@cisco.com>
References: <20201111115025.28879-1-geokohma@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 12:50:25 +0100 Georg Kohmann wrote:
> Packets are processed even though the first fragment don't include all
> headers through the upper layer header. This breaks TAHI IPv6 Core
> Conformance Test v6LC.1.3.6.
> 
> Referring to RFC8200 SECTION 4.5: "If the first fragment does not include
> all headers through an Upper-Layer header, then that fragment should be
> discarded and an ICMP Parameter Problem, Code 3, message should be sent to
> the source of the fragment, with the Pointer field set to zero."
> 
> The fragment needs to be validated the same way it is done in
> commit 2efdaaaf883a ("IPv6: reply ICMP error if the first fragment don't
> include all headers") for ipv6. Wrap the validation into a common function,
> ipv6_frag_thdr_truncated() to check for truncation in the upper layer
> header. This validation does not fullfill all aspects of RFC 8200,
> section 4.5, but is at the moment sufficient to pass mentioned TAHI test.
> 
> In netfilter, utilize the fragment offset returned by find_prev_fhdr() to
> let ipv6_frag_thdr_truncated() start it's traverse from the fragment
> header.
> 
> Return 0 to drop the fragment in the netfilter. This is the same behaviour
> as used on other protocol errors in this function, e.g. when
> nf_ct_frag6_queue() returns -EPROTO. The Fragment will later be picked up
> by ipv6_frag_rcv() in reassembly.c. ipv6_frag_rcv() will then send an
> appropriate ICMP Parameter Problem message back to the source.
> 
> References commit 2efdaaaf883a ("IPv6: reply ICMP error if the first
> fragment don't include all headers")
> 
> Signed-off-by: Georg Kohmann <geokohma@cisco.com>

LGTM, awaiting ack from Pablo.
