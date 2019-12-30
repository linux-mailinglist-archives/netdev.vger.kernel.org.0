Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB56F12D165
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 16:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfL3PPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 10:15:33 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46130 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbfL3PPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 10:15:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id k8so29437377otl.13
        for <netdev@vger.kernel.org>; Mon, 30 Dec 2019 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gftoodf3UOMrss5VLzXpaPA7ICiaDFzEeQJNPNT/ldY=;
        b=PpZZvS/tw4InRiwrDqxUnBW6x5eCWvJaOxn+iaUi22UqeMR4nuj83P6ce4YeFhpevb
         eJJ1UzCz5A/58M5neSGDGeoNxe9+ME5i/bJfpshZDOryQGSNxzsIexAwwgweWsFxSLy8
         n6fGcnaiapybQvBtmxdjYRC0j6YJzct54PiFgiBXKJj4ZzbJWzXIUcih+WQa64Gj9czH
         kV2SoLymwH2JtHxH1lqSh+Ulh2/cW8BZaifJ+0aac+6jxKNa1bkaPjEKCZwWnHW8BRpb
         Ad0j0Mfivz164u2HZFu0+Zt8qVFo97vqHjjRLfUchYVQzisfoBfnObkwFRVe5w/BpJBX
         SbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gftoodf3UOMrss5VLzXpaPA7ICiaDFzEeQJNPNT/ldY=;
        b=PACfSnvMJAnaiUYNViCWGdNtgddCJcDlJZI5CtjA/PtXwXqzXCdhEsjOWJM0/mu3RV
         B5fbZKytnRby9jUjGExlnqreQzP/scaZw9UlOevdNE9B89W0LcCmhdfrP8ro/rkOfQcN
         aNEWAqEhFQIeIZUXkt1ilWILJLvo2cWgo3zWHsm1hquZjED6tHKDiXJOA/0Hh/8leAsn
         S16oyBiORu8omKUOUiH4td1zygxbuqJHbCh9FKZIuFIwurII+pxfLKt2mH/XGF88H9db
         yBdWNkbNSDK8WXQwMT2IsOPBUqvO9QkWTfNixxym6hsVy1mBICcjHOlZYHweTSTSJh1P
         qLYQ==
X-Gm-Message-State: APjAAAVUzJc9bhxiyzONN9hahk56pWf85NoIRMfzRXmymhfZur3rxouQ
        EpuVXRdoVzpFxYsBywANgWQPrrokMBSAlZARnmWIbw==
X-Google-Smtp-Source: APXvYqypuaQ6XOSuw2C9shmtPEvd26q7CG57upNG/28g2q+CVoHCQ8cgQm8SOIZVw1Kz+GLDrMOUSGFKPbjs2vDNeZM=
X-Received: by 2002:a9d:4c94:: with SMTP id m20mr72838757otf.341.1577718931520;
 Mon, 30 Dec 2019 07:15:31 -0800 (PST)
MIME-Version: 1.0
References: <20191230140619.137147-1-edumazet@google.com>
In-Reply-To: <20191230140619.137147-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 30 Dec 2019 10:15:15 -0500
Message-ID: <CADVnQynUzSEAH0OFuc=yy0cYpJLhVutiFy8Bp8KxbcpEr=ZoDA@mail.gmail.com>
Subject: Re: [PATCH net] tcp_cubic: refactor code to perform a divide only
 when needed
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

On Mon, Dec 30, 2019 at 9:06 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Neal Cardwell suggested to not change ca->delay_min
> and apply the ack delay cushion only when Hystart ACK train
> is still under consideration. This should avoid a 64bit
> divide unless needed.
>
> Tested:
>
> 40Gbit(mlx4) testbed (with sch_fq as packet scheduler)
>
> $ echo -n 'file tcp_cubic.c +p'  >/sys/kernel/debug/dynamic_debug/control
> $ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpaa24 -l -4000000; done;nstat|egrep "Hystart"
>   14815
>   16280
>   15293
>   15563
>   11574
>   15145
>   14789
>   18548
>   16972
>   12520
> TcpExtTCPHystartTrainDetect     10                 0.0
> TcpExtTCPHystartTrainCwnd       1396               0.0
> $ dmesg | tail -10
> [ 4873.951350] hystart_ack_train (116 > 93) delay_min 24 (+ ack_delay 69) cwnd 80
> [ 4875.155379] hystart_ack_train (55 > 50) delay_min 21 (+ ack_delay 29) cwnd 160
> [ 4876.333921] hystart_ack_train (69 > 62) delay_min 23 (+ ack_delay 39) cwnd 130
> [ 4877.519037] hystart_ack_train (69 > 60) delay_min 22 (+ ack_delay 38) cwnd 130
> [ 4878.701559] hystart_ack_train (87 > 63) delay_min 24 (+ ack_delay 39) cwnd 160
> [ 4879.844597] hystart_ack_train (93 > 50) delay_min 21 (+ ack_delay 29) cwnd 216
> [ 4880.956650] hystart_ack_train (74 > 67) delay_min 20 (+ ack_delay 47) cwnd 108
> [ 4882.098500] hystart_ack_train (61 > 57) delay_min 23 (+ ack_delay 34) cwnd 130
> [ 4883.262056] hystart_ack_train (72 > 67) delay_min 21 (+ ack_delay 46) cwnd 130
> [ 4884.418760] hystart_ack_train (74 > 67) delay_min 29 (+ ack_delay 38) cwnd 152
>
> 10Gbit(bnx2x) testbed (with sch_fq as packet scheduler)
>
> $ echo -n 'file tcp_cubic.c +p'  >/sys/kernel/debug/dynamic_debug/control
> $ nstat -n;for f in {1..10}; do ./super_netperf 1 -H lpk52 -l -4000000; done;nstat|egrep "Hystart"
>    7050
>    7065
>    7100
>    6900
>    7202
>    7263
>    7189
>    6869
>    7463
>    7034
> TcpExtTCPHystartTrainDetect     10                 0.0
> TcpExtTCPHystartTrainCwnd       3199               0.0
> $ dmesg | tail -10
> [  176.920012] hystart_ack_train (161 > 141) delay_min 83 (+ ack_delay 58) cwnd 264
> [  179.144645] hystart_ack_train (164 > 159) delay_min 120 (+ ack_delay 39) cwnd 444
> [  181.354527] hystart_ack_train (214 > 168) delay_min 125 (+ ack_delay 43) cwnd 436
> [  183.539565] hystart_ack_train (170 > 147) delay_min 96 (+ ack_delay 51) cwnd 326
> [  185.727309] hystart_ack_train (177 > 160) delay_min 61 (+ ack_delay 99) cwnd 128
> [  187.947142] hystart_ack_train (184 > 167) delay_min 123 (+ ack_delay 44) cwnd 367
> [  190.166680] hystart_ack_train (230 > 153) delay_min 116 (+ ack_delay 37) cwnd 444
> [  192.327285] hystart_ack_train (210 > 206) delay_min 86 (+ ack_delay 120) cwnd 152
> [  194.511392] hystart_ack_train (173 > 151) delay_min 94 (+ ack_delay 57) cwnd 239
> [  196.736023] hystart_ack_train (149 > 146) delay_min 105 (+ ack_delay 41) cwnd 399
>
> Fixes: 42f3a8aaae66 ("tcp_cubic: tweak Hystart detection for short RTT flows")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>
> Link: https://www.spinics.net/lists/netdev/msg621886.html
> Link: https://www.spinics.net/lists/netdev/msg621797.html
> ---

Great!  Thanks, Eric.

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
