Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA130338D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbhAZE6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:58:23 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60632 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbhAYMVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:21:03 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210125115623euoutp020dc3b597c2b0bdee9e8114c49e5cdda5~dd6LnZ_bD0364103641euoutp02W
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 11:56:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210125115623euoutp020dc3b597c2b0bdee9e8114c49e5cdda5~dd6LnZ_bD0364103641euoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611575783;
        bh=Mq5BJ1+vePex+qTwblveMz5iiS+Z7q8tJa66kykf0ZI=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Ls1MsuVsJsmtA1MWoFFK9OXp/K7oNB/pF+lZ574tQgSui2VZjwCCuANeXD8/9wV7o
         cVcoL0BHZnWiJFGKQKfMcd82PnVu1RAQJ6RULMz6PZ+suu8QPo61v8WCqW8634UXpK
         7kxE64Emxrk9BGkIckQ9wpKCU9MUazbmWi62epO0=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210125115622eucas1p16882e454000fffd45560f125c7e7bafe~dd6LXnE730603906039eucas1p1t;
        Mon, 25 Jan 2021 11:56:22 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 98.D9.44805.6E1BE006; Mon, 25
        Jan 2021 11:56:22 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210125115622eucas1p1d95ea4bff4043bd2524c98beafd32408~dd6K_IuN63035330353eucas1p1b;
        Mon, 25 Jan 2021 11:56:22 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210125115622eusmtrp1917aea26e690990dfcea6031a1d31807~dd6K9gjcP2084120841eusmtrp17;
        Mon, 25 Jan 2021 11:56:22 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-ed-600eb1e6733d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 34.05.21957.6E1BE006; Mon, 25
        Jan 2021 11:56:22 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210125115622eusmtip2da7cf912f5561017ad5a85bcd40d06de~dd6KpPK_E2285722857eusmtip2Q;
        Mon, 25 Jan 2021 11:56:22 +0000 (GMT)
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <b425cbc3-63a8-3252-e828-bcb7b336b783@samsung.com>
Date:   Mon, 25 Jan 2021 12:56:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <4ae7a27c32cbf85b4ddb05cc2a16e52918663633.camel@sipsolutions.net>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42LZduzned1nG/kSDJb1mFt83PCJxeLNijvs
        FscWiFl0PV7J5sDi0d+7jcVj/ZarLB6fN8kFMEdx2aSk5mSWpRbp2yVwZUz+tZSpoFOy4tzK
        +gbGV6JdjJwcEgImEv0vVjN2MXJxCAmsYJToWLSLDcL5wihxZcs5qMxnRomTJ6eyw7TM3vAC
        zBYSWM4o8e2GF0TRR0aJNQtAZnFyCAsESdzcuI0FxBYR8JfYd6ABqIGDg1nARmLhlWKQMJuA
        oUTX2y42EJtXwE7i4/9VYDaLgKrEo4MrwcaICiRJ3L1zmAmiRlDi5MwnYCM5Bfwk3r1sYgax
        mQXkJZq3zoayxSVuPZnPBHKPhMAWDoknt66xgeyVEHCR6L/AC3G/sMSr41ugfpGROD25hwWi
        vplR4uG5tewQTg+jxOWmGYwQVdYSd879YoN4QFNi/S59iLCjRNOtjawQ8/kkbrwVhLiBT2LS
        tunMEGFeiY42IYhqNYlZx9fBrT144RLzBEalWUg+m4Xkm1lIvpmFsHcBI8sqRvHU0uLc9NRi
        o7zUcr3ixNzi0rx0veT83E2MwFRy+t/xLzsYl7/6qHeIkYmD8RCjBAezkgjvbj2eBCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK8SVvWxAsJpCeWpGanphakFsFkmTg4pRqYJJyUipyjhLb5JO7Z
        8MY9M7TPJLt936PS2XsqDrtFH2AyNes18OvRlFU65ep87kiJ93RRhbX6THnr19fyJU/wMrVm
        9X17KyjwymKVlD6pk7pX1nKzbXi40/wXd8rnq7+3TFmqmCFT8q8ycOqKg4vSWB4KJxfeSPjI
        XPkr69SZLYYWK0J5Pjzj64+w133L4JHvExr++eOuw29DPI7/MJVhEZn7VrEo+Mavmj2CIqXM
        CpejFynzFG1LyTohyuygN+nZk8ZMbZltqxX8Tq+13WVcUL9hwaqr/7ZJvT/XU+jXL2hd4idX
        Ft1k4mhY/v8qb4xv/ryyH5zf6nQ3qzKxGd8V/vn5goiNC5ddV+PDpUosxRmJhlrMRcWJALHk
        Il+UAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xe7rPNvIlGPS8l7L4uOETi8WbFXfY
        LY4tELPoerySzYHFo793G4vH+i1XWTw+b5ILYI7SsynKLy1JVcjILy6xVYo2tDDSM7S00DMy
        sdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5j8aylTQadkxbmV9Q2Mr0S7GDk5JARMJGZveMHe
        xcjFISSwlFFi/pP/zBAJGYmT0xpYIWxhiT/Xutggit4zShxd2csGkhAWCJK4uXEbC4gtIuAr
        seDOe6BJHBzMAjYSC68UQ9SvZJLYtfwhI0gNm4ChRNfbLrBeXgE7iY//V4HZLAKqEo8OrgSr
        ERVIkjgx6xMzRI2gxMmZT8Dmcwr4Sbx72QQWZxYwk5i3+SGULS/RvHU2lC0ucevJfKYJjEKz
        kLTPQtIyC0nLLCQtCxhZVjGKpJYW56bnFhvqFSfmFpfmpesl5+duYgTGz7ZjPzfvYJz36qPe
        IUYmDsZDjBIczEoivLv1eBKEeFMSK6tSi/Lji0pzUosPMZoC/TORWUo0OR8YwXkl8YZmBqaG
        JmaWBqaWZsZK4rxb566JFxJITyxJzU5NLUgtgulj4uCUamAy2Vm63FfeYpJT1M2YY+m719x6
        NpOv2OWFSUq486fG13ptH45Y3pzhdHRDm7/Z9raQ417yE4+UObxo81wW8vsty2OF7dsZb78Q
        KCou5lBX4U7exOWdd6dhL9P9lAs2ilMPx/fOu9PFfFuzPFrT9ydbq1qK2MEn0mZrBEqPyl80
        DS9zXxS+vUdWuEqvwOq/Ws6TiidcM6TbjOSZVC55z2Vma/l6bRPLG598wW7h70u+zJ7+YKbQ
        F2Mn0Rk6mvt+8fSoGJ2X398QtUM8dYf7gw95ObZv2hpili66VPTJ7uC33XkPDJ8//2AQaXN/
        g9W7xXOzPvMoun1VO19k/FREUbnhl8TtJYtXzgoL+vU7arcSS3FGoqEWc1FxIgA4Gd/VKAMA
        AA==
