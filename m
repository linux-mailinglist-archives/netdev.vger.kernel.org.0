Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB456BC1AC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjCOXpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCOXpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:45:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E41EC6E;
        Wed, 15 Mar 2023 16:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21718B81E91;
        Wed, 15 Mar 2023 23:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319D9C433EF;
        Wed, 15 Mar 2023 23:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678923541;
        bh=5GAPeyBfP2Zdf5EnCdjZvhZIA4Fi7REUqed3wUYdGag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lAfGv8Zo9dEdKwK8GO98w31I1bipnQB1+sElvJonBBQomHPZOxKdpff+v27nTVD4Z
         OKlDr5zrABM14vU+izk3Or4NIhGdg9yson/3x0qvQkTGAqlwjCg8do790xbpg8mTwV
         vBOnKruGGlnZx4TEvD6ZyUGTOvM3VBIaNgsqOKoV2AW45wM9vh6br3TFkiJKazU8ET
         tiEVQ4pdIVavG2OOY7YxGVzhY6/G/7O9J3kIBdMlML3RkMncRo3LRVrxW/y1jnoJnJ
         aH2NUH3/XngjCV0BukNaKqexNFLjnenY+2XsCjTLnKK5AjLJlUudqduqsJhylZVHXg
         nEilCQgqTYCdA==
Date:   Wed, 15 Mar 2023 16:39:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <20230315163900.381dd25e@kernel.org>
In-Reply-To: <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
References: <cover.1678364612.git.lorenzo@kernel.org>
        <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Mar 2023 13:25:31 +0100 Lorenzo Bianconi wrote:
> Take into account LRO and GRO configuration setting device xdp_features
> flag. Consider channel rq_wq_type enabling rx scatter-gatter support in
> xdp_features flag and disable NETDEV_XDP_ACT_NDO_XMIT_SG since it is not
> supported yet by the driver.
> Moreover always enable NETDEV_XDP_ACT_NDO_XMIT as the ndo_xdp_xmit
> callback does not require to load a dummy xdp program on the NIC.
> 
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Co-developed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

This one hits ASSERT_RTNL(), I think. Don't we need something like:

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 87e654b7d06c..5722a1fc6e9e 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -781,6 +781,9 @@ void xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
                return;
 
        dev->xdp_features = val;
+
+       if (dev->reg_state < NETREG_REGISTERED)
+               return;
        call_netdevice_notifiers(NETDEV_XDP_FEAT_CHANGE, dev);
 }
 EXPORT_SYMBOL_GPL(xdp_set_features_flag);

? The notifiers are not needed until the device is actually live.
