Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC43364A64
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 21:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhDSTUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239503AbhDSTUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 15:20:05 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96218C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 12:19:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id m12so4232353pgr.9
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 12:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFeRURNN1OfdLS0W1Y5M+rWaFeA+cTB6qaEybtCzIV0=;
        b=n8XcJ1YH1cfykov4+H9qnifm3c+Vtt6pgu3Y0uAjQk5QuxYw6ROI8+fATHFoCsAuy+
         j9AlnLMDRUV2wt81sQpC50Ok7qMhapdFzY03rAM6487Gx2SLHzat6G4OQ6Ih7+ksqt86
         bc3yzl5SQCXB5YjMuMPTf7RwrJtb4DiOfHUPjMgRuJMa38Twwx19gw5eNgAij7pCGnIA
         btco9J2u7H/8zwlg3mgolGxQtThj6YHE5lZoYR1O6NjtRi0VNnoCp4tqv3GMfIk11D3u
         n3cEypYbVDXS9HfwiyMFSipoL22T87I+uEIEQkwFMbfGxtSzQqCx/rf4nL2XtrZZZDhc
         5V1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFeRURNN1OfdLS0W1Y5M+rWaFeA+cTB6qaEybtCzIV0=;
        b=BXCte6c2VSkapb+tdRNMo56NJMv+2la7hYB1S5zcoSgc4lIbfz+NCS0urnAyZVW2eE
         iS7UjaLKHLh3ji4HXHgaF91olpRHWLL6xuCcPTUexZw/rKYVpwaG6CtU/Wbo659ZK9Q2
         RF/tLQ5+ZbG+9I2jFEJh0kkPRw4xXy/3RJ6XhegeEPjnCZMIvjB2OFVUx/DCU11xK0O+
         pshs563c7pbecCTo3HY4LOHxD9MWy7P39l6VNSjAv1GYDmmsbJdWYegSak2PK94c6Vne
         Q60llLXDGw/Y8kP7y1DkWgT/9b6XvvfjCqp+dr5f6pj6FuqB5NJcQ26TPxlYx2ZPxTJO
         7HAQ==
X-Gm-Message-State: AOAM533Aa8A/aBHpPHtMXNpus7gQG1LGmXHDcaBv3NM4PPQxMCkZdmCG
        tTc8jF/XCCR2uK6pECZKOX7zabcCyylC4BPFPuE=
X-Google-Smtp-Source: ABdhPJyO9uQy21Vc0uNUv1zOdH3WeSSJxWRa+SXOBmHxl5MvZS4CrtM3u/HHBMOIJWolYjMQ9egCY8sNe7P1kE9eXfc=
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id
 x20-20020a62fb140000b029022ee189c6b1mr21934850pfm.31.1618859975208; Mon, 19
 Apr 2021 12:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210416233046.12399-1-ducheng2@gmail.com>
In-Reply-To: <20210416233046.12399-1-ducheng2@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 19 Apr 2021 12:19:24 -0700
Message-ID: <CAM_iQpU-yNPQK1VBgfP9d=y80Gyh57VUrP6nxT5nKk=fF5_Stg@mail.gmail.com>
Subject: Re: [PATCH v4] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
To:     Du Cheng <ducheng2@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 4:30 PM Du Cheng <ducheng2@gmail.com> wrote:
>
> There is a reproducible sequence from the userland that will trigger a WARN_ON()
> condition in taprio_get_start_time, which causes kernel to panic if configured
> as "panic_on_warn". Catch this condition in parse_taprio_schedule to
> prevent this condition.
>
> Reported as bug on syzkaller:
> https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
>
> Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
> Signed-off-by: Du Cheng <ducheng2@gmail.com>

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
