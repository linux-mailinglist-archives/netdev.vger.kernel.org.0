Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3B4FCBD4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbiDLBVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbiDLBVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:21:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA9D18B3A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 18:19:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36D42B819BE
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1E4C385A4;
        Tue, 12 Apr 2022 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649726363;
        bh=0E41K8KQre0jx0Uq8MpvZpNL+R3yrQ2rsyjekmAe3KA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1e4PwKK1uBZGqN5HEerKCvDuJs7yZOiE0RMQWBqbrZ3f/0F0O2cMZNLM3KRQ6SIv
         YQa900Ak9RbFNhqRlbgUojJo0KP+N6kTjDpWzbpVYgla0smO732uTjGeTS0kF6sRlp
         ejvXbLUOkBgKZmTsI1eFW37oMPQoouBkogKDfyE8aWBcxnwrsgQT5PVy9hNxIEjug4
         L35q91gX8JEYOIehimssHqTMLWjDiez32Kh+4temnJsbHf05vOHbLdCrYp1ch3hrK3
         A6iKTP9mqO/9jX0GjIVtaxBj7mNJ0qRa547T6/5gbaqz/XXjhQMP+HsLmvQiEVJF8d
         GasTua/3t24Pw==
Date:   Mon, 11 Apr 2022 18:19:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tomas Melin <tomas.melin@vaisala.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        pabeni@redhat.com
Subject: Re: [PATCH v2] net: macb: Restart tx only if queue pointer is
 lagging
Message-ID: <20220411181921.245ba3e6@kernel.org>
In-Reply-To: <20220407161659.14532-1-tomas.melin@vaisala.com>
References: <20220407161659.14532-1-tomas.melin@vaisala.com>
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

On Thu,  7 Apr 2022 19:16:59 +0300 Tomas Melin wrote:
> commit 4298388574da ("net: macb: restart tx after tx used bit read")
> added support for restarting transmission. Restarting tx does not work
> in case controller asserts TXUBR interrupt and TQBP is already at the end
> of the tx queue. In that situation, restarting tx will immediately cause
> assertion of another TXUBR interrupt. The driver will end up in an infinite
> interrupt loop which it cannot break out of.
> 
> For cases where TQBP is at the end of the tx queue, instead
> only clear TX_USED interrupt. As more data gets pushed to the queue,
> transmission will resume.
> 
> This issue was observed on a Xilinx Zynq-7000 based board.
> During stress test of the network interface,
> driver would get stuck on interrupt loop within seconds or minutes
> causing CPU to stall.
> 
> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>

Applied, thanks. Commit 5ad7f18cd82c ("net: macb: Restart tx only if
queue pointer is lagging") in net.
