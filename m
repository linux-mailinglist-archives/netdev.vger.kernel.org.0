Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF16141F0
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 00:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJaXrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 19:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJaXrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 19:47:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B48D1580D
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 16:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C8AB81AEE
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 23:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94EEC433D6;
        Mon, 31 Oct 2022 23:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667260066;
        bh=qnDt9U2L7puTMDfhxdpVU/1hPBJH7OaofOu3M2B5r1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dH91RAuwMxU88lyzPd5znNLLoIuufWmfhrf9gSPT2vJmtiO7lLW0Vr/IC7nKN94cN
         xGAEs4KXEM50Xj4IIfc48OxJvP1O0GUwGJpb8ud9wZXXUNBqq4yizvisMHj8nXUe1T
         nBZzYGd4E0mB4dAJlTNFC3ctVhocW4JTetWfi/OUoq85gU6bDhsoGH2z0HnPOS6P5c
         rwmVfeUGeL9dI7nwmtmooZbNlEP+wx3KppQXY1F7PT9IdxyE9lDVbSbiRHdwJ1bTtA
         CO4I7Nm5gLQyFRWYoNtmxiaauME4jt5aYh/T0XFNfNT32x8TQ7SZhRj49XhO4Foe4y
         pOXXSzEuy/V4Q==
Date:   Mon, 31 Oct 2022 16:47:44 -0700
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
Message-ID: <20221031164744.43f8e83f@kernel.org>
In-Reply-To: <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221028084001.447a7c05@kernel.org>
        <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
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

On Mon, 31 Oct 2022 18:13:19 +0000 Shai Malin wrote:
> > Then there are stats.  
> 
> In the patch "net/mlx5e: NVMEoTCP, statistics" we introduced 
> rx_nvmeotcp_* stats.
> We believe it should be collected by the device driver and not 
> by the ULP layer.

I'm not sure I agree, but that's not the key point.
The key point is that we want the stats to come via a protocol specific
interface, and not have to be fished out of the ethtool -S goop. You
can still collect them in the driver, if we have any ULP-level stats at
any point we can add them to the same interface.
