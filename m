Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700A767A7E5
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjAYAkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjAYAkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456C7402C2;
        Tue, 24 Jan 2023 16:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8BB661353;
        Wed, 25 Jan 2023 00:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89569C433D2;
        Wed, 25 Jan 2023 00:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674607209;
        bh=mpoHTRt9mADgI/jJ7QezjNdFWZAEE0W4GlOqZASqxPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IjDE8WIgMJbJA6tfLPOsM2Q6MQu7z1ZqDChctcBUmEtw3N76hkf4Uo3RSafWQXqej
         3PABpak80PaDdSlzzu9gfxrofSB6jxjESgpYyQU8K8O7mbb2ar6kwhsW2x50E4BCE8
         4+prMwtpEeyUv20+NLSj95gp+40Ydcesmt/AyayIrfY/yQfIU9VAGRGVEEWwLzy2nZ
         DDfuCkO76rSJ81Ney6iavoBjAwkxFEePmkVE8uKHba2iw+xps1zLPRFEnhVU4XVD8P
         WbgRxdQo05o+NnrI7Iu4Xu7MuKkm/ZO9nAyJPYr1VEdlYuR0yRiQLseTk6Iwb9LfHC
         c+/Krcxkuy7YA==
Date:   Tue, 24 Jan 2023 16:40:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v4 5/8] net: fou: regenerate the uAPI from the
 spec
Message-ID: <20230124164007.6e2e67c9@kernel.org>
In-Reply-To: <7d1730862ef79be47f85fc0afd334cda9c3700d5.camel@sipsolutions.net>
References: <20230120175041.342573-1-kuba@kernel.org>
        <20230120175041.342573-6-kuba@kernel.org>
        <a16382e3-b66f-0a57-2482-72afd00cdabe@intel.com>
        <7d1730862ef79be47f85fc0afd334cda9c3700d5.camel@sipsolutions.net>
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

On Tue, 24 Jan 2023 19:50:40 +0100 Johannes Berg wrote:
> On Tue, 2023-01-24 at 18:49 +0100, Alexander Lobakin wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Fri, 20 Jan 2023 09:50:38 -0800
> >   
> > > Regenerate the FOU uAPI header from the YAML spec.
> > > 
> > > The flags now come before attributes which use them,
> > > and the comments for type disappear (coders should look
> > > at the spec instead).  
> > 
> > Sorry I missed the whole history of this topic. Wanted to ask: if we can
> > generate these headers and even C files, why ship the generated with the
> > source code and not generate them during building? Or it's slow and/or
> > requires some software etc.?
> 
> Currently it requires python 3 (3.6+, I'd think?).
> 
> Python is currently not documented as a build requirement in
> Documentation/process/changes.rst afaict.

Yes, I wanted to avoid bundling in changes which could be controversial.
Whether code is generated during build or committed is something we can
revisit at any point.
