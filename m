Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89C1633B0A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiKVLSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiKVLRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:17:19 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2D86035A
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:14:37 -0800 (PST)
Received: from fsav313.sakura.ne.jp (fsav313.sakura.ne.jp [153.120.85.144])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AMBEYTg023493;
        Tue, 22 Nov 2022 20:14:35 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav313.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp);
 Tue, 22 Nov 2022 20:14:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AMBEY5j023490
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 22 Nov 2022 20:14:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
Date:   Tue, 22 Nov 2022 20:14:33 +0900
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
 <f2fdb53a-4727-278d-ac1b-d6dbdac8d307@I-love.SAKURA.ne.jp>
 <871qpvmfab.fsf@cloudflare.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <871qpvmfab.fsf@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/22 19:46, Jakub Sitnicki wrote:
>> https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360 is the one
>> where changing lockdep class is concurrently done on pre-existing sockets.
>>
>> I think we need to always create a new socket inside l2tp_tunnel_register(),
>> rather than trying to serialize setting of sk_user_data under sk_callback_lock.
> 
> While that would be easier to handle, I don't see how it can be done in
> a backward-compatible way. User-space is allowed to pass a socket to
> l2tp today [1].

What is the expected usage of the socket which was passed to l2tp_tunnel_register() ?
Is the userspace supposed to just close() that socket? Or, is the userspace allowed to
continue using the socket?

If the userspace might continue using the socket, we would

  create a new socket, copy required attributes (the source and destination addresses?) from
  the socket fetched via sockfd_lookup(), and call replace_fd() like e.g. umh_pipe_setup() does

inside l2tp_tunnel_register(). i-node number of the socket would change, but I assume that
the process which called l2tp_tunnel_register() is not using that i-node number.

Since the socket is a datagram socket, I think we can copy required attributes. But since
I'm not familiar with networking code, I don't know what attributes need to be copied. Thus,
I leave implementing it to netdev people.

