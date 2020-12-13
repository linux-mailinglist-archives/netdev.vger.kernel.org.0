Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501AA2D8CB4
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 12:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgLMLYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgLMLYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:24:51 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F6C0613CF;
        Sun, 13 Dec 2020 03:24:10 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 6so3980368ejz.5;
        Sun, 13 Dec 2020 03:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IW66fMc7VTs1PtxS+22ry7ms1/9mizOXCdVTfKV5hpo=;
        b=bQn+oB1JoyeFOF0nG/mlAluMS+9oNaqRxA17ZBM9Oe3AOE8/JG6goH/EB1c4QkEda4
         T1lTzWqlfslNfkdjp202c07yMWPNGbIBbpqQZ+AzfJmqs+Kgj+dLxGZ+wWZGA5mc0NdB
         BijFlgEZnvzEJb3MGQPxQa2/dgeJuYhDvxuwz6QAxAIoRHfwl22d5quEoZXOhJp6a+qE
         ETivnglunAiRLTbK3ng7taHfwUqrNTJL3Mef8dDWPaAGgN2enm8bDppfomcBBDdM6fOw
         jt/C5/9LwS2YQBDgMwgsJ0z4C3ZaAE2+qiQJ4375nfTotPFrKA5zulfu7Q8I9D/Awk7+
         1yaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IW66fMc7VTs1PtxS+22ry7ms1/9mizOXCdVTfKV5hpo=;
        b=BVBMTCn3Bvu5bU8u22YwrSx8UYIrLr1dn/Gtu7QCctWasiftRQClF1RfJ4Jide5z2/
         oEbevEBznY4HqoeALxnXi/snXKW4lE+iHGRP/WO6+Sf4tO8t8uUs+qLpaH1MwAHNpjST
         7cICSEyp2srchAP8d7jtWgTMNvk6g/WDXK0iLlUM6eQ1yOK5eqfCPXl6wejZhIxn8spN
         OtxPSqA6Zsp1kiSzRKxsKsc7prwux91PXGcVki2CZ9dR5KijWb8tZJ8Nhx4OgeqeJJ2n
         5rYbYMBo9KQMgbYy4+1+7tclWUFLaU25ryFUH+kBxqSkZXQQAooPRicLP8pJtpMyntbE
         VKCg==
X-Gm-Message-State: AOAM531B7l7ilylRnx7vVwCRaWZ3ILOCQdDgyAMfMKyzuFnW395gUQT8
        1sE6TCaMzKMc6W+DxYtzQ4c=
X-Google-Smtp-Source: ABdhPJynlxi2QKNBVsllMFmw4nuD/o/QttB0CiO5OzyzZ7oeGscU5QYtBXumKqp3eM2r1PK4665luQ==
X-Received: by 2002:a17:906:a2d0:: with SMTP id by16mr18015254ejb.207.1607858649230;
        Sun, 13 Dec 2020 03:24:09 -0800 (PST)
Received: from [192.168.0.107] ([77.127.34.194])
        by smtp.gmail.com with ESMTPSA id de12sm12533753edb.82.2020.12.13.03.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 03:24:08 -0800 (PST)
Subject: Re: [patch 20/30] net/mlx4: Replace irq_to_desc() abuse
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
References: <20201210192536.118432146@linutronix.de>
 <20201210194044.580936243@linutronix.de>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <01e427f9-7238-d6a8-25ec-8585914d32df@gmail.com>
Date:   Sun, 13 Dec 2020 13:24:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201210194044.580936243@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2020 9:25 PM, Thomas Gleixner wrote:
> No driver has any business with the internals of an interrupt
> descriptor. Storing a pointer to it just to use yet another helper at the
> actual usage site to retrieve the affinity mask is creative at best. Just
> because C does not allow encapsulation does not mean that the kernel has no
> limits.
> 
> Retrieve a pointer to the affinity mask itself and use that. It's still
> using an interface which is usually not for random drivers, but definitely
> less hideous than the previous hack.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_cq.c   |    8 +++-----
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c   |    6 +-----
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |    3 ++-
>   3 files changed, 6 insertions(+), 11 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
