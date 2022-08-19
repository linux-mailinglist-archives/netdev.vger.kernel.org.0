Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD715993EB
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbiHSEJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiHSEI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:08:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6305E642F3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 21:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF68D61505
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 04:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8A0C433C1;
        Fri, 19 Aug 2022 04:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660882137;
        bh=48+jwJZQDsl0qF1ylY2lVga2dbpPfHbz/Vu4IzWhfcY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l19zkZRlIdU6kvwXeFFN5TntV2SeLDx3JCKW75bGe0bWgil2HRBscW5cyoZ049UQY
         ImxmjL6wnvymrK6kY5WQh1n+WMg1f/yC/umT44Aiu1BZt769dJb+rKr6ibDFNNc+Z7
         F7Gaosv6Ar5WuAW2ezgeJY4SYgPFLzmliwDnhNb71vkXy0yeAczAPhurVyjFp76oAt
         xLmmolfNlQzVVpw8IG5XaKEwluaerq4Uf+6Ycy16R9vQip4zLnqi6fKq8lc3uoTvra
         VH7dK6chRHrPjqDWnGLZxBu8I3MtrQpjCLBXe08/qnOXL/J8UUh9y7xK0aiz0A6sjj
         R1awdcONoAoCA==
Date:   Thu, 18 Aug 2022 21:08:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lior Nahmanson <liorna@nvidia.com>
Cc:     <edumazet@google.com>, <pabeni@redhat.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH 1/3] net/macsec: Add MACsec skb_metadata_dst Tx Data
 path support
Message-ID: <20220818210856.30353616@kernel.org>
In-Reply-To: <20220818132411.578-2-liorna@nvidia.com>
References: <20220818132411.578-1-liorna@nvidia.com>
        <20220818132411.578-2-liorna@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 16:24:09 +0300 Lior Nahmanson wrote:
> In the current MACsec offload implementation, MACsec interfaces shares
> the same MAC address by default.
> Therefore, HW can't distinguish from which MACsec interface the traffic
> originated from.
> 
> MACsec stack will use skb_metadata_dst to store the SCI value, which is
> unique per MACsec interface, skb_metadat_dst will be used later by the
> offloading device driver to associate the SKB with the corresponding
> offloaded interface (SCI) to facilitate HW MACsec offload.

struct macsec_tx_sc has a kdoc so you need to document the new field (md_dst).

On a quick (sorry we're behind on patches this week) look I don't see
the driver integration - is it coming later? Or there's already somehow
a driver in the tree using this infra? Normally the infra should be in
the same patchset as the in-tree user.

Last thing - please CC some of the folks who worked on MACsec in the
past, so we can get expert reviews, Antoine and Sabrina come to mind,
look thru the git history please.
