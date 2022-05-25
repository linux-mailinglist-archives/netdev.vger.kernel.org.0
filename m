Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8E3533B39
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiEYLB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiEYLBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:01:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FFE82BB0D
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mp+AHRyC2SZ1ELTJYU3oak0+KeRVtpSTaJn7d4C47E8=;
        b=iMxJFOmfDjkOF/2Y3BhFGPHbeWZKY0vvSZlN3EMdtiIvZ4X0M9gWRPy7tTXNXb3LI7tVZZ
        Zxff23YnzXhvKIe+tdxYbMqyLiiJJuDzDGygBK0zRdKO6eR7q2hmH0Ny6Hz0OZiOMUea2p
        UNTP4Wsb0Wxio6kACVYGEr8U14b/JhI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-hDa5RNAUOXC-8Z35mJzWZw-1; Wed, 25 May 2022 07:01:48 -0400
X-MC-Unique: hDa5RNAUOXC-8Z35mJzWZw-1
Received: by mail-qk1-f197.google.com with SMTP id m26-20020a05620a13ba00b006a32a7adb78so13776992qki.10
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Mp+AHRyC2SZ1ELTJYU3oak0+KeRVtpSTaJn7d4C47E8=;
        b=hdmm2M4pWaK6+gs6T2+A2Dl0AnVWwtlJu2OsCdeF/I3okp6tETkkty8TqjZjdhrPmH
         dQ6h16iB6GhFAHI6J1GUn96uyluyyo1qvoRi4wrzaP1LwJkZKYu5L6UwAoe0hz5/ZWCY
         /86yzHasQ9i3mLhZkUgdRcaN1yDDnRvy61Y7civleU+WpQgJcLV0qVIBWtMUe1qGb3sM
         i5J/OMgEU6Zi0UtysPWytzLvE8zGmzr+kq3RZZPtVxXLQF8vr02M1t7/e6NvCtvGS/i6
         3DtjTvrHDcMqY1pqQqMnQQ0SEwLSJzmHTnHtPMo6kgg8ABEy/3V4HrUTcxcn3EqrGTyY
         Cc8A==
X-Gm-Message-State: AOAM531MVoB84LDJlmuJhy9tm8ZQInJsMX3csexksKy8SY8St2xiP+/k
        zWPv+4bEoCc//tajBRS6PkKRcjCXJ5QDsvWZ0lybkRHpC2bSVJ0HlS3TRuqDBGMVmtZ40HBeYgP
        kKVuel7TstgmjDosD
X-Received: by 2002:a37:2708:0:b0:6a3:ad4e:f2d7 with SMTP id n8-20020a372708000000b006a3ad4ef2d7mr7300747qkn.571.1653476507570;
        Wed, 25 May 2022 04:01:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+fi4nzcfF/BgSg9tiNTyFvzZaxoWw4LuHDKGOFwFX+yu/pYEOcZBlUFHBHtTTmoapU+RCCQ==
X-Received: by 2002:a37:2708:0:b0:6a3:ad4e:f2d7 with SMTP id n8-20020a372708000000b006a3ad4ef2d7mr7300697qkn.571.1653476507034;
        Wed, 25 May 2022 04:01:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id l18-20020a05620a0c1200b0069fe1dfbeffsm1052000qki.92.2022.05.25.04.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 04:01:46 -0700 (PDT)
Message-ID: <42e84c99d8d254646fdfb66b001429fedd4c5830.camel@redhat.com>
Subject: Re: Softirq latencies causing lost ethernet packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "'greearb@candelatech.com'" <greearb@candelatech.com>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>
Cc:     "'tj@kernel.org'" <tj@kernel.org>,
        "'priikone@iki.fi'" <priikone@iki.fi>,
        "'peterz@infradead.org'" <peterz@infradead.org>
Date:   Wed, 25 May 2022 13:01:43 +0200
In-Reply-To: <50c8042451454d8e907dd026ed5a3d53@AcuMS.aculab.com>
References: <50c8042451454d8e907dd026ed5a3d53@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-25 at 09:01 +0000, David Laight wrote:
> I've finally discovered why I'm getting a lot of lost ethernet
> packets in one of my high packet rate tests (400k/sec short UDP).
> 
> The underlying problem is that the napi callbacks need to loop
> in the softirq code.
> For my test I need the cpu to be running at well over 50% 'softint'.
> (And that is just for the ethernet receive, RPS is moving the IP/UDP
> processing elsewhere.)
> 
> The problems are caused by this bit of code in __do_softirq():
> 
>         pending = local_softirq_pending();
>         if (pending) {
>                 if (time_before(jiffies, end) && !need_resched() &&
>                     --max_restart)
>                         goto restart;
> 
>                 wakeup_softirqd();
>         }
> 
> Eric's c10d73671 changed it from:
>         if (pending) {
>                 if (--max_restart)
>                         goto restart;
> 
>                 wakeup_softirqd();
>         }
> 
> to
>         if (pending) {
>                 if (time_before(jiffies, end) && !need_resched())
>                         goto restart;
> 
>                 wakeup_softirqd();
>         }
> 
> Because just running 10 copies caused excessive latencies.
> 
> The good work was then undone by 34376a50f that added the
> 'max_restart' check back (with its limit of 10) to avoid
> an issue with stop_machine getting stuck (jiffies doesn't
> increment).
> 
> This can (probably) be fixed by setting the limit to 1000.
> 
> However there is a separate issue with the need_resched() check.
> In my tests this is stopping the softint/napi callbacks for
> anything up to 9 milliseconds - more than enough to drop packets.
> 
> The problem here is that the softirqd are low priority processes.
> The application processes the receive the UDP all run under the
> realtime scheduler (priority -51).
> If the softint interrupts my RT process it is fine.
> But the following sequence isn't:
>  - softint runs on idle process.
>  - RT process scheduled on the same cpu
>  - __do_softirq() detects need_resched() calls wakeup_softirqd()
>  - scheduler switches from the idle to my RT process.
>  - RT process runs for several milliseconds.
>  - finally softirqd is scheduled
> 
> The softint is usually higher priority than any RT thread
> (because it just steals the context).
> But in the more unusual case of an RT process being scheduled
> while the softint is active it suddenly becomes lower priority
> than the RT process.
> 
> I'm sure what the intended purpose of the need_resched() is?
> I think it was eric's first thought for a limit, but he had to
> add the jiffies test as well to avoid RCU stalls.
> 
> The jiffies test itself might be problematic.
> It is fixed at 2 jiffies - 1ms to 2ms at 1000Hz.
> I'm expecting the softint code to be running at (maybe) 80% cpu.
> So that limit would need increasing.
> There is a similar limit in the napi code - but that is configurable
> (and, I think, just causes the softing code to loop).
> 
> But if RCU stalls are a problem maybe the rcu read lock ought to
> disable softints?
> So the softint is run when the rcu lock is released.
> 
> I did try setting the softirqd processes to a much higher priority
> but that didn't seem to help - I didn't look exactly why.
> 
> While I could use processor affinities to stop the application's
> RT threads running on the softint-heavy cpu that is all hard
> and difficult to arrange.
> In any case the application can make use of the non-softint time
> on those cpu.

Overall this looks like a scenario where the napi threaded model could
help?

echo 1 > /sys/class/net/<dev name>/threaded

and than set the napi threads scheduling parameter as it fit you
better.

Cheers,

Paolo

