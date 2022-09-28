Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB65EE46C
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 20:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiI1Sc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI1Sc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 14:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9257375FE3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 11:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAD861F78
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCF6C433C1;
        Wed, 28 Sep 2022 18:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664389974;
        bh=V8yXMC4PFrm7TduLRrwEgvYf5CG++MMP/ATFWfpqRbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvGZE0NbBzFsXhFeJoIzdnvvskxYzMONbCwZADtXLVMkL9M2oxcoMGq0jTLEBt9IA
         9N5xzF1q4DyLCUReWnOZ+uix15Z91iHByBP1INQAv0GuCgppjAbybQYJJYU3CvX8TW
         XBzwDgEBKtvSjdj+53F6fLAWSOYNnDmItlzvbuyyxv1/WEJ9l3Xj3wZdYX64vKsZFf
         y63Y7OnYQoBs1pVXTB/mAXG7u8v10hLhfnEOxf+T1Miec5pbLGbawAgFscpdZN6QVu
         7SPrBqU+4Vc7PeKYP9Au5tsNe4lbE2zje7dwIBfRmgjviPzd5Ynu5jRXrPMz209hT1
         1K3DYEHPbmyDA==
Date:   Wed, 28 Sep 2022 11:32:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 3/6] sfc: optional logging of TC offload
 errors
Message-ID: <20220928113253.1823c7e1@kernel.org>
In-Reply-To: <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
        <a1ff1d57bcd5a8229dd5f2147b09c4b2b896ecc9.1664218348.git.ecree.xilinx@gmail.com>
        <20220928104426.1edd2fa2@kernel.org>
        <b4359f7e-2625-1662-0a78-9dd65bfc8078@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 19:17:51 +0100 Edward Cree wrote:
> > Because extack does not work somehow?  
> 
> Last I checked, flow rules coming from an indirect binding to a tunnel
>  netdev did not report the hw driver's extack (or even rc) back to the
>  user.
> Also, extack can only contain fixed strings (netlink.h: "/* Currently
>  string formatting is not supported (due to the lack of an output
>  buffer.) */") which was a real problem for us.
> 
> > Somehow you limitations are harder to debug that everyone else's so you
> > need a private flag? :/  
> 
> It's not about debugging the driver, it's about communicating the
>  limitations to the end user.  Having TC rules mysteriously fail to be
>  offloaded with no indication of why is not a great UX :(

Yes, but everyone has the same problem.

> I couldn't see a way to handle this without vendor-specific ugliness,
>  but if you have a proposal I don't mind putting in some work to
>  implement it.

I won't help with the indirect stuff, I fixed it once a while
back already and it keeps getting broken. It must be a case of 
the extack not being plumbed thru, or people being conservative
because the errors are not fatal, right? Solvable.

The printf'ing? I recon something simple like adding a destructor 
for the message to the exack struct so you can allocate the message, 
or adding a small buffer in place (the messages aren't very long,
usually) come to mind.