X-CMS-MailID: 20210125115622eucas1p1d95ea4bff4043bd2524c98beafd32408
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
        <CGME20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458@eucas1p2.samsung.com>
        <6569c83a-11b0-7f13-4b4c-c0318780895c@samsung.com>
        <4ae7a27c32cbf85b4ddb05cc2a16e52918663633.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On 22.01.2021 13:27, Johannes Berg wrote:
>> This patch landed in today's (20210122) linux-next as commit
>> 791daf8fc49a ("cfg80211: avoid holding the RTNL when calling the
>> driver"). Sadly, it causes deadlock with mwifiex driver. I think that
>> lockdep report describes it enough:
> Yeah, umm, sorry about that. Evidently, I somehow managed to put
> "wiphy_lock()" into that part of the code, rather than "wiphy_unlock()"!
>
> I'll fix, thanks!

I've checked today's linux-next with the updated commit 27bc93583e35 
("cfg80211: avoid holding the RTNL when calling the driver") and there 
is still an issue there, but at least it doesn't cause a deadlock:

cfg80211: Loading compiled-in X.509 certificates for regulatory database
Bluetooth: vendor=0x2df, device=0x912a, class=255, fn=2
cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Bluetooth: FW download over, size 533976 bytes
btmrvl_sdio mmc3:0001:2: sdio device tree data not available
mwifiex_sdio mmc3:0001:1: WLAN FW already running! Skip FW dnld
mwifiex_sdio mmc3:0001:1: WLAN FW is active
mwifiex_sdio mmc3:0001:1: CMD_RESP: cmd 0x242 error, result=0x2
mwifiex_sdio mmc3:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed 
during       initialization
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5 at net/wireless/core.c:1336 
cfg80211_register_netdevice+0xa4/0x198 [cfg80211]
Modules linked in: mwifiex_sdio mwifiex sha256_generic libsha256 
sha256_arm btmrvl_sdio btmrvl cfg80211 bluetooth s5p_mfc exynos_gsc 
v4l2_mem2mem videobuf2_dma_co
ntig videobuf2_memops videobuf2_v4l2 videobuf2_common videodev 
ecdh_generic ecc mc s5p_cec
CPU: 1 PID: 18 Comm: kworker/1:0 Not tainted 
5.11.0-rc4-00536-g27bc93583e35-dirty #2345
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events request_firmware_work_func
[<c01116e8>] (unwind_backtrace) from [<c010cf58>] (show_stack+0x10/0x14)
[<c010cf58>] (show_stack) from [<c0b46744>] (dump_stack+0xa4/0xc4)
[<c0b46744>] (dump_stack) from [<c01270ac>] (__warn+0x118/0x11c)
[<c01270ac>] (__warn) from [<c0127164>] (warn_slowpath_fmt+0xb4/0xbc)
[<c0127164>] (warn_slowpath_fmt) from [<bf1a9de0>] 
(cfg80211_register_netdevice+0xa4/0x198 [cfg80211])
[<bf1a9de0>] (cfg80211_register_netdevice [cfg80211]) from [<bf28f2e4>] 
(mwifiex_add_virtual_intf+0x6a0/0x9f4 [mwifiex])
[<bf28f2e4>] (mwifiex_add_virtual_intf [mwifiex]) from [<bf26c79c>] 
(_mwifiex_fw_dpc+0x264/0x494 [mwifiex])
[<bf26c79c>] (_mwifiex_fw_dpc [mwifiex]) from [<c06c881c>] 
(request_firmware_work_func+0x58/0x94)
[<c06c881c>] (request_firmware_work_func) from [<c0149af8>] 
(process_one_work+0x30c/0x888)
[<c0149af8>] (process_one_work) from [<c014a0cc>] (worker_thread+0x58/0x594)
[<c014a0cc>] (worker_thread) from [<c015105c>] (kthread+0x154/0x19c)
[<c015105c>] (kthread) from [<c010011c>] (ret_from_fork+0x14/0x38)
Exception stack(0xc1cedfb0 to 0xc1cedff8)
...
---[ end trace c04a86d3eb55e7cb ]---
mwifiex_sdio mmc3:0001:1: info: MWIFIEX VERSION: mwifiex 1.0 (14.68.29.p59)
mwifiex_sdio mmc3:0001:1: driver_version = mwifiex 1.0 (14.68.29.p59)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

