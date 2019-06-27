Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AC357D11
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 09:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfF0HXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 03:23:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49969 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfF0HXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 03:23:36 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190627072334euoutp0293dfad6677119e1bc19d074b984ea2d8~r-U_xEIZ72403924039euoutp02y
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 07:23:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190627072334euoutp0293dfad6677119e1bc19d074b984ea2d8~r-U_xEIZ72403924039euoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561620214;
        bh=oGuHAPxwcWpfOMlWoWrei2vmhmacWVvsFMAeQZ+RIf0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=OsHZIxUFjWmECSIISSofxGe+YIg2bIThD6t83Pj6MlhVYXoPrLpToBU204O5BZb0B
         dia05kg9jUQy4zL5DcLmQeE8KXBW8xwJFN0b0y/NDTTPyIyQnKhKqCS7jQuP6cSnZJ
         0/TI/gpgCX4+r5rvQVKqB2y6/DtASVd7LBFETti4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190627072333eucas1p204fec7f4ebf1f64a40a89d832d3c06f6~r-U91uXJb0553205532eucas1p2u;
        Thu, 27 Jun 2019 07:23:33 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 55.40.04325.5FE641D5; Thu, 27
        Jun 2019 08:23:33 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190627072332eucas1p19e61c94d225e7ff2a154e98fc4354047~r-U8-0tI41949519495eucas1p12;
        Thu, 27 Jun 2019 07:23:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190627072332eusmtrp1c81dde32bcab36a468160b74f8323886~r-U8xsNPf1956919569eusmtrp1V;
        Thu, 27 Jun 2019 07:23:32 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-fe-5d146ef5a0ca
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 52.7B.04146.4FE641D5; Thu, 27
        Jun 2019 08:23:32 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190627072331eusmtip138c32d2e43c4ee49c9702f84e0b44316~r-U8G6Ho12895628956eusmtip1Y;
        Thu, 27 Jun 2019 07:23:31 +0000 (GMT)
Subject: Re: [PATCH bpf v4 2/2] xdp: fix hang while unregistering device
 bound to xdp socket
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <30d4e214-f53b-ac2d-e7f7-99bbd7b96b8f@samsung.com>
Date:   Thu, 27 Jun 2019 10:23:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626113427.761cc845@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7djP87pf80RiDaZ9FrD407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK+PVib+MBTc5
        K1ZsrWpg3MvexcjJISFgInH7xE0gm4tDSGAFo8SeSZtZIJwvjBJLHl5hg3A+M0rc3N0HVMYB
        1vLshh9EfDmjxOZl/xkhnI+MEndu7mcBmSssECex/3o7mC0iYCjx68YUVpAiZoHrTBL3b29m
        BkmwCehInFp9hBHE5hWwk3i57zgTiM0ioCox4/MjMFtUIELi8pZdUDWCEidnPmEBuYJTwFri
        2hQDkDCzgLhE05eVrBC2vMT2t3OYQXZJCDxil5j96zILxKMuEvPXfGeFsIUlXh3fAg0AGYnT
        k3ugauol7re8ZIRo7mCUmH7oHxNEwl5iy+tzYO8zC2hKrN+lDxF2lNh24z0TJFT4JG68FYS4
        gU9i0rbpzBBhXomONiGIahWJ3weXM0PYUhI3331mn8CoNAvJY7OQfDMLyTezEPYuYGRZxSie
        Wlqcm55abJyXWq5XnJhbXJqXrpecn7uJEZi6Tv87/nUH474/SYcYBTgYlXh4V+wUjhViTSwr
        rsw9xCjBwawkwpsfJhIrxJuSWFmVWpQfX1Sak1p8iFGag0VJnLea4UG0kEB6YklqdmpqQWoR
        TJaJg1OqgXHj7sn3PbfEBN88k3t1637P/L+KixL9XgZe0njBe3i62NqLJozn2V8JCp1UFw05
        //juoYTXam/Wr9qycxqD1utJJ9cJ9srkxj1rvNhX+E3zRDvDin2xZw/ZlZq86gpb0jD31C37
        Cm412Yd6LpYrlvltjtu1fZ5NTPaJqsqnN/99jJt3qMWras8WJZbijERDLeai4kQAHD3j+lkD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/xu7pf8kRiDd6+F7X407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PVib+MBTc5K1ZsrWpg3MvexcjBISFgIvHs
        hl8XIxeHkMBSRom7qzYwdzFyAsWlJH78usAKYQtL/LnWxQZR9J5R4s/UeWwgCWGBOIkHDQfB
        GkQEDCV+3ZjCClLELHCdSeLOwcesEB0fGCU+PlrCAlLFJqAjcWr1EUYQm1fATuLlvuNMIDaL
        gKrEjM+PwGxRgQiJvrbZbBA1ghInZz5hATmVU8Ba4toUA5Aws4C6xJ95l5ghbHGJpi8rWSFs
        eYntb+cwT2AUmoWkexaSlllIWmYhaVnAyLKKUSS1tDg3PbfYUK84Mbe4NC9dLzk/dxMjMFq3
        Hfu5eQfjpY3BhxgFOBiVeHhX7BSOFWJNLCuuzD3EKMHBrCTCmx8mEivEm5JYWZValB9fVJqT
        WnyI0RTot4nMUqLJ+cBEklcSb2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+J
        g1OqgdHEfNuR7woLGnsyUl5OYOX9Pfvv3bObGeW6BZXqFJv/fV5yQeJCZ8P52WeCD19e+pbX
        6NNmX7X/HnYTzi7dbaby7/qU0wlF6/QfzM/P9lobKq9zRvOo/8tWTgf+fdNWXXBPVuieF7TL
        fI3h8labs9Ofp/R0vVEK1rXduf2bKP8ds1Wsz748yjVTYinOSDTUYi4qTgQAaKZHDuwCAAA=
X-CMS-MailID: 20190627072332eucas1p19e61c94d225e7ff2a154e98fc4354047
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826@eucas1p1.samsung.com>
        <20190626181515.1640-3-i.maximets@samsung.com>
        <20190626113427.761cc845@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.06.2019 21:34, Jakub Kicinski wrote:
> On Wed, 26 Jun 2019 21:15:15 +0300, Ilya Maximets wrote:
>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>> index 267b82a4cbcf..56729e74cbea 100644
>> --- a/net/xdp/xdp_umem.c
>> +++ b/net/xdp/xdp_umem.c
>> @@ -140,34 +140,38 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
>>  	return err;
>>  }
>>  
>> -static void xdp_umem_clear_dev(struct xdp_umem *umem)
>> +void xdp_umem_clear_dev(struct xdp_umem *umem)
>>  {
>> +	bool lock = rtnl_is_locked();
> 
> How do you know it's not just locked by someone else?  You need to pass
> the locked state in if this is called from different paths, some of
> which already hold rtnl.

Oh. That's a shame. I need more sleep.

Thanks for spotting. I'll re-work this part.

Best regards, Ilya Maximets.

> 
> Preferably factor the code which needs the lock out into a separate
> function like this:
> 
> void __function()
> {
> 	do();
> 	the();
> 	things();
> 	under();
> 	the();
> 	lock();
> }
> 
> void function()
> {
> 	rtnl_lock();
> 	__function();
> 	rtnl_unlock();
> }
> 
>>  	struct netdev_bpf bpf;
>>  	int err;
>>  
>> +	if (!lock)
>> +		rtnl_lock();
> 
> 
> 
