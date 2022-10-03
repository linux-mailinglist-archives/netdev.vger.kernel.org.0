Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8F5F2C60
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJCIt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiJCItg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:49:36 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48386402E7
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 01:31:09 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id d64so10674205oia.9
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 01:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=bOGzabbpIlr/ORN3c4GEAh/PpyPWwYLGxDZz4D40gIA=;
        b=WVH2BULNHXu9Bn/JWZWs40JWd0InNZUzXILikDLmkUfOdfxrdBFLY6uvrrw13tZnmN
         Uve9NUBrD+5X4G8kaA+W9V9sjEvcZH9rpPz9K7r1N9rDpWEwSz6QVomebRleFAidjGIC
         NKZSnB3ZirpZe2mrW9oSLlIolW10RMClCJC62ASN+RMsZxYp8cCYKNeacw6yqbYqwUq4
         dvUAcj0tt0+Y8JA7la/Ipm6yZG1V7zVZZ41iWElf0c6H35HumwKI6w4rimWHn9JFgQ8D
         ZcNJ0pbT2DvCoae5YBs8feuGu3xpIaR2QfOsDzTLFd2GowJQZKOOI68drIqFCsObuBUF
         DK0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bOGzabbpIlr/ORN3c4GEAh/PpyPWwYLGxDZz4D40gIA=;
        b=N4v2v40z9st4l/r3Po0ybOdZcwQ8ytCmu3n2vmMiz5cO+D0ebMK+am8dZSRbAYcz57
         TkocI8+Ht+vhvYZ/92yP4jGu/sjZ7x8g5z/Pb1ROjZCj8fUfaoLRzIiajPGeMT5f2Taa
         xLp20u2YWPqviU78yDrf8GIlImL0hiyivdZt8KtKxVLAKX1IRjpKKEGhoK+LIgw2VbeM
         AoFGvKTLwKNW+JH51ddk72N0w2OEQJfz511e8Yu2lg64fOlxHdx7rhbfKnDx6bJ0BNBS
         mxcmnXiJoAXe3iF6Jj78WlmIG+YflDCH/ImkMpqIUVukBjitndVLkg3T8684VwTk9x13
         qGgw==
X-Gm-Message-State: ACrzQf2i4QVwi0qe5+alDfgz2+o67TWJwyzKklbhfN8O7N9He3ygICbY
        3LVrY6RWLycIcz5S+RehTUFIqtEqerJz1sO17SdleA==
X-Google-Smtp-Source: AMsMyM6IYT/ESTi/wYVs5Ic7j8HTBPjISj1DWl/n64WtT8znoUQmgSjThwLKVeVUFJkykTxM5R0DXHLad35OYKIocos=
X-Received: by 2002:a05:6808:2012:b0:34f:c816:cdf5 with SMTP id
 q18-20020a056808201200b0034fc816cdf5mr3498773oiw.45.1664785868455; Mon, 03
 Oct 2022 01:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <1613402622-11451-1-git-send-email-stefanc@marvell.com> <69516f245575e5ed09b3e291bcd784e2@matoro.tk>
In-Reply-To: <69516f245575e5ed09b3e291bcd784e2@matoro.tk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Mon, 3 Oct 2022 10:30:59 +0200
Message-ID: <CAPv3WKc4LKtZoyW3ixXfhvvYeOTkNVfTSdGWWWuKZS2hmOStDQ@mail.gmail.com>
Subject: Re: [net-next] net: mvpp2: Add TX flow control support for jumbo frames
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, andrew@lunn.ch, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, jon@solid-run.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

