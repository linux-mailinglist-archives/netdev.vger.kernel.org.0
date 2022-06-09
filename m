Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14B544215
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbiFIDp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiFIDpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:45:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984627F5CB
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 20:45:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51F36B81DBC
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99F8C34114;
        Thu,  9 Jun 2022 03:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654746320;
        bh=WcCr/u14xCGGhs0lJ7QJgwYnFgR43DBjbGzqHtw2tmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pfRco/7dL7GSRH6u50nWRtjgbZGVb0gQx1yvFvg2616xMOZobzHnXZVUoJmYzD3lw
         k89rjQYdbqBV/3zzImd3+9giYrW3a4B0j3d0h5vUA5pRYGFb8QSBaGuWxDbjLKlAxq
         Hk3xTQdCnavTIF9zwp8IJ1cBLqm9bdR/MapOli+6BbspJ75WlmaDVllMFkgg48C8S+
         WNibrOL/YLZj+/DXSn5Mjo7f63ANMLGtc/vtynCH4Tsyi/cakf58eGBlnmAHmbQonT
         XZfjfC/WLZ7RciBHF1e3AK1amZBHer4RSehqPgV9oFqWnJkn0TcbI1ASzDiXgc7chg
         c8lqfwMjiBekA==
Date:   Wed, 8 Jun 2022 20:45:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anton Makarov <antonmakarov11235@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        david.lebrun@uclouvain.be,
        Anton Makarov <anton.makarov11235@gmail.com>
Subject: Re: [net-next 1/1] net: seg6: Add support for SRv6 Headend Reduced
 Encapsulation
Message-ID: <20220608204518.4b23c3ca@kernel.org>
In-Reply-To: <20220608112646.9331-1-anton.makarov11235@gmail.com>
References: <20220608112646.9331-1-anton.makarov11235@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 14:26:46 +0300 Anton Makarov wrote:
> SRv6 Headend H.Encaps.Red and H.Encaps.L2.Red behaviors are implemented
> accordingly to RFC 8986. The H.Encaps.Red is an optimization of
> The H.Encaps behavior. The H.Encaps.L2.Red is an optimization of
> the H.Encaps.L2 behavior. Both new behaviors reduce the length of
> the SRH by excluding the first SID in the SRH of the pushed IPv6 header.
> The first SID is only placed in the Destination Address field
> of the pushed IPv6 header.
> 
> The push of the SRH is omitted when the SRv6 Policy only contains
> one segment.

missing byte swaps (install sparse and build with C=1 to catch it):

net/ipv6/seg6_iptunnel.c:237:56: warning: incorrect type in argument 1 (different base types)
net/ipv6/seg6_iptunnel.c:237:56:    expected restricted __be32 [usertype] flowinfo
net/ipv6/seg6_iptunnel.c:237:56:    got unsigned char [usertype] tos

Other random notes on things that jumped out:

> +	memset(skb->cb, 0, 48);

sizeof() is better

> +EXPORT_SYMBOL_GPL(seg6_do_srh_encap_red);

Why the export, this function should be static it seems, it's only used
in a since C source.
