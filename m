Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BFB6338FC
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiKVJs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiKVJsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:48:54 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0231215
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:48:49 -0800 (PST)
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AM9mlk7002154;
        Tue, 22 Nov 2022 18:48:47 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Tue, 22 Nov 2022 18:48:47 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AM9mlom002151
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 22 Nov 2022 18:48:47 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
Date:   Tue, 22 Nov 2022 18:48:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Content-Language: en-US
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com,
        syzbot+50680ced9e98a61f7698@syzkaller.appspotmail.com,
        syzbot+de987172bb74a381879b@syzkaller.appspotmail.com
References: <20221119130317.39158-1-jakub@cloudflare.com>
 <f8e54710-6889-5c27-2b3c-333537495ecd@I-love.SAKURA.ne.jp>
 <a850c224-f728-983c-45a0-96ebbaa943d7@I-love.SAKURA.ne.jp>
 <87wn7o7k7r.fsf@cloudflare.com>
 <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
 <87fseb7vbm.fsf@cloudflare.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <87fseb7vbm.fsf@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/22 6:55, Jakub Sitnicki wrote:
> First, let me say, that I get the impression that setup_udp_tunnel_sock
> was not really meant to be used on pre-existing sockets created by
> user-space. Even though l2tp and gtp seem to be doing that.
> 
> That is because, I don't see how it could be used properly. Given that
> we need to check-and-set sk_user_data under sk_callback_lock, which
> setup_udp_tunnel_sock doesn't grab itself. At the same time it might
> sleep. There is no way to apply it without resorting to tricks, like we
> did here.
> 
> So - yeah - there may be other problems. But if there are, they are not
> related to the faulty commit b68777d54fac ("l2tp: Serialize access to
> sk_user_data with sk_callback_lock"), which we're trying to fix. There
> was no locking present in l2tp_tunnel_register before that point.

https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360 is the one
where changing lockdep class is concurrently done on pre-existing sockets.

I think we need to always create a new socket inside l2tp_tunnel_register(),
rather than trying to serialize setting of sk_user_data under sk_callback_lock.

> However, that is also not related to the race to check-and-set
> sk_user_data, which commit b68777d54fac is trying to fix.

Therefore, I feel that reverting commit b68777d54fac "l2tp: Serialize access
to sk_user_data with sk_callback_lock" might be the better choice.

