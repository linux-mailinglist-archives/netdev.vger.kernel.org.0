Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457D7661114
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 19:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjAGSlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 13:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjAGSlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 13:41:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DD71BC91
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 10:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB81B803F6
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 18:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33C4C433EF;
        Sat,  7 Jan 2023 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673116902;
        bh=TrOg9Ud6kGnAYrg6+ETgV1I59BDXtzn2KKih6Rn/mZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZHH9laehtd6lrYkvW3E0V9ioaxM8nXCUz6zQTVyn0PXlO41GpcUK5vEbe4dVC3CJ
         fsF4Gw5tLOQImJGYBueGQ9gJNc28/Y3EI+WqBf6htmOAv25tIodIvUlCFqknd5pBtm
         bK/HnYzaPk0r/LXmI1PWRTY9V4JssVF2h6r7bzKVc7tfckmSzIPJgMO4CEvDlvMzQW
         hzlEyVZ6QSkMulsrVgDOJmgyvaTq/8sUw1ZtHeES5bDnlGXTJIVyZySw0BTpOXjeRd
         XmlXORRDWM8o9EGTsZ+CtXZFbteutHYmgJ0oFomQN8rSc3pwhZTlf1kyqF7XCLQIPg
         Gz14jIqFpf2SQ==
Date:   Sat, 7 Jan 2023 10:41:41 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 2/2] l2tp: close all race conditions in
 l2tp_tunnel_register()
Message-ID: <Y7m85XdeKwi9+Ytt@x130>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-3-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230105191339.506839-3-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 11:13, Cong Wang wrote:
>From: Cong Wang <cong.wang@bytedance.com>
>
>The code in l2tp_tunnel_register() is racy in several ways:
>
>1. It modifies the tunnel socket _after_ publishing it.
>
>2. It calls setup_udp_tunnel_sock() on an existing socket without
>   locking.
>
>3. It changes sock lock class on fly, which triggers many syzbot
>   reports.
>
>This patch amends all of them by moving socket initialization code
>before publishing and under sock lock. As suggested by Jakub, the
>l2tp lockdep class is not necessary as we can just switch to
>bh_lock_sock_nested().
>
>Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
>Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")

This patch relies on the previous one which doesn't include any tags.
If you are interested in this making it to -stable then maybe you need to
add those tags to the previous commit ?

I am not really familiar with the issue and how socket locks should work
here, but code wise LGTM.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>


>Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
>Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
>Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>Cc: Guillaume Nault <g.nault@alphalink.fr>
>Cc: Jakub Sitnicki <jakub@cloudflare.com>
>Cc: Eric Dumazet <edumazet@google.com>
>Signed-off-by: Cong Wang <cong.wang@bytedance.com>

