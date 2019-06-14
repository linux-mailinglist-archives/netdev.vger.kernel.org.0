Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2A945C40
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfFNML1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 08:11:27 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:35295 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFNML1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:11:27 -0400
Received: from [192.168.1.41] ([92.148.209.44])
        by mwinf5d40 with ME
        id QcBN2000a0y1A8U03cBNc2; Fri, 14 Jun 2019 14:11:26 +0200
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 14 Jun 2019 14:11:26 +0200
X-ME-IP: 92.148.209.44
Subject: Re: [PATCH net-next] hinic: Use devm_kasprintf instead of hard coding
 it
To:     aviad.krawczyk@huawei.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <c55cd76d-2d3e-d9b2-1f1b-4881102c407d@wanadoo.fr>
Date:   Fri, 14 Jun 2019 14:11:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I got a:

<aviad.krawczyk@huawei.com>: host huawei.com[103.218.216.136] said: 550
5.1.1 Error: invalid recipients is found from 80.12.242.127

However, MAINTAINERS has:
   HUAWEI ETHERNET DRIVER
   M:	Aviad Krawczyk <aviad.krawczyk@huawei.com>
   L:	netdev@vger.kernel.org
   S:	Supported
   F:	Documentation/networking/hinic.txt
   F:	drivers/net/ethernet/huawei/hinic/

I don't know how this should be fixed (neither if it should be...), so if s.o. knows, please do.

Best regards,
Christophe Jaillet

Le 13/06/2019 à 21:54, Christophe JAILLET a écrit :
> 'devm_kasprintf' is less verbose than:
>     snprintf(NULL, 0, ...);
>     devm_kzalloc(...);
>     sprintf
> so use it instead.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/ethernet/huawei/hinic/hinic_rx.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> index 9b4082557ad5..95b09fd110d3 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> @@ -493,7 +493,7 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
>   		   struct net_device *netdev)
>   {
>   	struct hinic_qp *qp = container_of(rq, struct hinic_qp, rq);
> -	int err, pkts, irqname_len;
> +	int err, pkts;
>   
>   	rxq->netdev = netdev;
>   	rxq->rq = rq;
> @@ -502,13 +502,11 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct hinic_rq *rq,
>   
>   	rxq_stats_init(rxq);
>   
> -	irqname_len = snprintf(NULL, 0, "hinic_rxq%d", qp->q_id) + 1;
> -	rxq->irq_name = devm_kzalloc(&netdev->dev, irqname_len, GFP_KERNEL);
> +	rxq->irq_name = devm_kasprintf(&netdev->dev, GFP_KERNEL,
> +				       "hinic_rxq%d", qp->q_id);
>   	if (!rxq->irq_name)
>   		return -ENOMEM;
>   
> -	sprintf(rxq->irq_name, "hinic_rxq%d", qp->q_id);
> -
>   	pkts = rx_alloc_pkts(rxq);
>   	if (!pkts) {
>   		err = -ENOMEM;


