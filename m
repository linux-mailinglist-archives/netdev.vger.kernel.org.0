Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF57FAC630
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 13:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390316AbfIGLBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 07:01:54 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57512 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390097AbfIGLBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 07:01:54 -0400
Received: from fsav106.sakura.ne.jp (fsav106.sakura.ne.jp [27.133.134.233])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x87B0aHm093582;
        Sat, 7 Sep 2019 20:00:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav106.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav106.sakura.ne.jp);
 Sat, 07 Sep 2019 20:00:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav106.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126227201116.bbtec.net [126.227.201.116])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x87B0aVu093579
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Sat, 7 Sep 2019 20:00:36 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Michal Hocko <mhocko@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
References: <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
 <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
 <20190903132231.GC18939@dhcp22.suse.cz> <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz> <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz> <20190904064144.GA5487@jagdpanzerIV>
 <20190904070042.GA11968@jagdpanzerIV> <20190904082540.GI3838@dhcp22.suse.cz>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <28040332-4639-375a-0832-b47759d1d2d8@I-love.SAKURA.ne.jp>
Date:   Sat, 7 Sep 2019 20:00:34 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190904082540.GI3838@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/09/04 17:25, Michal Hocko wrote:
> On Wed 04-09-19 16:00:42, Sergey Senozhatsky wrote:
>> On (09/04/19 15:41), Sergey Senozhatsky wrote:
>>> But the thing is different in case of dump_stack() + show_mem() +
>>> some other output. Because now we ratelimit not a single printk() line,
>>> but hundreds of them. The ratelimit becomes - 10 * $$$ lines in 5 seconds
>>> (IOW, now we talk about thousands of lines).
>>
>> And on devices with slow serial consoles this can be somewhat close to
>> "no ratelimit". *Suppose* that warn_alloc() adds 700 lines each time.
>> Within 5 seconds we can call warn_alloc() 10 times, which will add 7000
>> lines to the logbuf. If printk() can evict only 6000 lines in 5 seconds
>> then we have a growing number of pending logbuf messages.
> 
> Yes, ratelimit is problematic when the ratelimited operation is slow. I
> guess that is a well known problem and we would need to rework both the
> api and the implementation to make it work in those cases as well.
> Essentially we need to make the ratelimit act as a gatekeeper to an
> operation section - something like a critical section except you can
> tolerate more code executions but not too many. So effectively
> 
> 	start_throttle(rate, number);
> 	/* here goes your operation */
> 	end_throttle();
> 
> one operation is not considered done until the whole section ends.
> Or something along those lines.

Regarding OOM killer which is serialized by oom_lock mutex, I proposed
"mm, oom: More aggressively ratelimit dump_header()." at
https://lkml.kernel.org/r/1550325895-9291-2-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
but it was ignored.

> 
> In this particular case we can increase the rate limit parameters of
> course but I think that longterm we need a better api.
> 

I proposed "printk: Introduce "store now but print later" prefix." at
https://lkml.kernel.org/r/1550896930-12324-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
but it was not accepted.

But I think that more better solution for warn_alloc() is to defer printing
 from allocating context (which may not be allowed to sleep) to WQ context.
I proposed "mm,oom: Defer dump_tasks() output." at
https://lkml.kernel.org/r/7de2310d-afbd-e616-e83a-d75103b986c6@i-love.sakura.ne.jp
and answered to Michal's concerns. I hope we can apply the same thing for
warn_alloc() and show_mem(). Then, we can minimize latency for both
"memory allocation failures" and "OOM killer invocations".

