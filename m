Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8469A59573
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfF1IBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:01:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51586 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfF1IBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:01:19 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080117euoutp016982a87c4b067ecb79b2373aaf24e748~sTfMKkTl61366213662euoutp01G
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:01:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190628080117euoutp016982a87c4b067ecb79b2373aaf24e748~sTfMKkTl61366213662euoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561708877;
        bh=wcgcV0tJwUzmXVmNXDGn4ZkkEJhhcwPdUNLlNuG05po=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=F50dR3047CR+jwhOCx/qfu+sSDjC+EjPweVha1V78tIIbF2yZy1xvX1pXMrNBnN15
         rgoqPu/ocKBbMUGZNeW3AImNXbW1nBMATeK1wXNrAeVs3B3ulp2J3Qb0ODvOJDKPWw
         8o7ArQMMKZEJXrgmTV9TVnWQDzAmFNLd+2OVg5W0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190628080116eucas1p29b9b99feeba3a229e081a2cfcf916838~sTfLbq3vP1442914429eucas1p2M;
        Fri, 28 Jun 2019 08:01:16 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 07.9B.04325.B49C51D5; Fri, 28
        Jun 2019 09:01:15 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080115eucas1p1edc82651728719c2413ffc16b576a0ed~sTfKrzTTu2969929699eucas1p1I;
        Fri, 28 Jun 2019 08:01:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190628080115eusmtrp12959d6a6fcc277d7fbac5bd93f35e34c~sTfKdtbt32149521495eusmtrp1r;
        Fri, 28 Jun 2019 08:01:15 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-d8-5d15c94b888e
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id FC.D6.04146.B49C51D5; Fri, 28
        Jun 2019 09:01:15 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080114eusmtip1b8fee092190bf5f677ed1f155cc87b4f~sTfJ1ltX31983619836eusmtip11;
        Fri, 28 Jun 2019 08:01:14 +0000 (GMT)
