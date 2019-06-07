Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11963846F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfFGGg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:36:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40999 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727417AbfFGGgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 02:36:24 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190607063622euoutp01c352a425fd54be3b86d2478c6fc48a05~l1yECW1Fv0880508805euoutp014
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 06:36:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190607063622euoutp01c352a425fd54be3b86d2478c6fc48a05~l1yECW1Fv0880508805euoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559889382;
        bh=4dIKFHzGeWRANLIGlUbVTNAeAcyQG23/AuW/VLw3TLA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=gJkxsWFmGg4n0Vd99kYYQvX/CHLe6rLEVU3q9/43pclg5Amc7/vkldDutsD5w6lTC
         TviRlq+0CISr7ufXTtP9OtHtShLFS6BPf2M6z3jwLcn5916F8Vl5S6z6Q1llsA6BoE
         oZgfgr3wePxuE+HXXIr9PTCzGMJZRsS+tW2Nrm/E=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190607063621eucas1p1ee145ac25ce6b9b4640814f5704a3653~l1yDBO6bo1300013000eucas1p1F;
        Fri,  7 Jun 2019 06:36:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 22.FE.04377.5E50AFC5; Fri,  7
        Jun 2019 07:36:21 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190607063620eucas1p2b54027b6141b790397c2ddc44879eb01~l1yCKAXS40205402054eucas1p2f;
        Fri,  7 Jun 2019 06:36:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190607063620eusmtrp2ca90c853fcd48331b149b8566dafbe6a~l1yB6Tmul3208732087eusmtrp2D;
        Fri,  7 Jun 2019 06:36:20 +0000 (GMT)
X-AuditID: cbfec7f4-113ff70000001119-e9-5cfa05e5c1f5
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 16.67.04140.4E50AFC5; Fri,  7
        Jun 2019 07:36:20 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190607063619eusmtip2c09a629a3daea4a82bb0539461921c82~l1yBXwF2Y1026410264eusmtip2i;
        Fri,  7 Jun 2019 06:36:19 +0000 (GMT)
Subject: Re: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <3014f882-3042-cb6a-2356-ea3a754840a7@samsung.com>
Date:   Fri, 7 Jun 2019 09:36:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG/XbOdo7m5HPeXrwFQ6gsL0V/nD/SDAoGFZRiN4WcedCRN3bU
        UoOkzNRKRUzdENIu3rooa0wnYjRFs9JFZiohliih00w3c5ZYzjPJ/37f+z4Pz/vARxMSrdCb
        VqRmsMpUebJU5ETqeleNQdPC37Ghd9oxs1bQihhzT5+IqTHmk8yn26sU0/FCRTBDHTUiptHw
        hmJ6az2ZttIuFOEo0zaNCWR69Tgle9Q5I5CVaJuRzKzxPyW84HQogU1WZLHKkPA4p6SFfrUo
        /Yv71cfDZjIPVeJi5EgDPgjz1iKqGDnREtyIQDewYn9YENTPLpP8w4zAVKEitiwtwxrSxhLc
        gKD/VygvWkQwNzS6KXLDUaC2Lgps7I6DoKuVzyBwngCM42Mi20KE98Hbpz3IxmIcDrqbS5tm
        EgfA8tKTTbMHPgcWvcaucYV+1dRmsiMOA1P3IGVjAnvBDUuTkOed0DZfQ9jCABsosNbeF/Fn
        HwX9y2p7BTeY7dNSPPvCX/0DAc/XYSJ/BvHmQgRVhnX74jBoTbY0eiNhD7R0hPDjI5Bfd0tg
        GwN2gdF5V/4GFyjXVRH8WAyFBRJeHQB/XjfYL/CGsR9mqgxJ1duaqbe1UW9ro/6fW4vIZuTF
        ZnIpiSx3IJW9EszJU7jM1MTgS2kpGrTxl96t91naUcdavAFhGkmdxREOq7ESoTyLy04xIKAJ
        qbs464M1ViJOkGfnsMq0i8rMZJYzIB+alHqJcx2+xkhwojyDvcyy6axyayugHb3zkN/s+7sD
        cdS9sBNpH+cqR3zLojR+nZHN5tMnzzizceXGimf+oqJSzXGXtcZXkyv1rOp8+s/w3ulInc/k
        XlV5dYb/5/S6hG/zx0pKY0biLfWe4zCRfG2uavD77lwfj8Cp5yaOc2nQqfXRCo/RpodnRwLw
        LlmOIXqHd/fqgnPGgkJKckny/YGEkpP/Aw3AiwBHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xe7pPWH/FGJy4L2nxp20Do8XnI8fZ
        LOacb2GxuNL+k91i17qZzBaXd81hs1hx6AS7xbEFYhbb+/cxOnB6bFl5k8lj56y77B6L97xk
        8ujbsorR4/MmuQDWKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSc
        zLLUIn27BL2M9ydnsRXcFqlYcvUzSwPjNIEuRk4OCQETifVXN7F0MXJxCAksZZRYefwfK0RC
        SuLHrwtQtrDEn2tdbBBF7xkl9l/4zgSSEBYIlpj14yOYLSKgK7FvQyc7SBGzQAOTxPWVe6E6
        DjFK9H57xwhSxSagI3Fq9REwm1fATmJb8ydmEJtFQEXi66elYJNEBSIkZu9qYIGoEZQ4OfMJ
        mM0pYCvx+vA5dhCbWUBd4s+8S8wQtrhE05eVrBC2vMT2t3OYJzAKzULSPgtJyywkLbOQtCxg
        ZFnFKJJaWpybnltspFecmFtcmpeul5yfu4kRGIvbjv3csoOx613wIUYBDkYlHt4ZTD9jhFgT
        y4orc4Ee5GBWEuEtu/AjRog3JbGyKrUoP76oNCe1+BCjKdBzE5mlRJPzgWkiryTe0NTQ3MLS
        0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMHp1QDo2hu1L3cv3d3vD97aC/TS/caJqm9
        zM8i3r+4Pm86j+TZs3wWM1herO495dWvve28lnDJvhyNrs8TruhqHgsRsG7YyPb1830Dj01n
        yrd9jVc9ftilx6DhX9P6ZRl3j1mF67/zX5V97byo3ccU0dkrzscJflygwHP9wTq9Wa9evD4k
        Y5a9y1dELFiJpTgj0VCLuag4EQCMtDJO2wIAAA==
