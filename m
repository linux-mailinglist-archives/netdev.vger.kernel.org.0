Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11912E7873
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 19:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfJ1Sed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 14:34:33 -0400
Received: from mail-yb1-f175.google.com ([209.85.219.175]:45268 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfJ1Sed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 14:34:33 -0400
Received: by mail-yb1-f175.google.com with SMTP id q143so4399550ybg.12
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 11:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XuZVBPNVHOV/lYT6HFSUjO3ekOeALhnMwVwLviZbIew=;
        b=RNdCthK6XOl6jaU0cMlaao0aya+0jhpJ+5aeOlF7loj1QHJukzKTiAWuRwI5cCQmXc
         YFP6FHJpkiV6+4qkM9szbm9EmzW69xhsAUHV+0lJhKqRQUOJ37tgj8d5awe+y2Lsb8mw
         egXv5WfHMm0+hsKUW84baQkGOIdE/5gKII3duYPYmQ2u9gzpnNi7EQJzpopuCQG683hV
         H/EBkBbG1EsvbL+xqLfBG2SF35RjX4OLRjV6v/VIY/9HwV1P1z3giFQR8Uy7AxO74P9t
         7lJ/qrLT34Igl/dGYS4QzaOkMTmmD98p+83jf/HKMVqKv1W8oan8RQdryaBqm4Ji9uCz
         cT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XuZVBPNVHOV/lYT6HFSUjO3ekOeALhnMwVwLviZbIew=;
        b=QM/9vN1Wpby7w2Mhu/L7J3vCGiFJD55oiDGVsLkUvaKJkVKWvuyxXyDS9SFcK0L5qv
         NFlipuJua/FT/jD0ch2LvnI7wpfArP22jKz4isz1wjUa0qAKeit11cCQ9jhk2edOjY8u
         aMusOIJ0vPR1a9i/Gp2JVjwTQC2ftxoKx4bLOmgDRYAFdx7SnL2a7PW7okFzJZrP+E97
         xpHD79EUNmrXhfEPt57wrhHcYzfDxEzZtmmwOyeVb7KJchdiqX/Yz+qRgB2x31Y5y/DJ
         1IKmEPIwzRUc2Ns4L/Z01yKm4Bmsso3PpeCS5ZAdohGTAK/hMwMGCoPMguR4y+75zgpt
         awTQ==
X-Gm-Message-State: APjAAAWeDYpXiudQGQMSKbwvmC5LUuBvr0NYzbVVIHyVzXWcAcXO7yy+
        0paZ+6N7Co2VvwvpYkP0FS1DhlPbxGYVsMQ9g22Lpg==
X-Google-Smtp-Source: APXvYqxkzaJMcoK0z3hqPEUB7wPcJ5NNmf40cBWej5p5FC/nve/TXNyCaMWcpjvDAIwxlrLEoNI2G6NdEf+0At4PnuA=
X-Received: by 2002:a25:a085:: with SMTP id y5mr15553018ybh.408.1572287670182;
 Mon, 28 Oct 2019 11:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191022231051.30770-1-xiyou.wangcong@gmail.com> <20191028.112904.824821320861730754.davem@davemloft.net>
In-Reply-To: <20191028.112904.824821320861730754.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 28 Oct 2019 11:34:18 -0700
Message-ID: <CANn89iKeB9+6xAyjQUZvtX3ioLNs3sBwCDq0QxmYEy5X_nF+LA@mail.gmail.com>
Subject: Re: [Patch net-next 0/3] tcp: decouple TLP timer from RTO timer
To:     David Miller <davem@davemloft.net>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 11:29 AM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Tue, 22 Oct 2019 16:10:48 -0700
>
> > This patchset contains 3 patches: patch 1 is a cleanup,
> > patch 2 is a small change preparing for patch 3, patch 3 is the
> > one does the actual change. Please find details in each of them.
>
> Eric, have you had a chance to test this on a system with
> suitable CPU arity?

Yes, and I confirm I could not repro the issues at all.

I got a 100Gbit NIC, trying to increase the pressure a bit, and
driving this NIC at line rate was only using 2% of my 96 cpus host,
no spinlock contention of any sort.

Thanks.
