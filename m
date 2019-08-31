Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173E8A458C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfHaRRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 13:17:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38111 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbfHaRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 13:17:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id b2so7720920qtq.5
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 10:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=U9hinCX1QGNEU+4wMRh1h3RWjUpGxlDNe8QPh1hT+t8=;
        b=vSCf5wBzw0Y+tRoxzr7J1+q/5qSGnvnt3iW4UaapyNtuiGKO54OfvDdH004xbhctnM
         QhLOeFVeQPC8F3UJ9U3bHjh+fr0dqAQnjSQH97WWRQuteO02nsx+VtAqcP6t0aRv9oV/
         +qLwwcjgacw48Ho77lteeAKJz0gGUuAbHspRK0MFLFSdoPVd20y7oqKFuDsRerXl2JCu
         1pi1qKjD9kTDB+xyNp1IOpplgdknd7RT9/BcWKd0SU3mvxhdJUaAe48kipgQJO0JSykr
         Tm+YwTHpxuIfMFiDWiCxkWCeWBszGrig9Hw7Ey19D0JHeny7GmRMKDpADaUk+8qAvPXi
         Cx8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=U9hinCX1QGNEU+4wMRh1h3RWjUpGxlDNe8QPh1hT+t8=;
        b=OSVl8069MQ15PX0bf0nRCcniz3Ni7/QCleEH7r1X487PvGErbEuSmPy5ZqJwV4JHcW
         fCVk3svDCkFnFVJlT4M/F+Wct2bpuxPNKplY+z64qiONZwiH9LWM1MGoeJP839jFzvzo
         nPhm5/5rbvk9aQhuvjgB+ElgPutVar8VO6IbJJgmTsocNc37iyCRnEhwig08QhdBnUnr
         Oq47cVpst608g1I0ohFpXiUyWysXv6JPqqyQyzONmZmHk/iiLS2flYahlzF5Pp4Q0hvM
         bur5TFwsQrIym3S7UPtql4P+Nn/urjUuRISdFeBLaxlYwAPcL20iAvxZ7/gzM9TQGAiL
         x99A==
X-Gm-Message-State: APjAAAWYRMBP4a/i3Nyf/6QWsd0JHImV65h5NxcJIG3i/UEt0+Uw8l0g
        EIl07gSKYgGnLWybKfxYGXI=
X-Google-Smtp-Source: APXvYqxtWOKzYpkovKF77DMI4B1NylGr35hvOPUiJUSyN5ADS1M71/kBMsvtPYuncxD/AmfcEhmJDQ==
X-Received: by 2002:a0c:bf01:: with SMTP id m1mr5521230qvi.89.1567271848866;
        Sat, 31 Aug 2019 10:17:28 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u16sm4218487qkj.107.2019.08.31.10.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 10:17:28 -0700 (PDT)
Date:   Sat, 31 Aug 2019 13:17:27 -0400
Message-ID: <20190831131727.GD5642@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH] net: dsa: Fix off-by-one number of calls to
 devlink_port_unregister
