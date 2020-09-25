Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D202792B6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgIYUyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:54:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgIYUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 16:54:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PKn2cc039197;
        Fri, 25 Sep 2020 20:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=KE/6frUW0qLJ4yGqJjxsOBztcMMvJKPi7N6S9765s1A=;
 b=t0qzyxZi0dl+YKzXtuDuHrMGqOKgH5fIMmpwIJWVMm/U3dTu+P1SS3kJTlx79mD5uwMC
 A2Edf31HXh7Zjrho5JXRQeOv1ImV1hVmEUYsbtNFLoJL4bYLIxAyhjP+J/0Zp7ifDQzk
 3Nx9/VbQNAqiGj7LS7WXYR2mfogIVEGEDnYRbjzFJkRbq3WNPTTAj2pLS3zagmxoYMTV
 iw0TWXITzP/XF5OpedI74kVNFQzbK4Xkz4lunnpJPRW1Rg6Stg2474URqb04tp+XNqiJ
 CwLxCCi7uoZ8T0Vakvb3aUzZrxZh3Nt0KvQ9mrqnvOxELTIQV/CUCoVWCkaNPXyc2d99 Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnuysne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 20:54:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PKoEmv040658;
        Fri, 25 Sep 2020 20:54:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33r28yufem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 20:54:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08PKsBj6030876;
        Fri, 25 Sep 2020 20:54:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 13:54:10 -0700
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <amwang@redhat.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 6/7] scsi: libiscsi: use sendpage_ok() in
 iscsi_tcp_segment_map()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18scxinmw.fsf@ca-mkp.ca.oracle.com>
References: <20200925150119.112016-1-colyli@suse.de>
        <20200925150119.112016-7-colyli@suse.de>
Date:   Fri, 25 Sep 2020 16:54:07 -0400
In-Reply-To: <20200925150119.112016-7-colyli@suse.de> (Coly Li's message of
        "Fri, 25 Sep 2020 23:01:18 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=845
 suspectscore=1 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=827 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250150
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Coly,

> In iscsci driver, iscsi_tcp_segment_map() uses the following code to
> check whether the page should or not be handled by sendpage:
>     if (!recv && page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)))
>
> The "page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)" part is to
> make sure the page can be sent to network layer's zero copy path. This
> part is exactly what sendpage_ok() does.
>
> This patch uses  use sendpage_ok() in iscsi_tcp_segment_map() to replace
> the original open coded checks.

Looks fine to me.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
