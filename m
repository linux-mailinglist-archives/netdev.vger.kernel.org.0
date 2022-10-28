Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A109961088D
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 05:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiJ1DIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 23:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiJ1DIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 23:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0785A48A07;
        Thu, 27 Oct 2022 20:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9961D625E1;
        Fri, 28 Oct 2022 03:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8AC433B5;
        Fri, 28 Oct 2022 03:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666926531;
        bh=v5tBBIl0hmiCA93khbzSNtrdC8qEit67keKoDj0Edg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqHiL3VnNUexaeI52NkXwLNtt7iGSjqm1Zbj5qD+h/MW7bnsM8MLIIxs83dHsamW0
         ZZoLf45oZlgV1w8rTP2J6m6KRD8RKa/sYMf4Do88dqqCshj/o4d+MFAymAwDGAGQ6C
         +KhBQ5zO/+asxetMNfJPOFiqgLdH5H2U8Z4rF3TOfg5/4Rca1swdHEm3E8bnjQ99oi
         aTfFA5DIkgDujHzYUanrGW0sPMh+NdtLWJmlvmDzKDYF4EBixmCzPR0rQfuFjIizxX
         im3MStN5aktQOd6/gDfNhRr2QOySereQAgMBs/or0eXC14sxFuFGJHHvf9tvnC++eI
         HTo5hB3TVMykg==
Date:   Thu, 27 Oct 2022 20:08:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, michael.chan@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v2] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221027200849.34e26e3e@kernel.org>
In-Reply-To: <880ede37-773e-c2bd-8a69-6e3d202983d9@gmail.com>
References: <20221028012719.2702267-1-kuba@kernel.org>
        <880ede37-773e-c2bd-8a69-6e3d202983d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 19:50:35 -0700 Florian Fainelli wrote:
> > @@ -723,6 +724,8 @@ struct phy_device {
> >   
> >   	int pma_extable;
> >   
> > +	unsigned int link_down_events;  
> 
> Should not this be an u64 to match what the extended link state can 
> report? Not that I would hope that anyone had a chance to witness 4 
> billion link down events using PHYLIB.

How about I also make the uAPI side 32 bit? I made it 64b because
that feels like the default these days but as you say, re-training
a link 4 billion times is unlikely to happen in one person's lifetime :S
