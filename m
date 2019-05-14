Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138291C077
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 04:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfENCG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 22:06:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfENCG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 22:06:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E245Vk163757;
        Tue, 14 May 2019 02:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=eBHxKNkRR5Ce1ucgVDEmtR8ENRjTgp/1bnfgKwmBg2Y=;
 b=NTJ9LWVQ6Kn7nMkCJU9mdk4aIXr4+qCp7wdj48YUSGlSO4vTz6WKQpGwtykL2KJsmC/x
 PRuHKi2bLR5mPjPqnvp8amsZ5qyRI5cS6vEQtnneQqqQINGVm9zdgm7vhZvnH3VHuTjs
 Ra0a4P5fz0QdmfxK0ebLMZsxGJeotUVryl3UwbKRJQcAi1Mi2CsEOK9WmXx3LnucoQRz
 W27p5pBK5CpJ6zYCfzJhAvR9FpCNfth2PcyxYLtwCKfmHJZ4DFr5AntSoDsHhlWxQs5i
 Oo0phlnpLRcW80H7QIEPNNHKAfqJgk33P30G1DS+xDsc5i8CQLz3oAwj5t1ldB15YoED gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sdq1qana9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 02:06:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4E25Gc3042362;
        Tue, 14 May 2019 02:06:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2sdmeatf9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 02:06:21 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4E26GEF006926;
        Tue, 14 May 2019 02:06:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 May 2019 19:06:16 -0700
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH V4 0/3] scsi: core: avoid big pre-allocation for sg list
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190428073932.9898-1-ming.lei@redhat.com>
Date:   Mon, 13 May 2019 22:06:13 -0400
In-Reply-To: <20190428073932.9898-1-ming.lei@redhat.com> (Ming Lei's message
        of "Sun, 28 Apr 2019 15:39:29 +0800")
Message-ID: <yq1a7fpg57u.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140013
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140013
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ming,

> Since supporting to blk-mq, big pre-allocation for sg list is
> introduced, this way is very unfriendly wrt. memory consumption.

Applied to 5.3/scsi-queue with some clarifications to the commit
descriptions.

I am not entirely sold on 1 for the inline protection SGL size. NVMe
over PCIe is pretty constrained thanks to the metadata pointer whereas
SCSI DIX uses a real SGL for the PI. Consequently, straddling a page is
not that uncommon for large, sequential I/Os.

But let's try it out. If performance suffers substantially, we may want
to bump it to 2.

-- 
Martin K. Petersen	Oracle Linux Engineering
