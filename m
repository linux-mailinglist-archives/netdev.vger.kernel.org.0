Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF67ADFDF
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 22:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405957AbfIIUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 16:19:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46963 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732979AbfIIUTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 16:19:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so14454085qkd.13;
        Mon, 09 Sep 2019 13:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfisevVfjNvcs85pGlZIDsl1nyYzUD6gyExOAqZGTlk=;
        b=M1ZB9gdMN6aPaTUu2FeQzTnUhDhCmckQCEzqsBJp0T91f8ncVtY29tQk+czo5C5HQe
         rDvSA3H6ywupmpjUo4PfpbXe+9N2fLizf3eME7gxcOCKJGJaIG2kd0rSZJ+61rqNc7u8
         MCXfzG5hYyARUBHUBn4F/Ae9zsuwe5ZJZfXTPbIid3g9vU9FXcV3FUL4goyhYYeJlymj
         4LoI2pYAzleIMnTUAIb5Iq/5X3KEffdvUhHx6jOX5jlobi6IZYXBzw8+vS6zwlZYU23u
         3XNOwHNxIl3eK3zqZtnwsmsGW78VP+ERPyIPOIcSKGEio2ZVoQQNF9nUR5DIs75cqaYZ
         mdEw==
X-Gm-Message-State: APjAAAVwAsjTSeMn3nGQgyzFhWsBmsw8a7NaA0I7wxW9NCoksTAxy+DS
        Sf04pPwKav5CB5csEdQn7VvgPjkcWwgycbBJML8=
X-Google-Smtp-Source: APXvYqx0v4mZVfbJo+BtvGaJ+uiLmoOPCwu1inOas1Do/CWtoljKz+2fnTV9LOQAEHedUF5SwlGEeqE+sPzPqKI8vIs=
X-Received: by 2002:ae9:ee06:: with SMTP id i6mr4894922qkg.3.1568060344800;
 Mon, 09 Sep 2019 13:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190906151123.1088455-1-arnd@arndb.de> <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
In-Reply-To: <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 9 Sep 2019 22:18:48 +0200
Message-ID: <CAK8P3a0_VhZ9hYmc6P3Qx+Z6WSHh3PVZ7JZh7Tr=R1CAKvqWmA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in FW tracer
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>, "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 9, 2019 at 9:39 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Fri, 2019-09-06 at 17:11 +0200, Arnd Bergmann wrote:
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
> > @@ -557,16 +557,16 @@ static void mlx5_tracer_print_trace(struct
> > tracer_string_format *str_frmt,
> >                                   struct mlx5_core_dev *dev,
> >                                   u64 trace_timestamp)
> >  {
> > -     char    tmp[512];
> > -
>
> Hi Arnd, thanks for the patch,
> this function is very perfomance critical when fw traces are activated
> to pull some fw content on error situations, using kmalloc here might
> become a problem and stall the system further more if the problem was
> initially due to lack of memory.
>
> since this function only needs 512 bytes maybe we should mark it as
> noinline to avoid any extra stack usages on the caller function
> mlx5_fw_tracer_handle_traces ?

That would shut up the warning, but doesn't sound right either.

If it's performance critical indeed, maybe the best solution would
be to also avoid the snprintf(), as that is also a rather heavyweight
function?

I could not find an easy solution for this, but I did notice the unusual way
this deals with a variable format string passed into mlx5_tracer_print_trace
along with a set of parameters, which opens up a set of possible
format string vulnerabilities as well as making mlx5_tracer_print_trace()
a bit expensive. You also take a mutex and free memory in there,
which obviously then also got allocated in the fast path.

To do this right, a better approach may be to just rely on ftrace, storing
the (pointer to the) format string and the arguments in the buffer without
creating a string. Would that be an option here?

A more minimal approach might be to move what is now the on-stack
buffer into the mlx5_fw_tracer function. I see that you already store
a copy of the string in there from mlx5_fw_tracer_save_trace(),
which conveniently also holds a mutex already that protects
it from concurrent access.

       Arnd
