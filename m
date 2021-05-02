Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76127370B52
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhEBLaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:30:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:41586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhEBLa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:30:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7C363AE38;
        Sun,  2 May 2021 11:29:37 +0000 (UTC)
Subject: Re: [RFC PATCH v4 18/27] qedn: Add qedn_claim_dev API support
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Nikolay Assa <nassa@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-19-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <049e436b-d166-ebdd-5442-f616e7007d0e@suse.de>
Date:   Sun, 2 May 2021 13:29:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-19-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Nikolay Assa <nassa@marvell.com>
> 
> This patch introduces the qedn_claim_dev() network service which the
> offload device (qedn) is using through the paired net-device (qede).
> qedn_claim_dev() returns true if the IP addr(IPv4 or IPv6) of the target
> server is reachable via the net-device which is paired with the
> offloaded device.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Nikolay Assa <nassa@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/hw/qedn/qedn.h      |  4 +++
>   drivers/nvme/hw/qedn/qedn_main.c | 42 ++++++++++++++++++++++++++++++--
>   2 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> index c1ac17eabcb7..7efe2366eb7c 100644
> --- a/drivers/nvme/hw/qedn/qedn.h
> +++ b/drivers/nvme/hw/qedn/qedn.h
> @@ -8,6 +8,10 @@
>   
>   #include <linux/qed/qed_if.h>
>   #include <linux/qed/qed_nvmetcp_if.h>
> +#include <linux/qed/qed_nvmetcp_ip_services_if.h>
> +#include <linux/qed/qed_chain.h>
> +#include <linux/qed/storage_common.h>
> +#include <linux/qed/nvmetcp_common.h>
>   
>   /* Driver includes */
>   #include "../../host/tcp-offload.h"
> diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
> index e3e8e3676b79..52007d35622d 100644
> --- a/drivers/nvme/hw/qedn/qedn_main.c
> +++ b/drivers/nvme/hw/qedn/qedn_main.c
> @@ -27,9 +27,47 @@ static int
>   qedn_claim_dev(struct nvme_tcp_ofld_dev *dev,
>   	       struct nvme_tcp_ofld_ctrl_con_params *conn_params)
>   {
> -	/* Placeholder - qedn_claim_dev */
> +	struct pci_dev *qede_pdev = NULL;
> +	struct net_device *ndev = NULL;
> +	u16 vlan_id = 0;
> +	int rc = 0;
>   
> -	return 0;
> +	/* qedn utilizes host network stack through paired qede device for
> +	 * non-offload traffic. First we verify there is valid route to remote
> +	 * peer.
> +	 */
> +	if (conn_params->remote_ip_addr.ss_family == AF_INET) {
> +		rc = qed_route_ipv4(&conn_params->local_ip_addr,
> +				    &conn_params->remote_ip_addr,
> +				    &conn_params->remote_mac_addr,
> +				    &ndev);
> +	} else if (conn_params->remote_ip_addr.ss_family == AF_INET6) {
> +		rc = qed_route_ipv6(&conn_params->local_ip_addr,
> +				    &conn_params->remote_ip_addr,
> +				    &conn_params->remote_mac_addr,
> +				    &ndev);
> +	} else {
> +		pr_err("address family %d not supported\n",
> +		       conn_params->remote_ip_addr.ss_family);
> +
> +		return false;
> +	}
> +
> +	if (rc)
> +		return false;
> +
> +	qed_vlan_get_ndev(&ndev, &vlan_id);
> +	conn_params->vlan_id = vlan_id;
> +
> +	/* route found through ndev - validate this is qede*/
> +	qede_pdev = qed_validate_ndev(ndev);
> +	if (!qede_pdev)
> +		return false;
> +
> +	dev->qede_pdev = qede_pdev;
> +	dev->ndev = ndev;
> +
> +	return true;
>   }
>   
>   static int qedn_create_queue(struct nvme_tcp_ofld_queue *queue, int qid,
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
