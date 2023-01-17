Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9288B66E748
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjAQT4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjAQTyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311AE74973
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:48:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5606130C
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 18:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDD7C433D2;
        Tue, 17 Jan 2023 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673981332;
        bh=23MZApzNDTDFAty151R9reJt82K4UjNpjmNHeiL0IX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FdOXwiR4KcSUUH+E7bVORDg/KguL/G6+h+lCfW/duprI4Jgs58A6Mdo9UVfSZHtOf
         H/H4RgD3umkxn3TiSoGPBliTlk8KjRTLTYYoINb7eF2IYjoHwQLl6w+JyG7uSgHZBw
         1LnSK+kmUkseos1aImEnt+V0P8+VC6GNunqX9iMDTRr4MTEuV0ZRVGXiGup9eUJDqf
         qWWifJLff+uJnq5LrpjVfXmXF/g3CmMrLP1GFXr72Yj0T9L5rPs5oszB2KWsR/zJ85
         fyJA2XD+gPHUemw9p5lP28khwEnk//Bgj6iZy6Frr9FVC7xVKlQPpyns+xRton6qXg
         qb2xugy4yXpGQ==
Date:   Tue, 17 Jan 2023 10:48:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: Add hairpin debugfs files
Message-ID: <20230117104851.2c722c6e@kernel.org>
In-Reply-To: <ac5bf8cd-c30a-0c36-a6ca-a95a8ed0d152@nvidia.com>
References: <20230111053045.413133-1-saeed@kernel.org>
        <20230111053045.413133-9-saeed@kernel.org>
        <20230111103422.102265b3@kernel.org>
        <Y78gEBXP9BuMq09O@x130>
        <20230111130342.6cef77d7@kernel.org>
        <Y78/y0cBQ9rmk8ge@x130>
        <20230111194608.7f15b9a1@kernel.org>
        <f10e0fa9-4168-87e5-ddf7-e05318da6780@nvidia.com>
        <20230112142049.211d897b@kernel.org>
        <ac5bf8cd-c30a-0c36-a6ca-a95a8ed0d152@nvidia.com>
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

On Sun, 15 Jan 2023 12:04:58 +0200 Gal Pressman wrote:
> The hairpin queues are different than other queues in the driver as they
> are controlled by the device (refill, completion handling, etc.).
> Hardware configuration can make a difference in performance when working
> with hairpin, things that wouldn't necessarily affect regular queues the
> driver uses. The debugging process is also more difficult as the driver
> has little control/visibility over these.
> 
> At the end of the day, the debug process *is* going to be playing with
> the queue size/number, this allows us to potentially find a number that
> releases the bottleneck and see how it affects other stages in the pipe.
> Since these cases are unlikely to happen, and changing of these
> parameters can affect the device in other ways, we don't want people to
> just increase them when they encounter performance issues, especially
> not in production environments.
> 
> Does that make sense?

Okay, I think my guess that "debug" here means "wobble it to see if 
the device can go faster" was indeed correct. Long term maybe we should
find a better word for that than "debug".
