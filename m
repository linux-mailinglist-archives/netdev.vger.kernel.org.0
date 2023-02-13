Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4F69528F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 22:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjBMVBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 16:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBMVBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 16:01:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB7E211E5
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 13:01:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9484B612EE
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 21:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B10C433D2;
        Mon, 13 Feb 2023 21:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676322089;
        bh=5phipRbrCKJ18T7CPbB8yXjpyzkLTf5lWtkWiCxqUwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VuG9qs9NOB5Ouix+OU7UYcXOF98x+ibf+kSSQOQE3KtCQ/nEJ1jPz8pPwWld4deIh
         ufZj83KmkFJD6zdCHcJ+YUuYoz6ldQKHdjKKE4UPrwhl4DMemGY+ChDn4WvKkovkeO
         8R59afG7DT7mnFchWNJzjb6BdXnUCe8LJSQyLUaYNuwWBHtzcD29QtuqvltyiJHlTr
         5+nlnrYiPC5+spey7B2MaRzTLBnicuO1oR9lp6ar1eDo6swUYVekh1eBAuT+KNdur2
         1ZXCgoys+/wiO81rOU+XVHEFcZ0303nSSgtF+afoF82R/L/Rp+pH83zH8G0IRL7hIP
         40iRiUjyO7M+Q==
Date:   Mon, 13 Feb 2023 13:01:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: Re: [PATCH net] mlxsw: spectrum: Fix incorrect parsing depth after
 reload
Message-ID: <20230213130127.1746b50e@kernel.org>
In-Reply-To: <Y+fAmU5RuHrY28Vy@shredder>
References: <6abc3c92f72af737cb3bba18e610adaa897ced21.1675942338.git.petrm@nvidia.com>
        <20230210193350.239f707f@kernel.org>
        <Y+fAmU5RuHrY28Vy@shredder>
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

On Sat, 11 Feb 2023 18:21:45 +0200 Ido Schimmel wrote:
> > Sounds quite odd TBH, something doesn't get de-registered during _down()
> > but is registered again during _up()?  
> 
> It's not really de-registered / registered. The FIB multipath hash
> policy isn't changed when devlink reload is issued, so the driver
> doesn't bother decrementing the parsing depth reference count. The diff
> below does decrement the reference count on reload_down(). Tested it
> without the current fix and it seems to work. If you prefer, I can send
> a v2 with this diff squashed into the current fix.

That does seem cleaner to me, less error prone in case some actual clean
up is missed later. So if you don't mind - yes, I'd prefer the patch
from your reply, thanks!
