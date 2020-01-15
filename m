Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080C413CF51
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgAOVnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:43:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50248 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgAOVnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:43:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLd2hG084410;
        Wed, 15 Jan 2020 21:43:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tgKs1CYV0m0lxT/O856z2kMTdtLmm+hAQOKHL5NVB5s=;
 b=WLbQxwcd7UYIvloCJC0ckH9F0VflmHwQPY5PMqFqcRlaYpcSrJ6Ofcrf46tbLJuAWeJ8
 sJ+AitPYrIiLBnjeR+c0OTRfhCS183jpWLXYeJ1PbhYo4cSyyyZQqkqI1PJ326TXlp+7
 Rvdn78rOFbEcFGCicWZLDqAB1vGKucJulvw3bzxB/+i2yDfEd3au64M/CUohaqpxotAr
 m7dp4P59zyfGYUwhdQE5c0QBvsg4ZwwVIMwj0hmyZVD/+FPsQGX8iJ1FhRW+NTgyCC4a
 b8d/TcbgBME1FoABTjqvB+hKPvKYc8T7OhpsM5aLCNRsMPFPl7jG0f2+YQOr2rx53DzW 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xf74sewv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:43:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FLcvrH072636;
        Wed, 15 Jan 2020 21:43:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2xj61kf03m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 21:43:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FLh86Z014814;
        Wed, 15 Jan 2020 21:43:08 GMT
Received: from [10.209.227.41] (/10.209.227.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 13:43:08 -0800
Subject: Re: [PATCH mlx5-next 10/10] net/rds: Use prefetch for
 On-Demand-Paging MR
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-11-leon@kernel.org>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <4fbb234c-da0d-7cc9-7d02-eb8e4ad40c1e@oracle.com>
Date:   Wed, 15 Jan 2020 13:43:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200115124340.79108-11-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=875
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=927 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 4:43 AM, Leon Romanovsky wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> 
> Try prefetching pages when using On-Demand-Paging MR using
> ib_advise_mr.
> 
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

