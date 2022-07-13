Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAFE572A27
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiGMACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiGMACK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:02:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BCEC9204
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 17:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04A3B61685
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076AFC341C0;
        Wed, 13 Jul 2022 00:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657670529;
        bh=FUT3nqpkWzlAOzUQBxCV3tHhgc1pwI0ghcFnEG2MxA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULHt+PV7UIplPsTf4Z3vHp2MxiG3tXs1TIc3ZrQ8MZMQum+3R+jYStmSOmEK0sHN1
         s6xih366iGbX54J14W/f+DSgNVuSjW8ob0Hk+do0dMQMKs6x0SRzRxYL3PprHRvEaj
         yZItgeTclR7g0QvU8U2Yfvvj8yTJErKtfy81nNlwmZTO7OArJ4KvC1fmpKtbRODfPw
         x1/SGOqMVZOPdhzkWwa7nJC0hq0/Atj/05fmTPESSOH8Ag2KSIv/ecki5MrT0DLXhA
         r5SICn+aBLylaKZPkfYNBglrl+QfKqvqnw6K3J8eZe0MJjDL1DFvjKNxk8kDdA+ybJ
         AeeGRbLQt/hJg==
Date:   Tue, 12 Jul 2022 17:01:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lior Nahmanson <liorna@nvidia.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Message-ID: <20220712170159.6da38d1b@kernel.org>
In-Reply-To: <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
        <20220614091438.3d0665d9@kernel.org>
        <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
        <20220621122641.3cba3d38@kernel.org>
        <PH0PR12MB54490D24F44759ACDABC950FBF869@PH0PR12MB5449.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 06:50:52 +0000 Lior Nahmanson wrote:
> i considered the usage of skb_metadata_dst, however i still think
> that skb_ext will fit more to MACsec offload implementation for the following reasons:
> 1. for Rx, each skb can have a different SCI and offloaded values which mandate allocation
>     of metadata_dst for each skb which contradicts the desired usage for skb_metadata_dst where
>     it's allocated once and a refcnt held whenever used.

How many distinct SCIs do you expect to see?

> 2. skb_ext method is used in a similar IPsec offload implementation which in the future could make it easier
>     to refactor this section to unify all crypto offloads skb_ext usage.

MACSec is L2, IPsec has constraints we have to work around.
