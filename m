Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E9E4CE27E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 04:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbiCEDmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 22:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiCEDmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 22:42:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEC0229C9D
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 19:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0464060500
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26752C004E1;
        Sat,  5 Mar 2022 03:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646451678;
        bh=vYFGMGsjp7fhRtTczjbxOo/YX41ZG9JCEzdMIUdA9Lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QdVMH2zbYXy+QpcKE3KpU3sstnLSLMt2yPvGNVTEXSmGXMg0ylyfo33NFlhDtPVSZ
         hGd61+aWho3mBvFsPYYzcodClYbqdodV7d2sIncFZaToa75FGySyPi6vaf30D2aynJ
         FwrXHdA5k4+DbxRCgF60if/UFh90t+yRvSX8GwJO7o6+UawG9oVg5QL7IHQVjTvBJO
         wY00G6Fjxl5J4AL6OVZ3u8BZIPAIpswzpRh7dn2FpIAU3vz6LzduJYZ9+FUj4/KvJe
         STbKebANoHr4PQq7HrGrnpcBHlmwQJiBZQ30LUnR0Qx2djzjMbifpIMhA5fkdH5k29
         4zehDgfJUFpCQ==
Date:   Fri, 4 Mar 2022 19:41:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        patches@lists.linux.dev,
        Dimitris Michailidis <dmichail@fungible.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next?] net: fungible: fix multiple build problems
Message-ID: <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
References: <20220304211524.10706-1-rdunlap@infradead.org>
        <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Mar 2022 16:39:49 -0800 Dimitris Michailidis wrote:
> > Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
> > usage of IS_ENABLED() very well -- it is causing compile errors.  
> 
> I believe this is the source of the errors you see but it's not the compiler's
> fault or something specific to 7.5.0. The errors are because when
> IS_ENABLED() is false some of the symbols in the "if" are undefined and the
> compiler checks them regardless.

The compiler will need at least a declaration, right? tls_driver_ctx()
is pretty stupidly hidden under an ifdef, for reasons which I cannot
recall. Maybe we can take it out? 

Same thing could work for fun_tls_tx():

        return skb;
 }
+#else
+struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
+                          unsigned int *tls_len);
 #endif
 
no?
