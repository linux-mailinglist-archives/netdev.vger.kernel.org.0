Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA61468E03E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjBGSmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBGSmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:42:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0A1F5DF;
        Tue,  7 Feb 2023 10:42:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 096EFB81A12;
        Tue,  7 Feb 2023 18:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25317C433D2;
        Tue,  7 Feb 2023 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675795325;
        bh=2RluZuq/q71FEFIXJsDWM5c094jhSykEigPJAtPWRyA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NffQX6V6c/VaeoCeQ/D0GgNtwLx00j22nOLI9l/GUV73nAtzyZ28FTcXE0fWkOO8F
         sopCynyeobSHLATiJvVxDLOIG3Ce1ukuzvJ73yCgdLkGlT844QaBAPceKV4NCazFsM
         GRz9YZiP/IOEVqEapLa09NgBmsqTNpJCOWGO1nmWpc3fEiDBDO/aWGxdJXXKaA7Dnp
         P1KwKx+ZxO9XI09+imlxVX0QfeVobdXVGHIr3FHfvkRuaGJUSXECbFukMIIORvD5SC
         rPqG+S2aqFu0cn0LhU+b9dU02JXx9nBPfSf78zQNakmqqZRrh997wUrRuTqCNqvPUL
         Qqk808XPvj4Og==
Date:   Tue, 7 Feb 2023 10:42:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jonas Suhr Christensen <jsc@umbraculum.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Message-ID: <20230207104204.200da48a@kernel.org>
In-Reply-To: <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
        <20230205201130.11303-2-jsc@umbraculum.org>
        <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
        <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
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

On Tue, 07 Feb 2023 12:36:11 +0100 Paolo Abeni wrote:
> You can either try change to phys type to __be32 (likely not suitable
> for -net and possibly can introduce even more warnings elsewhere)

FWIW that seems like the best option to me as well. Let's ignore the
sparse warning for v3 and try to switch phys to __be32 in a separate
patch for net-next. No point adding force casts just to have to remove
them a week later, given how prevalent the problem is.

> or explicitly cast the argument.
