Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C9B65C931
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjACWJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjACWJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:09:28 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA7F003;
        Tue,  3 Jan 2023 14:09:27 -0800 (PST)
Received: from fsav112.sakura.ne.jp (fsav112.sakura.ne.jp [27.133.134.239])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 303M7k2O030536;
        Wed, 4 Jan 2023 07:07:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav112.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp);
 Wed, 04 Jan 2023 07:07:46 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav112.sakura.ne.jp)
Received: from [192.168.1.20] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 303M7j07030532
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 4 Jan 2023 07:07:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <2b35515e-5ad0-ee84-c90f-cb61428be4e4@I-love.SAKURA.ne.jp>
Date:   Wed, 4 Jan 2023 07:07:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [syzbot] WARNING: locking bug in inet_autobind
Content-Language: en-US
To:     Felix Kuehling <felix.kuehling@amd.com>,
        Waiman Long <longman@redhat.com>, edumazet@google.com,
        jakub@cloudflare.com
References: <0000000000002ae67f05f0f191aa@google.com>
 <ea9c2977-f05f-3acd-ee3e-2443229b7b55@amd.com>
 <3e531d65-72a7-a82a-3d18-004aeab9144b@redhat.com>
 <a47b840f-b2b8-95d7-ddc0-c9d5dde3c28c@amd.com>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        Alexander.Deucher@amd.com, Christian.Koenig@amd.com,
        David1.Zhou@amd.com, Evan.Quan@amd.com, Harry.Wentland@amd.com,
        Oak.Zeng@amd.com, Ray.Huang@amd.com, Yong.Zhao@amd.com,
        airlied@linux.ie, ast@kernel.org, boqun.feng@gmail.com,
        daniel@ffwll.ch, daniel@iogearbox.net, davem@davemloft.net,
        dsahern@kernel.org, gautammenghani201@gmail.com, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, mingo@redhat.com,
        ozeng@amd.com, pabeni@redhat.com, peterz@infradead.org,
        rex.zhu@amd.com, songliubraving@fb.com, will@kernel.org,
        yhs@fb.com, yoshfuji@linux-ipv6.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <a47b840f-b2b8-95d7-ddc0-c9d5dde3c28c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/01/04 1:20, Felix Kuehling wrote:
> 
> Am 2023-01-03 um 11:05 schrieb Waiman Long:
>> On 1/3/23 10:39, Felix Kuehling wrote:
>>> The regression point doesn't make sense. The kernel config doesn't enable CONFIG_DRM_AMDGPU, so there is no way that a change in AMDGPU could have caused this regression.
>>>
>> I agree. It is likely a pre-existing problem or caused by another commit that got triggered because of the change in cacheline alignment caused by commit c0d9271ecbd ("drm/amdgpu: Delete user queue doorbell variable").
> I don't think the change can affect cache line alignment. The entire amdgpu driver doesn't even get compiled in the kernel config that was used, and the change doesn't touch any files outside drivers/gpu/drm/amd/amdgpu:
> 
> # CONFIG_DRM_AMDGPU is not set
> 
> My guess would be that it's an intermittent bug that is confusing bisect.
> 
> Regards,
>   Felix

This was already explained in https://groups.google.com/g/syzkaller-bugs/c/1rmGDmbXWIw/m/nIQm0EmxBAAJ .

Jakub Sitnicki suggested

  What if we revisit Eric's lockdep splat fix in 37159ef2c1ae ("l2tp: fix
  a lockdep splat") and: 

  1. remove the lockdep_set_class_and_name(...) call in l2tp; it looks
     like an odd case within the network stack, and

  2. switch to bh_lock_sock_nested in l2tp_xmit_core so that we don't
     break what has been fixed in 37159ef2c1ae.

and we are waiting for response from Eric Dumazet.

