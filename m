Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F4452ECDB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348198AbiETNHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 09:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345583AbiETNHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 09:07:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A79344F9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=96gYhciAwSTISVzOHfGm7wUgU01BeIHTbYfzGqx5M38=; b=LqEUK1CIy9974RGPP+HD2qvz6p
        lcUfO9xQ2lS19eN7B+9X664q9TyV0ioYPmYKCJjzcrXDE3vJwPqp6KOrr9qAz7IO2NfzvmPZDT/XQ
        DzIwkmOjN98tTwLdTTHEIjTC1fETxhxohLcuZ656oT+2Unzub+3hJO3Fg1v9O3ScCopg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns2LE-003czG-FD; Fri, 20 May 2022 15:06:52 +0200
Date:   Fri, 20 May 2022 15:06:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, keescook@chromium.org, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
Subject: Re: [PATCH net-next] eth: mtk_eth_soc: silence the GCC 12
 array-bounds warning
Message-ID: <YoeSbH0d3qlAtwo6@lunn.ch>
References: <20220520055940.2309280-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520055940.2309280-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:59:40PM -0700, Jakub Kicinski wrote:
> GCC 12 gets upset because in mtk_foe_entry_commit_subflow()
> this driver allocates a partial structure. The writes are
> within bounds.

I'm wondering if the partial structure is worth it:

struct mtk_flow_entry {
        union {
                struct hlist_node list;
                struct {
                        struct rhash_head l2_node;
                        struct hlist_head l2_flows;
                };
        };
        u8 type;
        s8 wed_index;
        u16 hash;
        union {
                struct mtk_foe_entry data;
                struct {
                        struct mtk_flow_entry *base_flow;
                        struct hlist_node list;
                        struct {} end;
                } l2_data;
        };
        struct rhash_head node;
        unsigned long cookie;
};


It allocates upto l2_data.end

struct rhash contains a single pointer

So this is saving 8 or 16 bytes depending on architecture.

I estimate the structure as a whole is at least 100 bytes on 32bit
systems.

I suppose it might make sense if this makes the allocation go from 129
bytes to <= 128, and the allocater is rounding up to the nearest power
of 2?

	Andrew
