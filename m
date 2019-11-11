Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BDF822F
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKKV0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:26:25 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38473 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKKV0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:26:25 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so11593268pfp.5;
        Mon, 11 Nov 2019 13:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S/dDooYdItgV3dLbLJwFFfSuew2iW89I9IXIwYwXJT8=;
        b=FURjo+S6eX+GpCTzL+4WYgJP0xbKD4mutUow02AJzUr3Mu/xqTmgWrCKIS4yHwbu2o
         TlaAO0kWY7FJpI7Kn4i92tOm5dVfzZiqwuwbRCu756b0G2rRPYNmK0Hp/uC9ehkzaA3i
         7MxMZljKrBSMHAcgTyo4qny8IKF7VCCDkgoQr+PUSeF2m2+itMy1iKrJJT6thyRvcmUw
         UdLSG99ni3iv3TrSPmcjypFrNwpLMCrBnOoQZQlvmjgZKa69e+SFPEK8YsG66duPyUJz
         FIzYtlRScjTVXBX7lIRpvOph9gozt8btjKQQe9/kFbZ+0k1wIeSvXcDVbfjykyQAtdEY
         eCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S/dDooYdItgV3dLbLJwFFfSuew2iW89I9IXIwYwXJT8=;
        b=S70XIyHNvIJa6kpNZcIRcV87VOLgUZu/uS7ARuoSTMgpv97s+deEn++AMc8Wr5G5eK
         oiQaauRE1yjAy4i3iFt/5ioUzpjogXpzIDQma/bqCVCDmt3e8NOsDcdQz/t0qqPmGNLc
         YxBWWJJbhGxs0Cu+dJHdUDb2nzq4z4e9+qgnIK290Gd303stRGkvPbFr5wnm/KQJAgZ6
         TF9baKxANdG5Mw4i0+POidWoQcMnW6hE367BO9EJ8W/cetlohPd5JwwmxGMUX7Zwl9bf
         qkccVQC1KHhkD+YF5780A8Zxk2LI66ddbxHxocrcwTSHI8dXmW4w0oXeSq0lXti+Cpmi
         yqSg==
X-Gm-Message-State: APjAAAXpfllMZ7XGFCsqgE9yVNwm4A8EZvwD9eWhcuPEzFag/kBdg462
        8NReA//RYysYVYRSQsGjOkRffHnz1BWY6fob4Hg=
X-Google-Smtp-Source: APXvYqzDtAPHhWESSr2uQPA5m1h2JhmEZlv/3xnWGoainOX2XoYPVefT+ORyUyE9fpcnPs4M+jW8Efqn5Pe1+ThDgwA=
X-Received: by 2002:a17:90a:326b:: with SMTP id k98mr1569237pjb.50.1573507584464;
 Mon, 11 Nov 2019 13:26:24 -0800 (PST)
MIME-Version: 1.0
References: <20191111140502.17541-1-tonylu@linux.alibaba.com>
In-Reply-To: <20191111140502.17541-1-tonylu@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 11 Nov 2019 13:26:13 -0800
Message-ID: <CAM_iQpUaPsFHrDmd7fLjWZLbbo8j1uD6opuT+zKqPTVuQPKniA@mail.gmail.com>
Subject: Re: [PATCH] net: remove static inline from dev_put/dev_hold
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>, shemminger@osdl.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 6:12 AM Tony Lu <tonylu@linux.alibaba.com> wrote:
>
> This patch removes static inline from dev_put/dev_hold in order to help
> trace the pcpu_refcnt leak of net_device.
>
> We have sufferred this kind of issue for several times during
> manipulating NIC between different net namespaces. It prints this
> log in dmesg:
>
>   unregister_netdevice: waiting for eth0 to become free. Usage count = 1

I debugged a nasty dst refcnt leak in TCP a long time ago, so I can
feel your pain.


>
> However, it is hard to find out who called and leaked refcnt in time. It
> only left the crime scene but few evidence. Once leaked, it is not
> safe to fix it up on the running host. We can't trace dev_put/dev_hold
> directly, for the functions are inlined and used wildly amoung modules.
> And this issue is common, there are tens of patches fix net_device
> refcnt leak for various causes.
>
> To trace the refcnt manipulating, this patch removes static inline from
> dev_put/dev_hold. We can use handy tools, such as eBPF with kprobe, to
> find out who holds but forgets to put refcnt. This will not be called
> frequently, so the overhead is limited.

I think tracepoint serves the purpose of tracking function call history,
you can add tracepoint for each of dev_put()/dev_hold(), which could
also inherit the trace filter and trigger too.

The netdev refcnt itself is not changed very frequently, but it is
refcnt'ed by other things like dst too which is changed frequently.
This is why usually when you see the netdev refcnt leak warning,
the problem is probably somewhere else, like dst refcnt leak.

Hope this helps.

Thanks.
