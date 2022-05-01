Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637E25166E3
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349728AbiEASTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 14:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240872AbiEASTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 14:19:24 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B76237F4;
        Sun,  1 May 2022 11:15:57 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id y27so5792232vkl.8;
        Sun, 01 May 2022 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NXAda5xt4/wjysrYvB9nS7/wLpRXFD7ow9IgkMbZhoM=;
        b=F8aoysx+QXHplgMd3z11Px+G/wEO26PmZrVlP/KIG6z9M0YLlBo5ZIhbVQZU4oSTGx
         5dbYni/zq1fX9wgjNy2ccd6ms7J8o1TcevK03mgMQrFDlQnCPkr1gScI5p/sgkhYO/ad
         TZYPonc6U16d2FGujEgC2gYXSLAYgV14M1lYJrm21iOOb/AbgNBxTLmsuPnTnQza9Qpq
         u4J0cHKHQycEn3MPQLiRERhhBdnJ/k+wmOpuCXBjgCxClHu4BavgdRkJs6yJ9HDHZ5yc
         Lakw8I6UFhUQqKkLmDbi4D6+ze/rHMLPu5a9E5r25tc0B6SnJbp/Y1lrOC857kwlKcQN
         ux1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NXAda5xt4/wjysrYvB9nS7/wLpRXFD7ow9IgkMbZhoM=;
        b=FgcHz/fI3IKy63FqY4U1QCpiS5a5JFzpJfLz1bQ+jQpR3UtMCsqCbd1G6DtxXcwcDw
         gFJMQgz0nqI1nMpwT9K6YmFgrxR3uGPD3/bpiteQI15QoHKJVdQ+lPnxUfMzsfhawjRy
         +IwFYpjxaLJTEygsgu4udF6LJLeHeVItmneZWnYHs0np8ADRkdU3m/cB5u+RNPqUXijW
         DmLEk9hY+yba3L1sl4uPpOGRMOxToPjSI6lBvCa7U2qG8KZjMb7t4LhtTLvsLo4/4VtX
         dWHPNWd9jRLDyJXwrH4w2kbdZU3Vi/7fs3w22CRqzLRmjGcF3i50a7KSWqyexpSGCptR
         Gaxg==
X-Gm-Message-State: AOAM532MPJ0Y8OU0eDblZRDePwpJ8adF4A97Ld0X7biRRKl+FSljdyG5
        H4cLqc91jR9aIA2oiGh/yDVa6TqLw9QCaFhZsfpPcYND
X-Google-Smtp-Source: ABdhPJzfZP1BsLle8elGQ2WBrGagfetre6PTc8h/lxFRp4W+QYmd19lNxRnJRRsGavdSlxrZvuboaZ91p8L9tjMJb64=
X-Received: by 2002:a1f:e2c7:0:b0:34d:310f:6b0 with SMTP id
 z190-20020a1fe2c7000000b0034d310f06b0mr2072202vkg.19.1651428956898; Sun, 01
 May 2022 11:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220501175828.8185-1-ryazanov.s.a@gmail.com> <Ym7MyhaX3SYX9rmm@kroah.com>
In-Reply-To: <Ym7MyhaX3SYX9rmm@kroah.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 1 May 2022 21:15:55 +0300
Message-ID: <CAHNKnsTrzEiSqFjv8ZPvxBuDfH6ThKQn_XFSs0woeN4N4yUCNw@mail.gmail.com>
Subject: Re: [PATCH net] usb: cdc-wdm: fix reading stuck on device close
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 1, 2022 at 9:09 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sun, May 01, 2022 at 08:58:28PM +0300, Sergey Ryazanov wrote:
>> cdc-wdm tracks whether a response reading request is in-progress and
>> blocks the next request from being sent until the previous request is
>> completed. As soon as last user closes the cdc-wdm device file, the
>> driver cancels any ongoing requests, resets the pending response
>> counter, but leaves the response reading in-progress flag
>> (WDM_RESPONDING) untouched.
>>
>> So if the user closes the device file during the response receive
>> request is being performed, no more data will be obtained from the
>> modem. The request will be cancelled, effectively preventing the
>> WDM_RESPONDING flag from being reseted. Keeping the flag set will
>> prevent a new response receive request from being sent, permanently
>> blocking the read path. The read path will staying blocked until the
>> module will be reloaded or till the modem will be re-attached.
>>
>> This stuck has been observed with a Huawei E3372 modem attached to an
>> OpenWrt router and using the comgt utility to set up a network
>> connection.
>>
>> Fix this issue by clearing the WDM_RESPONDING flag on the device file
>> close.
>>
>> Without this fix, the device reading stuck can be easily reproduced in a
>> few connection establishing attempts. With this fix, a load test for
>> modem connection re-establishing worked for several hours without any
>> issues.
>>
>> Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and
>> reading from the device")
>
> Nit, Fixes: lines should only be one line, I'll fix this up when
> applying it.

Ouch. Sorry.

>> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>> ---
>>
>> Technically, cdc-wdm belongs to the USB subsystem even though it serves
>> WWAN devices. I think this fix should be applied (backported) to LTS
>> versions too. So I targeted it to the 'net' tree, but send it to both
>> lists to get a feedback. Greg, Jakub, what is the best tree for this
>> fix?
>>
>> ---
>>  drivers/usb/class/cdc-wdm.c | 1 +
>>  1 file changed, 1 insertion(+)
>
> scripts/get_maintainer.pl is pretty clear this goes through the USB
> tree.  I'll queue it up in a few days, thanks,

Thank you for your clarification, will keep in mind.

-- 
Sergey
