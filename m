Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309192775D5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgIXPvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:51:15 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:36188 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgIXPvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:51:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600962668; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=9DxyVzBF2Y2HUGEyBmAKPbqDif0hg4W6wg+GG3d3u4k=;
 b=bf+OlmSzH/96KXwOWVoo1rps7pn+9rJlayMQQTv/0LfOPRfihUPxfURvS+U0455o35IVxODE
 Af9QnS36zESKvF81p5EuEOrUHb8yKVnpe0BAxkVRMgVLBU8uvrDTLEePuou4abaws/SSDgoz
 cY5MFqHXTQIkCep96ZmQ6KQtS/Q=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5f6cc03d63643dee6237b430 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Sep 2020 15:50:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5DDE8C4339C; Thu, 24 Sep 2020 15:50:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E35B4C433C8;
        Thu, 24 Sep 2020 15:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E35B4C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] rtw88: Fix probe error handling race with firmware
 loading
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200920132621.26468-2-afaerber@suse.de>
References: <20200920132621.26468-2-afaerber@suse.de>
To:     =?utf-8?q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org, Chin-Yen Lee <timlee@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-realtek-soc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?utf-8?q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Brian Norris <briannorris@chromium.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200924155021.5DDE8C4339C@smtp.codeaurora.org>
Date:   Thu, 24 Sep 2020 15:50:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andreas Färber <afaerber@suse.de> wrote:

> In case of rtw8822be, a probe failure after successful rtw_core_init()
> has been observed to occasionally lead to an oops from rtw_load_firmware_cb():
> 
> [    3.924268] pci 0001:01:00.0: [10ec:b822] type 00 class 0xff0000
> [    3.930531] pci 0001:01:00.0: reg 0x10: [io  0x0000-0x00ff]
> [    3.936360] pci 0001:01:00.0: reg 0x18: [mem 0x00000000-0x0000ffff 64bit]
> [    3.944042] pci 0001:01:00.0: supports D1 D2
> [    3.948438] pci 0001:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    3.957312] pci 0001:01:00.0: BAR 2: no space for [mem size 0x00010000 64bit]
> [    3.964645] pci 0001:01:00.0: BAR 2: failed to assign [mem size 0x00010000 64bit]
> [    3.972332] pci 0001:01:00.0: BAR 0: assigned [io  0x10000-0x100ff]
> [    3.986240] rtw_8822be 0001:01:00.0: enabling device (0000 -> 0001)
> [    3.992735] rtw_8822be 0001:01:00.0: failed to map pci memory
> [    3.998638] rtw_8822be 0001:01:00.0: failed to request pci io region
> [    4.005166] rtw_8822be 0001:01:00.0: failed to setup pci resources
> [    4.011580] rtw_8822be: probe of 0001:01:00.0 failed with error -12
> [    4.018827] cfg80211: Loading compiled-in X.509 certificates for regulatory database
> [    4.029121] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [    4.050828] Unable to handle kernel paging request at virtual address edafeaac9607952c
> [    4.058975] Mem abort info:
> [    4.058980]   ESR = 0x96000004
> [    4.058990]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    4.070353]   SET = 0, FnV = 0
> [    4.073487]   EA = 0, S1PTW = 0
> [    4.073501] dw-apb-uart 98007800.serial: forbid DMA for kernel console
> [    4.076723] Data abort info:
> [    4.086415]   ISV = 0, ISS = 0x00000004
> [    4.087731] Freeing unused kernel memory: 1792K
> [    4.090391]   CM = 0, WnR = 0
> [    4.098091] [edafeaac9607952c] address between user and kernel address ranges
> [    4.105418] Internal error: Oops: 96000004 [#1] PREEMPT SMP
> [    4.111129] Modules linked in:
> [    4.114275] CPU: 1 PID: 31 Comm: kworker/1:1 Not tainted 5.9.0-rc5-next-20200915+ #700
> [    4.122386] Hardware name: Realtek Saola EVB (DT)
> [    4.127223] Workqueue: events request_firmware_work_func
> [    4.132676] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
> [    4.138393] pc : rtw_load_firmware_cb+0x54/0xbc
> [    4.143040] lr : request_firmware_work_func+0x44/0xb4
> [    4.148217] sp : ffff800010133d70
> [    4.151616] x29: ffff800010133d70 x28: 0000000000000000
> [    4.157069] x27: 0000000000000000 x26: 0000000000000000
> [    4.162520] x25: 0000000000000000 x24: 0000000000000000
> [    4.167971] x23: ffff00007ac21908 x22: ffff00007ebb2100
> [    4.173424] x21: ffff00007ad35880 x20: edafeaac96079504
> [    4.178877] x19: ffff00007ad35870 x18: 0000000000000000
> [    4.184328] x17: 00000000000044d8 x16: 0000000000004310
> [    4.189780] x15: 0000000000000800 x14: 00000000ef006305
> [    4.195231] x13: ffffffff00000000 x12: ffffffffffffffff
> [    4.200682] x11: 0000000000000020 x10: 0000000000000003
> [    4.206135] x9 : 0000000000000000 x8 : ffff00007e73f680
> [    4.211585] x7 : 0000000000000000 x6 : ffff80001119b588
> [    4.217036] x5 : ffff00007e649c80 x4 : ffff00007e649c80
> [    4.222487] x3 : ffff80001119b588 x2 : ffff8000108d1718
> [    4.227940] x1 : ffff800011bd5000 x0 : ffff00007ac21600
> [    4.233391] Call trace:
> [    4.235906]  rtw_load_firmware_cb+0x54/0xbc
> [    4.240198]  request_firmware_work_func+0x44/0xb4
> [    4.245027]  process_one_work+0x178/0x1e4
> [    4.249142]  worker_thread+0x1d0/0x268
> [    4.252989]  kthread+0xe8/0xf8
> [    4.256127]  ret_from_fork+0x10/0x18
> [    4.259800] Code: f94013f5 a8c37bfd d65f03c0 f9000260 (f9401681)
> [    4.266049] ---[ end trace f822ebae1a8545c2 ]---
> 
> To avoid this, wait on the completion callbacks in rtw_core_deinit()
> before releasing firmware and continuing teardown.
> 
> Note that rtw_wait_firmware_completion() was introduced with
> c8e5695eae9959fc5774c0f490f2450be8bad3de ("rtw88: load wowlan firmware
> if wowlan is supported"), so backports to earlier branches may need to
> inline wait_for_completion(&rtwdev->fw.completion) instead.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Fixes: c8e5695eae99 ("rtw88: load wowlan firmware if wowlan is supported")
> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>

2 patches applied to wireless-drivers-next.git, thanks.

ecda9cda3338 rtw88: Fix probe error handling race with firmware loading
ac4bac99161e rtw88: Fix potential probe error handling race with wow firmware loading

-- 
https://patchwork.kernel.org/patch/11787655/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

