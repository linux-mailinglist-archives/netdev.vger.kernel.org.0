Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDB5302F00
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbhAYW0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:26:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53398 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732959AbhAYVhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:37:25 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210125213614euoutp018ef6572d016ab4e1543d0fe56a990e02~dl0d8mxWz2784627846euoutp01f
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 21:36:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210125213614euoutp018ef6572d016ab4e1543d0fe56a990e02~dl0d8mxWz2784627846euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611610574;
        bh=9hUA3NjGgtMJiwTbY/FEGxMgnQB669QlBgVjRIv10C8=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=XcACO7qfp4gdLwliCKY7TTotXck27RrMzdUsn+jjQOGVd/Pjb943C0iYibTPA6OSo
         nPu1eYI2qvMyMkSGuJF8CNid/GFco7lsTUXJyembY/PzVhi1xOv4KBZm9TrjSZRSWj
         y0OkItNbNdjAUpLZzZAi1EHtBteZs2Hsn0BOkh8A=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210125213613eucas1p13bd56a94ebc65206ffc657a0d1213091~dl0c5bTxZ3081330813eucas1p1W;
        Mon, 25 Jan 2021 21:36:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 21.9E.44805.DC93F006; Mon, 25
        Jan 2021 21:36:13 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210125213612eucas1p1ca606bbd4484cfcb43d3799bcdfb0d94~dl0bwSkzt1887718877eucas1p1J;
        Mon, 25 Jan 2021 21:36:12 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210125213612eusmtrp1031647d8f6a7d63aaa7ca61a766a027f~dl0bvwYcU0251002510eusmtrp1I;
        Mon, 25 Jan 2021 21:36:12 +0000 (GMT)
X-AuditID: cbfec7f4-b37ff7000000af05-cd-600f39cd5fce
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id C6.10.16282.CC93F006; Mon, 25
        Jan 2021 21:36:12 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210125213612eusmtip26b3c81e583210d2e66aa92c86175bce7~dl0bbmRj70320403204eusmtip2-;
        Mon, 25 Jan 2021 21:36:12 +0000 (GMT)
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <bab523e6-c7c7-658e-d5d6-7715ca11948b@samsung.com>
Date:   Mon, 25 Jan 2021 22:36:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9cf620a5ae47bce0cf6344db502589a8763fc861.camel@sipsolutions.net>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42LZduznOd2zlvwJBrs+aVt83PCJxeLNijvs
        FscWiFl0PV7J5sDi0d+7jcVj/ZarLB6fN8kFMEdx2aSk5mSWpRbp2yVwZcyaNJu94CxfxdFz
        XxkbGB9xdzFyckgImEj0/fzB1MXIxSEksIJRont2MyOE84VRYtXBGYwgVUICnxklth4vhunY
        d3gfO0TRckaJ+WsvskE4Hxklvi8+yQpSJSwQJHFz4zYWEFtEwF9i34EGoA4ODmYBG4mFV8AG
        sQkYSnS97WIDCfMK2ElsWakAEmYRUJWYNLedHcQWFUiSuHvnMBOIzSsgKHFy5hMWkHJOAT+J
        pycLQMLMAvIS29/OYYawxSVuPZkP9oyEwA4OiaWvL7NB3Owi8WnGC2YIW1ji1fEt7BC2jMTp
        yT0sEA3NjBIPz61lh3B6GCUuN0F8LyFgLXHn3C82iPs1Jdbv0ocIO0o03drIChKWEOCTuPFW
        EOIIPolJ26YzQ4R5JTrahCCq1SRmHV8Ht/bghUvMExiVZiH5bBaSd2YheWcWwt4FjCyrGMVT
        S4tz01OLjfJSy/WKE3OLS/PS9ZLzczcxAlPJ6X/Hv+xgXP7qo94hRiYOxkOMEhzMSiK8u/V4
        EoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzJm1ZEy8kkJ5YkpqdmlqQWgSTZeLglGpgWhubZLTp
        5ruK+dHvfh3x6RT7vDmKV+T+8Tnv6+usRK/9PbLxdeCOjjvzpPZNXz2pYemSAMGm0m/7+DQ1
        Jt83tlx0lDFflmvVCXtO59beJWesM4/8cY7ferilet6K7pjGI8teVsfqby0rTgyuag5bsMwr
        Qrvs3PVfPgfv+UTVcT00eSZ7/eOCnKjZDCFpCTKyP35vX5grtVi3PuWDtP6S5S0a8tOZDb5J
        CnyOqDD+NK+51OBIVbze99hceR5PNY+wczsdnTZOZ5MU+BjTpPjq7ZdXOmYRc+dK3ndJ5V7x
        6eLZO3v7pm++dOMlezVjzx7XXQ9aljesEXRtmuFxoDz5k4ioaIC+vfm5PMbumNMPlViKMxIN
        tZiLihMBMqiLNZQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xe7pnLPkTDCaflLf4uOETi8WbFXfY
        LY4tELPoerySzYHFo793G4vH+i1XWTw+b5ILYI7SsynKLy1JVcjILy6xVYo2tDDSM7S00DMy
        sdQzNDaPtTIyVdK3s0lJzcksSy3St0vQy5g1aTZ7wVm+iqPnvjI2MD7i7mLk5JAQMJHYd3gf
        excjF4eQwFJGiQldP1kgEjISJ6c1sELYwhJ/rnWxQRS9Z5Q4ObuBCSQhLBAkcXPjNrAGEQFf
        iQV33gNN4uBgFrCRWHilGKJ+EbPE83fTwWrYBAwlut6CDOLg4BWwk9iyUgEkzCKgKjFpbjs7
        iC0qkCRxYtYnZhCbV0BQ4uTMJywg5ZwCfhJPTxaAhJkFzCTmbX7IDGHLS2x/OwfKFpe49WQ+
        0wRGoVlIumchaZmFpGUWkpYFjCyrGEVSS4tz03OLjfSKE3OLS/PS9ZLzczcxAqNn27GfW3Yw
        rnz1Ue8QIxMH4yFGCQ5mJRHe3Xo8CUK8KYmVValF+fFFpTmpxYcYTYHemcgsJZqcD4zfvJJ4
        QzMDU0MTM0sDU0szYyVxXpMja+KFBNITS1KzU1MLUotg+pg4OKUamNTcGg4WPNBJ9fV6fVv0
        zEaziHX8tS7yzyqiOV5xRq642bkjWOX2x0kLo2eofMwLv7o+nqfg7B42m//KSQu7tx1bkzE7
        OynE9vCyg0cuaSgri/3SNTx2YwPvyiePtnPEyTm/87vyK6/p+Y+44mmzIm5unrTc7PiW7aUG
        qQF52c3pP5fEtkR7peitzDiy4ev/6aUhp+NXuQQdu7meTU7g81GrKLYDBRJilUvfRWbqz9O9
        IHtO97ZAxnJul1/2C7dMOqrQoXeuOZlZfmaTI4ea2LWi6+aZIW/7iuw2zVMtUl9n7zvdfkOy
        98rI10cVnZi+HW388excXX/s51XsDQs4ZNZ2xlxWUrctXewmp9t7UImlOCPRUIu5qDgRAFST
        LcAnAwAA