niedz., 2 pa=C5=BA 2022 o 21:25 matoro
<matoro_mailinglist_kernel@matoro.tk> napisa=C5=82(a):
>
> Hi all, I know this is kind of an old change but I have got an issue
> with this driver that might be related.  Whenever I change the MTU of
> any interfacing using mvpp2, it immediately results in the following
> crash.  Is this change related?  Is this a known issue with this driver?
>
> [ 1725.925804] mvpp2 f2000000.ethernet eth0: mtu 9000 too high,
> switching to shared buffers
> [ 1725.9258[ 1725.935611] mvpp2 f2000000.ethernet eth0: Link is Down
> 04] mvpp2 f2000000.ethernet eth0: mtu 9000 too high, switching to shared
> buffers
> [ 17[ 1725.950079] Unable to handle kernel NULL pointer dereference at
> virtual address 0000000000000000
> 25.935611]  Mem abort info:
> [33mmvpp2 f20000[ 1725.963804]   ESR =3D 0x0000000096000004
> 00.ethernet eth0[ 1725.968960]   EC =3D 0x25: DABT (current EL), IL =3D 3=
2
> bits
> : Link is Do[ 1725.975685]   SET =3D 0, FnV =3D 0
> wn
> [ 1725.980143]   EA =3D 0, S1PTW =3D 0
> [ 1725.983643]   FSC =3D 0x04: level 0 translation fault
> [ 1725.988539] Data abort info:
> [ 1725.991430]   ISV =3D 0, ISS =3D 0x00000004
> [ 1725.995279]   CM =3D 0, WnR =3D 0
> [ 1725.998256] user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000104b8300=
0
> [ 1726.004724] [0000000000000000] pgd=3D0000000000000000,
> p4d=3D0000000000000000
> [ 1726.011543] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [ 1726.017137] Modules linked in: sfp mdio_i2c marvell mcp3021 mvmdio
> at24 mvpp2 armada_thermal phylink sbsa_gwdt cfg80211 rfkill fuse
> [ 1726.029032] CPU: 2 PID: 16253 Comm: ip Not tainted
> 5.19.8-1-aarch64-ARCH #1
> [ 1726.036024] Hardware name: SolidRun CN9130 based SOM Clearfog Base
> (DT)
> [ 1726.042665] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS
> BTYPE=3D--)
> [ 1726.049656] pc : mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
> [ 1726.054915] lr : mvpp2_bm_pool_update_fc+0x40/0x154 [mvpp2]
> [ 1726.060515] sp : ffff80000b17b580
> [ 1726.063842] x29: ffff80000b17b580 x28: 0000000000000000 x27:
> 0000000000000000
> [ 1726.071010] x26: ffff8000013ceb60 x25: 0000000000000008 x24:
> ffff0001054b5980
> [ 1726.078177] x23: ffff0001021e2480 x22: 0000000000000038 x21:
> 0000000000000000
> [ 1726.085346] x20: ffff0001049dac80 x19: ffff0001054b4980 x18:
> 0000000000000000
> [ 1726.092513] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000000000000000
> [ 1726.099680] x14: 0000000000000109 x13: 0000000000000109 x12:
> 0000000000000000
> [ 1726.106847] x11: 0000000000000040 x10: ffff80000a3471b8 x9 :
> ffff80000a3471b0
> [ 1726.114015] x8 : ffff000100401b88 x7 : 0000000000000000 x6 :
> 0000000000000000
> [ 1726.121182] x5 : ffff80000b17b4e0 x4 : 0000000000000000 x3 :
> 0000000000000000
> [ 1726.128348] x2 : ffff0001021e2480 x1 : 0000000000000000 x0 :
> 0000000000000000
> [ 1726.135514] Call trace:
> [ 1726.137968]  mvpp2_cm3_read.isra.0+0x8/0x2c [mvpp2]
> [ 1726.142871]  mvpp2_bm_pool_update_priv_fc+0xc0/0x100 [mvpp2]
> [ 1726.148558]  mvpp2_bm_switch_buffers.isra.0+0x1c0/0x1e0 [mvpp2]
> [ 1726.154506]  mvpp2_change_mtu+0x184/0x264 [mvpp2]
> [ 1726.159233]  dev_set_mtu_ext+0xdc/0x1b4
> [ 1726.163087]  do_setlink+0x1d4/0xa90
> [ 1726.166593]  __rtnl_newlink+0x4a8/0x4f0
> [ 1726.170443]  rtnl_newlink+0x4c/0x80
> [ 1726.173944]  rtnetlink_rcv_msg+0x12c/0x37c
> [ 1726.178058]  netlink_rcv_skb+0x5c/0x130
> [ 1726.181910]  rtnetlink_rcv+0x18/0x2c
> [ 1726.185500]  netlink_unicast+0x2c4/0x31c
> [ 1726.189438]  netlink_sendmsg+0x1bc/0x410
> [ 1726.193377]  sock_sendmsg+0x54/0x60
> [ 1726.196879]  ____sys_sendmsg+0x26c/0x290
> [ 1726.200817]  ___sys_sendmsg+0x7c/0xc0
> [ 1726.204494]  __sys_sendmsg+0x68/0xd0
> [ 1726.208083]  __arm64_sys_sendmsg+0x28/0x34
> [ 1726.212196]  invoke_syscall+0x48/0x114
> [ 1726.215962]  el0_svc_common.constprop.0+0x44/0xec
> [ 1726.220686]  do_el0_svc+0x28/0x34
> [ 1726.224014]  el0_svc+0x2c/0x84
> [ 1726.227082]  el0t_64_sync_handler+0x11c/0x150
> [ 1726.231455]  el0t_64_sync+0x18c/0x190
> [ 1726.235134] Code: d65f03c0 d65f03c0 d503233f 8b214000 (b9400000)
> [ 1726.241253] ---[ end trace 0000000000000000 ]---
> [ 1726.245888] note: ip[16253] exited with preempt_count 1
>

Thank you for the report. I will check in my setup. Please provide me
with the log from the power on until OS prompt (it should include the
early firmware and the full dmesg).

Best regards,
Marcin
