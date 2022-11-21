Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E18631DA2
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiKUKDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiKUKDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:03:33 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD81A4A07E
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:03:28 -0800 (PST)
Received: from fsav315.sakura.ne.jp (fsav315.sakura.ne.jp [153.120.85.146])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2ALA3ONB003573;
        Mon, 21 Nov 2022 19:03:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav315.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp);
 Mon, 21 Nov 2022 19:03:24 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2ALA3OKL003569
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 21 Nov 2022 19:03:24 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ef09820a-ca97-0c50-e2d8-e1344137d473@I-love.SAKURA.ne.jp>
Date:   Mon, 21 Nov 2022 19:03:24 +0900
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
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <87wn7o7k7r.fsf@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/21 18:00, Jakub Sitnicki wrote:
>> Is it safe to temporarily set a dummy pointer like below?
>> If it is not safe, what makes assignments done by
>> setup_udp_tunnel_sock() safe?
> 
> Yes, I think so. Great idea. I've used it in v2.

So, you are sure that e.g.

	udp_sk(sk)->gro_receive = cfg->gro_receive;

in setup_udp_tunnel_sock() (where the caller is passing cfg->gro_receive == NULL)
never races with e.g. below check (because the socket might be sending/receiving
in progress since the socket is retrieved via user-specified file descriptor) ?

Then, v2 patch would be OK for fixing this regression. (But I think we still should
avoid retrieving a socket from user-specified file descriptor in order to avoid
lockdep race window.)


struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
                                struct udphdr *uh, struct sock *sk)
{
	(...snipped...)
        if (!sk || !udp_sk(sk)->gro_receive) {
		(...snipped...)
                /* no GRO, be sure flush the current packet */
                goto out;
        }
	(...snipped...)
        pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
out:
        skb_gro_flush_final(skb, pp, flush);
        return pp;
}

> 
> We can check & assign sk_user_data under sk_callback_lock, and then just
> let setup_udp_tunnel_sock overwrite it with the same value, without
> holding the lock.

Given that sk_user_data is RCU-protected on reader-side, don't we need to
wait for RCU grace period after resetting to NULL?

> 
> I still think that it's best to keep the critical section as short as
> possible, though.

