Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB4162EA2
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRSet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:34:49 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35661 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRSet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:34:49 -0500
Received: by mail-io1-f65.google.com with SMTP id h8so10991191iob.2;
        Tue, 18 Feb 2020 10:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6utW5zpBGZdkE/X85fwj9ukk+lXXzsfc4fJcknN/FJk=;
        b=toQcBUKNgScyCDiWdC34axIPqQTZKiFC6SAAtB0u+WJ+ZuStKhtPXSjLiO8H/xXLx5
         Jh07dsG4hyNZv0NJLSICIrsnmcjoFyJtkQhdPwjMZbY87iR6OA7r6lrL2AByrW3IJfZc
         ghjwlfaN9yn+xlfe4XjnvDLIHA0OznNAl12wg3fi2AOifDyHkCCu8oi/MxlurwZV8Os3
         6Uaz831KXQp2FpsKydbPIt2tMJVh8ezHMbQq4Lb+mqAkAmMITFw54ZKRt8hZyB9u/BjM
         QPEVBu1a1s+YAAD2yZ17exvJ2zVf9oA3d7EeOXeQIJuaJp+gHr3AMeUgDY+zLqQ20HIF
         qCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6utW5zpBGZdkE/X85fwj9ukk+lXXzsfc4fJcknN/FJk=;
        b=SjR9hf95U3+rLtnVMP5e75yp8CNU8ZU/yU6aQ3d8/877rDvVEncIkAiyEt6raAIVAW
         zWP2xfnTN1DdNTzP8m2iVh1YbetCf5G987oRg34DP7OSWk9wA5TORIhuVhG9uO6aMLUP
         PQHYAJ1G6gZ3k6sWGLi6gh2Fpihh+dmPtVk0hasJOwBstIgZAAeW34bqFeWeytMKzfcw
         bfA5OG2WySdj+6WrgzhZ5iRA8X1ajkmll/t3Y2xCxIDRfSa81IeU5KTnrpD0vPRx5Ovk
         7xUzc65zN9BKL0AYY1vl6xe25NC1eKDXRy97ZeYvoUsrrrX+QW2OGaFx0RQYTYfM9Ckq
         Wnvg==
X-Gm-Message-State: APjAAAWByKQ5ugZlatDFiPr7PWQCOYYWKV9xron45kDftKOYWJhNSmeq
        LCE34Yd5uqg+8zQ0H75kur3jB/bw+fNOavQqDm4=
X-Google-Smtp-Source: APXvYqzrmTgiAn3qTV4ak/NxkwEw5dKPolvgC/KdPk7W9Fb2Vcgr2yrHz75tj+TGm+xHulsJ2cgO+Lkx7KEmGDGh3SY=
X-Received: by 2002:a5e:860f:: with SMTP id z15mr16047488ioj.64.1582050888480;
 Tue, 18 Feb 2020 10:34:48 -0800 (PST)
MIME-Version: 1.0
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com> <9270ae4b-feb1-6a4d-8a22-fbe5e47b7617@gmail.com>
In-Reply-To: <9270ae4b-feb1-6a4d-8a22-fbe5e47b7617@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 18 Feb 2020 10:34:37 -0800
Message-ID: <CAKgT0UdP78GGnowWC85YiTAHOr63NiLa25=2TSckKBEzGBdeJA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: use new helper tcp_v6_gso_csum_prep
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 1:43 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Use new helper tcp_v6_gso_csum_prep in additional network drivers.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/atheros/alx/main.c       |  5 +---
>  .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
>  drivers/net/ethernet/brocade/bna/bnad.c       |  7 +----
>  drivers/net/ethernet/cisco/enic/enic_main.c   |  3 +--
>  drivers/net/ethernet/intel/e1000/e1000_main.c |  6 +----
>  drivers/net/ethernet/intel/e1000e/netdev.c    |  5 +---
>  drivers/net/ethernet/jme.c                    |  7 +----
>  .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 +---
>  drivers/net/ethernet/qualcomm/emac/emac-mac.c |  7 ++---
>  drivers/net/ethernet/socionext/netsec.c       |  6 +----
>  drivers/net/hyperv/netvsc_drv.c               |  5 +---
>  drivers/net/usb/r8152.c                       | 26 ++-----------------
>  drivers/net/vmxnet3/vmxnet3_drv.c             |  5 +---
>  13 files changed, 16 insertions(+), 77 deletions(-)
>

It might make sense to break this up into several smaller patches
based on the maintainers for the various driver bits.

So the changes all look fine to me, but I am not that familiar with
the non-Intel drivers.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
