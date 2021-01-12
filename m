Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD572F2400
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbhALAcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbhALAb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 19:31:58 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA67C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:31:18 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v26so366123eds.13
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 16:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tdfZYeMqF8EZqSHFoX8WqnohF3D7TXnreULZiExCiNw=;
        b=gASiLpkKvDkAulOsVVa3/9uUNu5yEmBxzxVp5gvumnDI9eLvuoW5Lyw5/x7oE0afQE
         WoJpHrhOJawx3jVQ2MMuPt+NvPLV0ryUNGQkeny4RBxS1qGQsREUszYRrJnp7+g8czON
         Wd2k5zfI9gXSy5Pb6oVqTrfopJ27wY89pri8Rw6pvsT67sRDHTWRonYj2v0Lx42cm6t8
         +aifvQvWZQjdiULtGsxjEpsyoHDT8HgWGz4JcepCnoxbk8sQQ5IoGM6NQ5D9uLW5zykV
         bOOoEafZOWLyqImQvSLMA662VtBC+6HxIlVwpkptweTognqnIbBNSegKQwtYLz4t5xAV
         WYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tdfZYeMqF8EZqSHFoX8WqnohF3D7TXnreULZiExCiNw=;
        b=ALTBimQ7yYVNO538aOO1si7y/jPwklNkiic9LEzXcMCnbF/HRQv4dd4SX6iWeS0j4p
         zSpsUUQSYlKCgaghtZwI80aADTUGiU8G7ikWMQ7/IkWrtB6CfwAhbmkSpsYV5e2ABbtc
         txYX7nfKbxVMlLHPK1aXjqu+osXf5JCKaonB/A0MlLu5ivwCwcuB+Y0C/4EZ5mencbaH
         SizcOr89oTRbocQq5WRKWe3lg8YXpyFau1QV/8TBf2lHIsEFwCjUOPCX0Vf8764w8+rM
         LfnL6yPqVJoYx6Ghao8WMKmbk0+kxh6fucUHo2TXqiE9qSB0pCOlR4W/QZEBoqjzGqZh
         hyig==
X-Gm-Message-State: AOAM533PUE3Y2wQR0pUgIE84Pj0rz9yyiNQIvbPNi/K4F/0K7ncDYyA2
        HSzTNT6gt4VrBqOUmDEoIBY=
X-Google-Smtp-Source: ABdhPJyqDwHLBOgvMLYbG8t0NXSg20q5gONCbuUYhAZ+7er34BGO0QONBQlvM0dDrVDFPfaR9vHIzw==
X-Received: by 2002:a05:6402:1102:: with SMTP id u2mr1400378edv.18.1610411477103;
        Mon, 11 Jan 2021 16:31:17 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ci20sm499582ejc.26.2021.01.11.16.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 16:31:16 -0800 (PST)
Date:   Tue, 12 Jan 2021 02:31:15 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: unbind all switches from tree when DSA
 master unbinds
Message-ID: <20210112003115.6gj6y2qjjm2shlnh@skbuf>
References: <20210111230943.3701806-1-olteanv@gmail.com>
 <3ec90588-2e42-e9ca-8565-252667ca5fb4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec90588-2e42-e9ca-8565-252667ca5fb4@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 03:40:46PM -0800, Florian Fainelli wrote:
