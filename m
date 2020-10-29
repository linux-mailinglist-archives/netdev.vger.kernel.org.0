Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E58D29F90C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725780AbgJ2XWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:22:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50796 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2XWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 19:22:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TNJ9Sx088612;
        Thu, 29 Oct 2020 23:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : mime-version : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iCgOVVY9koyTzdluMrIUyT5Ny5E+jy24QzqSTuJHj3c=;
 b=UajiZKtOLPMZtL4AG64Xxkos9PRqnZddXJ5LXntzK8W3pU7KKiQPPFtzXX9vnGkiw2LM
 uqzNDfORhIbgplMymj7XD1FpMg/Hf8whx4L8tqGQDy9PXWAJ4ugOjSDRhW99TLdepN2J
 7qQGSg8WqIZQE5qSmkOjXVD5B40b0/FZaxTInRIXxtLzKuzVTUFCmCrJ8mP3qDEZSnug
 QXag+cz2jOeaOANA4QZ6Z6aj3nu8crXupZni+vUedqpHmuoD8Q37t2Edoa+EcIUbP1HF
 P+syOCwB/I7mS5sR40frL/ppQqhslouqViVD3dUuz1LtZYDfYAKo6RmnnfnvELGJmRnE qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7m7ehf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 23:22:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TNKC6J073198;
        Thu, 29 Oct 2020 23:22:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx612v67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 23:22:34 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TNMYBQ030489;
        Thu, 29 Oct 2020 23:22:34 GMT
Received: from [10.159.253.93] (/10.159.253.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 16:22:33 -0700
Message-ID: <5F9B4EB7.607@oracle.com>
Date:   Thu, 29 Oct 2020 16:22:31 -0700
From:   si-wei liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, lingshan.zhu@intel.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error
 path
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com> <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com> <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com> <5F863B83.6030204@oracle.com> <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com> <20201015091150-mutt-send-email-mst@kernel.org> <5F88AE4A.9030300@oracle.com> <20201029175305-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201029175305-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1011 mlxscore=0 suspectscore=2
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/29/2020 2:53 PM, Michael S. Tsirkin wrote:
> On Thu, Oct 15, 2020 at 01:17:14PM -0700, si-wei liu wrote:
>> On 10/15/2020 6:11 AM, Michael S. Tsirkin wrote:
>>> On Thu, Oct 15, 2020 at 02:15:32PM +0800, Jason Wang wrote:
>>>> On 2020/10/14 上午7:42, si-wei liu wrote:
>>>>>> So what I suggest is to fix the pinning leakage first and do the
>>>>>> possible optimization on top (which is still questionable to me).
>>>>> OK. Unfortunately, this was picked and got merged in upstream. So I will
>>>>> post a follow up patch set to 1) revert the commit to the original
>>>>> __get_free_page() implementation, and 2) fix the accounting and leakage
>>>>> on top. Will it be fine?
>>>> Fine.
>>>>
>>>> Thanks
>>> Fine by me too.
>>>
>> Thanks, Michael & Jason. I will post the fix shortly. Stay tuned.
>>
>> -Siwei
> did I miss the patch?
>
You didn't, sorry. I was looking into a way to speed up the boot time 
for large memory guest by multi-threading the page pinning process, and 
it turns out I need more time on that. Will post the fix I have now 
soon, hopefully tomorrow.

-Siwei


