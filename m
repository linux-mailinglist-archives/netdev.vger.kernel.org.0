Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBAB28FA08
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392210AbgJOUR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:17:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59046 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392167AbgJOUR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 16:17:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FKANCM103594;
        Thu, 15 Oct 2020 20:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : mime-version : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7QAvXMeeS57/+hrtbbW9yGz6rPw3JrSqRU0qxFyRT80=;
 b=A1OkIizRKmb2Tfffot7DQRboH4NjLAAgg5VPMw/Qu1eoLeLv4ZaX1f8u9SUO4FPblYJ3
 3aUqC3tk/9dI2gBCyGsH5GwfrmqnjVHfofMK4BafUdLOEtERR9UNrJW1I6UTgqOL/tds
 Asns4lw07xICdR7ozCNJ2SliSuUeCPsilY+yYYY0NS3u+SuFYwza0P6vzliH117c0jR2
 7udPRVs9MSAH8Z7oiOb7DG6irDjeEzpPUtWCJCRzSQhrgTw8rV97FY9Bgy5T0MclLfOw
 cyZKnXPphc+kGheXmu65EgCai+41ygQtK7kS7v9cRiEiOJOlowOVLsTbSykQjaHbrcN/ Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3434wkxt97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 20:17:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09FK6eXF158648;
        Thu, 15 Oct 2020 20:17:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 343pw0u8tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 20:17:18 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09FKHHZU002127;
        Thu, 15 Oct 2020 20:17:17 GMT
Received: from [10.159.253.148] (/10.159.253.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Oct 2020 13:17:17 -0700
Message-ID: <5F88AE4A.9030300@oracle.com>
Date:   Thu, 15 Oct 2020 13:17:14 -0700
From:   si-wei liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     lingshan.zhu@intel.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/2] vhost-vdpa: fix page pinning leakage in error
 path
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com> <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com> <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com> <5F863B83.6030204@oracle.com> <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com> <20201015091150-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201015091150-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=2 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9775 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/15/2020 6:11 AM, Michael S. Tsirkin wrote:
> On Thu, Oct 15, 2020 at 02:15:32PM +0800, Jason Wang wrote:
>> On 2020/10/14 上午7:42, si-wei liu wrote:
>>>>
>>>> So what I suggest is to fix the pinning leakage first and do the
>>>> possible optimization on top (which is still questionable to me).
>>> OK. Unfortunately, this was picked and got merged in upstream. So I will
>>> post a follow up patch set to 1) revert the commit to the original
>>> __get_free_page() implementation, and 2) fix the accounting and leakage
>>> on top. Will it be fine?
>>
>> Fine.
>>
>> Thanks
> Fine by me too.
>
Thanks, Michael & Jason. I will post the fix shortly. Stay tuned.

-Siwei

