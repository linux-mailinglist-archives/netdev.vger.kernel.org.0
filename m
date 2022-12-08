Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1247D646852
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 05:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLHErR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 23:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHErQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 23:47:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4F259;
        Wed,  7 Dec 2022 20:47:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64946B82035;
        Thu,  8 Dec 2022 04:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82677C433C1;
        Thu,  8 Dec 2022 04:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670474833;
        bh=pPEVBly9bfwd8dphaKuIkNzoSFzBZukDoXkitwRnVEE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5Rb44oVO9LtVec07iBkQLxBQ2ZAEuPj/95jjmfqdn2yPGHCpUxeIIRlwX9tRt8sd
         o3tiZ+RtOVe2I9Lnt5aWsapT5pR6YeoJr9KeMRzqNryDf+HTPs592QXcGguATUUHV4
         2vQhLweqtzolFWoZ/BUAv23F6gHoPw8Zyc80JP420P9FXiWw9EpqAqUIDXC8yQ2z2I
         zz6s7/d9FwXcdATyGJKb3dUkJGDzJoNbv7SGCe9ptII8fN9ojA4ClB076pafzfMP1g
         DJfboz7hDEEhS1R1Qa7Zk/WyYxQ8YPN6EGtzFQgC2A4cC6xdrTWaZDSMBs1CYi/KF4
         04pJyCUj/frgA==
Date:   Wed, 7 Dec 2022 20:47:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Message-ID: <20221207204711.6599d8ba@kernel.org>
In-Reply-To: <BYAPR18MB24231B717F9FF380623E74F4CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>
        <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>
        <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal>
        <20221206092352.7a86a744@kernel.org>
        <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
        <20221206172652.34ed158a@kernel.org>
        <BYAPR18MB24234AE72EF29F506E0B7480CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
        <20221207200204.6819575a@kernel.org>
        <BYAPR18MB24231B717F9FF380623E74F4CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
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

On Thu, 8 Dec 2022 04:41:56 +0000 Veerasenareddy Burru wrote:
> > On Thu, 8 Dec 2022 03:17:33 +0000 Veerasenareddy Burru wrote:  
> > > We have a follow up patch after this series implementing
> > > ndo_get_vf_xxx() and ndo_set_vf_xxx().  
> > 
> > We don't accept new drivers which use those interfaces.  
> 
> Kindly suggest the acceptable interface.

Kindly make the minimal effort to follow the list :/

Perhaps others have the time to explain things to you, 
I believe my time is best spent elsewhere.
