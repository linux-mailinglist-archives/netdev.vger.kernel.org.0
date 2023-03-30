Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEC6CF9FB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjC3EIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC3EID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:08:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423314EEA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED4BEB82338
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BF6C433D2;
        Thu, 30 Mar 2023 04:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680149280;
        bh=Chnva3TDpfXtFTuM31fD3VabzdJxL+deMXecCo+u+Co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LeNH6Gz8UDUHl5rKvoXyIJ9Y55SW1Qu7qVOJ3aQXz4xZlOkutKI5hHqa1AqiQZJ6F
         bkFIB1lmS+KYT/Dz1lvieLIRNd0oyl+vw87SFiUATUKk9YWURoe53HV7Y04x5OVSeq
         xGjI58Vsv7mrIE07/VrH0UE9KaWaBvCq5q5ESlid2tm13Rg5BGCve1p1W18NbHw5X7
         ZRV0ujsw2Ab0xhkJM9WzIhwHQ2Rp3vtBMMtFxqhPdIQBv04OI/mRIykshrRHe/MMG4
         NXRH3VwA6V80wZC4fGABi8TKAIWTDFrcSI3Fi7BXVQ8cHieyDeCDKlTy3w4EMoiLUb
         7uyKTi+U18tUQ==
Date:   Wed, 29 Mar 2023 21:07:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
Message-ID: <20230329210759.1a8f9df4@kernel.org>
In-Reply-To: <ZCUDFyNQoulZRsRQ@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com>
        <ZCQSf6Sc8A8E9ERN@localhost>
        <ZCUDFyNQoulZRsRQ@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 11:33:43 +0800 Hangbin Liu wrote:
> On Wed, Mar 29, 2023 at 12:27:11PM +0200, Miroslav Lichvar wrote:
> > On Wed, Mar 29, 2023 at 11:13:37AM +0800, Hangbin Liu wrote:  
> > > At present, bonding attempts to obtain the timestamp (ts) information of
> > > the active slave. However, this feature is only available for mode 1, 5,
> > > and 6. For other modes, bonding doesn't even provide support for software
> > > timestamping. To address this issue, let's call ethtool_op_get_ts_info
> > > when there is no primary active slave. This will enable the use of software
> > > timestamping for the bonding interface.  
> > 
> > Would it make sense to check if all devices in the bond support
> > SOF_TIMESTAMPING_TX_SOFTWARE before returning it for the bond?
> > Applications might expect that a SW TX timestamp will be always
> > provided if the capability is reported.  
> 
> In my understanding this is a software feature, no need for hardware support.
> In __sock_tx_timestamp() it will set skb tx_flags when we have
> SOF_TIMESTAMPING_TX_SOFTWARE flag. Do I understand wrong?

Driver needs to call skb_tx_timestamp(), so unlike with Rx there's
something to do for the driver.
