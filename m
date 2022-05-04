Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2147A519320
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244871AbiEDBIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244837AbiEDBI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:08:29 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0D32B257
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:04:55 -0700 (PDT)
Received: from fsav120.sakura.ne.jp (fsav120.sakura.ne.jp [27.133.134.247])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 24414TkX051843;
        Wed, 4 May 2022 10:04:29 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav120.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav120.sakura.ne.jp);
 Wed, 04 May 2022 10:04:29 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav120.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 24414Tbc051840
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 4 May 2022 10:04:29 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f6f9f21d-7cdd-682f-f958-5951aa180ec7@I-love.SAKURA.ne.jp>
Date:   Wed, 4 May 2022 10:04:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        patchwork-bot+netdevbpf@kernel.org
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-rdma <linux-rdma@vger.kernel.org>
References: <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <165157801106.17866.6764782659491020080.git-patchwork-notify@kernel.org>
 <CANn89iLHihonbBUQWkd0mjJPUuYBLMVoLCsRswtXmGjU3NKL5w@mail.gmail.com>
 <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89iJ=LF0KhRXDiFcky7mqpVaiHdbc6RDacAdzseS=iwjr4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/04 7:37, Eric Dumazet wrote:
>> I think we merged this patch too soon.
>>
>> My question is : What prevents rds_tcp_conn_path_connect(), and thus
>> rds_tcp_tune() to be called
>> after the netns refcount already reached 0 ?
>>
>> I guess we can wait for next syzbot report, but I think that get_net()
>> should be replaced
>> by maybe_get_net()
> 
> Yes, syzbot was fast to trigger this exact issue:

Does maybe_get_net() help?

Since rds_conn_net() returns a net namespace without holding a ref, it is theoretically
possible that the net namespace returned by rds_conn_net() is already kmem_cache_free()d
if refcount dropped to 0 by the moment sk_alloc() calls sock_net_set().

rds_tcp_conn_path_connect() {
  sock_create_kern(net = rds_conn_net(conn)) {
    __sock_create(net = rds_conn_net(conn), kern = 1) {
      err = pf->create(net = rds_conn_net(conn), kern = 1) {
        // pf->create is either inet_create or inet6_create
        sk_alloc(net = rds_conn_net(conn), kern = 1) {
          sk->sk_net_refcnt = kern ? 0 : 1;
          if (likely(sk->sk_net_refcnt)) {
            get_net_track(net, &sk->ns_tracker, priority);
            sock_inuse_add(net, 1);
          }
          sock_net_set(sk, net);
        }
      }
    }
  }
  rds_tcp_tune() {
    if (!sk->sk_net_refcnt) {
      sk->sk_net_refcnt = 1;
      get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
      sock_inuse_add(net, 1);
    }
  }
}

"struct rds_connection" needs to hold a ref in order to safely allow
rds_tcp_tune() to call maybe_get_net(), which in turn makes pointless
to use maybe_get_net() from rds_tcp_tune() because "struct rds_connection"
must have a ref. Situation where we are protected by maybe_get_net() is
quite limited if long-lived object is not holding a ref.

Hmm, can we simply use &init_net instead of rds_conn_net(conn) ?

