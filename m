Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F004761405D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 23:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJaWFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 18:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJaWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 18:05:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF74140F3;
        Mon, 31 Oct 2022 15:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68688614CA;
        Mon, 31 Oct 2022 22:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC51C433D6;
        Mon, 31 Oct 2022 22:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667253913;
        bh=58kz24nXAawlkva955235al4uA9icMf97bcrURLhte4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzHixuNz+xw2XaP/jzWJoUoo3TwlxstHUYZHyUq9hY2re8MaNENcMNawEwK6vxd9z
         NBItrKi8KEjcr/2UrSEHX5Syl8xdB/ZBUnrknCBZNmI81wr3XKRrVyeD30GDU0dybj
         PP8bnIlVXaY5TFYg963Qqj+Q4kYxV/1GFj2zXcSvYwXRYkudJD/5cWExXzH0nil3F/
         wx0mGbply5dRBU0UQvcOAsgmGQVXENSl7vb5CHtJjntwxlMf5rRucCiPhsUC2WcTJv
         zc79cVVrmAbqVEu7k2yeuoV4XGcrjzna7ezmhmE428o6GVC2AgYLnmQtNGL94tyPCr
         HrLc69XvABH2w==
Date:   Mon, 31 Oct 2022 16:04:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, Rasesh Mody <rmody@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 5/6] bna: Avoid clashing function prototypes
Message-ID: <Y2A4eQ67IihENQrb@work>
References: <cover.1666894751.git.gustavoars@kernel.org>
 <2812afc0de278b97413a142d39d939a08ac74025.1666894751.git.gustavoars@kernel.org>
 <202210290009.C42E731@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202210290009.C42E731@keescook>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 29, 2022 at 12:12:26AM -0700, Kees Cook wrote:
> On Thu, Oct 27, 2022 at 03:20:47PM -0500, Gustavo A. R. Silva wrote:
> > When built with Control Flow Integrity, function prototypes between
> > caller and function declaration must match. These mismatches are visible
> > at compile time with the new -Wcast-function-type-strict in Clang[1].
> > 
> > Fix a total of 227 warnings like these:
> > 
> > drivers/net/ethernet/brocade/bna/bna_enet.c:519:3: warning: cast from 'void (*)(struct bna_ethport *, enum bna_ethport_event)' to 'bfa_fsm_t' (aka 'void (*)(void *, int)') converts to incompatible function type [-Wcast-function-type-strict]
> >                 bfa_fsm_set_state(ethport, bna_ethport_sm_down);
> >                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > The bna state machine code heavily overloads its state machine functions,
> > so these have been separated into their own sets of structs, enums,
> > typedefs, and helper functions. There are almost zero binary code changes,
> > all seem to be related to header file line numbers changing, or the
> > addition of the new stats helper.
> 
> This looks like it borrowed from
> https://lore.kernel.org/linux-hardening/20220929230334.2109344-1-keescook@chromium.org/
> Nice to get a couple hundred more fixed. :)


Yep; you're right. That's exactly the patch I was staring at
while doing these changes. :)

> 
> > [1] https://reviews.llvm.org/D134831
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> > Changes in v2:
> >  - None. This patch is new in the series.
> 
> This is relatively stand-alone (not an iw_handler patch), so it could
> also go separately too.

My criteria here was that all these patches avoid clashing function
prototypes. So, they could be put together into a series, regardless
if they are "iw_handler" related patches.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!
--
Gustavo
