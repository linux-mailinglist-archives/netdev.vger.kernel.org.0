Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986E06308DA
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiKSBxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiKSBw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:52:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2578C622A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83FF9B825D8
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCE2C433D7;
        Sat, 19 Nov 2022 01:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668821789;
        bh=zVWnxBXPG0silGy/2bUDb2Kl4rwIBN5cfMJbtnSCDSE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qK1dre2UNgV2JMIgq50Ufy/X6ufIje7xlbbZ5+Z41FILN1eTbbVU653YYARcodn4b
         WeRavdEq46hSJNYC2aNqofv6j4v++YF8KtETYZiTgtlRuViOFjeYEdO9OhwcXykFCL
         RHGmegY8WP/IqpxAv2H8bl1JaezcKfkxJSgofA8d+lak+B17gUGH1igTj+ToZ9qUgH
         nihHJQYBPaKF4Xsu/7e24pwwfMN6oGmqQkHgppWakr9lzDeQR09M+9oElKiIO99XWa
         Bj9ElRM3TxCL3mwj+QPJnA8TWzdHXtaYQWrwn92haKCqp+Zq4CP77XUelmVote8dNC
         aoPE3CnLrSJ+A==
Date:   Fri, 18 Nov 2022 17:36:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
Message-ID: <20221118173628.2a9d6e7b@kernel.org>
In-Reply-To: <20221117220803.2773887-3-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
        <20221117220803.2773887-3-jacob.e.keller@intel.com>
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

On Thu, 17 Nov 2022 14:07:57 -0800 Jacob Keller wrote:
> The calculation for the data_size in the devlink_nl_read_snapshot_fill
> function uses an if statement that is better expressed using the min_t
> macro.
> 
> Noticed-by: Jakub Kicinski <kuba@kernel.org>

I'm afraid that's not a real tag. You can just drop it, 
I get sufficient credits.

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 96afc7013959..932476956d7e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6410,14 +6410,10 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>  	*new_offset = start_offset;
>  
>  	while (curr_offset < end_offset) {
> -		u32 data_size;
> +		u32 data_size = min_t(u32, end_offset - curr_offset,
> +				      DEVLINK_REGION_READ_CHUNK_SIZE);

nit: don't put multi-line statements on the declaration line if it's 
not the only variable.

>  		u8 *data;
>  
> -		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
> -			data_size = end_offset - curr_offset;
> -		else
> -			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
