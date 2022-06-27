Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A8755D132
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiF0Sw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbiF0SwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:52:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F2EEB9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:52:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFB1EB81913
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E34C3411D;
        Mon, 27 Jun 2022 18:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656355938;
        bh=AV44bbXf/b0Nt1eSsAD25U/UVC9mbOGd1oIi06qClUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FS/SV5YBUEXQ9XoAu2/fE5uLjX/3INv55l0GEG4cWjdIdAkWKy5qGmMfjtWX74Vqy
         3kirl9yOb/Ngib+YtBpZREknTilDWtFSugC2TD3C42Lydz0jQcdpSq2PdHdJl3Pwnp
         Tfv7P8Gh85BN9c+lVhSpv/tiGEmOIT1Rip9qUApcjVXsY5njucLFdBAvJyOTA5bG21
         SzgR/liYs7JaZbkgk7tYD5wLZvvG0t9IL2fW+D9LEDaC7hCXeYSbyMlxifgRrwVGjP
         61gqMSKciQGG5uXkPInNIjwKcvY//NkEcvJm1hUsIrJbPiuGCExC7nKrkeTE6mXGIa
         hytLx0I+cBr7g==
Date:   Mon, 27 Jun 2022 11:52:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com
Subject: Re: [patch net-next 00/11] mlxsw: Implement dev info and dev flash
 for line cards
Message-ID: <20220627115209.35b699d9@kernel.org>
In-Reply-To: <ccd0e04c-5241-16da-929f-18059caee428@pensando.io>
References: <20220614123326.69745-1-jiri@resnulli.us>
        <Yqmiv2+C1AXa6BY3@shredder>
        <YqoZkqwBPoX5lGrR@nanopsycho>
        <fbaca11c-c706-b993-fa0d-ec7a1ba34203@pensando.io>
        <Yrltpz0wXW35xmgd@nanopsycho>
        <ccd0e04c-5241-16da-929f-18059caee428@pensando.io>
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

On Mon, 27 Jun 2022 11:38:50 -0700 Shannon Nelson wrote:
> >> Can you encode the base device's PCI info into the auxiliary device's id  
> > 
> > Would look odd to he PCI BDF in auxdev addsess, wouldn't it?  
> 
> Sure, it looks a little odd to see something like mycore.app.1281, but 
> it does afford the auxiliary driver, and any other observer, a way to 
> figure out which device it is representing.  This also works nicely when 
> trying to associate an auxiliary driver instance for a VF with the 
> matching VF PCI driver instance.

I'd personally not mind divorcing devlink from bus devices a little
more. On one hand we have cases like this where there's naturally no
bus device, on the other we have multi-link PCI devices which want to
straddle NUMA nodes but otherwise are just a logical unit.
