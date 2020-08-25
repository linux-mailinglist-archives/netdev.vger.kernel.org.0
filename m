Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409EB250E14
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgHYBLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgHYBLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:11:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE34CC061574;
        Mon, 24 Aug 2020 18:11:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87CC01295776B;
        Mon, 24 Aug 2020 17:54:24 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:11:09 -0700 (PDT)
Message-Id: <20200824.181109.421299456838417383.davem@davemloft.net>
To:     ahabdels@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [net-next v4] seg6: using DSCP of inner IPv4 packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200824085124.2488-1-ahabdels@gmail.com>
References: <20200824085124.2488-1-ahabdels@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:54:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmed Abdelsalam <ahabdels@gmail.com>
Date: Mon, 24 Aug 2020 08:51:24 +0000

> This patch allows copying the DSCP from inner IPv4 header to the
> outer IPv6 header, when doing SRv6 Encapsulation.
> 
> This allows forwarding packet across the SRv6 fabric based on their
> original traffic class.
> 
> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>

"Allows" sounds like the behavior is optional, but that is not what
is happening here.  You are making this DSCP inheritance behavior
unconditional.

I've stated that the current behavior matches what other ipv6
tunneling devices do, and therefore we should keep it that way.

Furthermore, this behavior has been in place for several releases
so you cannot change it by default.  People may be depending upon
how things work right now.

Also:

> @@ -130,6 +129,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
>  	struct ipv6_sr_hdr *isrh;
>  	int hdrlen, tot_len, err;
>  	__be32 flowlabel;
> +	u8 tos = 0, hop_limit;

Need to preserve reverse christmas tree here.
