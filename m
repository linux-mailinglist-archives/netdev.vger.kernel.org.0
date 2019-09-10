Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24F6AE538
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405145AbfIJIPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:15:13 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35881 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405050AbfIJIPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:15:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so19736716qtf.3;
        Tue, 10 Sep 2019 01:15:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pj4P7d4msDG9z+WyEQMeQ/b2Jubj1id8ACJalQ4i4z0=;
        b=L9d7BVTEJ24huElcaaE2n2VSCC/XuTbSs5NsZD4SeEiI0MK8reo+eSGNblyGKgn2jz
         LJMgIGwqur4DkUP0HgcOWKqf+X622WKc5iUJzRITgtbyYU/7WbQ3B7qw6e1OTvWEvHLg
         d7QeFiaAPHsJXg2h7czErjeMg7isnAggGrL0YjT3ywivtNqKJaR0D+by51+2SLn8KnIZ
         2jaSMBIYD3wpYyt5hxB63Iiw26IPktqtVP11ZB3P9tmvXnnCpSx8zEvXTSn3JqspgyyI
         noeJ4QvogsVQKRGXCJzg8PlZ9TENwNPEx/yLPyAsAt4M1a9V2s5G+ju+x4xt/a0VfxOk
         rchg==
X-Gm-Message-State: APjAAAXJ+roGYFPMNOFdNSqaZqWRqokg/pKSk6p+mOeVnhEOpfWMUAEJ
        2EGDNGWjJyV8dBidRB+XKw27g/CZHgS5mUvAJw8=
X-Google-Smtp-Source: APXvYqxRcJpR/dFP45hslcmwKU+zLCjl92rL4uXDF5FVw/tWIpOcHcO+Pg1e9C8Zuz9qkkRhnaOdUplpzg/kKEUGHks=
X-Received: by 2002:a0c:d084:: with SMTP id z4mr17113392qvg.63.1568103309691;
 Tue, 10 Sep 2019 01:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190906151123.1088455-1-arnd@arndb.de> <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
 <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com> <5abccf6452a9d4efa2a1593c0af6d41703d4f16f.camel@mellanox.com>
In-Reply-To: <5abccf6452a9d4efa2a1593c0af6d41703d4f16f.camel@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 10 Sep 2019 10:14:53 +0200
Message-ID: <CAK8P3a3q4NqiU-OydMqU3J=gT-8eBmsiL5tPsyJb1PNgR+48hA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in FW tracer
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 9, 2019 at 11:53 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Mon, 2019-09-09 at 22:18 +0200, Arnd Bergmann wrote:

> > To do this right, a better approach may be to just rely on ftrace,
> > storing
> > the (pointer to the) format string and the arguments in the buffer
> > without
> > creating a string. Would that be an option here?
>
> I am not sure how this would work, since the format parameters can
> changes depending on the FW string and the specific traces.

Ah, so the format string comes from the firmware? I didn't look
at the code in enough detail to understand why it's done like this,
only enough to notice that it's rather unusual.

Possibly trace_mlx5_fw might still get away with copying the format
string and the arguments, leaving the snprintf() to the time we read
the buffer, but I don't know enough about ftrace to be sure that
would actually work, and you'd need to duplicate it in
mlx5_devlink_fmsg_fill_trace().

> > A more minimal approach might be to move what is now the on-stack
> > buffer into the mlx5_fw_tracer function. I see that you already store
> > a copy of the string in there from mlx5_fw_tracer_save_trace(),
> > which conveniently also holds a mutex already that protects
> > it from concurrent access.
> >
>
> This sounds plausible.
>
> So for now let's do this or the noinline approach, Please let me know
> which one do you prefer, if it is the mutex protected buffer, i can do
> it myself.
>
> I will open an internal task and discussion then address your valuable
> points in a future submission, since we already in rc8 I don't want to
> take the risk now.

Yes, that sounds like a good plan. If you can't avoid the snprintf
entirely, then the mutex protected buffer should be helpful, and
also avoid a strncpy() along with the stack buffer.

      Arnd
