Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25CF5171AD
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbiEBOjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385778AbiEBOjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 10:39:21 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF2860F3
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 07:35:51 -0700 (PDT)
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 242ETxQC023628;
        Mon, 2 May 2022 23:29:59 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Mon, 02 May 2022 23:29:59 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 242ETxJb023622
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 2 May 2022 23:29:59 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <cd6d1939-233e-fe3d-1bc4-ed49cda14efb@I-love.SAKURA.ne.jp>
Date:   Mon, 2 May 2022 23:29:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2] net: rds: acquire refcount on TCP sockets
Content-Language: en-US
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <b0f99499-fb6a-b9ec-7bd3-f535f11a885d@I-love.SAKURA.ne.jp>
 <5f90c2b8-283e-6ca5-65f9-3ea96df00984@I-love.SAKURA.ne.jp>
 <f8ae5dcd-a5ed-2d8b-dd7a-08385e9c3675@I-love.SAKURA.ne.jp>
 <CANn89iJukWcN9-fwk4HEH-StAjnTVJ34UiMsrN=mdRbwVpo8AA@mail.gmail.com>
 <a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp>
 <F8AED695-D4EC-4560-9EEC-5DF0CEFD88AC@oracle.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <F8AED695-D4EC-4560-9EEC-5DF0CEFD88AC@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/02 23:12, Haakon Bugge wrote:
>> +	/* TCP timer functions might access net namespace even after
>> +	 * a process which created this net namespace terminated.
>> +	 */
>> +	if (!sk->sk_net_refcnt) {
>> +		sk->sk_net_refcnt = 1;
>> +		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> 
> Don't you need a corresponding put_net_track()?

__sk_free() and __sk_destruct() will do if sk->sk_net_refcnt is set.

> 
>> +		sock_inuse_add(net, 1);
>> +	}

