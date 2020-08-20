Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2CA24B6B9
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbgHTKjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:39:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1934 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731243AbgHTKS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:18:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KAGWqi022030;
        Thu, 20 Aug 2020 03:17:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=vWGxHsCdDOFhdAg7NDVJv0rvYjo12eib8G3udj8ekd8=;
 b=Yz1OvBh4eU97JMnbN/5dn93Y4Yag6FJiuSXFhkN6Iri3cY/gHPYcy+M4iklUvu/mtDzX
 T7VDWZJBt49WqqdJJi8Z7aF1j0xyK5rUOYiANx8Tk7VsaA5wJ4351HyL3vEmRT1sNj3Q
 ekBUjwiAejrKWtLJZpBctUHx4uTIjIGyihepJZEspy45Qe8wCcBtTKeTag4gpxJolJ7E
 A6xmlA2rfUrXDfEToqyH8HFGllEVD7KXbrGnAOEaPFrGC0zBMb5ZU+5qj2hed0rh5VdB
 sxMtnpwShROWcqIoQ3oKR3onXPqnY/ZvVolsuWgSKqAKOucK5nCpw3t+2SySqKz/3zFG Gw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhvkk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 03:17:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 03:17:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Aug 2020 03:17:52 -0700
Received: from [10.193.54.28] (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id DAA4C3F7043;
        Thu, 20 Aug 2020 03:17:49 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH NET] net: atlantic: Use readx_poll_timeout() for
 large timeout
To:     Guenter Roeck <linux@roeck-us.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
References: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
 <20200819161953.GA179916@roeck-us.net>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <1eea92e3-872f-2e83-f97c-4c57cd5d72b2@marvell.com>
Date:   Thu, 20 Aug 2020 13:17:48 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:80.0) Gecko/20100101
 Thunderbird/80.0
MIME-Version: 1.0
In-Reply-To: <20200819161953.GA179916@roeck-us.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_02:2020-08-19,2020-08-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> implemented a read callback with an udelay(10000U). This fails to
>> compile on ARM because the delay is >1ms. I doubt that it is needed to
>> spin for 10ms even if possible on x86.
>>
>> >From looking at the code, the context appears to be preemptible so
> using
>> usleep() should work and avoid busy spinning.
>>
>> Use readx_poll_timeout() in the poll loop.
>>
>> Cc: Mark Starovoytov <mstarovoitov@marvell.com>
>> Cc: Igor Russkikh <irusskikh@marvell.com>
>> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> 
> Fixes: 8dcf2ad39fdb2 ("net: atlantic: add hwmon getter for MAC
> temperature")
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> 
> As in: This patch does not cause any additional trouble and will fix the
> observed compile failure. However, the submitter of 8dcf2ad39fdb2 might
> consider adding a mutex either into hw_atl_b0_get_mac_temp() or into
> the calling code.

Hi Sebastian, Guenter, thanks for catching and taking care of this,
Looks good for me so far.

>> Could someone with hardware please verify it? It compiles, yes.
>>

We'll verify this on our side, sure.

Regards,
  Igor
