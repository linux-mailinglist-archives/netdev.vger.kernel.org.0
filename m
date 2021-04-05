Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699B8353C14
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 08:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhDEGVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 02:21:04 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:14366 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDEGVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 02:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617603659; x=1649139659;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=IllAWTlByjnUDMPrbBdicSIRjER11MckY9g1Tlavi8g=;
  b=hndZNfFtp/TFS1Z+8GWNI6kPThiNTqhGDlLLc/h7NGDMKI6iZ3NxkfSm
   AnCZVz7FGrsE6HEbQRlGqtqMXsy1irxp3L2zqCNw6WnLmKIAoGmQVx78B
   F/SJhDT3Zo2wH5zyF62DUJSjVyPueo7r8wmuMp3TYzkdJgcH/dHFcWEAp
   s=;
X-IronPort-AV: E=Sophos;i="5.81,305,1610409600"; 
   d="scan'208";a="99090077"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 05 Apr 2021 06:20:51 +0000
Received: from EX13D19EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 7A7F4A1E03;
        Mon,  5 Apr 2021 06:20:45 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.162.239) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 5 Apr 2021 06:20:38 +0000
Subject: Re: [PATCH rdma-next 1/8] RDMA/core: Check if client supports IB
 device or not
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        <netdev@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-2-leon@kernel.org>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <43f5eb80-55b9-722b-1006-23d823108eb1@amazon.com>
Date:   Mon, 5 Apr 2021 09:20:32 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405055000.215792-2-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.239]
X-ClientProxiedBy: EX13D44UWC004.ant.amazon.com (10.43.162.209) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04/2021 8:49, Leon Romanovsky wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> RDMA devices are of different transport(iWarp, IB, RoCE) and have
> different attributes.
> Not all clients are interested in all type of devices.
> 
> Implement a generic callback that each IB client can implement to decide
> if client add() or remove() should be done by the IB core or not for a
> given IB device, client combination.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/device.c | 3 +++
>  include/rdma/ib_verbs.h          | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index c660cef66ac6..c9af2deba8c1 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -691,6 +691,9 @@ static int add_client_context(struct ib_device *device,
>  	if (!device->kverbs_provider && !client->no_kverbs_req)
>  		return 0;
>  
> +	if (client->is_supported && !client->is_supported(device))
> +		return 0;

Isn't it better to remove the kverbs_provider flag (from previous if statement)
and unify it with this generic support check?
