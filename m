Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62D29E431
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgJ2Hfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgJ2HY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:57 -0400
X-Greylist: delayed 2584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Oct 2020 22:34:57 PDT
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A34C0610D3;
        Wed, 28 Oct 2020 22:34:57 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09T4hmWN001609;
        Thu, 29 Oct 2020 04:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=vNOU0G1+nDkC24wwPCUFpoG8J+CFgVtGuanshuUsUsk=;
 b=Caj176iLpfJNs4A7qlOyJTvV5aQLOgImqIxpN1UY4Ag5UH7Irz2CLYZv5v0EZwF7as87
 4AzpQwQ+K3k0Phqhf/zeiaOf4J0cwqya4bhIOKNR2wpTAcACbl+VmseK7p4vyU7Ms2ra
 fC9wK48wwX03Dx6gOg4Yo8mgbSBv4cmTowfTW6TfUr1p1HEKV6acF3j18t4JRIczf4pb
 VPR77BK+klvaRZVTDoWrHLHmPIWxAhDeIUGx95D2JtsmsgaW0MappnojYBtvfl6yPlZ3
 RiYd2/D+T4XOm7FNR6mAyJilgzqhGt22xfjRcVQ+eCXRsN5fNuIIgfkJWWgNOaG9RG4N QQ== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 34cce8c15w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Oct 2020 04:50:38 +0000
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09T4nOLo029340;
        Thu, 29 Oct 2020 00:50:37 -0400
Received: from prod-mail-relay19.dfw02.corp.akamai.com ([172.27.165.173])
        by prod-mail-ppoint3.akamai.com with ESMTP id 34f29rssdy-1;
        Thu, 29 Oct 2020 00:50:37 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay19.dfw02.corp.akamai.com (Postfix) with ESMTP id 685426055F;
        Thu, 29 Oct 2020 04:50:36 +0000 (GMT)
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com>
 <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
 <CAM_iQpX0XzNDCzc2U5=g6aU-HGYs3oryHx=rmM3ue9sH=Jd4Gw@mail.gmail.com>
 <19f888c2-8bc1-ea56-6e19-4cb4841c4da0@akamai.com>
 <93ab7f0f-7b5a-74c3-398d-a572274a4790@huawei.com>
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <248e5a32-a102-0ced-1462-aa2bc5244252@akamai.com>
Date:   Thu, 29 Oct 2020 00:50:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <93ab7f0f-7b5a-74c3-398d-a572274a4790@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_01:2020-10-28,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290034
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_01:2020-10-28,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290034
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.31)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 10:37 PM, Yunsheng Lin wrote:
 > On 2020/10/29 4:04, Vishwanath Pai wrote:
 >> On 10/28/20 1:47 PM, Cong Wang wrote:
 >>> On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath <vpai@akamai.com> 
wrote:
 >>>> Hi,
 >>>>
 >>>> We noticed some problems when testing the latest 5.4 LTS kernel 
and traced it
 >>>> back to this commit using git bisect. When running our tests the 
machine stops
 >>>> responding to all traffic and the only way to recover is a reboot. 
I do not see
 >>>> a stack trace on the console.
 >>>
 >>> Do you mean the machine is still running fine just the network is down?
 >>>
 >>> If so, can you dump your tc config with stats when the problem is 
happening?
 >>> (You can use `tc -s -d qd show ...`.)
 >>>
 >>>>
 >>>> This can be reproduced using the packetdrill test below, it should 
be run a
 >>>> few times or in a loop. You should hit this issue within a few 
tries but
 >>>> sometimes might take up to 15-20 tries.
 >>> ...
 >>>> I can reproduce the issue easily on v5.4.68, and after reverting 
this commit it
 >>>> does not happen anymore.
 >>>
 >>> This is odd. The patch in this thread touches netdev reset path, if 
packetdrill
 >>> is the only thing you use to trigger the bug (that is netdev is 
always active),
 >>> I can not connect them.
 >>>
 >>> Thanks.
 >>
 >> Hi Cong,
 >>
 >>> Do you mean the machine is still running fine just the network is down?
 >>
 >> I was able to access the machine via serial console, it looks like it is
 >> up and running, just that networking is down.
 >>
 >>> If so, can you dump your tc config with stats when the problem is 
happening?
 >>> (You can use `tc -s -d qd show ...`.)
 >>
 >> If I try running tc when the machine is in this state the command never
 >> returns. It doesn't print anything but doesn't exit either.
 >>
 >>> This is odd. The patch in this thread touches netdev reset path, if 
packetdrill
 >>> is the only thing you use to trigger the bug (that is netdev is 
always active),
 >>> I can not connect them.
 >>
 >> I think packetdrill creates a tun0 interface when it starts the
 >> test and tears it down at the end, so it might be hitting this code path
 >> during teardown.
 >
 > Hi, Is there any preparation setup before running the above 
packetdrill test
 > case, I run the above test case in 5.9-rc4 with this patch applied 
without any
 > preparation setup, did not reproduce it.
 >
 > By the way, I am newbie to packetdrill:), it would be good to provide the
 > detail setup to reproduce it,thanks.
 >
 >>
 >> P.S: My mail server is having connectivity issues with vger.kernel.org
 >> so messages aren't getting delivered to netdev. It'll hopefully get
 >> resolved soon.
 >>
 >> Thanks,
 >> Vishwanath
 >>
 >>
 >> .
 >>

I can't reproduce it on v5.9-rc4 either, it is probably an issue only on
5.4 then (and maybe older LTS versions). Can you give it a try on
5.4.68?

For running packetdrill, download the latest version from their github
repo, then run it in a loop without any special arguments. This is what
I do to reproduce it:

while true; do ./packetdrill <test-file>; done

I don't think any other setup is necessary.

-Vishwanath

