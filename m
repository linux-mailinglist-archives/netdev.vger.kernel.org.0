Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5826C412D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjCVDke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCVDkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:40:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0DF5A6E1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B47A61E74
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51667C433D2;
        Wed, 22 Mar 2023 03:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679456429;
        bh=DzyeNgWWCFHsgsVItqqpMeSgJiE49lDy4u2PwzTIDss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IwF+5gxoAh/+JTAesyvg71+wkOaI6QNz8o2FJh6GHIhDDMGQBgdfJU38bK8vTFd0p
         It0ZAgcZ3UZraq70l4Dql4uTlzsm2wPah04ZaYzr4RKTWkSW6V8jJ/43wnT6QK3fJ9
         J5RPao5kxiMai8cH2/TB7mw2mgdYMNynlzSbvc/6QCmL7klpFuKHcddt+0SI5UT3sB
         2KcwqMr9VT5iG8OeSHlsVTttis2AhaENEh955i9AAJ/hO5pQxZSq4s9VvoCOofALg9
         Go32Pd4bcU+4i85UecgI/PrbDk13bqc2wZk1/H6ThLvoQut4x7gGkqAfQxQGDzxivx
         P1G/IznEeEXYg==
Date:   Tue, 21 Mar 2023 20:40:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: Re: [net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Message-ID: <20230321204028.20e5a27e@kernel.org>
In-Reply-To: <20230320175144.153187-3-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
        <20230320175144.153187-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 10:51:32 -0700 Saeed Mahameed wrote:
> +static int get_free_index(struct cpu_rmap *rmap)
> +{
> +	int i;
> +
> +	for (i = 0; i < rmap->size; i++)
> +		if (!rmap->obj[i])
> +			return i;
> +
> +	return -1;

-ENOSPC, why invent a special value ..

> @@ -295,7 +307,11 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>  	glue->notify.release = irq_cpu_rmap_release;
>  	glue->rmap = rmap;
>  	cpu_rmap_get(rmap);
> -	glue->index = cpu_rmap_add(rmap, glue);
> +	rc = cpu_rmap_add(rmap, glue);
> +	if (rc == -1)
> +		return -ENOSPC;

which you then have to convert into an errno ?

Also you leak glue here.