Subject: Re: [PATCH bpf v5 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <2190070e-db72-6fbe-8dc9-7567847e48ff@samsung.com>
Date:   Fri, 28 Jun 2019 11:01:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <74C6C13C-651D-4CD1-BCA1-1B8998A4FA31@gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsWy7djPc7reJ0VjDTrXWFj8advAaPH5yHE2
        i8ULvzFbzDnfwmJxpf0nu8WxFy1sFrvWzWS2uLxrDpvFikMngGILxCy29+9jdOD22LLyJpPH
        zll32T0W73nJ5NF14xKzx/Tuh8wefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlbFneQt7wWOB
        ir4dU5gaGG/wdjFyckgImEj8fnyOuYuRi0NIYAWjxOHL6xghnC+MEjdO32GDcD4zShzf/YwN
        pmXqkSksILaQwHJGieYl5RBFHxklDsydBVYkLBAnsaz7HyOILSKgK7FvQyc7SBGzwG0mie3b
        TrCCJNgEdCROrT4CVsQrYCfxYsVfoCIODhYBVYkf7aIgYVGBCInLW3ZBlQhKnJz5hAWkhFPA
        VuLUpnKQMLOAuETTl5WsELa8RPPW2WDvSAhcY5e4cPQ4E8TRLhJb93yGsoUlXh3fwg5hy0ic
        ntzDAmHXS9xveckI0dzBKDH90D+oBnuJLa/Pgd3GLKApsX6XPogpIeAocXimFoTJJ3HjrSDE
        CXwSk7ZNZ4YI80p0tAlBzFCR+H1wOTOELSVx891n9gmMSrOQ/DULyTOzkDwzC2HtAkaWVYzi
        qaXFuempxcZ5qeV6xYm5xaV56XrJ+bmbGIGJ6/S/4193MO77k3SIUYCDUYmHV2GnSKwQa2JZ
        cWXuIUYJDmYlEV7Jc0Ah3pTEyqrUovz4otKc1OJDjNIcLErivNUMD6KFBNITS1KzU1MLUotg
        skwcnFINjPu75nvNy5440ab22oWDJs/OW1xNl4tw+Xvh1YKN5tJTLHd3HJQtUahU+BQXGLFs
        QdkBo/d6Lr9ElJ77xsf6PVQPbKuoWPzqXZ3xAfmlP55/8O1a8OqSYL+4lPpN5vPyLXmh3x5u
        eCY1fzPX6qzYR2USHgn3BUUvG8kHKjGftJEx7bB/ovbIW4mlOCPRUIu5qDgRAH9MtJhYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/xu7reJ0VjDX5c47b407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PP8hb2gscCFX07pjA1MN7g7WLk5JAQMJGY
        emQKSxcjF4eQwFJGie/PprBBJKQkfvy6wAphC0v8udYFFhcSeM8o8eFtGogtLBAnMfXANGYQ
        W0RAV2Lfhk52EJtZ4DaTxJStURBDvzBKLDr7FyzBJqAjcWr1EUYQm1fATuLFCpA4BweLgKrE
        j3ZRkLCoQIREX9tsNogSQYmTM5+wgJRwCthKnNpUDjFeXeLPvEvMELa4RNOXlawQtrxE89bZ
        zBMYhWYh6Z6FpGUWkpZZSFoWMLKsYhRJLS3OTc8tNtQrTswtLs1L10vOz93ECIzVbcd+bt7B
        eGlj8CFGAQ5GJR5ehZ0isUKsiWXFlbmHGCU4mJVEeCXPAYV4UxIrq1KL8uOLSnNSiw8xmgK9
        NpFZSjQ5H5hG8kriDU0NzS0sDc2NzY3NLJTEeTsEDsYICaQnlqRmp6YWpBbB9DFxcEo1MNYV
        nn46o9+5wixU4XPYjiUZK+WUC/rZ3WvC9x398kuTq2DZAatDaSKiu478SWP4aMxzPCGpkLVr
        979lgtoJwS+OZy8NPXMjdfOiN5Urttt+37Lo9euns75vUWK1ql0clnzpnw/vKn3Zaffb0/gn
        m33jiaxzFFxqc2TpIzc9U/PI8K6gNSFOq5VYijMSDbWYi4oTAaZyV5HrAgAA
X-CMS-MailID: 20190628080115eucas1p1edc82651728719c2413ffc16b576a0ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934
References: <20190627101529.11234-1-i.maximets@samsung.com>
        <CGME20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934@eucas1p1.samsung.com>
        <20190627101529.11234-3-i.maximets@samsung.com>
        <74C6C13C-651D-4CD1-BCA1-1B8998A4FA31@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.06.2019 1:04, Jonathan Lemon wrote:
> On 27 Jun 2019, at 3:15, Ilya Maximets wrote:
> 
>> Device that bound to XDP socket will not have zero refcount until the
>> userspace application will not close it. This leads to hang inside
>> 'netdev_wait_allrefs()' if device unregistering requested:
>>
>>   # ip link del p1
>>   < hang on recvmsg on netlink socket >
>>
>>   # ps -x | grep ip
>>   5126  pts/0    D+   0:00 ip link del p1
>>
>>   # journalctl -b
>>
>>   Jun 05 07:19:16 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>
>>   Jun 05 07:19:27 kernel:
>>   unregister_netdevice: waiting for p1 to become free. Usage count = 1
>>   ...
>>
>> Fix that by implementing NETDEV_UNREGISTER event notification handler
>> to properly clean up all the resources and unref device.
>>
>> This should also allow socket killing via ss(8) utility.
>>
>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>  include/net/xdp_sock.h |  5 +++
>>  net/xdp/xdp_umem.c     | 10 ++---
>>  net/xdp/xdp_umem.h     |  1 +
>>  net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
>>  4 files changed, 87 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index d074b6d60f8a..82d153a637c7 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -61,6 +61,11 @@ struct xdp_sock {
>>      struct xsk_queue *tx ____cacheline_aligned_in_smp;
>>      struct list_head list;
>>      bool zc;
>> +    enum {
>> +        XSK_UNINITIALIZED = 0,
>> +        XSK_BINDED,
>> +        XSK_UNBINDED,
>> +    } state;
> 
> I'd prefer that these were named better, perhaps:
>    XSK_READY,
>    XSK_BOUND,
>    XSK_UNBOUND,

Sure. Thanks for suggestion!

> 
> Other than that:
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 

I'll send a new version with the new state names keeping your ACK.

Best regards, Ilya Maximets.
