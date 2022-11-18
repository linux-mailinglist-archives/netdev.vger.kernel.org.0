Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA52762ED16
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 06:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiKRFNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 00:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRFNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 00:13:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078356CA1C
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 21:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99FB7B82267
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F168FC433D6;
        Fri, 18 Nov 2022 05:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668748397;
        bh=LNSwWzwj5FFwYd/Ox6V6jZkMQR/llg/CkMgMCLmTQiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o4ZHMMYN5zQmJz4h+b7rJMTiK2gVpwUf5uakZUSspUGaGz0wY5BnWVYo24Ws8YB1x
         DokRvX/6oM96GeuQuHPJofBRCJr93tJ9u093wyJZlms5hDcA2ZVn8BntJnQWfYhlye
         m3rHSyNBeLwC+UrVUHk1HNMfottT1pLYaNj+m7XT4mHUbP4DEJzHo8uWxNll0dm9C/
         npTRYMhCp3+EubCNCGtfEomDOcr/VKOjxF/oR5HtrAjZ1ct2BBMo4EWiixjvxMEkSp
         wOq3vDqwfxEz1yF+XGtqoxA4l2rNrDyzl7UeO9MZeksHyPDhyxbkXxQqDsuDJlbHtd
         FK+wAp9zVOg1g==
Date:   Thu, 17 Nov 2022 21:13:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yan Cangang <nalanzeyu@gmail.com>
Cc:     leon@kernel.org, Mark-MC.Lee@mediatek.com, john@phrozen.org,
        nbd@nbd.name, netdev@vger.kernel.org, sean.wang@mediatek.com
Subject: Re: [PATCH v2] net: ethernet: mtk_eth_soc: fix memory leak in error
 path
Message-ID: <20221117211315.1402a27c@kernel.org>
In-Reply-To: <20221116051407.1679342-1-nalanzeyu@gmail.com>
References: <Y3H1VgVOJB5kHbaa@unreal>
        <20221116051407.1679342-1-nalanzeyu@gmail.com>
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

On Wed, 16 Nov 2022 13:14:07 +0800 Yan Cangang wrote:
> In mtk_ppe_init(), when dmam_alloc_coherent() or devm_kzalloc() failed,
> the rhashtable ppe->l2_flows isn't destroyed. Fix it.
> 
> In mtk_probe(), when mtk_eth_offload_init() or register_netdev() failed,
> have the same problem. Also, call to mtk_mdio_cleanup() is missed in this
> case. Fix it.
> 
> Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
> Signed-off-by: Yan Cangang <nalanzeyu@gmail.com>

Please break this fix up into a series of two patches, first one fixing
the issue in ba37b7caf1ed and 502e84e2382d, and second one fixing the
issue in 33fc42de3327. Those are separate fixes, and should be
backported differently (the former is needed in LTS).

Please repost with the subject changed as Leon suggested and do not
repost in this thread, start a new thread.
