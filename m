Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47A2849530
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfFQWdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:33:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43504 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFQWdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:33:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so6531609pgv.10
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvpMcAU4IlTvoMtZwQO9v3Uk8QuLJ2xmdxsld5jOLeM=;
        b=vY7tQbidyQS64LOoqYLHv8TIJSaEzRM37+2PJMdZkDg8vANElZ3/ETy7WEEkOPnB9j
         s0vdZ4YlCNDb/eeJTtjbQ3oPrAQmWoS0zPANeuaRAS+pgYDTk6CEuHq5hF9PMkGjwOan
         G7bXH9gJPJXei8P4k9oatIpfdv+EIMlig+nNKjRrq3Z9dNmyYDmPI9SrJ5v9i/q3S9Gq
         Ym2uG6ZroQ4B6NT5w0mstWu0nczPsre8lUq3Mvflt08O7WXJx+paMnQnEzp8zKiRvkLg
         lY5f6COp0LY9i+Ba11flnwKGJd+1P65jvkDmGP+NyRRyvzXCM53Yum8c1uVRl8+htria
         OP3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvpMcAU4IlTvoMtZwQO9v3Uk8QuLJ2xmdxsld5jOLeM=;
        b=No6XJBOTMb1+GCqPArI9zq4FUxRC/RVbCOYpH5p79MeYLaaSdRih5J/1ezDu4y6Xhs
         R726PsyYkEUSjzieUgBbrnt/5mxI7cJ6mRXO1l/KK+9xjV1pbmcHAHIQP9l3ic7s4Wdg
         0++xITySOWAaIDZpNBfgJD0sgkGzTGyGylfMf9849HoxqPAUVnZlB9LxjzeZBNVYVrMF
         UxO5pN8d/ckWyx2zq2iu9J+hTW0gxTDiMQtLPfs72EfulV4i6+TrhM5ibYuPOHz/Ca8p
         dXd8Eb+jJw+zl8cqO9i8xwXHq+m+jQz6qenD5Mrlkqr+fi5+KUi7oiZLsmEkA7FUiTjM
         RUdA==
X-Gm-Message-State: APjAAAVvbZngKzh2pfrI6xo9TDRJE+FYgNMSs3rH05paCMlGv5dwraZL
        6meS//mckgQZ6NiOPgcsqHt1XxW6ox8l3ighINX6fNUJ1bI=
X-Google-Smtp-Source: APXvYqyCwsCVzJQiR2StbMKKVURUyI8mkPWMLl/znggAFIB+GpuL4iRrhh7JKNCCvfkFMoJPr7F7gz3KDWPs0K2c1Ow=
X-Received: by 2002:a17:90a:1d8:: with SMTP id 24mr1530663pjd.70.1560810789632;
 Mon, 17 Jun 2019 15:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190617181111.5025-1-jakub.kicinski@netronome.com> <20190617181111.5025-2-jakub.kicinski@netronome.com>
In-Reply-To: <20190617181111.5025-2-jakub.kicinski@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Jun 2019 15:32:57 -0700
Message-ID: <CAM_iQpWa=mTo6JCffh5dX5Y=8Nq+xBMhG0AqDx+9KrfGXz8wZg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] net: netem: fix backlog accounting for
 corrupted GSO frames
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        netem@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Eric Dumazet <edumazet@google.com>,
        posk@google.com, Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> When GSO frame has to be corrupted netem uses skb_gso_segment()
> to produce the list of frames, and re-enqueues the segments one
> by one.  The backlog length has to be adjusted to account for
> new frames.
>
> The current calculation is incorrect, leading to wrong backlog
> lengths in the parent qdisc (both bytes and packets), and
> incorrect packet backlog count in netem itself.
>
> Parent backlog goes negative, netem's packet backlog counts
> all non-first segments twice (thus remaining non-zero even
> after qdisc is emptied).
>
> Move the variables used to count the adjustment into local
> scope to make 100% sure they aren't used at any stage in
> backports.
>
> Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Looks good!

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
