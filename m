Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0294F68E794
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 06:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBHFew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 00:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBHFen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 00:34:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE8143464
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 21:34:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B104614B0
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 05:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6162C433D2;
        Wed,  8 Feb 2023 05:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675834475;
        bh=zvi4MSnxEhuHocbKuDGqiJXp/y2prmYNJNzlGR4xljk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFOLMrRwOBtt80PhpdnHNvAff1+Rr/UHjLtgt9ni2vFDh1Vt/qyzJDMjvATkf5q6h
         WrKCbyEcw/28y9ykukBUWBUhTcQ9G1NW8y1Zd1ANY+zAIxfKeS0Q/1nzRuow+genAJ
         bmcm9Tx54cY6eSUeR7r/u+Fvt/86lQz6DdhIa5ZzyttQstLumoo0tqA/0FzCRBtByC
         jEMTIKH8Ezp7ckcqWGQtiUVXGFQDkzDOZ7mwEHmkqNCaBtAN0nCS3uwBIEBbnWytpt
         ZBOgHT5Shczao0E+ajMnacsojFVscgLVIEGbOcAy/zPYOg6//kltd69eBuWBOBB5nm
         WmuLlKNScDJLg==
Date:   Tue, 7 Feb 2023 21:34:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Subject: Re: [PATCH net 1/1] tipc: fix kernel warning when sending SYN
 message
Message-ID: <20230207213433.6d679340@kernel.org>
In-Reply-To: <20230207012046.8683-1-tung.q.nguyen@dektech.com.au>
References: <20230207012046.8683-1-tung.q.nguyen@dektech.com.au>
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

On Tue,  7 Feb 2023 01:20:46 +0000 Tung Nguyen wrote:
> When sending a SYN message, this kernel stack trace is observed:
> 
> ...
> [   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
> ...
> [   13.398494] Call Trace:
> [   13.398630]  <TASK>
> [   13.398630]  ? __alloc_skb+0xed/0x1a0
> [   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
> [   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
> [   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
> [   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __local_bh_enable_ip+0x37/0x80
> [   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __sys_connect+0x9f/0xd0
> [   13.398630]  __sys_connect+0x9f/0xd0
> [   13.398630]  ? preempt_count_add+0x4d/0xa0
> [   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
> [   13.398630]  __x64_sys_connect+0x16/0x20
> [   13.398630]  do_syscall_64+0x42/0x90
> [   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
> to copy to/from iterator") has introduced sanity check for copying
> from/to iov iterator. Lacking of copy direction from the iterator
> viewpoint would lead to kernel stack trace like above.

How far does the bug itself date, tho?
Can we get a Fixes tag?

> This commit fixes this issue by initializing the iov iterator with
> the correct copy direction.
