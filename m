Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E3A589EAD
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbiHDP3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiHDP3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A13B21245;
        Thu,  4 Aug 2022 08:29:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A48661376;
        Thu,  4 Aug 2022 15:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28F9C433D7;
        Thu,  4 Aug 2022 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659626956;
        bh=yNci9Y78VKSjDPAsOc4SPLROEnwi+kQbPuSYK4F3UDM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L1ovtR14M1yhAHYJR2tiX+//Ol0qAwBZXs+aKGiVhh42t9aKijrKfqDdUyHwGh+7E
         Ej8zdKT4mnd64nr+T1x7TKCl8zz34d/TSv8ZOzXoaftIur7o2Huj7lMFwQNecE1+CP
         WgmgcVSi/xHNIFD4nPGWgz2mvpA6PWSIEU+KtMhMjOoC00XxC+TCP30PV8/jz4cvCR
         Hn1JHvTHfZjnAh0JXxNIcfOVv4GOv41ep9cFZzP7wr30fNvyObKh7aoo8JydHUQLDY
         e4B7NfOxeOAa2URYuB8IqxL5k7cLSIFij8l4huhH5GhR21hD6m7DDeacNULdP1z56J
         6MtoizmCfOsnw==
Date:   Thu, 4 Aug 2022 08:29:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     kafai@fb.com, 18801353760@163.com, andrii@kernel.org,
        ast@kernel.org, borisp@nvidia.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        guwen@linux.alibaba.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [PATCH v4] net: fix refcount bug in sk_psock_get (2)
Message-ID: <20220804082913.5dac303c@kernel.org>
In-Reply-To: <20220804030514.7118-1-yin31149@gmail.com>
References: <20220803153706.oo47lv3kvkpb7yem@kafai-mbp.dhcp.thefacebook.com>
        <20220804030514.7118-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Aug 2022 11:05:15 +0800 Hawkins Jiawei wrote:
> I wonder if it is proper to gather these together in a patchset, for
> they are all about flags in sk_user_data, maybe:
> 
> [PATCH v5 0/2] net: enhancement to flags in sk_user_data field
> 	- introduce the patchset
> 
> [PATCH v5 1/2] net: clean up code for flags in sk_user_data field
> 	- refactor the things in include/linux/skmsg.h and
> include/net/sock.h
> 	- refactor the flags's usage by other code, such as
> net/core/skmsg.c and kernel/bpf/reuseport_array.c
> 
> [PATCH v5 2/2] net: fix refcount bug in sk_psock_get (2)
> 	- add SK_USER_DATA_PSOCK flag in sk_user_data field

Usually the fix comes first, because it needs to be backported to
stable, and we don't want to have to pull extra commits into stable
and risk regressions in code which was not directly involved in the bug.
