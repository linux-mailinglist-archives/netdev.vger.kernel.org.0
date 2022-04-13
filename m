Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926A34FFFC2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 22:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbiDMUKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 16:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiDMUKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 16:10:11 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459137B10B;
        Wed, 13 Apr 2022 13:07:49 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nej10-000FtR-Vy; Wed, 13 Apr 2022 21:50:59 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nej10-000PG8-EN; Wed, 13 Apr 2022 21:50:58 +0200
Subject: Re: [PATCH v4 sysctl-next] bpf: move bpf sysctls from kernel/sysctl.c
 to bpf module
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com, leeyou.li@huawei.com,
        laiyuanyuan.lai@huawei.com
References: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
 <20220407070759.29506-1-zhuyan34@huawei.com>
 <3a82460b-6f58-6e7e-a3d9-141f42069eda@iogearbox.net>
 <Ylcd0zvHhi96zVi+@bombadil.infradead.org>
 <b615bd44-6bd1-a958-7e3f-dd2ff58931a1@iogearbox.net>
 <YlcoevXO2t1pn3Pu@bombadil.infradead.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86460c31-f25a-445a-b58c-0e90eb60a95f@iogearbox.net>
Date:   Wed, 13 Apr 2022 21:50:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YlcoevXO2t1pn3Pu@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26511/Wed Apr 13 10:22:45 2022)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 9:46 PM, Luis Chamberlain wrote:
> On Wed, Apr 13, 2022 at 09:40:58PM +0200, Daniel Borkmann wrote:
>> On 4/13/22 9:00 PM, Luis Chamberlain wrote:
>>> On Wed, Apr 13, 2022 at 04:45:00PM +0200, Daniel Borkmann wrote:
>>>> On 4/7/22 9:07 AM, Yan Zhu wrote:
>>>>> We're moving sysctls out of kernel/sysctl.c as its a mess. We
>>>>> already moved all filesystem sysctls out. And with time the goal is
>>>>> to move all sysctls out to their own subsystem/actual user.
>>>>>
>>>>> kernel/sysctl.c has grown to an insane mess and its easy to run
>>>>> into conflicts with it. The effort to move them out is part of this.
>>>>>
>>>>> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
>>>>
>>>> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>>>>
>>>> Given the desire is to route this via sysctl-next and we're not shortly
>>>> before but after the merge win, could we get a feature branch for bpf-next
>>>> to pull from to avoid conflicts with ongoing development cycle?
>>>
>>> Sure thing. So I've never done this sort of thing, so forgive me for
>>> being new at it. Would it make sense to merge this change to sysctl-next
>>> as-is today and put a frozen branch sysclt-next-bpf to reflect this,
>>> which bpf-next can merge. And then sysctl-next just continues to chug on
>>> its own? As-is my goal is to keep sysctl-next as immutable as well.
>>>
>>> Or is there a better approach you can recommend?
>>
>> Are you able to merge the pr/bpf-sysctl branch into your sysctl-next tree?
>>
>>    https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/log/?h=pr/bpf-sysctl
>>
>> This is based off common base for both trees (3123109284176b1532874591f7c81f3837bbdc17)
>> so should only pull in the single commit then.
> 
> Yup. That worked just fine. I pushed it.

Great, thanks!
