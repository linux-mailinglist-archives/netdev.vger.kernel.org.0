Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125B6611623
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJ1PkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ1PkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AC74D802
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 08:40:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB21E62909
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 15:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2994CC433D6;
        Fri, 28 Oct 2022 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666971603;
        bh=8U47bXZSo7ZN6OiQ3u1CAVeisNjC1lkAQ5nUDGbMgHQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vOGLXaWjVf8q4XM/QSQWOrJCgQMK2r2UZpR8ou7Bk13Tiw2bxK9ORkybsf7mNWRBv
         JwKbriSVgYKnGp4xxQKXLSeh8boi4OIkH3PZ08HHnWVQqNXvAcStNT6/gGMWd1M2aG
         msAluQTGfuHfgXE58JAI36pQvwDaTBeHq1kVhBw3ADyPYIRNSrB5Rql+C9iNzIh1RY
         k82fAxRZ1l8SOW2A2wiY9Npna+VhlRFXZaU2tf4l2+d7b6WEg7FLp17++2FOwFLjXK
         JvEsWWP7JXVXKNtrW4uSBYS8sep00gRNT/a+XvWLvxyxViH4BW+LtRWC/TrIr0nOmc
         J7XUsNHae+GNA==
Date:   Fri, 28 Oct 2022 08:40:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@nvidia.com>
Cc:     Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Message-ID: <20221028084001.447a7c05@kernel.org>
In-Reply-To: <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
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

On Fri, 28 Oct 2022 10:32:22 +0000 Shai Malin wrote:
> > It's a big enough feature to add a genetlink or at least a ethtool
> > command to control. If you add more L5 protos presumably you'll want
> > to control disable / enable separately for them. Also it'd be cleaner
> > to expose the full capabilities and report stats via a dedicated API.
> > Feature bits are not a good fix for complex control-pathy features.  
> 
> With our existing design, we are supporting a bundle of DDP + CRC offload.
> We don't see the value of letting the user control it individually.

I was talking about the L5 parsing you do. I presume it won't be a huge
challenge for you to implement support for framing different than NVMe,
and perhaps even NVMe may have new revisions or things you don't
support? At which point we're gonna have a bit for each protocol? :S
Then there are stats.

We should have a more expressive API here from the get go. TLS offload
is clearly lacking in this area.

> The capabilities bits were added in order to allow future devices which 
> supported only one of the capabilities to plug into the infrastructure 
> or to allow additional capabilities/protocols.
> 
> We could expose the caps via ethtool as regular netdev features, it would 
> make everything simpler and cleaner, but the problem is that features have 
> run out of bits (all 64 are taken, and we understand the challenge with 
> changing that).

Feature bits should be exclusively for information which needs to be
accessed on the fast path, on per packet basis. If you have such a need
then I'm not really opposed to you allocating bits as well, but primary
feature discovery *for the user* should not be over the feature bits.

> We could add a new ethtool command, but on the kernel side it would be 
> quite redundant as we would essentially re-implement feature flag processing 
> (comparing string of features names and enabling bits).
> 
> What do you think?
