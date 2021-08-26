Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F9C3F80E9
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 05:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhHZDXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 23:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbhHZDXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 23:23:21 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787B0C061757;
        Wed, 25 Aug 2021 20:22:34 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id c19-20020a9d6153000000b0051829acbfc7so1681302otk.9;
        Wed, 25 Aug 2021 20:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bUeZZcRUwgsVKTg9hbUOFpXsEAgjIJCFQuo9JR/6uzc=;
        b=Cd+PYR/CcyaKB2Dv5SB33p47LhOGWZXNOHn1EdmwVk1xcpzdrlZ6xHmaxnv2H1iPGf
         RWtP8SHbN3xokld1eM/pm5ttcqP5oEVT3y2TUXHs9mzHYDOL5ViUCwYYIhEstqF70Xfp
         WJuv/0dJdP/tOW4nFPoUoYJVY8ksZK6uTBcL2dfkCvEqvr9MPxqLKenyIHOEOED7k9fP
         mE1OcurZBALiFsM6WDqfM97C0n+lhT/e6Q4pbTF5SCAfMxtOP/qx8KGfQiJ1ujkQVkgf
         7i9VtdHZ42y7O9CHoQnhHn5VTuFgre5r3KC01v84y3Q2g+/0/OiXLFD9PY+X/ZGfUQCJ
         TbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bUeZZcRUwgsVKTg9hbUOFpXsEAgjIJCFQuo9JR/6uzc=;
        b=SRU+e5ThTLTMXDX4pKMR7WK33IC2oQIhNX84Ez8lTRZLi6mx6iGfRdgGSoo+MOFPBs
         RyEnlE4e5XZr+jNQhNSKJ9NIy2bnlWtAOOC5TB0TWOZKZ+fkCjdfp391nj6ZVpmATuwb
         dr8q+VufwfYc2IkO/HJoYTmeTWYhAtSmailOWtjjR1cS17hS8hqGvH+EAxBib9z6U1BZ
         OnMZnHX7Ty38mJvlNAYzmUdvzWyNQSjfDU72mKjEQdapMFsNIW2VWqJdhnuTIG2TVuxc
         J/H+75arsNBhEBPSFXscEK9PzibGU/NSJkMJpdOVXacXRQ0NgggeCs2mNH09beK6jKhC
         936w==
X-Gm-Message-State: AOAM530MPrf5WSBKNrF55IJnGJEvqqwsImurjUU3BHIAQIpvlC5UrAzT
        HtClxLCYPOFGnmh+KuMpvYM711kdOTaVaC3Wj8g=
X-Google-Smtp-Source: ABdhPJxgk1EqPZK7qA7ih/uquKPxaLzFqjR5sZ54uxK1N75LUQxoav/lMAWNN1uN0WKcEyzI+s06wNoInRxtLucaEAY=
X-Received: by 2002:a05:6830:20d0:: with SMTP id z16mr1331201otq.330.1629948153918;
 Wed, 25 Aug 2021 20:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210824071926.68019-1-benbjiang@gmail.com> <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net>
 <CAPJCdBmTPW5gcO6DO5i=T+R2TNypzbaA666krk=7Duf2mt1yBw@mail.gmail.com> <f9b97b7f-cb48-f0bf-2dfb-a13bf1296b19@linux.intel.com>
In-Reply-To: <f9b97b7f-cb48-f0bf-2dfb-a13bf1296b19@linux.intel.com>
From:   Jiang Biao <benbjiang@gmail.com>
Date:   Thu, 26 Aug 2021 11:22:23 +0800
Message-ID: <CAPJCdB=MF=PY0R+a1Ka9ymDvp9EXf2HbzosAC1sUh547EcAjOA@mail.gmail.com>
Subject: Re: [PATCH] ipv4/mptcp: fix divide error
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Jiang Biao <tcs_robot@tencent.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 at 01:56, Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
>
> On Tue, 24 Aug 2021, Jiang Biao wrote:
>
> > Hi,
> >
> > On Tue, 24 Aug 2021 at 15:36, Matthieu Baerts
> > <matthieu.baerts@tessares.net> wrote:
> >>
> >> Hi Jiang,
> >>
> >> On 24/08/2021 09:19, Jiang Biao wrote:
> >>
> >> (...)
> >>
> >>> There is a fix divide error reported,
> >>> divide error: 0000 [#1] PREEMPT SMP KASAN
> >>> RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
> >>> RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992
> >>
> >> Thank you for this patch and validating MPTCP on your side!
> >>
> >> This issue is actively tracked on our Github project [1] and a patch is
> >> already in our tree [2] but still under validation.
> >>> It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
> >>> Fix it by adding protection in mptcp_push_release.
> >>
> >> Indeed, you are right, info->mss_now can be set to 0 in some cases but
> >> that's not normal.
> >>
> >> Instead of adding a protection here, we preferred fixing the root cause,
> >> see [2]. Do not hesitate to have a look at the other patch and comment
> >> there if you don't agree with this version.
> >> Except if [2] is difficult to backport, I think we don't need your extra
> >> protection. WDYT?
> >>
> > Agreed, fixing the root cause is much better.
> > Thanks for the reply.
> >
>
> Hi Jiang -
>
> Could you try cherry-picking this commit to see if it eliminates the error
> in your system?
>
> https://github.com/multipath-tcp/mptcp_net-next/commit/9ef5aea5a794f4a369e26ed816e9c80cdc5a5f86
>
ok, I'll try and give you feedback.

Regards,
Jiang
