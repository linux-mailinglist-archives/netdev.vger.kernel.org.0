Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF393432AE
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCUNLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhCUNLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:11:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BFFC061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 06:11:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so9984940pjb.0
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 06:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pdpLGwZVWgH1ZXWMGAb8CDhHmencOHZRTJisrrYzukM=;
        b=fvWoMaWKDwk6hbHahxH0fr03yS1R0JQXZ+P3M7Lpq3ImM/PaVyww/cZvAiYqOCi0uP
         HI4UKfyIMVX4IHv1CvoGFjLOM3pgXdxuwK9C+c35WKr9MkHDwugQOcNE9wu0pvZP5wA3
         74CxJHxm8ER0YHyiFIJZ4OmnZ8WU8h48i334nKcZUYHsOA7dyS5Ebaf9C88X1zd+ITUu
         v2FPOFL40YCvfVIrJzZVVCVTvJtn6tr4pfsaTkCdzBDilBsv2IRDMeeCac+u+U+FTMEe
         Iy+caqnh4ZQyCu7ph09heaPpdTV8bYG2mzvdvP7Mk24v2T/h2ikb+HoGmSaVXUP5CSb2
         nWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pdpLGwZVWgH1ZXWMGAb8CDhHmencOHZRTJisrrYzukM=;
        b=Kw58XXVrOvT/FEFPPKiCWICTD5ZmaCmz85T99fNNha4vL3CFyzsAolmUOHmfihLq0D
         5dMXu/MoBa+dEEQnH/Jx33B2qOSWh830B/ENiMFyEFFUjZIjFVo1ESJft4NvYfjYI9g3
         wnxeKqLlKwEpvyQ6PgHLfQMPIYEujaoh7Qp3P39r/czbVJHlt0P2XouFS3GJr8d98fee
         XmBOp5S/SFOtfxli7YrhSQd6KAyTo90Lac5iMERm8H7PAtQ+9WrQgsN0A/5tP5CcPIqV
         haxHAyNOt+1esIxzrfzceYiCv1bafYMrNZgjSTC310TcSPsJNU9pJ6R9MNfSre43tCls
         pyzQ==
X-Gm-Message-State: AOAM530lPNAzwEBMBXBX9wic6Lq3aAjd+oPLJMqCYMIBrbMbjHdzFkAc
        MA/2WLgAjgg09JUE6s327MNRmvWLVCMuFQ==
X-Google-Smtp-Source: ABdhPJxpvivSu2v/AqSP0cBfVHCiJ7bwze7KKyc67QgGvffOBPql6pVgZ37iVMPtkfpSsVnehbm8rQ==
X-Received: by 2002:a17:90a:a403:: with SMTP id y3mr8259581pjp.227.1616332259284;
        Sun, 21 Mar 2021 06:10:59 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a20sm11374868pfl.97.2021.03.21.06.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Mar 2021 06:10:58 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] io_uring: call req_set_fail_links() on short
 send[msg]()/recv[msg]() with MSG_WAITALL
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <c4e1a4cc0d905314f4d5dc567e65a7b09621aab3.1615908477.git.metze@samba.org>
 <12efc18b6bef3955500080a238197e90ca6a402c.1616268538.git.metze@samba.org>
 <38a987b9-d962-7531-6164-6dde9b4d133b@kernel.dk>
 <d68edf13-99a7-d010-cfc8-542f59ac7e27@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b624c6ad-fa60-d745-8393-3c778fdeca73@kernel.dk>
Date:   Sun, 21 Mar 2021 07:10:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d68edf13-99a7-d010-cfc8-542f59ac7e27@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/21 4:20 AM, Stefan Metzmacher wrote:
> 
> Am 20.03.21 um 23:57 schrieb Jens Axboe:
>> On 3/20/21 1:33 PM, Stefan Metzmacher wrote:
>>> Without that it's not safe to use them in a linked combination with
>>> others.
>>>
>>> Now combinations like IORING_OP_SENDMSG followed by IORING_OP_SPLICE
>>> should be possible.
>>>
>>> We already handle short reads and writes for the following opcodes:
>>>
>>> - IORING_OP_READV
>>> - IORING_OP_READ_FIXED
>>> - IORING_OP_READ
>>> - IORING_OP_WRITEV
>>> - IORING_OP_WRITE_FIXED
>>> - IORING_OP_WRITE
>>> - IORING_OP_SPLICE
>>> - IORING_OP_TEE
>>>
>>> Now we have it for these as well:
>>>
>>> - IORING_OP_SENDMSG
>>> - IORING_OP_SEND
>>> - IORING_OP_RECVMSG
>>> - IORING_OP_RECV
>>>
>>> For IORING_OP_RECVMSG we also check for the MSG_TRUNC and MSG_CTRUNC
>>> flags in order to call req_set_fail_links().
>>>
>>> There might be applications arround depending on the behavior
>>> that even short send[msg]()/recv[msg]() retuns continue an
>>> IOSQE_IO_LINK chain.
>>>
>>> It's very unlikely that such applications pass in MSG_WAITALL,
>>> which is only defined in 'man 2 recvmsg', but not in 'man 2 sendmsg'.
>>>
>>> It's expected that the low level sock_sendmsg() call just ignores
>>> MSG_WAITALL, as MSG_ZEROCOPY is also ignored without explicitly set
>>> SO_ZEROCOPY.
>>>
>>> We also expect the caller to know about the implicit truncation to
>>> MAX_RW_COUNT, which we don't detect.
>>
>> Thanks, I do think this is much better and I feel comfortable getting
>> htis applied for 5.12 (and stable).
>>
> 
> Great thanks!
> 
> Related to that I have a questing regarding the IOSQE_IO_LINK behavior.
> (Assuming I have a dedicated ring for the send-path of each socket.)
> 
> Is it possible to just set IOSQE_IO_LINK on every sqe in order to create
> an endless chain of requests so that userspace can pass as much sqes as possible
> which all need to be submitted in the exact correct order. And if any request
> is short, then all remaining get ECANCELED, without the risk of running any later
> request out of order.
> 
> Are such link chains possible also over multiple io_uring_submit() calls?
> Is there still a race between, having an iothread removing the request from
> from the list and fill in a cqe with ECANCELED, that userspace is not awaire
> of yet, which then starts a new independed link chain with a request that
> ought to be submitted after all the canceled once.
> 
> Or do I have to submit a link chain with just a single __io_uring_flush_sq()
> and then strictly need to wait until I got a cqe for the last request in
> the chain?

A chain can only exist within a single submit attempt, so it will not work
if you need to break it up over multiple io_uring_enter() calls.

-- 
Jens Axboe

