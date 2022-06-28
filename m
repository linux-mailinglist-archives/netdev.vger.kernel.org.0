Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A192055D4BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbiF1Eiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 00:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiF1Eiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 00:38:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6403B5;
        Mon, 27 Jun 2022 21:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7796B81C18;
        Tue, 28 Jun 2022 04:38:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB74AC3411D;
        Tue, 28 Jun 2022 04:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656391129;
        bh=nNr9e3DkyzRpISv/TUSNImIsSI6npMd6I/9ac777X9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HkMp0hFeKN0v3bPMd8NBLbiynojp2wKWd9q+pSiqiMuT84hlmUFA6VZLCKjrQtqos
         ZgM+MAnSPkjjWRvIUAEg/WGoRI6INZA5lfZ5tjLIrD5AQde9aOGffql8uFS9bbwY9M
         YGXPaPWC8ExStSkoJ8RGw4w0obKQ7lGpEtw9MTH7pm6YabLdUVhr4ZJWw0EGaC0AG3
         rGGe6IsQzw2Imdvc+7K+kruPQfKflk0IfagjgqnuQzfffF/9qrU2FRaqq9ppepA820
         5Q8Dvdz4QX7k/RrV7CmzPHT0avyAG9ZtKDkBH8Nkap4/rjZxAnnFPltoMcgMutr5BX
         rDt/xsYkYe0Xg==
Date:   Mon, 27 Jun 2022 21:38:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wentao_Liang <Wentao_Liang_g@163.com>,
        "David S . Miller" <davem@davemloft.net>, jdmason@kudzu.us,
        edumazet@google.com, pabeni@redhat.com, paskripkin@gmail.com,
        jgg@ziepe.ca, liuhangbin@gmail.com, arnd@arndb.de,
        christophe.jaillet@wanadoo.fr, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.18 24/53] drivers/net/ethernet/neterion/vxge:
 Fix a use-after-free bug in vxge-main.c
Message-ID: <20220627213847.60d09e43@kernel.org>
In-Reply-To: <20220628021839.594423-24-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
        <20220628021839.594423-24-sashal@kernel.org>
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

On Mon, 27 Jun 2022 22:18:10 -0400 Sasha Levin wrote:
> From: Wentao_Liang <Wentao_Liang_g@163.com>
> 
> [ Upstream commit 8fc74d18639a2402ca52b177e990428e26ea881f ]
> 
> The pointer vdev points to a memory region adjacent to a net_device
> structure ndev, which is a field of hldev. At line 4740, the invocation
> to vxge_device_unregister unregisters device hldev, and it also releases
> the memory region pointed by vdev->bar0. At line 4743, the freed memory
> region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
> use-after-free vulnerability. We can fix the bug by calling iounmap
> before vxge_device_unregister.

This is a dud see commit 877fe9d49b74 ("Revert
"drivers/net/ethernet/neterion/vxge: Fix a use-after-free bug in vxge-main.c"")

