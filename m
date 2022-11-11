Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3A624F3A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiKKBLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiKKBLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:11:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053E945ED0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D11E61B72
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 01:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DCDC433C1;
        Fri, 11 Nov 2022 01:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668129062;
        bh=PAiMx2C6eH49FT4wJAJPIj1G9UWRdp+rDVPJtRaGziI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q9AIPmfZqDJTWvdyrIqSdO9UW0wuJBQKbIhBaOy0IiE/BXHbqQonmB6FGIeZV1fmu
         399Fw7xq0KUVZW20M3Y7x9NTWossleW5Qmey7D9tB31gbMX49KZq25KcHoHXRgZLG2
         PSkV/gq1zjgCZuQPjSz6s0Wz1Vc0TtpNsUA6ITzJ5ymXvOm6sVC42mM4KTvpoNfajR
         oNBn9I4ZoX2ajBafewPB6ZNwLYOoNfUbZJoxau26cDygZhWJ0u2z0yMHSLkWOQl8uV
         S12wm2mY5HaIlORDkZGJYIjwQUI52FEKIfK41slJS86EoCt9gSrV/bKSPltqEu9qm3
         dL+Xif+0CjW8A==
Date:   Thu, 10 Nov 2022 17:11:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Kupper <thomas.kupper@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/1] amd-xgbe: fix active cable determination
Message-ID: <20221110171101.6dce660c@kernel.org>
In-Reply-To: <aa6ad8c7-5df9-9569-2849-ee601b862645@gmail.com>
References: <8c3c6939-ec3d-012d-f686-ddcf5812c21b@gmail.com>
        <20221110135705.684af895@kernel.org>
        <fcf6ad3b-8dde-a926-1b6e-e2810040d7c8@gmail.com>
        <20221110143558.793dd6bf@kernel.org>
        <aa6ad8c7-5df9-9569-2849-ee601b862645@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Nov 2022 00:00:38 +0100 Thomas Kupper wrote:
> >> I apologise, after reading through all the guidelines I forgot that it
> >> was on top of the latest linux-kernel instead of net.
> >>
> >> Regarding the 'Fixes' tag: active cables don't works for at least since
> >> kernel v5.15, to what commit would you suggest do I refer to?  
> > Which exact sub-version of 5.15 ? Looking at the history of the file
> > commit 09c5f6bf11ac988743 seems like a candidate but you'd need to
> > double check based on what you know, or just revert and see if that
> > fixes your problem (to confirm that's the culprit).  
> 
> Checking with git blame shows that in commit abf0a1c2b26ad from 
> 2016-11-10 the whole if, else if ... clause plus a lot more was 
> introduced. And since then the handling of the active cables was 
> missing. The check (for the passive cable) got moved up in the commit 
> you mentioned.
> 
> I would then use 'Fixes: abf0a1c2b26ad ...', right?

Yup, sounds like it! Make sure you use the exact format from here
https://www.kernel.org/doc/html/v4.12/process/submitting-patches.html#describe-your-changes
don't wrap the line, and don't separate the tags with empty lines.
The Fixes tags are used by automated backport machinery so we need
exact format to be followed.

> And sent pretty much the same mail as the first time, with Tom and
> Raju CCed? And Patchwork will realise that?

You can throw in v2 into the subject tag to avoid any confusion:
[PATCH new v2] and that's it, yes :)
