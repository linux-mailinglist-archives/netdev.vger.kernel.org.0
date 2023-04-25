Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319896EDB3D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 07:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjDYFi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 01:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjDYFi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 01:38:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8ED65BC;
        Mon, 24 Apr 2023 22:38:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74EAB629E2;
        Tue, 25 Apr 2023 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8914C4339B;
        Tue, 25 Apr 2023 05:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682401103;
        bh=zZrxb/D1CPT+xTOAWqqm/3GaNY8wRigq9u3LlHSEFus=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YL1YrjrYizvPaVyhFsS6x3GG6uxQ7xUC4bJdTZ3BAEI3mVSBpa4lCg45rF8EqYnIl
         Fq5fe8c0q7tGuxbuVj0jd25FjjDFNaflP4CeGDzG60FOmbw3sIFYx3+ULtePkADUwJ
         0kKKD978gg2v2ZG6vKrmMxW9+n6uRLHI96RGcgjypUYlQAyqssLXc1JWuiWKFKtsCN
         qsy2MSla/yGKhvINqIRII2F7hvj9FpI3DTWnA5dcNS5k36W0uCMihCOBbEwo2+Ipht
         /9VjfQBZJ+bfcJVa0jV1EuvXVaAdly1RDFnhV/vXqQ/oPN4LTOgtaUAU05jKOM1HG8
         1v5Czuxgj7ebg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: wireless-next-2023-04-21
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421075404.63c04bca@kernel.org>
        <e31dae6daa6640859d12bf4c4fc41599@realtek.com>
Date:   Tue, 25 Apr 2023 08:38:17 +0300
In-Reply-To: <e31dae6daa6640859d12bf4c4fc41599@realtek.com> (Ping-Ke Shih's
        message of "Tue, 25 Apr 2023 02:41:46 +0000")
Message-ID: <87leigr06u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Friday, April 21, 2023 10:54 PM
>> To: Kalle Valo <kvalo@kernel.org>
>> Cc: netdev@vger.kernel.org; linux-wireless@vger.kernel.org
>> Subject: Re: pull-request: wireless-next-2023-04-21
>> 
>> On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
>> >  .../net/wireless/realtek/rtw89/rtw8851b_table.c    | 14824 +++++++++++++++++++
>> >  .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    21 +
>> 
>> We should load these like FW, see the proposal outlined in
>> https://lore.kernel.org/all/20221116222339.54052a83@kernel.org/
>> for example. Would that not work?
>> 
>
> That would work, and I think struct fields addr and val should be __le32.
> And, I have some draft ideas to handle some situations we will face:
>
> 1. upgrading to newer driver without built-in tables will break user space
>    if people don't download table file from linux-firmware.git.
>    Maybe, we can keep the built-in tables and support loading from files
>    for couple years at least.
>
> 2. c code can do changes along with these tables, so driver should do some
>    compatibility things for register version. 
>
> 3. The file contains not only simple registers tables but also TX power tables
>    and power tracking tables. These tables are multiple dimensions, and
>    dimensions can be changed due to more channels are supported, for example.
>    To be backward compatible, we need to add conversion function from
>    v1, v2 ... to current.
>
> I will think further to make this change smooth. 

IIRC we discussed this back in initial rtw88 or rtw89 driver review (not
sure which one). At the time I pushed for the current solution to have
the initvals in static variables just to avoid any backwards
compatibility issues. I agree that the initvals in .c files are ugly but
is it worth all the extra effort and complexity to move them outside the
kernel? I'm starting to lean towards it's not worth all the extra work.

For me most important is that backwards compatibility is not broken,
that would be bad for the users. So whatever we decide let's keep that
in mind.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
