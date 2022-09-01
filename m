Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67415AA30A
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 00:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiIAW3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 18:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiIAW3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 18:29:10 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ABD102F
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 15:27:27 -0700 (PDT)
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 281MPY1f007699;
        Fri, 2 Sep 2022 07:25:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Fri, 02 Sep 2022 07:25:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 281MPY2R007696
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 2 Sep 2022 07:25:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <e96a8dce-9444-c363-2dfa-83fe5c7012b5@I-love.SAKURA.ne.jp>
Date:   Fri, 2 Sep 2022 07:25:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] 9p/trans_fd: perform read/write with TIF_SIGPENDING
 set
Content-Language: en-US
To:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>
Cc:     syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <00000000000039af4d05915a9f56@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
 <4293faaf-8279-77e2-8b1a-aff765416980@I-love.SAKURA.ne.jp>
 <69253379.JACLdFHAbQ@silver>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <69253379.JACLdFHAbQ@silver>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/09/02 0:23, Christian Schoenebeck wrote:
> So the intention in this alternative approach is to allow user space apps  
> still being able to perform blocking I/O, while at the same time making the 
> kernel thread interruptible to fix this hung task issue, correct?

Making the kernel thread "non-blocking" (rather than "interruptible") in order
not to be blocked on I/O on pipes.

Since kernel threads by default do not receive signals, being "interruptible"
or "killable" does not help (except for silencing khungtaskd warning). Being
"non-blocking" like I/O on sockets helps.

>> --- a/net/9p/trans_fd.c
>> +++ b/net/9p/trans_fd.c
>> @@ -256,11 +256,13 @@ static int p9_fd_read(struct p9_client *client, void
>> *v, int len) if (!ts)
>>  		return -EREMOTEIO;
>>
>> -	if (!(ts->rd->f_flags & O_NONBLOCK))
>> -		p9_debug(P9_DEBUG_ERROR, "blocking read ...\n");
>> -
>>  	pos = ts->rd->f_pos;
>> +	/* Force non-blocking read() even without O_NONBLOCK. */
>> +	set_thread_flag(TIF_SIGPENDING);
>>  	ret = kernel_read(ts->rd, v, len, &pos);
>> +	spin_lock_irq(&current->sighand->siglock);
>> +	recalc_sigpending();
>> +	spin_unlock_irq(&current->sighand->siglock);
> 
> Is the recalc_sigpending() block here actually needed? The TIF_SIGPENDING flag 
> is already cleared by net/9p/client.c, no?

This is actually needed.

The thread which processes this function is a kernel workqueue thread which
is supposed to process other functions (which might call "interruptible"
functions even if signals are not received by default).

The thread which currently clearing the TIF_SIGPENDING flag is a user process
(which are calling "killable" functions from syscall context but effectively
"uninterruptible" due to clearing the TIF_SIGPENDING flag and retrying).
By the way, clearing the TIF_SIGPENDING flag before retrying "killable" functions
(like p9_client_rpc() does) is very bad and needs to be avoided...

