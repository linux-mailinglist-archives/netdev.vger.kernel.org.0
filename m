Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040B73005A5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbhAVOiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbhAVOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 09:38:00 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51351C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 06:37:15 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id 186so3074340vsz.13
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 06:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWVqs/bI9wwr3tSnltmuSBGXJrYR6JzaEPLhsLUOb2w=;
        b=vNbj/DD/Msv/wACPFyJoexQkB0cazUlpSKezfd/S887z7Q+D4b+liGMCx6Lcm5Oi5+
         SER7t52tQ4Q3rcb7i0UtijjXx7IUf/RdksI7IeS5z00VnkrQ9zkbFHjkVYP+/+vJgZ4n
         sOhH7Ai9fYfhG8KXKsYKiHthQn0YJ5apd+XVtW0tk7TAuQWHrIex1Zsd4qxaYOBMsf9A
         4SHg4M5N1QrlOf40SWq9yHQmua6ZLpDMPreUd4sZOSkdYJZovIcUZQqBLnkCCL7zmQ7m
         1Xl+JYyWdQtm8zI34oxxlE2iseZYi+MtcOcQcxgghiRea2/SNyYIhXiBt92fCl1bXOZG
         Oe6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWVqs/bI9wwr3tSnltmuSBGXJrYR6JzaEPLhsLUOb2w=;
        b=baV5vMR+g0Yurgf9d1Gxtsn2PWJU7Aw3oRuJdG0w3SdTkxcOp0ChLlN0quXix/AbHh
         Vmo35wO0EvKYEaV/jOMSk3M7BZrVf9JoJTjrJEDfAM4KAvvecaKN8hyGA76GcWA1EvOu
         EzxsJzRBHB326qEZJ2CyHkcK4/Wq8dqo9zCAk/Mnl6zYrlj6gr89sKdgvFPvNcuhMZq1
         bLMfHpwrwdknXN5kjj5ze9Yh38myWPkgkRFsxJTF6T1FbYT2uCLfYiYfeX4VKCuk1UFe
         q0CM083itAIrutsZvZNisYoZeXmp8U9UcY1JNR9uYr/4SYOm2sXCrv3hwxYLjJmxhF8I
         FiFg==
X-Gm-Message-State: AOAM532+9CYOGKqBPvMGn6E8JVOSzAtm9ahHHmn9NO51txnSBaXUKpUR
        C2zYsn5ZJTAEDg2RqEKs6lmPho+4VH9ncm+8M1yPPQ==
X-Google-Smtp-Source: ABdhPJwZtwXw4vHnYNQuq50JH5MFq1Wr5I5Cdl81C1Rpehkkd0FyVI7zlSVPnsrquojJ0Q+m262lWqHvTkA5gLRmHm0=
X-Received: by 2002:a67:7956:: with SMTP id u83mr951182vsc.54.1611326234187;
 Fri, 22 Jan 2021 06:37:14 -0800 (PST)
MIME-Version: 1.0
References: <1611311242-6675-1-git-send-email-yangpc@wangsu.com> <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com>
In-Reply-To: <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 22 Jan 2021 09:36:57 -0500
Message-ID: <CADVnQynw7_4wJTUBHTnQ91rEoXKK+LuS1NQHdpYNhQs3CnMfsg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>,
        Yuchung Cheng <ycheng@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 5:53 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > change from DISORDER to OPEN. If the sender is app-limited, it can only
> > wait for the RTO timer to expire and retransmit.
> >
> > The reason for this is that the TLP timer is set before CA_STATE changes
> > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > until after tcp_fastretrans_alert() returns and remove the
> > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> >
> > This commit has two additional benefits:
> > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > avoid spurious RTO caused by RTO timer early expires.
> > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > timer is set.
> >
> > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > ---
>
> This looks like a very nice patch, let me run packetdrill tests on it.
>
> By any chance, have you cooked a packetdrill test showing the issue
> (failing on unpatched kernel) ?

Thanks, Pengcheng. This patch looks good to me as well, assuming it
passes our packetdrill tests. I agree with Eric that it would be good
to have an explicit packetdrill test for this case.

neal
