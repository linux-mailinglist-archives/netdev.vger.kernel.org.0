Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEF0602751
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJRInZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJRInY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:43:24 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313292ED41;
        Tue, 18 Oct 2022 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=heQizsKM6wB6x3ZGPufNdBjDOwODRsRwqhUa5JzMemg=; b=S9rrTtrXoodMq+Q+eCaNsBov4E
        G6LxRUEnQnbtglJ/rDSNlZWSAnt8U0C1caQcmwXCEG7D8HeGaQ4Pjs1YIl48OEwnblqG1PnxJw44x
        5/qFcbXtiVEfiAtvAx7D4SksBOLBHmByGWAhvFMvHbz9MNxdrNf80KyXdaAPrgSIPqlaA/OvE5deD
        PAu7ecVLtUM2/OP40s6n22qQe+qldweUGAd2skokQYNveNY2vg4i/WE614lNxSupe+76FAlWViypk
        NAILK9lut/NXW2Z4hcLZfGFb7Mir1FqDiGGZXFCuJDMOYo3zbR6rmy0u0U35IMX+xQKUarVqHiPMk
        00+JNeMbZ/lP+4baNPcR8y6sY2uGFtOAXgYmjEQBG57fyok//8IuXFTvz5U5sSFXkDy+3gY1Uw/Ml
        z3IpdpWnw7rqabiTp3m7apXzfZPv+1M9MGzinKQy9YgN/tGmFDollaaJa3UjbZs+MmC4rtk0Pk/Fw
        TgLqPcuTWMojgUKGuMiFNbaG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1okiBz-004iMG-M5; Tue, 18 Oct 2022 08:43:19 +0000
Message-ID: <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
Date:   Tue, 18 Oct 2022 10:43:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_CQE_F_COPIED
In-Reply-To: <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> On 10/14/22 12:06, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>> In the tests I made I used this version of IORING_CQE_F_COPIED:
>> https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=645d3b584c417a247d92d71baa6266a5f3d0d17d
>> (also inlined at the end)
>>
>> Would that something we want for 6.1? (Should I post that with a useful commit message, after doing some more tests)
> 
> I was thinking, can it be delivered separately but not in the same cqe?
> The intention is to keep it off the IO path. For example, it can emit a
> zc status CQE or maybe keep a "zc failed" counter inside the ring. Other
> options? And we can add a separate callback for that, will make a couple
> of things better.
> 
> What do you think? Especially from the userspace usability perspective.

So far I can't think of any other way that would be useful yet,
but that doesn't mean something else might exist...

IORING_CQE_F_COPIED is available per request and makes it possible
to judge why the related SENDMSG_ZC was fast or not.
It's also available in trace-cmd report.

Everything else would likely re-introduce similar complexity like we
had with the notif slots.

Instead of a new IORING_CQE_F_COPIED flag we could also set
cqe.res = SO_EE_CODE_ZEROCOPY_COPIED, but that isn't really different.

As I basically use the same logic that's used to generate SO_EE_CODE_ZEROCOPY_COPIED
for the native MSG_ZEROCOPY, I don't see the problem with IORING_CQE_F_COPIED.
Can you be more verbose why you're thinking about something different?

metze
