Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF248939B
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 22:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfHKUWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 16:22:51 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44546 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfHKUWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 16:22:51 -0400
Received: by mail-ot1-f68.google.com with SMTP id b7so101673770otl.11;
        Sun, 11 Aug 2019 13:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LhCZsWxZ9N0cFWIcf2zFmzJDaTFv5khYxxXFoiFHFWc=;
        b=FmE07a+nY1HAiO1rZnpjtzbLGzfO6KldQ2bZDNtWHZSNJRnyWc2I/38EyigtGOYOw0
         IPbM6A5H333mRQrrA+lr4GYpR31LAKYRzEwuTOTqu52E+cDVQQp2rwhoc75LG/zje7bS
         2Fc/0PZa4y7COtYss1r79TGXFY7meEJuIPuaZZ3Kkrj23//Bqbi/VF2ia4XO2fqXmXC/
         VeblU1cEJY6iMkIQ+3YpiMCIxqr0XDX4VLlO8U7qaRGoTFruw3JQIt5/cQdPlvxNV6P7
         EE18/3a/p79DDBPHNbqzTci3O+XlfBZFJ4u/ZeP0epTf7sf2DFO1dwGeKsE+EDVRqL5H
         Rc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LhCZsWxZ9N0cFWIcf2zFmzJDaTFv5khYxxXFoiFHFWc=;
        b=gBVqSvRZLhPCwtkN2ndmpRTCnuGTrR6SuzReLVMvuYTv4BugfguVdalyPdS7fqVGLj
         1SqQPG/cZ4EeCPjtTVCGVPl6QJGBMjnzUXZt8Y6ZT4ZBd5r7for620ENHvkuThtOOc6N
         cSEaEMLHABIDM6Zv/XxUpDvVkpVGwaGpNsOfWnhCu3V/HD/46k9Kf8ETLdL9rtB7wV96
         NRksn1q6PbXEeSpRGC16rkIafbU9zLxOHvP1X4U3tg0tSe0BCr7QuUN1lauFa6OSnqeF
         hsWEG+972meWyfCvY7kUUMvTK96YhW1HjpemlVpTYbbyQqtN1tS5IZtjazelRmXocP3W
         LHIg==
X-Gm-Message-State: APjAAAWbWXNkXZRVgUIP5BQJ1+45LsXIygFsukcap2s2D1Cegt1EUhLn
        /KmDmhbaQ+oM+n4HHqUXx0rf6Zv4qIt2c+hrsgRiOg==
X-Google-Smtp-Source: APXvYqzN0e1ldEXQab16Pz+xVPTk//ZiZ63CKAj2OIYrK3ALilgswuz+hP1rq+AcMw7tJZFuiH5gXBCnPHjj9ZSrmtw=
X-Received: by 2002:a02:6d24:: with SMTP id m36mr34626709jac.87.1565554970465;
 Sun, 11 Aug 2019 13:22:50 -0700 (PDT)
MIME-Version: 1.0
References: <1565554067-4994-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565554067-4994-1-git-send-email-wenwen@cs.uga.edu>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 11 Aug 2019 13:22:39 -0700
Message-ID: <CAKgT0Ue_cSVDd6Tf9ji5zUCNEseAAzUtDG3BS6TEhR8Xh83xQQ@mail.gmail.com>
Subject: Re: [PATCH] net: ixgbe: fix memory leaks
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amritha Nambiar <amritha.nambiar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 1:08 PM Wenwen Wang <wenwen@cs.uga.edu> wrote:
>
> In ixgbe_configure_clsu32(), 'jump', 'input', and 'mask' are allocated
> through kzalloc() respectively in a for loop body. Then,
> ixgbe_clsu32_build_input() is invoked to build the input. If this process
> fails, next iteration of the for loop will be executed. However, the
> allocated 'jump', 'input', and 'mask' are not deallocated on this execution
> path, leading to memory leaks.
>
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index cbaf712..6b7ea87 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -9490,6 +9490,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
>                                 jump->mat = nexthdr[i].jump;
>                                 adapter->jump_tables[link_uhtid] = jump;
>                                 break;
> +                       } else {
> +                               kfree(mask);
> +                               kfree(input);
> +                               kfree(jump);
>                         }
>                 }
>                 return 0;

So I think this fix is still missing a good chunk of the exception
handling it should have. Specifically we will end up failing and then
trying to allocate for the next rule. It seems like we should probably
stop trying to program rules and unwind the work we have already done.

Also it would probably make sense to return an error if we are unable
to program one of the rules into the hardware. Otherwise things will
fail and the user will never know why.
