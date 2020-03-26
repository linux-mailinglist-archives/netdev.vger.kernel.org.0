Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B547B194443
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgCZQ14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 12:27:56 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:41059 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgCZQ14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 12:27:56 -0400
Received: by mail-il1-f194.google.com with SMTP id t6so2322624ilj.8;
        Thu, 26 Mar 2020 09:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2MvgnsSQhFJOcyx9F2ihbJOXdLnu/MGIqeeUoB2SLbM=;
        b=O+HVkvBErHFx61kmKWqwDVr9mM9NwxkP5CgHZkz8KKBG51hrYlwuKP26qg84OHsxVB
         0Csn9hEqw5zUtxAZ8hXbKJYonAGgMiW0oSwLVoWbnfKE7nmgDQTWRrmKkq0R3soBo1O6
         YA2xpd7O25TSRoBEZeQ7E95N53qbjw3fE5HCjUUKmtAeNikCAx8lmf4WzXJgNMiGFSJx
         c4+Rvjrk3GX2GNNId3q5hbOuLfTBkYt3mx/jzzQjOjWhqiNfneAMWR968ENRiKCvdJgC
         Lt4zrBYpUJM4uD/0sBT0Ucf0edmhAvR21jjC3t8qlxejtaMgYo1HetQF0xoeZiEQ/Df3
         Sgmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2MvgnsSQhFJOcyx9F2ihbJOXdLnu/MGIqeeUoB2SLbM=;
        b=MNkjxv5kWyr3Pe1Cl//9zeE5kC6LSuxM1nh5bRaOuSeBBVr/vqmMbCsj2KZUXtHdHF
         YsBnURRnnaoMhi4z++vAqr7EhE9pNcxcjmuEZYGp3X0PIbIThkxWgacIy8m28BpXqVlr
         DP8UHztCbTQy8iJ8x2u6maFqsLmj19r8izkXyt2PQ3KM+ABOQE42XoEXfoJQnwiFBzI+
         TS2l/tfu2k3oXmwf4RjNb/xVKFe/ojQjfuy3VuIdS20ZNi5JA5St29peQ22y5BcL6oUi
         Cd2CXMy5b4fAWsyJRqiQtNSAj40GMkWuclxDy9yQyqtSZjaBVzs5xMOkaZPJ6yCNz2Ip
         carw==
X-Gm-Message-State: ANhLgQ0zlqfs3WFGsjO5UaFGySfNHjyxCMqpCdNfy1/KZ3Qyz1H8GLDV
        9b8FJ9wfXpc515nlRFL5olRAZ4L+DNGRK5P19gQj6u2sw90=
X-Google-Smtp-Source: ADFU+vs3UUxKJvBojeAzB/v9NDT0zXbWaHLGTU3p4w5iPWYt+V3DgoqWyKdwP6CKCFaA8gpJqDpqts+2JawxmNNR4DE=
X-Received: by 2002:a92:3955:: with SMTP id g82mr9646493ila.237.1585240073233;
 Thu, 26 Mar 2020 09:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200326103926.20888-1-kai.heng.feng@canonical.com>
In-Reply-To: <20200326103926.20888-1-kai.heng.feng@canonical.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Mar 2020 09:27:42 -0700
Message-ID: <CAKgT0UfFnXcSSsXvxk8+xiZvyzDh+8V-9bCT-z5U+MEVoAVKLw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] igb: Use a sperate mutex insead of rtnl_lock()
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 3:39 AM Kai-Heng Feng
<kai.heng.feng@canonical.com> wrote:
>
> Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
> fixed race condition between close and power management ops by using
> rtnl_lock().
>
> This fix is a preparation for next patch, to prevent a dead lock under
> rtnl_lock() when calling runtime resume routine.
>
> However, we can't use device_lock() in igb_close() because when module
> is getting removed, the lock is already held for igb_remove(), and
> igb_close() gets called during unregistering the netdev, hence causing a
> deadlock. So let's introduce a new mutex so we don't cause a deadlock
> with driver core or netdev core.
>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

So this description doesn't make much sense to me. You describe the
use of the device_lock() in igb_close() but it isn't used there. In
addition it seems like you are arbitrarily moving code that was
wrapped in the rtnl_lock out of it. I'm not entirely sure that is safe
since there are calls within many of these functions that assume the
rtnl_lock is held and changing that is likely going to introduce more
issues.



> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index b46bff8fe056..dc7ed5dd216b 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -288,6 +288,8 @@ static const struct igb_reg_info igb_reg_info_tbl[] = {
>         {}
>  };
>
> +static DEFINE_MUTEX(igb_mutex);
> +
>  /* igb_regdump - register printout routine */
>  static void igb_regdump(struct e1000_hw *hw, struct igb_reg_info *reginfo)
>  {
> @@ -4026,9 +4028,14 @@ static int __igb_close(struct net_device *netdev, bool suspending)
>
>  int igb_close(struct net_device *netdev)
>  {
> +       int err = 0;
> +
> +       mutex_lock(&igb_mutex);
>         if (netif_device_present(netdev) || netdev->dismantle)
> -               return __igb_close(netdev, false);
> -       return 0;
> +               err = __igb_close(netdev, false);
> +       mutex_unlock(&igb_mutex);
> +
> +       return err;
>  }
>

Okay, so I am guessing the problem has something to do with the
addition of the netdev->dismantle test here and the fact that it is
bypassing the present check for the hotplug remove case?

So it looks like nobody ever really reviewed commit 888f22931478
("igb: Free IRQs when device is hotplugged"). What I would recommend
is reverting it and instead we fix the remaining pieces that need to
be addressed in igb so it more closely matches what we have in e1000e
after commit a7023819404a ("e1000e: Use rtnl_lock to prevent race
conditions between net and pci/pm"). From what I can tell the only
pieces that are really missing is to update igb_io_error_detected so
that in addition to igb_down it will call igb_free_irq, and then in
addition we should be wrapping most of the code in that function with
an rtnl_lock since it is detaching a device and making modifications
to it.
