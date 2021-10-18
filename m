Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508F9431994
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhJRMrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:47:10 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53275 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhJRMrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:47:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634561098; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=RLNXA35XJkkVy9dCYQdzgxU5Mr9XzVvEwaSLUq/vja4=;
 b=FK5IcrOvKo5IB3jn4UBLs6ioW+pZUimfTB2kM4e2vxGfOeXhcjEKbNrg8DE72BFQAQYuf7zc
 EhPuRr4WBxCJ2j67EheA6xwr1+c2VYqYpNPLqC348woxON0VArzgoguIbKiwNW8xmVRwSx0T
 ye63uVfT5JDTYQuOjIN2tm5Edpg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 616d6c3df3e5b80f1f1afcd6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:44:45
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AE44EC43617; Mon, 18 Oct 2021 12:44:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB19EC4338F;
        Mon, 18 Oct 2021 12:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EB19EC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] mwifiex: Fix possible memleak in probe and disconnect
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211018063818.1895774-1-wanghai38@huawei.com>
References: <20211018063818.1895774-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <shenyang39@huawei.com>,
        <marcelo@kvack.org>, <linville@tuxdriver.com>,
        <luisca@cozybit.com>, <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163456107685.11105.13969946027999768773.kvalo@codeaurora.org>
Date:   Mon, 18 Oct 2021 12:44:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai <wanghai38@huawei.com> wrote:

> I got memory leak as follows when doing fault injection test:
> 
> unreferenced object 0xffff888031c2f000 (size 512):
>   comm "kworker/0:2", pid 165, jiffies 4294922253 (age 391.180s)
>   hex dump (first 32 bytes):
>     00 20 f7 08 80 88 ff ff 01 00 00 00 00 00 00 00  . ..............
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000537bdb86>] kmem_cache_alloc_trace+0x16d/0x360
>     [<0000000047666fab>] if_usb_probe+0x90/0x96e [usb8xxx]
>     [<00000000de44b4f0>] usb_probe_interface+0x31b/0x800 [usbcore]
>     [<000000009b1a1951>] really_probe+0x299/0xc30
>     [<0000000055b8ffce>] __driver_probe_device+0x357/0x500
>     [<00000000bb0c7161>] driver_probe_device+0x4e/0x140
>     [<00000000866d1730>] __device_attach_driver+0x257/0x340
>     [<0000000084e79b96>] bus_for_each_drv+0x166/0x1e0
>     [<000000009bad60ea>] __device_attach+0x272/0x420
>     [<00000000236b97c1>] bus_probe_device+0x1eb/0x2a0
>     [<000000008d77d7cf>] device_add+0xbf0/0x1cd0
>     [<000000004af6a3f0>] usb_set_configuration+0x10fb/0x18d0 [usbcore]
>     [<000000002ebdfdcd>] usb_generic_driver_probe+0xa2/0xe0 [usbcore]
>     [<00000000444f344d>] usb_probe_device+0xe4/0x2b0 [usbcore]
>     [<000000009b1a1951>] really_probe+0x299/0xc30
>     [<0000000055b8ffce>] __driver_probe_device+0x357/0x500
> 
> cardp is missing being freed in the error handling path of the probe
> and the path of the disconnect, which will cause kmemleak.
> 
> This patch adds the missing free().
> 
> Fixes: 876c9d3aeb98 ("[PATCH] Marvell Libertas 8388 802.11b/g USB driver")
> Fixes: c305a19a0d0a ("libertas_tf: usb specific functions")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

mwifiex patches are applied to wireless-drivers, not to the net tree. Please be
careful how you mark your patches.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211018063818.1895774-1-wanghai38@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

