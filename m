Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2395D12B608
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfL0RGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:06:23 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42107 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0RGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:06:23 -0500
Received: by mail-oi1-f194.google.com with SMTP id 18so8976863oin.9
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 09:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpSu5VCxqrcQulmYaPjYIIj+qJl+t5x/5c6ulHT7ET0=;
        b=JZiGA0kxAzUzffGBwe5WBw1RkvNSKBDea1G9kk7vRyISqPSELxaxPIrYPJcyvQwwT7
         TeaEqZvOzdQR8f+pUUqnTbDsUIt9hDZQG2AxIRjhqjo4u5dH3bF6pr+necDRck9SAyTA
         gwDOfsfKDJBpeQi7/SVog76sSLA9WrTm/5MdlfKCFjVMaiLrBX7BqEEpbvmHzGXbMlg4
         T/KqGuKuSDyaQP4MaDhr59dnNpO1zKU88jIYHDty+IaCoIelQmoqAj2xllGU+RtytuE3
         5n5zGzxT1iICU7CeeO6wMwZpkU9rPZiTjP0RHGh3AJhxnzV/XXiBDbJn5z9+5vmUS7j1
         MYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpSu5VCxqrcQulmYaPjYIIj+qJl+t5x/5c6ulHT7ET0=;
        b=cExtHERx5Cliu6m0B/CeoMQh/jDde4VidRXgIPFP5Nc803nqBXhv56qOrLqp/ph7bJ
         +z448g0zkxl2MBNqIYnvU0h4Lq8IU5T/TukgYJXHXATNHkOIcPSnB7NhZTuobW0f8kp4
         q3Dqdb5IJOoakotXn/OjNc7Mbs9ruR1hEeTyY91RyjFPV6OvlGnZvbfSH6/zdGRuBSK4
         szoh8Zgtw+ssx1q+KAODsAe8rLAzaQvNyh8OdSEZBa5RR+Ys6FGz4J9Li4ziRw26Ejp6
         tU4z5lNhOgKp5hpgUOqt1bVXW7IaVk9ezLaStSgXNFZxvUhy+IqQJoBPVENx3cpVxL4z
         gnJg==
X-Gm-Message-State: APjAAAUc0z8OGi2uIhlAczrpi4EAcWD3cGta9Q4XMXw40c3xJQeNBxvP
        JsFLTAIqKXMDvM5Z4bI8wHg6bFdMyEQ5eLp3LjnZYA==
X-Google-Smtp-Source: APXvYqw7Aj4zU1JMIusYMBsdE+bGbdOcn3qlX/6Gl6WlLRT2bCHw5eqJUGPyBMBnmsHOgDGUCm3AmHRUR0WqUb9z4rc=
X-Received: by 2002:aca:dfd5:: with SMTP id w204mr3975832oig.95.1577466381515;
 Fri, 27 Dec 2019 09:06:21 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com> <20191223202754.127546-6-edumazet@google.com>
In-Reply-To: <20191223202754.127546-6-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 12:06:05 -0500
Message-ID: <CADVnQy=-a4z57vD-9mHA9=oC0R3O0vtNPkpnfJQpTRt2vP2qGw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/5] tcp_cubic: make Hystart aware of pacing
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> For years we disabled Hystart ACK train detection at Google
> because it was fooled by TCP pacing.
>
> ACK train detection uses a simple heuristic, detecting if
> we receive ACK past half the RTT, to exit slow start before
> hitting the bottleneck and experience massive drops.
>
> But pacing by design might delay packets up to RTT/2,
> so we need to tweak the Hystart logic to be aware of this
> extra delay.
>
> Tested:
>  Added a 100 usec delay at receiver.
>
> Before:
> nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
>    9117
>    7057
>    9553
>    8300
>    7030
>    6849
>    9533
>   10126
>    6876
>    8473
> TcpExtTCPHystartTrainDetect     10                 0.0
> TcpExtTCPHystartTrainCwnd       1230               0.0
>
> After :
> nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
>    9845
>   10103
>   10866
>   11096
>   11936
>   11487
>   11773
>   12188
>   11066
>   11894
> TcpExtTCPHystartTrainDetect     10                 0.0
> TcpExtTCPHystartTrainCwnd       6462               0.0
>
> Disabling Hystart ACK Train detection gives similar numbers
>
> echo 2 >/sys/module/tcp_cubic/parameters/hystart_detect
> nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
>   11173
>   10954
>   12455
>   10627
>   11578
>   11583
>   11222
>   10880
>   10665
>   11366

I guess all these tests are with the "fq" qdisc with pacing enabled?

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv4/tcp_cubic.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)

Thanks, Eric. The revised heuristic for paced traffic seems like a
nice improvement.

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
