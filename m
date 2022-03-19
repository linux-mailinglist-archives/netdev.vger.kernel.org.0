Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D424DE4D5
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiCSAX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiCSAX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8252310611D;
        Fri, 18 Mar 2022 17:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 120396170A;
        Sat, 19 Mar 2022 00:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E504C340E8;
        Sat, 19 Mar 2022 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647649348;
        bh=h91cBqgzNfgdm1S+DRILunx1ofNBbhjUuiyUdb5fkrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=byr3miQU8j2L353iv9IjKp4sdO2fkgscFhngc0+Ddm9Val5rB5CZk/S93dXaSb/eC
         TEPnpAjpSbih/4fMNBfVw02h2w+imikMADxsN+PqGfLBPdaeegCZ9oKrVFA6CFY/Rw
         uTvNvil2ltkDWY41Kz0tejqGA1Dx72QAvWRUQSnKORVguxo7w3Cd6rDY/92jjmix/g
         XBEFT6rrZ2LEXPkP77KsW/zt3bkJZmshP7eY/DJx0onaUZM5GdxDj4GKbV6q31FUQ7
         zUZSKidpa/+bz1PZQX8fe37rG110UNUEm6jw1Pr+I3Qfua5AFJMOpQfm67MFlj/Iof
         4eNgaAUbPkBcg==
Date:   Fri, 18 Mar 2022 17:22:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
Message-ID: <20220318172221.68ecb86a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <082a7743-2eb8-c067-e41d-2a3acca5c056@gmail.com>
References: <20220310045358.224350-1-jeremy.linton@arm.com>
        <f831a4c6-58c9-20bd-94e8-e221369609e8@gmail.com>
        <de28c0ec-56a7-bfff-0c41-72aeef097ee3@arm.com>
        <2167202d-327c-f87d-bded-702b39ae49e1@gmail.com>
        <CALeDE9MerhZWwJrkg+2OEaQ=_9C6PHYv7kQ_XEQ6Kp7aV2R31A@mail.gmail.com>
        <472540d2-3a61-beca-70df-d5f152e1cfd1@gmail.com>
        <20220318122017.24341eb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <082a7743-2eb8-c067-e41d-2a3acca5c056@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 14:26:36 -0700 Florian Fainelli wrote:
> Maybe I should have refrained from making that comment after all :)
> Having the Fixes: tag dramatically helps with getting this patch applied
> all the way to the relevant stable trees and surely correctness over
> speed should prevail. If we want to restore the performance loss (with
> the onus on Doug and I to prove that there is a performance drop), then
> we could send a fix with the appropriate localized barrier followed by a
> revert of Jeremy's patch. And if we cared about getting those two
> patches applied to stable, we would tag them with the appropriate Fixes tag.
> 
> It looks like there are a few 'net' changes that showed up, are you
> going to send a pull request to Linus before 5.17 final is cut?

Not unless there's -rc9. We'll just merge net into net-next before
submitting net-next, most likely.
