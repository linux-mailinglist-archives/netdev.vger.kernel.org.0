Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA40866A3A3
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjAMTsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjAMTsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40DB6C070
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 11:48:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75CD4B821D5
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8712FC433D2;
        Fri, 13 Jan 2023 19:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673639282;
        bh=QYqIFbc52IbaZq1UrDHtYcXdbXzk/rI2lvgGtqgYK70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZJr4IzI2zICR2hjLlujP8pgNM/jvc14C/ByqbliE1JYR/XfGCr8YcJB675mHzHSG
         JCvTTzdK/LtxISzS9ByFbGrtTYTE6h4+bR22W+Qe2KBRua1U1QCpjLen/NHBu8IGhC
         TUqfcebF0RCTOs0AkdW/FBaOrltO11KbYhc0tV+vmM+w2gOOMuuplrtdIeU7mZHUz3
         AnQ/8u2HNCaoXfH/VCQdcP+ThQBdNnCM9nmK6XJoHK8v4yTKCGxrpeDyhfDr6VVdd1
         ZfniDsSLGCEH3RqsGzrjoeOaXSrqF8mrL9caZ70AuxidvIoIwvG24OaWKho6Tb5ufD
         bo9qlVWdeqItw==
Date:   Fri, 13 Jan 2023 11:48:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool
 and rmnet
Message-ID: <20230113114800.357a96e2@kernel.org>
In-Reply-To: <CAKgT0Ueb7AA3NrwxFX7VjS_h1j-kOdXUGYchTjwCh9ah1kpbZA@mail.gmail.com>
References: <20230111130520.483222-1-dnlplm@gmail.com>
        <b8f798f7b29a257741ba172d43456c3a79454e9c.camel@gmail.com>
        <CAGRyCJGFhNfbHs=qhdOg9DYOq_tLOska2r2B08WTBbnFyXXjhw@mail.gmail.com>
        <CAKgT0Ueb7AA3NrwxFX7VjS_h1j-kOdXUGYchTjwCh9ah1kpbZA@mail.gmail.com>
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

On Fri, 13 Jan 2023 08:16:48 -0800 Alexander Duyck wrote:
> > ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES works also as a way to determine
> > that tx aggregation has been enabled by the userspace tool managing
> > the qmi requests, otherwise no aggregation should be performed.  
> 
> Is there a specific reason why you wouldn't want to take advantage of
> aggregation that is already provided by the stack in the form of
> things such as GSO and the qdisc layer? I know most of the high speed
> NICs are always making use of xmit_more since things like GSO can take
> advantage of it to increase the throughput. Enabling BQL is a way of
> taking that one step further and enabling the non-GSO cases.

The patches had been applied last night by DaveM but FWIW I think
Alex's idea is quite interesting. Even without BQL I believe you'd 
get xmit_more set within a single GSO super-frame. TCP sends data
in chunks of 64kB, and you're only aggregating 32kB. If we could
get the same effect without any added latency and user configuration
that'd be great.
