Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945DA5AC31A
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbiIDHRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 03:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDHRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 03:17:45 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5A042AC3
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 00:17:44 -0700 (PDT)
Received: from fsav315.sakura.ne.jp (fsav315.sakura.ne.jp [153.120.85.146])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2847Hgmp076700;
        Sun, 4 Sep 2022 16:17:42 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav315.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp);
 Sun, 04 Sep 2022 16:17:42 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav315.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2847HgY6076697
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 4 Sep 2022 16:17:42 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <40f15366-6027-ec7a-e151-bcc108855cb8@I-love.SAKURA.ne.jp>
Date:   Sun, 4 Sep 2022 16:17:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net/9p: use a dedicated spinlock for modifying IDR
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
References: <000000000000f842c805e64f17a8@google.com>
 <2470e028-9b05-2013-7198-1fdad071d999@I-love.SAKURA.ne.jp>
 <YxRHYaqqISAr5Rif@codewreck.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YxRHYaqqISAr5Rif@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/09/04 15:36, Dominique Martinet wrote:
> We have an idr per client though so this is needlessly adding contention
> between multiple 9p mounts.
> 
> That probably doesn't matter too much in the general case,

I thought this is not a hot operation where contention matters.

>                                                            but adding a
> different lock per connection is cheap so let's do it the other way
> around: could you add a lock to the p9_conn struct in net/9p/trans_fd.c
> and replace c->lock by it there?

Not impossible, but may not be cheap for lockdep.

> That should have identical effect as other transports don't use client's
> .lock ; and the locking in trans_fd.c is to protect req's status and
> trans_fd's own lists which is orthogonal to client's lock that protects
> tag allocations. I agree it should work in theory.
> 
> (If you don't have time to do this this patch has been helpful enough and
> I can do it eventually)

Sent as https://lkml.kernel.org/r/68540a56-6a5f-87e9-3c21-49c58758bfaf@I-love.SAKURA.ne.jp .

By the way, I think credit for the patch on https://syzkaller.appspot.com/bug?extid=50f7e8d06c3768dd97f3 goes to Hillf Danton...

