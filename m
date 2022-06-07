Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15633540694
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiFGRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347526AbiFGRfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:35:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4AD11045F
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62A4F60BC6
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944EBC385A5;
        Tue,  7 Jun 2022 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654623029;
        bh=uGWqClOrwfAziPiUCxLZQ36qn9wzXoeytlSo/Tc+6Q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d2cQILm1QCPYMFm8Ys3VpuvSklErSjtmbFruT1R3Q8g0K/zbpD8cPVpWsRjiag699
         w+ADGxx00AUVyx22sMNw5s/74cgkJJY+QRxe1VUwf6HNFoB6bDDZiNZQGoJEIWKlnk
         7bXS8Tc/UaxGPtCa2loboE4a8Va3FiOAfpaGBMNbbIiTbpslM9Uryg14zYjsgJ4RSc
         YTjgcQfq9by+gEo/Ydr8r+8jpD1EDAjqQDi3dANjtzkwFHBGK6YW6M0AbnTY1TNmGs
         eqFALoFhKFPmefsEa+UpTnzlBhKwucmi0EM5eq92hL42SaVcdkcBpODRXs2F7g9G0L
         +LunJFz5TVBWQ==
Date:   Tue, 7 Jun 2022 10:30:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220607103028.15f70be6@kernel.org>
In-Reply-To: <21b34b86-d43b-e86a-57ec-0689a9931824@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
        <20220602094428.4464c58a@kernel.org>
        <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
        <20220603085140.26f29d80@kernel.org>
        <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
        <20220606105936.4162fe65@kernel.org>
        <21b34b86-d43b-e86a-57ec-0689a9931824@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 13:35:19 +0300 Maxim Mikityanskiy wrote:
> > That'd be an acceptable compromise. Hopefully sufficiently forewarned
> > users will mentally remove the zc_ part and still have a meaningful
> > amount of info about what the flag does.
> > 
> > Any reason why we wouldn't reuse the same knob for zc sendmsg()? If we
> > plan to reuse it we can s/sendfile/send/ to shorten the name, perhaps.  
> 
> We can even make it as short as zc_ro_tx in that case.

SG

> Regarding sendmsg, I can't anticipate what knob will be used. There is 
> MSG_ZEROCOPY which is also a candidate.

Right, that's what I'm wondering. MSG_ZEROCOPY already has some
restrictions on user not touching the data but technically a pure 
TCP connection will not be broken if the data is modified. I'd lean
towards requiring the user setting zc_ro_tx, but admittedly I don't
have a very strong reason.

> Note that the constant in the header file has "SENDFILE" in its name, so 
> if you want to reuse it for the future sendmsg zerocopy, we should think 
> about renaming it in advance, before anyone starts using it. 
> Alternatively, an alias for this constant can be added in the future.

Would be good to rename it to whatever we settle for on the iproute2
side. Are we going with zc_ro_tx, then?
