Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8620633EE9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiKVO27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiKVO24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:28:56 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F162E6316F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:28:54 -0800 (PST)
Received: from fsav313.sakura.ne.jp (fsav313.sakura.ne.jp [153.120.85.144])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AMESqla060599;
        Tue, 22 Nov 2022 23:28:52 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav313.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp);
 Tue, 22 Nov 2022 23:28:52 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AMESlPX060590
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 22 Nov 2022 23:28:51 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <c50bb326-7946-82b9-418a-95638818aa84@I-love.SAKURA.ne.jp>
Date:   Tue, 22 Nov 2022 23:28:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] l2tp: Don't sleep and disable BH under writer-side
 sk_callback_lock
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
 <a3b7d8cd-0c72-8e6b-78f2-71b92e70360f@I-love.SAKURA.ne.jp>
 <20221122141011.GA3303@pc-4.home>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20221122141011.GA3303@pc-4.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/22 23:10, Guillaume Nault wrote:
> User space uses this socket to send and receive L2TP control packets
> (tunnel and session configuration, keep alive and tear down). Therefore
> it absolutely needs to continue using this socket after the
> registration phase.

Thank you for explanation.

>> If the userspace might continue using the socket, we would
>>
>>   create a new socket, copy required attributes (the source and destination addresses?) from
>>   the socket fetched via sockfd_lookup(), and call replace_fd() like e.g. umh_pipe_setup() does
>>
>> inside l2tp_tunnel_register(). i-node number of the socket would change, but I assume that
>> the process which called l2tp_tunnel_register() is not using that i-node number.
>>
>> Since the socket is a datagram socket, I think we can copy required attributes. But since
>> I'm not familiar with networking code, I don't know what attributes need to be copied. Thus,
>> I leave implementing it to netdev people.
> 
> That looks fragile to me. If the problem is that setup_udp_tunnel_sock()
> can sleep, we can just drop the udp_tunnel_encap_enable() call from
> setup_udp_tunnel_sock(), rename it __udp_tunnel_encap_enable() and make
> make udp_tunnel_encap_enable() a wrapper around it that'd also call
> udp_tunnel_encap_enable().
> 

That's what I thought at https://lkml.kernel.org/r/c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp .

But the problem is not that setup_udp_tunnel_sock() can sleep. The problem is that lockdep
gets confused due to changing lockdep class after the socket is already published. We need
to avoid calling lockdep_set_class_and_name() on a socket retrieved via sockfd_lookup().

