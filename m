Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCE631ED4A
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhBRR1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhBROGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 09:06:11 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830BDC06178B
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:04:15 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id c1so1421664qtc.1
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 06:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ITK2W56ft818ZWt4QDSd8KlN0Y5ANnHZi1kSURRPbHU=;
        b=wM5YG8NVcZQLBM6znd53hm2kK+Eu+SfLU58yysPJAQGtMmp967qgN7o9dga2Rqk9oa
         OtBVqKvYND/GxH2wY9N+wcTzd01j7CfEsU/LQPNHbydX8rJ3Wk/tYuMdzMatdkHqx3G1
         q90OymzVLBUTSXtAE1/P8qPJODvLKDLORunh0LDlwrRtMFtOPA06x8ydVq6c9g0G7JyH
         G1zKYud+5V8PoGSsGMHNdxuJcJ9sEqDSNWHQ0iuHSgdPNoQlQ/85tLYcYzVu3UHO+FJb
         KcBBC1/kK1fCacKF1vxA8QnHjtvwgJVs0AFvIozaDLyAO5CK4eGboTo1pOZuJBxGFld7
         Zsow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ITK2W56ft818ZWt4QDSd8KlN0Y5ANnHZi1kSURRPbHU=;
        b=EbiOc6qEvxAe7tZqKZVTe7Vw79epODWH5XGzPXHtHsOTm5Lz8hG+L1+wmPVBSOM+35
         1PkmmKZwXwmpUImWcPQaOqi+2eUfjanto8CHTq2lPRf277na9gkKTmOKcgHPdHuEWZSC
         WUOHIlR9xqRDminuooP/5+MeQr5+AZ6fd4ET3qIBGlKXCOWj4lCcoqR1l2o5G+zrIkro
         LqUjVbOxABN2xXgE6VbQ2yWcI59rq8Qb4p4YBY50SF/JQ5dXfgXe+IFKo30t4GHFnWBr
         0a0aA8fA5DD0tSq9GstxYQz2rmCFssBLOmcDuX63rveTvxxoRxPVPpBEAa/oinBPFKJl
         PX1A==
X-Gm-Message-State: AOAM531aAr+imG/1A/qFynbCcGsz9FWH+NKbPC2aU5YaqYHw7ldTZh8t
        DFfsf9/cg7oO9cXFnm5sMOBav4i2rRmvR9hcFEQd7A==
X-Google-Smtp-Source: ABdhPJw24iQF+ujPFN4xeenJpr72+2HdskNaJoYNjojmbpduSAdsdODcinoq0tbzyPmGXusOepK0A3jymEkxOPB3TQY=
X-Received: by 2002:ac8:7514:: with SMTP id u20mr4288204qtq.66.1613657054203;
 Thu, 18 Feb 2021 06:04:14 -0800 (PST)
MIME-Version: 1.0
References: <000000000000787b8805bb8b96ce@google.com> <639082dd7bddce31122200cc0e587c482379d1a7.camel@redhat.com>
In-Reply-To: <639082dd7bddce31122200cc0e587c482379d1a7.camel@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 18 Feb 2021 15:04:02 +0100
Message-ID: <CACT4Y+b3nZ=SXbRo7FUV5BO4r1kyPyPSUXG9=TNWBtOzLRFa_g@mail.gmail.com>
Subject: Re: possible deadlock in mptcp_push_pending
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot <syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 1:41 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2021-02-17 at 09:31 -0800, syzbot wrote:
> > syzbot found the following issue on:
> >
> > HEAD commit:    c48f8607 Merge branch 'PTP-for-DSA-tag_ocelot_8021q'
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16525cb0d00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=d1b1723faccb7a43f6d1
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+d1b1723faccb7a43f6d1@syzkaller.appspotmail.com
> >
> > ============================================
> > WARNING: possible recursive locking detected
> > 5.11.0-rc7-syzkaller #0 Not tainted
> > --------------------------------------------
> > syz-executor.1/15600 is trying to acquire lock:
> > ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1598 [inline]
> > ffff888057303220 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp_push_pending+0x28b/0x650 net/mptcp/protocol.c:1466
>
> Even this one is suspected to be a dup of 'WARNING in dst_release': the
> subflow socket lock family is reported to be 'sk_lock-AF_INET6', but
> subflows are created in kernel, and get 'k-sk_lock-AF_INET6'. This
> looks like [re]use after free, likely via msk->first, as in the
> suspected dup issue. Lacking a repro, I'm not 110% sure.
>
> @Dmitry, I'm wondering which is the preferred course of action here:
> tentatively marking this one as a dup, or leaving it alone till we get
> a reproducer?

Hi Paolo,

I don't have a strong opinion. Either way will work, especially since
this seems to happen regularly. Or, submit a fix and wait to see if
this stops happening or not.
