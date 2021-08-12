Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E8C3EABD4
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 22:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237537AbhHLUeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 16:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237366AbhHLUeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 16:34:08 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBEAC061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 13:33:42 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x5so6376447ybe.12
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 13:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JBlSJNWE0kgHB3yILg2YCGhJXNcBjFmQNMzr7P/X0Mo=;
        b=KLRfgDN6PJ7i92/r2gY2BnPyIEzEM6zhOf46xpQQ8NUY0HxhVeLk7j2mCQaHgZpczJ
         divtFXJmtEQNJPXGjDFiqLTmCXIFwOmoga25VSbR73NVFk8ttvskMzKu90jqSinp414y
         ClVMyOF3gNSiAw7eioJzNflc+U+VLnVImuN0DktyH12LT5lwG2RuI1lr6rmQYSmgsFgb
         RlYnJb3PYPGv1D6FzLzXB4eGndKegpgBpRppv0+JgT/H7fRW7dYSRX+qmnTGotbd3Tu9
         RIIF1OXYbC40be24uFXsglYWHrSvnC4Rw/lXvijddMZOwhXcC/AconznBXhSJV6JHFjr
         pjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JBlSJNWE0kgHB3yILg2YCGhJXNcBjFmQNMzr7P/X0Mo=;
        b=MyOI0jSy/ECrOPocJOOvNLvLfXimj7oH8W15ELxP1KfdLvvVBzxO0bL/DLjNg49MSX
         Zv4bGX3VJL9FLQ1tVggJfT8kVjn2I+D1L4lTj5nwbLS4LvSMV1kH3AC+3lC/qFOnwSR5
         Q+4kTchEYsZT8Ju7CYCbWLqPTtzahr2/+M/1CF2ETLSY/hmtUWJt2T+Aw4JnE9TPP9ox
         Cfwx9nRnPCK7q3Jre3m75eqtGTJL4AcEJokWNXDB7MNKKjZTzzp/wyo7dUlGFeNlWuwg
         puxlEPpU+qyxsCL9Ydhd6kG5vOZ2/6RVpipKc7wHMTWYsvUSPBpxT9whSFM1xIkDekju
         ATOw==
X-Gm-Message-State: AOAM533HCliOIR04+DoD7veo5SDQd7kagJ6+lA9X4jPRp8XXq/DZYvR3
        JMIF8b58LjGmOoxXiMm7E3uCfNpO5tQK0gn7vw5Edg==
X-Google-Smtp-Source: ABdhPJy/hLuxdDxPKkmi1R1PItSkZ0QG4aawDcaJ7zIxGeQAuBAdx6mKwimmoNo3nEUL0iLJ4+HWo3j1t7tPGwgq604=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr6671783ybj.504.1628800421249;
 Thu, 12 Aug 2021 13:33:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
 <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com> <a807dd9c-4f8a-c205-8fa0-01effdd54553@oracle.com>
In-Reply-To: <a807dd9c-4f8a-c205-8fa0-01effdd54553@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 Aug 2021 22:33:30 +0200
Message-ID: <CANn89iKx9JW8atr96MJHpU34C7c3Wm72cbxkxUJQmoj=mX2UoQ@mail.gmail.com>
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 7:37 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>
>
> On 8/12/21 12:53 AM, Eric Dumazet wrote:
> >          if (ousk->oob_skb)
> > -               kfree_skb(ousk->oob_skb);
> > +               consume_skb(ousk->oob_skb);
>
> Should I be using consume_skb(), as the skb is not being consumed, the
> ref count is decremented and if zero skb will be freed.
>

consume_skb() and kfree_skb() have the same ref count handling.

The difference is that kfree_skb() is used by convention when a packet
is dropped

Admins can look closely at packet drops with drop_monitor, or :

perf record -a -g -e skb:kfree_skb sleep 10
perf report

In your case, the oob_skb is not really dropped. It is replaced by
another one, it is part of the normal operation.