X-CMS-MailID: 20190607063620eucas1p2b54027b6141b790397c2ddc44879eb01
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190606124020eucas1p2007396ae8f23a426a17e0e5481636187
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190606124020eucas1p2007396ae8f23a426a17e0e5481636187
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
        <20190606124014.23231-1-i.maximets@samsung.com>
        <4414B6B6-3FE2-4CF2-A67A-159FCF6B9ECF@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.06.2019 21:03, Jonathan Lemon wrote:
> On 6 Jun 2019, at 5:40, Ilya Maximets wrote:
> 
>> Device that bound to XDP socket will not have zero refcount until the
>> userspace application will not close it. This leads to hang inside
>> 'netdev_wait_allrefs()' if device unregistering requested:
>>
>>   # ip link del p1
>>   < hang on recvmsg on netlink socket >
>>
>>   # ps -x | grep ip
>>   5126  pts/0    D+   0:00 ip link del p1
>>
>>   # journalctl -b
>>
>>   Jun 05 07:19:16 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>
>>   Jun 05 07:19:27 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>   ...
>>
>> Fix that by counting XDP references for the device and failing
>> RTM_DELLINK with EBUSY if device is still in use by any XDP socket.
>>
>> With this change:
>>
>>   # ip link del p1
>>   RTNETLINK answers: Device or resource busy
>>
>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>
>> Another option could be to force closing all the corresponding AF_XDP
>> sockets, but I didn't figure out how to do this properly yet.
>>
>>  include/linux/netdevice.h | 25 +++++++++++++++++++++++++
>>  net/core/dev.c            | 10 ++++++++++
>>  net/core/rtnetlink.c      |  6 ++++++
>>  net/xdp/xsk.c             |  7 ++++++-
>>  4 files changed, 47 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 44b47e9df94a..24451cfc5590 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
>>   *	@watchdog_timer:	List of timers
>>   *
>>   *	@pcpu_refcnt:		Number of references to this device
>> + *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
>>   *	@todo_list:		Delayed register/unregister
>>   *	@link_watch_list:	XXX: need comments on this one
>>   *
>> @@ -1966,6 +1967,7 @@ struct net_device {
>>  	struct timer_list	watchdog_timer;
>>
>>  	int __percpu		*pcpu_refcnt;
>> +	int __percpu		*pcpu_xdp_refcnt;
>>  	struct list_head	todo_list;
> 
> 
> I understand the intention here, but don't think that putting a XDP reference
> into the generic netdev structure is the right way of doing this.  Likely the
> NETDEV_UNREGISTER notifier should be used so the socket and umem unbinds from
> the device.
> 

Thanks for the pointer! That is exactly what I looked for.
I'll make a new version that will unbind resources using netdevice notifier.

Best regards, Ilya Maximets.