In-Reply-To: <20190831124619.460-1-olteanv@gmail.com>
References: <20190831124619.460-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Aug 2019 15:46:19 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> When a function such as dsa_slave_create fails, currently the following
> stack trace can be seen:
> 
> [    2.038342] sja1105 spi0.1: Probed switch chip: SJA1105T
> [    2.054556] sja1105 spi0.1: Reset switch and programmed static config
> [    2.063837] sja1105 spi0.1: Enabled switch tagging
> [    2.068706] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
> [    2.076371] ------------[ cut here ]------------
> [    2.080973] WARNING: CPU: 1 PID: 21 at net/core/devlink.c:6184 devlink_free+0x1b4/0x1c0
> [    2.088954] Modules linked in:
> [    2.092005] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.3.0-rc6-01360-g41b52e38d2b6-dirty #1746
> [    2.100912] Hardware name: Freescale LS1021A
> [    2.105162] Workqueue: events deferred_probe_work_func
> [    2.110287] [<c03133a4>] (unwind_backtrace) from [<c030d8cc>] (show_stack+0x10/0x14)
> [    2.117992] [<c030d8cc>] (show_stack) from [<c10b08d8>] (dump_stack+0xb4/0xc8)
> [    2.125180] [<c10b08d8>] (dump_stack) from [<c0349d04>] (__warn+0xe0/0xf8)
> [    2.132018] [<c0349d04>] (__warn) from [<c0349e34>] (warn_slowpath_null+0x40/0x48)
> [    2.139549] [<c0349e34>] (warn_slowpath_null) from [<c0f19d74>] (devlink_free+0x1b4/0x1c0)
> [    2.147772] [<c0f19d74>] (devlink_free) from [<c1064fc0>] (dsa_switch_teardown+0x60/0x6c)
> [    2.155907] [<c1064fc0>] (dsa_switch_teardown) from [<c1065950>] (dsa_register_switch+0x8e4/0xaa8)
> [    2.164821] [<c1065950>] (dsa_register_switch) from [<c0ba7fe4>] (sja1105_probe+0x21c/0x2ec)
> [    2.173216] [<c0ba7fe4>] (sja1105_probe) from [<c0b35948>] (spi_drv_probe+0x80/0xa4)
> [    2.180920] [<c0b35948>] (spi_drv_probe) from [<c0a4c1cc>] (really_probe+0x108/0x400)
> [    2.188711] [<c0a4c1cc>] (really_probe) from [<c0a4c694>] (driver_probe_device+0x78/0x1bc)
> [    2.196933] [<c0a4c694>] (driver_probe_device) from [<c0a4a3dc>] (bus_for_each_drv+0x58/0xb8)
> [    2.205414] [<c0a4a3dc>] (bus_for_each_drv) from [<c0a4c024>] (__device_attach+0xd0/0x168)
> [    2.213637] [<c0a4c024>] (__device_attach) from [<c0a4b1d0>] (bus_probe_device+0x84/0x8c)
> [    2.221772] [<c0a4b1d0>] (bus_probe_device) from [<c0a4b72c>] (deferred_probe_work_func+0x84/0xc4)
> [    2.230686] [<c0a4b72c>] (deferred_probe_work_func) from [<c03650a4>] (process_one_work+0x218/0x510)
> [    2.239772] [<c03650a4>] (process_one_work) from [<c03660d8>] (worker_thread+0x2a8/0x5c0)
> [    2.247908] [<c03660d8>] (worker_thread) from [<c036b348>] (kthread+0x148/0x150)
> [    2.255265] [<c036b348>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> [    2.262444] Exception stack(0xea965fb0 to 0xea965ff8)
> [    2.267466] 5fa0:                                     00000000 00000000 00000000 00000000
> [    2.275598] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    2.283729] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [    2.290333] ---[ end trace ca5d506728a0581a ]---
> 
> devlink_free is complaining right here:
> 
> 	WARN_ON(!list_empty(&devlink->port_list));
> 
> This happens because devlink_port_unregister is no longer done right
> away in dsa_port_setup when a DSA_PORT_TYPE_USER has failed.
> Vivien said about this change that:
> 
>     Also no need to call devlink_port_unregister from within dsa_port_setup
>     as this step is inconditionally handled by dsa_port_teardown on error.
> 
> which is not really true. The devlink_port_unregister function _is_
> being called unconditionally from within dsa_port_setup, but not for
> this port that just failed, just for the previous ones which were set
> up.
> 
> ports_teardown:
> 	for (i = 0; i < port; i++)
> 		dsa_port_teardown(&ds->ports[i]);
> 
> Initially I was tempted to fix this by extending the "for" loop to also
> cover the port that failed during setup. But this could have potentially
> unforeseen consequences unrelated to devlink_port or even other types of
> ports than user ports, which I can't really test for. For example, if
> for some reason devlink_port_register itself would fail, then
> unconditionally unregistering it in dsa_port_teardown would not be a
> smart idea. The list might go on.
> 
> So just make dsa_port_setup undo the setup it had done upon failure, and
> let the for loop undo the work of setting up the previous ports, which
> are guaranteed to be brought up to a consistent state.
> 
> Fixes: 955222ca5281 ("net: dsa: use a single switch statement for port setup")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

This belongs to net-next. Thanks,

	Vivien
