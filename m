Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974BD67F4EA
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 06:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjA1F0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 00:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjA1F0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 00:26:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7F47BE4D;
        Fri, 27 Jan 2023 21:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76736B82200;
        Sat, 28 Jan 2023 05:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A9FC433EF;
        Sat, 28 Jan 2023 05:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674883608;
        bh=Zv9RYztzmfeeUXtmsnWulZnltlTkGNR6OGOCm8FP0jg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n+M/AtV17Yiuy8gEBnc+AbZE4OI6aigKaysU85tGqrvwFObicWiE/jusChPOJHB36
         jmWtdvagYJKUgMYmbxsTmzB50YvCHy9vsRQgACVUHzBi+7H0EG5yiTymtWHsqEfryd
         pApEc5ncBKs2mz85wBCqlBFYk8rpXipN5ZfCo8Lll/3TXpZg64lBC7iG3xE4vhojVN
         cQtV1ppNv0CKiFgrv2j25pN6te4x9WHheI6UVMn/zoON8gA2ETwYX5x632B1xoBG2p
         tm+fv8RqhhQ7+ECY1npFh5kHEUYr0bbqwXOpGvq5nMuIap6etPlDte3VtYnN5YVuVJ
         phX2/m+HwdPWg==
Date:   Fri, 27 Jan 2023 21:26:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>, <nbd@nbd.name>,
        <davem@davemloft.net>, <edumazet@google.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
        <lorenzo@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in
 GRO
Message-ID: <20230127212646.4cfeb475@kernel.org>
In-Reply-To: <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com>
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
        <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
        <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
> to 1 in gro_list_prepare() seems to be making more sense so that the above
> case has the same handling as skb_has_frag_list() handling?
> https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> 
> As it seems to avoid some unnecessary operation according to comment
> in tcp4_gro_receive():
> https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322

The frag_list case can be determined with just the input skb.
For pp_recycle we need to compare input skb's pp_recycle with
the pp_recycle of the skb already held by GRO.

I'll hold off with applying a bit longer tho, in case Eric
wants to chime in with an ack or opinion.
