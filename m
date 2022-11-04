Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA1C619CD4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKDQP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiKDQPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B6527B14
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 09:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5348862258
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 16:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5E0C433C1;
        Fri,  4 Nov 2022 16:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667578543;
        bh=BF32zu5BdgRFY+X0dBO2QhNpBFNsBdgVPgyhKwwmT+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tTKcQMnnylNeCkbF7pp3o+oJkHqBjZZWvjhQmUKrZ3CJ4LizMLb3m7o/6eyYSFZfX
         Xe0RqSgLzgypBeA1yPhHZLNp2uYykd1Yb02on18crya3Z385VCimT04mhegRDjnyM8
         hS8R2OVKxp9EGdR5+6IhfSJfYImUK04jeGBlLIIUfx1HfUiW79hqvdfqNWt2hwxRoC
         5CQ0ycDtnD7VajRsdZzohfC00I2JsxokJMcLoIA3IZFfpYMkK8dCP8cAqU7ConDXNO
         Dw3lQONJ3riUOA7Gu5juOvHE9UoJ76576cgjtexvWdLbmDBJuxO0TVBF555mKBS0Le
         cthfLz9nzn3Rg==
Date:   Fri, 4 Nov 2022 09:15:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     Shai Malin <smalin@nvidia.com>,
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
Message-ID: <20221104091541.1f014b7d@kernel.org>
In-Reply-To: <253eduiu946.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221028084001.447a7c05@kernel.org>
        <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221031164744.43f8e83f@kernel.org>
        <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
        <253k04ct08y.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
        <20221103185713.5d2ec13b@kernel.org>
        <253eduiu946.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Nov 2022 15:44:57 +0200 Aurelien Aptel wrote:
> >>    # query ULP stats of $dev
> >>    ethtool -u|--ulp-get --include-statistics <dev>  
> >
> > -I|--include-statistics ?  
> 
> Could you please elaborate what is the comment?

Since you were noting the short version for --ulp-gen I thought 
I'd mention that --include-statistics also has one and it's -I :)
