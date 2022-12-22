Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9612653A5A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiLVBkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLVBks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:40:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6FE1175;
        Wed, 21 Dec 2022 17:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3497B81BE6;
        Thu, 22 Dec 2022 01:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C92AC433D2;
        Thu, 22 Dec 2022 01:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671673244;
        bh=5hnA9BOPvRCsr9HRqNX8XNegYPB26+FLi9Rn2nGpnu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IT6jl8cqpjRGnzQEgdfuC1lW2fi3DyceeTn/hkCvrPqc+ukKQREJM4a53K++ZiOp4
         PFaOlXJ9RIuyOnAxfUIUx5R0J4O0nWy8T8v1HajJLwMx5+4s7EfTgECyb7rNHE2ZBY
         c0WpvbBBNMZJfTUjc6yLo5pRogzaeyiAXlqJbY1404kJAP1ch5rXxFqiSPjInfW6UQ
         XvPxLkIIrQz+a00VqaYW0tnS4ycvFRmlnVUAMspYu0x/VUx186w6cyjmy+Fu1hOxQ6
         q/RkGWObwvza4i7ghZxfdHJN1YewXvGWaV8efRbKHFeLAQhBNDtMRvG5uTeyK0NXZV
         z6wWox25Z2rjw==
Date:   Wed, 21 Dec 2022 17:40:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] fjes: Fix an error handling path in fjes_probe()
Message-ID: <20221221174043.1191996a@kernel.org>
In-Reply-To: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
References: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
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

On Tue, 20 Dec 2022 21:57:06 +0100 Christophe JAILLET wrote:
> A netif_napi_add() call is hidden in fjes_sw_init(). It should be undone
> by a corresponding netif_napi_del() call in the error handling path of the
> probe, as already done inthe remove function.

Ah, now I see why Michal asked about netif_napi_del() in the other
driver :S  free_netdev() cleans up NAPIs.
