Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8183E52AF1D
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiERAVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiERAVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E9F4ECEB
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 930A86141C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57B4C385B8;
        Wed, 18 May 2022 00:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652833303;
        bh=oEGgxzLYF6IckywGUwMoV9dF0/nlyFNFeZbGaSEKi8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CZf/ASIlxYr3BTahMxa1NWkYRuvoTyXiQOiCPDxSWQze3jdtKU6KqSYY+Mtf+YKLx
         ZMilNdhyuhHPjdbNiatkPqm+k0kbxSXPgoLyNTndmNHLaEekBCJM17VpUSlBoKhsdC
         /mZZm8wwaIchXnGQIV6yK6ibS4wx1VMTMBkzOICBlpso0J27bOZ0AqRXw97MRYk3Rw
         Drl+ErkxCXzhhFjhVJWmN9/hFf+TzCdcxOfO0WvFS9/nI0P71EAVQqg9GUhfrVX35J
         YUddk886mrXeJ7j4tbkV8iTP7Pt64WBkeodqrz+0hwNUlxSXCoDNxI9peMlCDelpWt
         iHbUVQsNPiIOg==
Date:   Tue, 17 May 2022 17:21:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCHv2 net] Documentation: add description for
 net.core.gro_normal_batch
Message-ID: <20220517172141.0eb57b8a@kernel.org>
In-Reply-To: <21572bb1e0cc55596965148b8fdf31120606480f.1652454155.git.lucien.xin@gmail.com>
References: <21572bb1e0cc55596965148b8fdf31120606480f.1652454155.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 11:02:35 -0400 Xin Long wrote:
> Describe it in admin-guide/sysctl/net.rst like other Network core options.
> Users need to know gro_normal_batch for performance tuning.
> 
> v1->v2:
>   - Improved the description according to the suggestion from Edward and
>     Jakub.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: Prijesh Patel <prpatel@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index f86b5e1623c6..5cb99403bf03 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -374,6 +374,17 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
>  If set to 1 (default), hash rethink is performed on listening socket.
>  If set to 0, hash rethink is not performed.
>  
> +gro_normal_batch
> +----------------
> +
> +Maximum number of the segments to batch up for GRO list-RX.

How about s/for GRO list-RX/on output of GRO/ ?

> When a packet exits
> +GRO, either as a coalesced superframe or as an original packet which GRO has
> +decided not to coalesce, it is placed on a per-NAPI list. This list is then
> +passed to the stack when the segments in this list count towards the
> +gro_normal_batch limit.

... when the number of segments reaches the gro_normal_batch limit.

> +
> +Default : 8

Also, should we drop the default? It's easy to grep for, chances are if
anyone updates the value they will forget to change the doc.

Sorry for the late review, I wasn't expecting v3 will be needed.

>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>  

