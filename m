Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A5818BFA4
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCSSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:50:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33660 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbgCSSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 14:50:05 -0400
Received: by mail-oi1-f196.google.com with SMTP id r7so3884338oij.0
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 11:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rBBTCQZKvZ6z4WK9Xo1ZHxbyAdL21+7byNbe/ZRuw0c=;
        b=XhFaroa4eCglvWBaLqoGx9MgoSQz08cJbXAW+83d3oq38J3kmKbdac+qe8tbsyz94f
         fde9FijEu0Pzf5ZAlj3fP+vxLSdHGeuVBdAtLpmPCnHONapIvWZtlQMa5MHdKDcpiJ0C
         TQaPnJ6G34x4x4Cry5MRohLUZfdeJp128ssM45FGAS7+Tdy9+di26+87e5KE1aFT4iz5
         0Zp/ALBc7761shhRrNpVICP/w4M9jwwI3lsb1/l+ogXAX3QsvQP+JG/Z89FuzVpYavN9
         v+lu/05VA57PfymQrFLy2eDtyisWBiFnwivFX4Y9/LQmUW3+9ARBhu3XFhcIAKAzDVkT
         Q/fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rBBTCQZKvZ6z4WK9Xo1ZHxbyAdL21+7byNbe/ZRuw0c=;
        b=PeJfVJisMpaIMcsoxxZCZ72eRc6Hrf5YpFZEydjnBo3pHRKOwx/FZ6+X2K08boLFI+
         rk2kOKLc9/Np4F5T73g73pC7Vl6p59JKKAK/Rq994pQfnyhLf0+C2bqjhtz1u0ziknhb
         P/+BzIoqL803GeZNDrTXGIsoq+PE5knq9qkoJ2tdl5jcqw/MPQ0Od87rs/I3NQDsT/Q2
         Q5c2yhOaNuMTyqnrKnqo74kGwjY2Jp5EsH60+RhCRpnctRfxNo/lwgdJ30+ooNXNaHAF
         imm68bePGkbG7RPDlS3oMlrTzDQFdy+DSq7ziOla5R1cugRd2L142U6DaSgz16oM+HDA
         5lxg==
X-Gm-Message-State: ANhLgQ2618ZAcQzjmqYF6kU13svZWsK0YWN1fGk8tVMSE4szDhQRNzfa
        WOoD5rJiXT0Dl6o8iohrSUWc1Sz/pGeNMkhjPlP+qw==
X-Google-Smtp-Source: ADFU+vuAW/xF8TkO8eugnikWDkJB3BbwaXLHQAim9ZR2gRbQodWFKChBMp92mydkZkVObyLhhkazzZcB5/RxEl5bXFs=
X-Received: by 2002:a05:6808:48d:: with SMTP id z13mr3348154oid.79.1584643804372;
 Thu, 19 Mar 2020 11:50:04 -0700 (PDT)
MIME-Version: 1.0
References: <1584599549-6793-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1584599549-6793-1-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 19 Mar 2020 14:49:47 -0400
Message-ID: <CADVnQy=FGds+0DLeqg2hZ1Z3gWGp41WNmiJf9hVaLy0NwbieAQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] tcp: make cwnd-limited not affected by tcp
 internal pacing
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Kevin Yang <yyd@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 2:33 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> The current cwnd-limited is set when cwnd is fully used
> (inflight >= cwnd), which allows the congestion algorithm
> to accurately determine whether cwnd needs to be added.
>
> However, there may be a problem when using tcp internal pacing:
> In congestion avoidance phase, when a burst of packets are
> acked by a stretched ACK or a burst of ACKs, this makes a large
> reduction in inflight in a short time. At this time, the sender
> sends data according to the pacing rate cannot fill CWND and
> cwnd-limited is not set. The worst case is that cwnd-limited
> is set only after the last packet in a window is sent. This causes
> the congestion algorithm to be too conservative to increase CWND.
>
> The idea is that once cwnd-limited is set, it maintains a window period.
> In this period, it is considered that the CWND is limited. This makes
> the congestion algorithm unaffected by tcp internal pacing.
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---

Thanks for sending this patch! We ran into this bug in our team
recently as well, and have been working on iterating on patches to fix
it.

I think this particular proposal in this patch does not properly
persist the max_packets_out until all the ACKs have been received for
a flight of data. The consequence of this would be that the cwnd does
not grow properly in slow-start for cases where the max_packets_out is
high enough to merit growing cwnd, but the connection is not strictly
cwnd-limited.

I'm a bit busy this week but I will try to put together and send out a
proposed patch ASAP.

best,
neal