> ==================================================================
> [   61.359856] BUG: KASAN: use-after-free in devlink_nl_port_fill+0x578/0x7a8
> [   61.366847] Read of size 4 at addr c7cf00a8 by task sh/249
> [   61.372413]
> [   61.470930] [<c0eb5458>] (devlink_nl_port_fill) from [<c0eb5e20>] (devlink_port_notify+0x80/0x12c)
> [   61.490566] [<c0eb5da0>] (devlink_port_notify) from [<c0eb6558>] (devlink_port_unregister+0x5c/0x108)
> [   61.505678] [<c0eb64fc>] (devlink_port_unregister) from [<c0feef60>] (dsa_switch_teardown.part.3+0x188/0x18c)
> [   61.523621] [<c0feedd8>] (dsa_switch_teardown.part.3) from [<c0fef00c>] (dsa_tree_teardown_switches+0xa8/0xc4)
> [   61.541663] [<c0feef64>] (dsa_tree_teardown_switches) from [<c0fef2cc>] (dsa_unregister_switch+0x124/0x250)
> [   61.557328] [<c0fef1a8>] (dsa_unregister_switch) from [<c0ba2f8c>] (bcm_sf2_sw_remove+0x98/0x13c)
> [   61.576895] [<c0ba2ef4>] (bcm_sf2_sw_remove) from [<c0a57ae8>] (platform_remove+0x44/0x5c)
> [   61.591063] [<c0a57aa4>] (platform_remove) from [<c0a54930>] (device_release_driver_internal+0x150/0x254)
> [   61.604438] [<c0a547e0>] (device_release_driver_internal) from [<c0a4d040>] (device_links_unbind_consumers+0xf8/0x12c)
> [   61.623162] [<c0a4cf48>] (device_links_unbind_consumers) from [<c0a54864>] (device_release_driver_internal+0x84/0x254)
> [   61.645614] [<c0a547e0>] (device_release_driver_internal) from [<c0a54a88>] (device_driver_detach+0x30/0x34)
> [   61.663466] [<c0a54a58>] (device_driver_detach) from [<c0a514d8>] (unbind_store+0x90/0x134)
> [   61.675605] [<c0a51448>] (unbind_store) from [<c0a50108>] (drv_attr_store+0x50/0x5c)
> [   61.810185]
> [   61.811715] Allocated by task 31:
> [   61.835006]  alloc_netdev_mqs+0x5c/0x50c
> [   61.839012]  dsa_slave_create+0x110/0x9c8
> [   61.843102]  dsa_register_switch+0xdb0/0x13a4
> [   61.847548]  b53_switch_register+0x47c/0x6dc
> [   61.851906]  bcm_sf2_sw_probe+0xaa4/0xc98
> [   61.855996]  platform_probe+0x90/0xf4
> [   61.859741]  really_probe+0x184/0x728
> [   61.863481]  driver_probe_device+0xa4/0x278
> [   61.867745]  __device_attach_driver+0xe8/0x148
> [   61.872274]  bus_for_each_drv+0x108/0x158
> [   61.876361]  __device_attach+0x190/0x234
> [   61.880362]  device_initial_probe+0x1c/0x20
> [   61.884628]  bus_probe_device+0xdc/0xec
> [   61.888540]  deferred_probe_work_func+0xd4/0x11c
> [   61.893242]  process_one_work+0x420/0x8f8
> [   61.897341]  worker_thread+0x4fc/0x91c
> [   61.901174]  kthread+0x21c/0x22c
> [   61.904478]  ret_from_fork+0x14/0x20
> [   61.908125]  0x0
> [   61.910014]
> [   61.911543] Freed by task 249:
> [   61.934842]  kfree+0xbc/0x2a8
> [   61.937877]  kvfree+0x34/0x38
> [   61.940913]  netdev_freemem+0x30/0x34
> [   61.944661]  netdev_release+0x48/0x50
> [   61.948400]  device_release+0x5c/0x100
> [   61.952234]  kobject_put+0x14c/0x2d8
> [   61.955888]  put_device+0x20/0x24
> [   61.959284]  free_netdev+0x170/0x194
> [   61.962935]  dsa_slave_destroy+0xac/0xb0
> [   61.966936]  dsa_port_teardown.part.2+0xa0/0xb4
> [   61.971558]  dsa_tree_teardown_switches+0x50/0xc4
> [   61.976354]  dsa_unregister_switch+0x124/0x250
> [   61.980887]  bcm_sf2_sw_remove+0x98/0x13c
> [   61.984977]  platform_remove+0x44/0x5c
> [   61.988810]  device_release_driver_internal+0x150/0x254
> [   61.994129]  device_links_unbind_consumers+0xf8/0x12c
> [   61.999266]  device_release_driver_internal+0x84/0x254
> [   62.004497]  device_driver_detach+0x30/0x34
> [   62.008762]  unbind_store+0x90/0x134
> [   62.012411]  drv_attr_store+0x50/0x5c
> [   62.016145]  sysfs_kf_write+0x90/0x9c
> [   62.019885]  kernfs_fop_write+0x178/0x2b4
> [   62.023975]  vfs_write+0x19c/0x644
> [   62.027452]  ksys_write+0xd4/0x170
> [   62.030930]  sys_write+0x18/0x1c
> [   62.034232]  ret_fast_syscall+0x0/0x2c
> [   62.038056]  0xb66eda2c

What is allocated in dsa_slave_create, freed in dsa_slave_destroy and
used in devlink_nl_port_fill via devlink_port->type_dev? It's the good
old net_device!

Either this is a devlink design bug or we're all holding it wrong.
In mlxsw, mlxsw_core_port_fini (which calls devlink_port_unregister) is
called after unregister_netdev && free_netdev, just like in DSA's case.
Apparently devlink_port_unregister notifies of port deletion over
netlink, and accesses the freshly freed net_device in the meanwhile.
Adding Jiri to figure out which one it is.
