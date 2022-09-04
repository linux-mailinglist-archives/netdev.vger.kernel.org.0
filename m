Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710DB5AC3BE
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiIDKCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 06:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIDKCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 06:02:10 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6055FCE
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 03:02:08 -0700 (PDT)
Received: from fsav413.sakura.ne.jp (fsav413.sakura.ne.jp [133.242.250.112])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 284A26Uj009351;
        Sun, 4 Sep 2022 19:02:06 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav413.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp);
 Sun, 04 Sep 2022 19:02:06 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav413.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 284A268O009348
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 4 Sep 2022 19:02:06 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <10e6223b-88c2-a377-c238-11c93d4e1afb@I-love.SAKURA.ne.jp>
Date:   Sun, 4 Sep 2022 19:02:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] net/9p: use a dedicated spinlock for modifying IDR
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        syzbot <syzbot+2f20b523930c32c160cc@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
References: <YxRZ7xtcUiYcPaw0@codewreck.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <YxRZ7xtcUiYcPaw0@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/09/04 16:55, Dominique Martinet wrote:
> Tetsuo Handa wrote on Sun, Sep 04, 2022 at 04:06:36PM +0900:
>> Changes in v2:
>>   Make this spinlock per "struct p9_client", though I don't know how we
>>   should update "@lock" when "@idr_lock" also protects @fids and @reqs...
> 
> Sorry for the trouble, this is not what I meant: this v2 makes 'lock'
> being unused except for trans_fd, which isn't optimal for other
> transports like e.g. virtio or rdma.

v1 was smaller, and I thought frequency of calling
idr_alloc()/idr_alloc_u32()/idr_remove() is low enough to justify
use of global spinlock.

> 
> In hindsight it's probably faster to just send a diff... Happy to keep
> you as author if you'd like, or sign off or whatever you prefer -- I
> wouldn't have guessed what that report meant without you.

This diff is bigger than I can guess correctness. Maybe v1 patch should be
applied as a fix for this problem (because including Reported-by: or Fixes:
likely makes patches be automatically picked up by stable kernel maintainers
before syzbot tests for a while) and your patch should be applied as an improvement
(i.e. omit Reported-by: and Fixes: ). You can manually request for inclusion into
stable kernels after syzbot tested for a while.

> Eh, with your link I'd agree, but I never got any mail from him.

Too bad. Hillf is proposing patches in many bugs, but it seems that
he does not try to propose as formal patches with description.

