Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9752F0E8
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351758AbiETQn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiETQnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:43:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E9F178547
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:43:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0082B82C86
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F9EC34100;
        Fri, 20 May 2022 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653065002;
        bh=RzSdRV9m5RGrsdExurT/RAHNhtHNdIS6a1xqzULdbr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPJdVJRHeJoAi/ZMe5lnDuEw78vxTNx+JaAPINc+TQ7HmsrT4X7L5i4tGe6qlnmYg
         9WMEOng25B9/FJWPczT2sB5gtXAplXuNrH7aq/sT5u+z1nbubVWnXMKjqdgMflvhsK
         xnXT//Y+e3dn6qhqW9ezrQhfhLX+FMbt7+ohvl9OWPKF0jPaZyHsNJFMITq4c6lhct
         q1eOXokDWuE2/ODC3zd/xHkxlxmEoM++lhA4BfOeWzPAhyQr55HFBmCSxC9Rp5GYHQ
         C19eF1oi+x01A10QfgPmJC8TSLuwCxlD8CmbuU1FO3mR8xMWCzH5eIv8xE03dsTbxh
         0I/eFKLX1lLaQ==
Date:   Fri, 20 May 2022 09:43:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
Subject: Re: [PATCH net-next] eth: mtk_eth_soc: silence the GCC 12
 array-bounds warning
Message-ID: <20220520094321.712b50a4@kernel.org>
In-Reply-To: <YoeSbH0d3qlAtwo6@lunn.ch>
References: <20220520055940.2309280-1-kuba@kernel.org>
        <YoeSbH0d3qlAtwo6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 15:06:52 +0200 Andrew Lunn wrote:
> On Thu, May 19, 2022 at 10:59:40PM -0700, Jakub Kicinski wrote:
> > GCC 12 gets upset because in mtk_foe_entry_commit_subflow()
> > this driver allocates a partial structure. The writes are
> > within bounds.  
> 
> I'm wondering if the partial structure is worth it:
> 
> struct mtk_flow_entry {
>         union {
>                 struct hlist_node list;
>                 struct {
>                         struct rhash_head l2_node;
>                         struct hlist_head l2_flows;
>                 };
>         };
>         u8 type;
>         s8 wed_index;
>         u16 hash;
>         union {
>                 struct mtk_foe_entry data;
>                 struct {
>                         struct mtk_flow_entry *base_flow;
>                         struct hlist_node list;
>                         struct {} end;
>                 } l2_data;
>         };
>         struct rhash_head node;
>         unsigned long cookie;
> };
> 
> 
> It allocates upto l2_data.end
> 
> struct rhash contains a single pointer
> 
> So this is saving 8 or 16 bytes depending on architecture.
> 
> I estimate the structure as a whole is at least 100 bytes on 32bit
> systems.
> 
> I suppose it might make sense if this makes the allocation go from 129
> bytes to <= 128, and the allocater is rounding up to the nearest power
> of 2?

Good point, I'm not sure what Felix prefers. I think isolating the
necessary fields into a different structure and encapsulating that
into something with the extra two members (or maybe the GROUP_MEMBER
macro thing?) would be another way forward.

I'd still like explicit feedback on the Makefile hack. Is it too ugly?
We could wait for GCC 12 to get its act together was well, but 
I'm guessing Dave and I are not the only people who will upgrade to
Fedora 36 and enter a world of pain...
