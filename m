Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD595621D7
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiF3SNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiF3SNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:13:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895CD37AB1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 11:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A355B82CA6
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 18:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77310C34115;
        Thu, 30 Jun 2022 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656612808;
        bh=AVSGvBlyUIoiPttnRLaWTrOt3eoblOMLSyOeq+0TLRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CZLML79AWTbH7z+sxyNCBqLNmBMwFYHg+z2tPsalTGfmQ7jIttvCOMaS+0MGIA0v3
         OUcP9C7JBJu++OH9saH3KpNYJtciU2ktZBmF2gtU7jD7M8LYydEFTGELe29BsDfDfF
         YcDsPVlFtHJiEGAZmlYPMMAXtQ5Vs8ex8jkNmDtdlCZvcqGNLvp84MA+m5z+vzsoLn
         jIm/ZPggKi0IMVHgngDEXIPtxht9tRHgy9QJMTLbzqbzYjz1h3jmG1PZwcSb3Qiq1U
         beR9qi6FVsswNrZSL/6fUixL2alFeX3OHQbbFF8jFlzwXlyrVQLjiE9bcGNTu0rzb2
         g4fcrd8R+Yr7w==
Date:   Thu, 30 Jun 2022 11:13:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220630111327.3a951e3b@kernel.org>
In-Reply-To: <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
        <20220620130426.00818cbf@kernel.org>
        <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 17:27:08 +0200 Dima Chumak wrote:
> I've re-read more carefully the cover letter of the original 'devlink:
> rate objects API' series by Dmytro Linkin, off of which I based my
> patches, though my understanding still might be incomplete/incorrect
> here.
> 
> It seems that TC, being ingress only, doesn't cover the full spectrum of
> rate-limiting that's possible to achieve with devlink. TC works only
> with representors and doesn't allow to configure "the other side of the
> wire", where devlink port function seems to be a better match as it
> connects directly to a VF.

Right, but you are adding Rx and Tx now, IIUC, so you're venturing into
the same "side of the wire" where tc lives.

> Also, for the existing devlink-rate mechanism of VF grouping, it would be
> challenging to achieve similar functionality with TC flows, as groups don't
> have a net device instance where flows can be attached.

You can share actions in TC. The hierarchical aspects may be more
limited, not sure.

> I want to apologize in case my proposed changes have come across as
> being bluntly ignoring some of the pre-established agreements and
> understandings of TC / devlink responsibility separation, it wasn't
> intentional.

Apologies, TBH I thought you're the same person I was arguing with last
time.

My objective is to avoid having multiple user space interfaces which 
drivers have to (a) support and (b) reconcile. We already have the VF 
rate limits in ip link, and in TC (which I believe is used by OvS
offload). 

I presume you have a mlx5 implementation ready, so how do you reconcile
those 3 APIs?
