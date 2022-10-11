Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577145FA964
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 02:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiJKAiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 20:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJKAiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 20:38:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2D62CE38;
        Mon, 10 Oct 2022 17:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB2060FBD;
        Tue, 11 Oct 2022 00:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BEBC433D6;
        Tue, 11 Oct 2022 00:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665448691;
        bh=gD0XzObZGBNY1azWlAEYglnUqgYxis3tn+8qnCqXlo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C3LCPwT4gyMFLpeUzZJfNYNYO1tLkaYXOl91hoUa1ypCfSYRolvLJjusCaRrWOv44
         2+2dupQOXsUb3K3Iztbv5Q0lARCJyikifCE1OYsZxQrP1NiYr2lCRUgSKT1gF8auhV
         bMkHo/P5M5zNzk2k8m24S6wD6zpxjy92pz/MvpY0Jpj6dl31wFyRIucdp2WCpWK/OL
         YUNaduOoWDy/R1mvtvUicUmuuTQ+lFzYee4SaczxFldHcKIp+PDb1JU4oe2/Dlvuw5
         nRAJWq1EWG6A/ysLzPg/OD2a7IcPGtKeCWcdTTCf4y6zoQghELcFGgk2Mz3sMCJyjg
         NvSy7YFZJMAMQ==
Date:   Mon, 10 Oct 2022 17:38:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected
 length
Message-ID: <20221010173809.5f863ea6@kernel.org>
In-Reply-To: <Y0R+ZU6kdbeUER1c@lunn.ch>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
        <Y0R+ZU6kdbeUER1c@lunn.ch>
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

On Mon, 10 Oct 2022 22:19:49 +0200 Andrew Lunn wrote:
> On Wed, Oct 05, 2022 at 07:43:01PM +0300, Andy Shevchenko wrote:
> > The strlen() may go too far when estimating the length of
> > the given string. In some cases it may go over the boundary
> > and crash the system which is the case according to the commit
> > 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> > 
> > Rectify this by switching to strnlen() for the expected
> > maximum length of the string.  
> 
> This seems like something which should have a fixes: tag, and be
> against net, not net-next.

Quoting DaveM's revert mentioned in the commit message:

    First of all, the orion5x buffer is not NULL terminated.  mac_pton()
    has no business operating on non-NULL terminated buffers because
    only the caller can know that this is valid and in what manner it
    is ok to parse this NULL'less buffer.
    
    Second of all, orion5x operates on an __iomem pointer, which cannot
    be dereferenced using normal C pointer operations.  Accesses to
    such areas much be performed with the proper iomem accessors.

So AFAICT only null-terminated strings are expected here, this patch
does not fix any known issue. No need to put it in net (if it's needed
at all).