X-CMS-MailID: 20210125213612eucas1p1ca606bbd4484cfcb43d3799bcdfb0d94
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
        <b425cbc3-63a8-3252-e828-bcb7b336b783@samsung.com>
        <9cf620a5ae47bce0cf6344db502589a8763fc861.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 25.01.2021 13:34, Johannes Berg wrote:
>> I've checked today's linux-next with the updated commit 27bc93583e35
>> ("cfg80211: avoid holding the RTNL when calling the driver") and there
>> is still an issue there, but at least it doesn't cause a deadlock:
>>
>> cfg80211: Loading compiled-in X.509 certificates for regulatory database
>> Bluetooth: vendor=0x2df, device=0x912a, class=255, fn=2
>> cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
>> Bluetooth: FW download over, size 533976 bytes
>> btmrvl_sdio mmc3:0001:2: sdio device tree data not available
>> mwifiex_sdio mmc3:0001:1: WLAN FW already running! Skip FW dnld
>> mwifiex_sdio mmc3:0001:1: WLAN FW is active
>> mwifiex_sdio mmc3:0001:1: CMD_RESP: cmd 0x242 error, result=0x2
>> mwifiex_sdio mmc3:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed
>> during       initialization
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 5 at net/wireless/core.c:1336
>> cfg80211_register_netdevice+0xa4/0x198 [cfg80211]
> Yeah, umm, brown paper bag style bug.
>
> I meant to _move_ that line down, but somehow managed to _copy_ it down.
> Need to just remove it since rdev is not even initialized at that point.
>
> I've updated my tree to include this:
>
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 5e8b523dc645..200cd9f5fd5f 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -1333,7 +1333,6 @@ int cfg80211_register_netdevice(struct net_device *dev)
>          int ret;
>   
>          ASSERT_RTNL();
> -       lockdep_assert_held(&rdev->wiphy.mtx);
>   
>          if (WARN_ON(!wdev))
>                  return -EINVAL;
>
Right, this finally fixed all the issues.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

