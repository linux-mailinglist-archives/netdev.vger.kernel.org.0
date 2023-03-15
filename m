Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E93196BBE7A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbjCOVFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjCOVFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0344B7EDC
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:04:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684BB61E6E
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 21:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E43C433EF;
        Wed, 15 Mar 2023 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678914295;
        bh=dhgooa0mjWz79DZ5nXYf3vePnlvdRaHA3cJ3TPCd6/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L6+yEYrTbz8Rj5UUgjRLrtmkSA//vLAXTs5ZEgoI4EtAD5eeQ6etAYTTRJWPJ8bBp
         0mPzJLMW0jm3RR7XYvwzpocWBuL8uUkiHlkNt08eeq2pbJc1OsZlG+hidX00BhAcza
         YBJH+AjE+dySupA4sW3yjJeQnZq0kH/IlXTg6S5av2jloWfjjhiec2WDNkX4bQ9rWN
         XF52m+5soehPANel7+TAWXvZlJTQxd3rV8h9QOeRWPj4GnNmz3NJ+OyyxkuN/NNhny
         ONvHsoju0l9ME2DGR34eikHsidJ5RJ5cNFmanYnPlJAW5TDS1NabmdY2tNflwUzPjl
         NvEtw+uvVCiHg==
Date:   Wed, 15 Mar 2023 14:04:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Piotr Raczynski <piotr.raczynski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in
 MANAGE_PAGES
Message-ID: <20230315140454.4329d99e@kernel.org>
In-Reply-To: <ZBIv4oGgtWbTGkaS@x130>
References: <20230314174940.62221-1-saeed@kernel.org>
        <20230314174940.62221-4-saeed@kernel.org>
        <ZBHD2J8I1WGf9gnB@nimitz>
        <ZBIv4oGgtWbTGkaS@x130>
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

On Wed, 15 Mar 2023 13:51:46 -0700 Saeed Mahameed wrote:
> >> +static u32 get_ec_function(u32 function)
> >> +{
> >> +	return function >> 16;
> >> +}
> >> +
> >> +static u32 get_func_id(u32 function)
> >> +{
> >> +	return function & 0xffff;
> >> +}
> >> +  
> >Some code in this file is mlx5 'namespaced', some is not. It may be a
> >little easier to follow the code knowing explicitly whether it is driver
> >vs core code, just something to consider.
> 
> For static local file functions we prefer to avoid mlx5 perfix.

FWIW the lack of consistent namespacing does make mlx5 code harder 
for me to read, so it's definitely something to reconsider long term.
