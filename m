Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B075A6CA0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiH3S4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiH3S4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3677541
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14A61B81D8A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 18:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46181C433D6;
        Tue, 30 Aug 2022 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661885791;
        bh=4848dtnEVL059zSIhDoR07cyDQkAoEjFn0GhbT7XNEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GsPLKiWVVwbuVIk9O7wAoy2x/uj/DcGlED2LXTKXvX0GIvtNsN4q0DgAXz7IP9H18
         +6giKkNyWPqd1KrNs8/JNyyQNLAcDTZ9PA57Ch2XLx8d4AA7FfXSIIdm2vHP4jx/ba
         fg1A7Qj4rPAjj5qFPHl+plUfPf774jeeIO7s16mlrJJrPudNpjMOYGZs7d8YY/zYK7
         UtUQFgywjks2bJUDv0DUbDk0qS37rItzZNeYnVQm1jOSfCVtE+wQcJQI6BI1IQVJ79
         fK80hmGp2p+oQG6D57xxgKZlmMHSZcdvXlanWrmHRU8vXfv7Lox4iOvQrpxBT+DNNl
         lW/bXW6QLFcyw==
Date:   Tue, 30 Aug 2022 11:56:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH xfrm-next v3 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220830115627.27099213@kernel.org>
In-Reply-To: <Yw5KtJ+vOoi+qSM6@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
        <20220825143610.4f13f730@kernel.org>
        <YwhnsWtzwC/wLq1i@unreal>
        <20220826164522.33bfe68c@kernel.org>
        <Yw5KtJ+vOoi+qSM6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 14:36:52 -0300 Jason Gunthorpe wrote:
> I was meaning rather generically handling the packets in the
> hypervisor side without involving the CPU. 
> 
> We have customers deploying many different models for this in their
> hypervisor, including a significant deployment using a model like the
> above. 
> 
> It achieves a kind of connectivity to a VM with 0 hypervisor CPU
> involvement with the vlan push/pop done in HW.

I don't see how that necessitates the full IPsec offload.

Sorry, perhaps I assumed we were on the same page too hastily.

I was referring to a model where the TC rules redirect to a IPsec
tunnel which is then routed to the uplink. All offloaded. Like
we do today for VxLAN encap/decap.

That necessitates full offload, and therefore can be used as a strong
argument for having a full offload in netdev.

> We other use-models, like the offloaded OVS switching model you are
> alluding to, that is Leon has as a followup.

