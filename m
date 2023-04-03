Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939746D44F4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjDCMyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbjDCMyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:54:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B0518FA3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:54:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BE9EB819F3
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE693C433EF;
        Mon,  3 Apr 2023 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680526442;
        bh=lL6qcQQ0eNTcRsrznzZrkP/jtLfD4DFutqS6gKb2HDA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jK/h8mCRUcWe0ZgZtOl1jLj8IVN98W+2X8xbAa3vSHg6fWQBJYlx7pzFDL/xqM4kq
         NWiyObSVBd3mvKd0NcSGfzgcmxhs1yODfngGHwD+wNt2NbKPTGFASJqjlnWFP4HscF
         YtGeE53v7ZIxaOBP2H5jagtRE5EjqhsrbpqSRCra8WGP+uzO7C9U7BiNfhClTMlbQM
         KvTAMU/Z2czGAK8c1/H7lvSpXab7g35XR/4ZTGyFoEQylXODHQewKHrNl70QCWRo8u
         coceywnBm+eTjdTpITj57dpyBTHfkPWQUTK5f1ZTg12ZSbtXy7ZjFSwlCKcYEiekVA
         EGcTJOa7gc/xg==
Date:   Mon, 3 Apr 2023 15:53:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: fix ppe flow
 accounting for L2 flows
Message-ID: <20230403125358.GC176342@unreal>
References: <20230331082945.75075-1-nbd@nbd.name>
 <20230331082945.75075-2-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331082945.75075-2-nbd@nbd.name>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:29:44AM +0200, Felix Fietkau wrote:
> For L2 flows, the packet/byte counters should report the sum of the
> counters of their subflows, both current and expired.
> In order to make this work, change the way that accounting data is tracked.
> Reset counters when a flow enters bind. Once it expires (or enters unbind),
> store the last counter value in struct mtk_flow_entry.
> 
> Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 137 ++++++++++--------
>  drivers/net/ethernet/mediatek/mtk_ppe.h       |   8 +-
>  .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   2 +-
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |  17 +--
>  4 files changed, 88 insertions(+), 76 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
