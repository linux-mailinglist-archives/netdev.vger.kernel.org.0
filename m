Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D416F15F0
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 12:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345699AbjD1Kn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 06:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbjD1KnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 06:43:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB092706;
        Fri, 28 Apr 2023 03:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 373DB60C0D;
        Fri, 28 Apr 2023 10:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99344C433D2;
        Fri, 28 Apr 2023 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682678599;
        bh=cr4spr+W66ImQd/SIrHqDWMlzeS4k1hTXtCqSr7iwq4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pQ0n3z9HiSrlu//prMDjjr0LEr/n6Rd6ox4qzO2h2D82IqV1bm27D4lqc90sN3rcK
         sLzSg9ZhcPmBePPlEbMnmgri1fX3tLlahglqBimvJhDkXXy0iZHgb4h6+wvOMcxdDC
         5WtDDo2CShXyWCCOksggWKENeXdAoW/F+wdBAbzb9DayPIIzffzsrba0mMYb3XB1X/
         /YfazB9vuv+tq2WGf3rjRNQdKslzPoQER3Ifgvach0/uN/XEhhC6KdN8pXSDyFfEzb
         mYREaOdM99EucnGEMhI2SlxyPBMkku0ByUrTnJ358yyJBDiA2kwk+PRgOlunEZmxwv
         jNBtpZeujTk0w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-04-21
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421075404.63c04bca@kernel.org>
        <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
        <87leigr06u.fsf@kernel.org> <20230425071848.6156c0a0@kernel.org>
Date:   Fri, 28 Apr 2023 13:43:16 +0300
In-Reply-To: <20230425071848.6156c0a0@kernel.org> (Jakub Kicinski's message of
        "Tue, 25 Apr 2023 07:18:48 -0700")
Message-ID: <87cz3os2wr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 25 Apr 2023 08:38:17 +0300 Kalle Valo wrote:
>> IIRC we discussed this back in initial rtw88 or rtw89 driver review (not
>> sure which one). At the time I pushed for the current solution to have
>> the initvals in static variables just to avoid any backwards
>> compatibility issues. I agree that the initvals in .c files are ugly but
>> is it worth all the extra effort and complexity to move them outside the
>> kernel? I'm starting to lean towards it's not worth all the extra work.
>
> I don't think it's that much extra work, the driver requires FW
> according to modinfo, anyway, so /lib/firmware is already required.
> And on smaller systems with few hundred MB of RAM it'd be nice to not
> hold all the stuff in kernel memory, I'd think.

Later in this thread Ping explained pretty well the challenges here,
that sums exactly what I'm worried about.

> We have a rule against putting FW as a static table in the driver
> source, right? Or did we abandon that? Isn't this fundamentally similar?

My understanding is that these are just initialisation values for
hardware, not executable code. (Ping, please correct me if I
misunderstood.) So that's why I thought these are ok to have in kernel.
So I took practicality over elegance here.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
