Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8F2CF1AC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgLDQNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:13:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43384 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgLDQNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:13:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4G95ps138159;
        Fri, 4 Dec 2020 16:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=87V0vBKZMG5YXDONYo3hdIWeOjNHJMRmA9Y1tYp7IAw=;
 b=wQ6VPLqq61Gvpsotnsvxxi0MYBhn4OA+gcsxLVgyohkrr7wxrT9x7LifhGS1xEuGk14t
 AgWXecRxn4iSyQy6DB56rOkpSIOyJfyBmxHt8GSB4BWV6fqb8WiVYWLM92csvN3Tcpiw
 nTvEAA7vk2uFGEHB5lfkQ/pf8AZOowlfyfI5yIJfdvPJF1rvz4PHTgrU7MN7B7k8+7eN
 AobBRr31UKywxF/dAF1u20bpPX1eGJ2hhOSv5N4FBJRy2CpXgDqRBe86aEGaqydNwvH7
 Lt9610A2s7Y6jFXR0ZAAB3woACSwQqA5ksSJbCvyOOCDcawhoOvI4fIKBRkjDD0whsgB 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egm3vjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 16:12:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4G9V4n100254;
        Fri, 4 Dec 2020 16:12:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540g3v4fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 16:12:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B4GC9VL019559;
        Fri, 4 Dec 2020 16:12:09 GMT
Received: from [10.154.152.223] (/10.154.152.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 08:12:09 -0800
Subject: Re: [PATCH] vhost scsi: fix error return code in
 vhost_scsi_set_endpoint()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <1c6e01d0-9329-862c-6480-fbb91a8910cf@oracle.com>
Date:   Fri, 4 Dec 2020 10:12:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1607071411-33484-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/20 2:43 AM, Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>   drivers/vhost/scsi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 6ff8a5096..4ce9f00 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1643,7 +1643,8 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
>   			if (!vhost_vq_is_setup(vq))
>   				continue;
>   
> -			if (vhost_scsi_setup_vq_cmds(vq, vq->num))
> +			ret = vhost_scsi_setup_vq_cmds(vq, vq->num);
> +			if (ret)
>   				goto destroy_vq_cmds;
>   		}
>   
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
