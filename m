Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FD82A3BFE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgKCFez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:34:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41152 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgKCFez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:34:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A35YmhY057709;
        Tue, 3 Nov 2020 05:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : mime-version : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HlT5yJVmAJtxWGJeAI2tVIvqrtonMltJepMGyY8oo38=;
 b=Wx+EmW8BNpU+Dka5DuqAk6puQvQotsLuVBMOBSJqKpYabLf+eJp9ItSmf33Kr5XwOjFY
 t2qhYultNad0JHbxteK+ND5qv5vKurNvuPZn2dILJ61m9l/Yn2NhB82qdt12oIB8LoWB
 2JcLqjMdyB4joOs1JTj5+Yz+VM0mrgwEeqOZnNrBW0mJ6G6VsZxR9efNVjnFZln0BAjY
 RV3V2RGgTylwq0PCmQ6Ohq8dn2x2c11mObHnJ3U3qA2+DXFbK60Gy+rQrP3Ibucy1zcD
 yOEDwcJiQDyPbhqUxTYpla87v5cDrwh/5CjKLjC+b+ISO6l4ubnGmKXlNIq+a6B0R2t5 PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34hhb1yc5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 05:34:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A35UgPr053927;
        Tue, 3 Nov 2020 05:34:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34hw0cy2w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 05:34:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A35YkoU015307;
        Tue, 3 Nov 2020 05:34:46 GMT
Received: from [10.159.241.142] (/10.159.241.142)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Nov 2020 21:34:46 -0800
Message-ID: <5FA0EBF4.5050802@oracle.com>
Date:   Mon, 02 Nov 2020 21:34:44 -0800
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
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com> <1601701330-16837-3-git-send-email-si-wei.liu@oracle.com> <574a64e3-8873-0639-fe32-248cb99204bc@redhat.com> <5F863B83.6030204@oracle.com> <835e79de-52d9-1d07-71dd-d9bee6b9f62e@redhat.com> <20201015091150-mutt-send-email-mst@kernel.org> <5F88AE4A.9030300@oracle.com> <20201029175305-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201029175305-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9793 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030041
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
The patch had been posted last Friday. See this thread:

https://lore.kernel.org/virtualization/1604043944-4897-2-git-send-email-si-wei.liu@oracle.com/

-Siwei
