Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82DF5AC1DA
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 02:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIDA2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 20:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDA2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 20:28:09 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1E74DB43
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 17:28:08 -0700 (PDT)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2840RRg8093852;
        Sun, 4 Sep 2022 09:27:27 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Sun, 04 Sep 2022 09:27:27 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2840RQqi093848
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 4 Sep 2022 09:27:27 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <38d892bd-8ace-c4e9-9d73-777d3828acbc@I-love.SAKURA.ne.jp>
Date:   Sun, 4 Sep 2022 09:27:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] 9p/trans_fd: perform read/write with TIF_SIGPENDING
 set
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <00000000000039af4d05915a9f56@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
 <4293faaf-8279-77e2-8b1a-aff765416980@I-love.SAKURA.ne.jp>
 <69253379.JACLdFHAbQ@silver>
 <e96a8dce-9444-c363-2dfa-83fe5c7012b5@I-love.SAKURA.ne.jp>
 <YxPlzlJAKObm88p8@codewreck.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YxPlzlJAKObm88p8@codewreck.org>
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

On 2022/09/04 8:39, Dominique Martinet wrote:
> Is there any reason you spent time working on v2, or is that just
> theorical for not messing with userland fd ?

Just theoretical for not messing with userland fd, for programs generated
by fuzzers might use fds passed to the mount() syscall. I imagined that
syzbot again reports this problem when it started playing with fcntl().

For robustness, not messing with userland fd is the better. ;-)

> 
> unless there's any reason I'll try to find time to test v1 and queue it
> for 6.1

OK.

> We seem to check for EAGAIN where kernel_read/write end up being called
> and there's a poll for scheduling so it -should- work, but I assume this
> hasn't been tested much and might take a bit of time to test.

Right. Since the I/O in kernel side is poll based multiplexing, forcing
non-blocking I/O -should- work. (But I can't test e.g. changes in CPU time
usage because I don't have environment to test. I assume that poll based
multiplexing saves us from doing busy looping.)

We are currently checking for ERESTARTSYS and EAGAIN. The former is for
non-socket fds which do not have O_NONBLOCK flag, and the latter is for
socket fds which have O_NONBLOCK flag. If we enforce O_NONBLOCK flag,
the former will become redundant. I think we can remove the former check
after you tested that setting O_NONBLOCK flag on non-socket fds does not break.

