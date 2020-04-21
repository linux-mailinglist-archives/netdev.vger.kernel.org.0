Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F015D1B30D9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUT6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUT6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:58:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E1EC0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:58:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id p10so6791365ioh.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QbjTXTQQxb1zaR6jil1OkG7sq3Ic84mqlWb/ozG+UwA=;
        b=TjBt51V7YHl/CvLvj4z5fLk9oo7NO1VH1k+Rl9GaQJCTF5IagEcv87tU6cGYyXX643
         OPMawMykj/u1Er4lqt9eytElFIOakUdOCGlcQ/SK+AoBNUlEAWpqJA0js/T0Ld9ePPBE
         BADH6lEaM+7EdpD/gflFSJboCNc4FvTLunqsn3odDbWOekwWXNJkth3pglFdtQmwTg+x
         ph4KhNSJ4Ju7cyjMYBmyBDUzTqGteLU8d4nMQSQkxUDJpTpOwphQUKo0GaM19yMSBIde
         lwuHAwp8bgidTfpMU90my9n5Ml7EbgGOdSzy4wsEo3TuIefUEvEgjg/cuBXGcccOvS4q
         zOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QbjTXTQQxb1zaR6jil1OkG7sq3Ic84mqlWb/ozG+UwA=;
        b=DLy4yhRRN4g1IUqXqO8sTM/TMcn60fVKMyKe+9BERyq7pd6lJryWMhDVCf6J2A26Dm
         hgosgt8jz1VKhT3z3iG9X2mlwOLMKSTrvCJpD9zIRwPRqgIo8a+bWRi7jF2xnpt57UO7
         4k8us0flVYrzhxxzka0kr42PFLge5c+nAa6dGsww/QPHmXl9A+Y6jthmTazy10jKXZz8
         Mckxkg3e2XDe0yot0JzEX8dSC+j5xM/d+KqKMmP4mo/zcCTFdzzenmx9Fh0Fa0573BgL
         mAnDhNphg7su+gqn4eBsrePeizQPlN1s0odrt2MsM5gPJakbWXNteGvwTzcNJG7w6LWK
         jocw==
X-Gm-Message-State: AGi0PuaNJuNaTHnZYVBsWcB5H9hxP6e6IQsbX4mYKsOgaZY+7nXanm4g
        FxPKuRBoJKmqp6AadHal0RxwpA==
X-Google-Smtp-Source: APiQypIHpSzMIE9nB72pZXlh0evvzQCYKpwBrAFqm80V5i2SGESonyPmGLAXgRYI9JhQkePZljO1TQ==
X-Received: by 2002:a02:77d2:: with SMTP id g201mr22179072jac.65.1587499118778;
        Tue, 21 Apr 2020 12:58:38 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id y70sm1205068ilk.47.2020.04.21.12.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 12:58:38 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is
 used
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        Jamal Hadi Salim <hadi@mojatatu.com>
References: <20200421180426.6945-1-jhs@emojatatu.com>
 <CAPpH65zGO02uQyWQXXq6Yg_zsZcVZg+4-KWfRo_q3iACHr6s_Q@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <478bfaf8-6418-2d37-cae6-88b113d686b0@mojatatu.com>
Date:   Tue, 21 Apr 2020 15:58:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAPpH65zGO02uQyWQXXq6Yg_zsZcVZg+4-KWfRo_q3iACHr6s_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On 2020-04-21 3:38 p.m., Andrea Claudi wrote:
[..]
> 
> Hi Jamal,
> Are you sure this fixes your issue?

Yes.

> I think asprintf could segfault
> only if ctx is null, but this case is not addressed in your patch.

The issue is tmp(after it is created by asprintf) gets trampled.
This:
ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
allocates enough space for tmp.
But then later:
strcat(tmp, sub);
strcat(tmp...);
creates a buffer overrun.

It is easy to overlook things like these when making a large
semantically-equivalent change - so i would suggest to also
review the general patch that went from sprintf->asprintf.

> I remember that Stephen asked me to use asprintf to avoid allocating
> huge buffers on stack; anyway I've no objection to sprintf, if needed.

Generally that is good practise. And even for this case
you could probably find a simpler way to solve it with asprintf
or realloc trickery. I am not sure it is worth the bother - 4K on
the stack in user space is not a big deal really.

cheers,
jamal
