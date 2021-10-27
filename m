Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A677E43C3F6
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhJ0HfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:35:11 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:45015 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbhJ0HfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:35:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635319965; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=O93Caq1JW1KMAEIKVZ6rP7UqQ9VTvsuojA8a/yFs0ZU=;
 b=is+08FVc0R32WshlfGY/WThGLINxnkTKyxyiHgCb2tagTekpyJfueclBrfuE7+2MuwFEiodl
 okii+a/78Xvoy15jXDHGSby819Zk6d4ABXm/iUSGASkpCa/T8biAwfbxwjnZpwkiOTYfxzSj
 kImy2KXjy39ld/niZZoKihWoqHc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 617900995ca800b6c1c5fff4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:32:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13DB4C4361B; Wed, 27 Oct 2021 07:32:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F3F1C4338F;
        Wed, 27 Oct 2021 07:32:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0F3F1C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 wireless-drivers 1/2] libertas_tf: Fix possible memory
 leak
 in probe and disconnect
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211020120345.2016045-2-wanghai38@huawei.com>
References: <20211020120345.2016045-2-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <briannorris@chromium.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <shenyang39@huawei.com>, <marcelo@kvack.org>,
        <linville@tuxdriver.com>, <luisca@cozybit.com>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163531995539.30745.14828002876650574898.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:32:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai <wanghai38@huawei.com> wrote:

> I got memory leak as follows when doing fault injection test:
> 
> unreferenced object 0xffff88810a2ddc00 (size 512):
>   comm "kworker/6:1", pid 176, jiffies 4295009893 (age 757.220s)
>   hex dump (first 32 bytes):
>     00 50 05 18 81 88 ff ff 00 00 00 00 00 00 00 00  .P..............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8167939c>] slab_post_alloc_hook+0x9c/0x490
>     [<ffffffff8167f627>] kmem_cache_alloc_trace+0x1f7/0x470
>     [<ffffffffa02a1530>] if_usb_probe+0x60/0x37c [libertas_tf_usb]
>     [<ffffffffa022668a>] usb_probe_interface+0x1aa/0x3c0 [usbcore]
>     [<ffffffff82b59630>] really_probe+0x190/0x480
>     [<ffffffff82b59a19>] __driver_probe_device+0xf9/0x180
>     [<ffffffff82b59af3>] driver_probe_device+0x53/0x130
>     [<ffffffff82b5a075>] __device_attach_driver+0x105/0x130
>     [<ffffffff82b55949>] bus_for_each_drv+0x129/0x190
>     [<ffffffff82b593c9>] __device_attach+0x1c9/0x270
>     [<ffffffff82b5a250>] device_initial_probe+0x20/0x30
>     [<ffffffff82b579c2>] bus_probe_device+0x142/0x160
>     [<ffffffff82b52e49>] device_add+0x829/0x1300
>     [<ffffffffa02229b1>] usb_set_configuration+0xb01/0xcc0 [usbcore]
>     [<ffffffffa0235c4e>] usb_generic_driver_probe+0x6e/0x90 [usbcore]
>     [<ffffffffa022641f>] usb_probe_device+0x6f/0x130 [usbcore]
> 
> cardp is missing being freed in the error handling path of the probe
> and the path of the disconnect, which will cause memory leak.
> 
> This patch adds the missing kfree().
> 
> Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

2 patches applied to wireless-drivers-next.git, thanks.

d549107305b4 libertas_tf: Fix possible memory leak in probe and disconnect
9692151e2fe7 libertas: Fix possible memory leak in probe and disconnect

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211020120345.2016045-2-wanghai38@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

