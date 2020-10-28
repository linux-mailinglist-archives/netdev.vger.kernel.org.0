Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BE429E158
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgJ2CA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgJ1Vvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:51:40 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D11C0613CF;
        Wed, 28 Oct 2020 14:51:40 -0700 (PDT)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 09SJG5dG030030;
        Wed, 28 Oct 2020 20:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=nXQOVbyB8pxdeSVRR03uPD+fV/eyzypMF/2fEjqk2jY=;
 b=o1gULdxacjs1WySERaLK/PEwjzLxGW55S51Mz4/IVbBOqwiHlS17LQNkyewF6tY4dvAU
 UREYeszxKOqZEM2p/MZ39L9vFCP8G951nbSDiswb7kb5tx0YrkdKiHGOG4bTGhAWZovW
 IS5N/fNyT5X0flLLAJADzBAu91zBqcb3HoHlkd86zEfIJs/Kg7kNqOz2F07SyrsYlHUb
 zb+4wJYHUNiIMxIYS1b9G9dJPR0cUTN79N+WbJ2ED1FES8S2UM2gcnX1rs7UkXgPueC/
 xkcT/1BrAudCSL3wBI2J5CjBqhGKjK1KYpTTNEKBYE30MVyaWR/YGbuAMcw3yO9yeQOB zg== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 34ccex7qe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 20:04:53 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 09SJJk3H021466;
        Wed, 28 Oct 2020 13:04:53 -0700
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint5.akamai.com with ESMTP id 34f1pyhbsn-1;
        Wed, 28 Oct 2020 13:04:53 -0700
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id C90E923A52;
        Wed, 28 Oct 2020 20:04:52 +0000 (GMT)
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "Hunt, Joshua" <johunt@akamai.com>,
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
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <19f888c2-8bc1-ea56-6e19-4cb4841c4da0@akamai.com>
Date:   Wed, 28 Oct 2020 16:04:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX0XzNDCzc2U5=g6aU-HGYs3oryHx=rmM3ue9sH=Jd4Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280122
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_09:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280122
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/20 1:47 PM, Cong Wang wrote:
 > On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath <vpai@akamai.com> wrote:
 >> Hi,
 >>
 >> We noticed some problems when testing the latest 5.4 LTS kernel and 
traced it
 >> back to this commit using git bisect. When running our tests the 
machine stops
 >> responding to all traffic and the only way to recover is a reboot. I 
do not see
 >> a stack trace on the console.
 >
 > Do you mean the machine is still running fine just the network is down?
 >
 > If so, can you dump your tc config with stats when the problem is 
happening?
 > (You can use `tc -s -d qd show ...`.)
 >
 >>
 >> This can be reproduced using the packetdrill test below, it should 
be run a
 >> few times or in a loop. You should hit this issue within a few tries but
 >> sometimes might take up to 15-20 tries.
 > ...
 >> I can reproduce the issue easily on v5.4.68, and after reverting 
this commit it
 >> does not happen anymore.
 >
 > This is odd. The patch in this thread touches netdev reset path, if 
packetdrill
 > is the only thing you use to trigger the bug (that is netdev is 
always active),
 > I can not connect them.
 >
 > Thanks.

Hi Cong,

 > Do you mean the machine is still running fine just the network is down?

I was able to access the machine via serial console, it looks like it is
up and running, just that networking is down.

 > If so, can you dump your tc config with stats when the problem is 
happening?
 > (You can use `tc -s -d qd show ...`.)

If I try running tc when the machine is in this state the command never
returns. It doesn't print anything but doesn't exit either.

 > This is odd. The patch in this thread touches netdev reset path, if 
packetdrill
 > is the only thing you use to trigger the bug (that is netdev is 
always active),
 > I can not connect them.

I think packetdrill creates a tun0 interface when it starts the
test and tears it down at the end, so it might be hitting this code path
during teardown.

P.S: My mail server is having connectivity issues with vger.kernel.org
so messages aren't getting delivered to netdev. It'll hopefully get
resolved soon.

Thanks,
Vishwanath


