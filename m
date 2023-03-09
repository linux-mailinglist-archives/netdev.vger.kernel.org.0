Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2D6B2C64
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCIRyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCIRyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:54:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9A1F31FF
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 09:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD727B8203A
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 17:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D4AC433EF;
        Thu,  9 Mar 2023 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678384478;
        bh=9SsUoTbTu3imuUjz6gmMEc31IJWSMDIU3TZ3CzBJS1U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=glAxP1FfqD8ZJU54jzRx00evkpPlygs0JzchDqPJsCYI7eAVXhnJ1KYxHO/lKm+hv
         AAtVHMrH4qZ0+ZxnwJkc2GUdGc+HLfXZTIEPM7RQmGv6rYZLcMQ3kP4ebojCDLWsnt
         N0sc6YuCzgw6RfSso0c+bE0ozVvwoAPelrjIMuer5KYWnILbbCDXo+yqILg1e/jv5J
         bPOqZz/WJom7iSl7MQqUgkyemhlfWpKJi9owiRX6r39d7fsGdodjFr/9pgCwtiFhXV
         omSF4hkjCczamwT/EIQXWTx13lK5oGOJQd82Esu9WoVuX1TeJGFHwYYWuB29FQJOqG
         C6nm2FqrzFXvQ==
Date:   Thu, 9 Mar 2023 09:54:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        maximmi@nvidia.com, tariqt@nvidia.com, vfedorenko@novek.ru,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Message-ID: <20230309095436.17b01898@kernel.org>
In-Reply-To: <3c9eaf1b-b9eb-ed06-076a-de9a36d0993f@gmail.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
        <20220722235033.2594446-8-kuba@kernel.org>
        <3c9eaf1b-b9eb-ed06-076a-de9a36d0993f@gmail.com>
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

On Thu, 9 Mar 2023 17:15:26 +0200 Tariq Toukan wrote:
> A few fixes were introduced for this patch, but it seems to still cause 
> issues.
> 
> I'm running simple client/server test with wrk and nginx and TLS RX 
> device offload on.
> It fails with TlsDecryptError on the client side for the large file 
> (256000b), while succeeding for the small one (10000b). See repro 
> details below.
> 
> I narrowed the issue down to this offending patch, by applying a few 
> reverts (had to solve trivial conflicts):

What's the sequence of records in terms of being offloaded vs fall back?
Could you whip up a simple ring buffer to see if previous records were
offloaded and what the skb geometries where?
