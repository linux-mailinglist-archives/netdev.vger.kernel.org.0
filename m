Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842BE5F77B4
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 13:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJGLxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 07:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJGLxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 07:53:33 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D232FB7ECB;
        Fri,  7 Oct 2022 04:53:31 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 297Bqjsi041794;
        Fri, 7 Oct 2022 20:52:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Fri, 07 Oct 2022 20:52:45 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 297Bqi3r041791
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Oct 2022 20:52:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <0362d03f-9332-0b37-02e0-2b1b169f4c6f@I-love.SAKURA.ne.jp>
Date:   Fri, 7 Oct 2022 20:52:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2] 9p/trans_fd: perform read/write with TIF_SIGPENDING
 set
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
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
 <38d892bd-8ace-c4e9-9d73-777d3828acbc@I-love.SAKURA.ne.jp>
 <Yz+Di8tJiyPPJUaK@codewreck.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Yz+Di8tJiyPPJUaK@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/07 10:40, Dominique Martinet wrote:
> Tetsuo Handa wrote on Sun, Sep 04, 2022 at 09:27:22AM +0900:
>> On 2022/09/04 8:39, Dominique Martinet wrote:
>>> Is there any reason you spent time working on v2, or is that just
>>> theorical for not messing with userland fd ?
>>
>> Just theoretical for not messing with userland fd, for programs generated
>> by fuzzers might use fds passed to the mount() syscall. I imagined that
>> syzbot again reports this problem when it started playing with fcntl().
>>
>> For robustness, not messing with userland fd is the better. ;-)
> 
> By the way digging this back made me think about this a bit again.
> My opinion hasn't really changed that if you want to shoot yourself in
> the foot I don't think we're crossing any priviledge boundary here, but
> we could probably prevent it by saying the mount call with close that fd
> and somehow steal it? (drop the fget, close_fd after get_file perhaps?)
> 
> That should address your concern about robustess and syzbot will no
> longer be able to play with fcntl on "our" end of the pipe. I think it's
> fair to say that once you pass it to the kernel all bets are off, so
> closing it for the userspace application could make sense, and the mount
> already survives when short processes do the mount call and immediately
> exit so it's not like we need that fd to be open...
> 
> 
> What do you think?

I found that pipe is using alloc_file_clone() which allocates "struct file"
instead of just incrementing "struct file"->f_count.

Then, can we add EXPORT_SYMBOL_GPL(alloc_file_clone) to fs/file_table.c and
use it like

  struct file *f;

  ts->rd = fget(rfd);
  if (!ts->rd)
    goto out_free_ts;
  if (!(ts->rd->f_mode & FMODE_READ))
    goto out_put_rd;
  f = alloc_file_clone(ts->rd, ts->rd->f_flags | O_NONBLOCK, ts->rd->f_op);
  if (IS_ERR(f))
    goto out_put_rd;
  fput(ts->rd);
  ts->rd = f;

  ts->wr = fget(wfd);
  if (!ts->wr)
    goto out_put_rd;
  if (!(ts->wr->f_mode & FMODE_WRITE))
    goto out_put_wr;
  f = alloc_file_clone(ts->wr, ts->wr->f_flags | O_NONBLOCK, ts->wr->f_op);
  if (IS_ERR(f))
    goto out_put_wr;
  fput(ts->wr);
  ts->wr = f;

 from p9_fd_open() for cloning "struct file" with O_NONBLOCK flag added?
Just an idea. I don't know whether alloc_file_clone() arguments are correct...

