Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1066145CA8
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfFNMV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 08:21:27 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:19416
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727619AbfFNMV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:21:27 -0400
X-IronPort-AV: E=Sophos;i="5.63,373,1557180000"; 
   d="scan'208";a="309260432"
Received: from unknown (HELO hadrien.local) ([163.173.90.224])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 14:21:24 +0200
Date:   Fri, 14 Jun 2019 14:21:23 +0200 (CEST)
From:   Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
cc:     aviad.krawczyk@huawei.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] hinic: Use devm_kasprintf instead of hard coding
 it
In-Reply-To: <c55cd76d-2d3e-d9b2-1f1b-4881102c407d@wanadoo.fr>
Message-ID: <alpine.DEB.2.20.1906141420280.9068@hadrien>
References: <20190613195412.1702-1-christophe.jaillet@wanadoo.fr> <c55cd76d-2d3e-d9b2-1f1b-4881102c407d@wanadoo.fr>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-573815791-1560514884=:9068"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--8323329-573815791-1560514884=:9068
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Fri, 14 Jun 2019, Christophe JAILLET wrote:

> Hi,
>
> I got a:
>
> <aviad.krawczyk@huawei.com>: host huawei.com[103.218.216.136] said: 550
> 5.1.1 Error: invalid recipients is found from 80.12.242.127
>
> However, MAINTAINERS has:
>   HUAWEI ETHERNET DRIVER
>   M:	Aviad Krawczyk <aviad.krawczyk@huawei.com>
>   L:	netdev@vger.kernel.org
>   S:	Supported
>   F:	Documentation/networking/hinic.txt
>   F:	drivers/net/ethernet/huawei/hinic/
>
> I don't know how this should be fixed (neither if it should be...), so if s.o.
> knows, please do.

Maybe this person would know, since he is also from Huawei and has signed
off on a patch by Aviad Krawczyk:

cde66f24c3bf42123647c5233447c5790d92557f
Signed-off-by: Zhao Chen <zhaochen6@huawei.com>

julia

>
> Best regards,
> Christophe Jaillet
>
> Le 13/06/2019 à 21:54, Christophe JAILLET a écrit :
> > 'devm_kasprintf' is less verbose than:
> >     snprintf(NULL, 0, ...);
> >     devm_kzalloc(...);
> >     sprintf
> > so use it instead.
> >
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> >   drivers/net/ethernet/huawei/hinic/hinic_rx.c | 8 +++-----
> >   1 file changed, 3 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> > b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> > index 9b4082557ad5..95b09fd110d3 100644
> > --- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> > +++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
> > @@ -493,7 +493,7 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct
> > hinic_rq *rq,
> >   		   struct net_device *netdev)
> >   {
> >   	struct hinic_qp *qp = container_of(rq, struct hinic_qp, rq);
> > -	int err, pkts, irqname_len;
> > +	int err, pkts;
> >     	rxq->netdev = netdev;
> >   	rxq->rq = rq;
> > @@ -502,13 +502,11 @@ int hinic_init_rxq(struct hinic_rxq *rxq, struct
> > hinic_rq *rq,
> >     	rxq_stats_init(rxq);
> >   -	irqname_len = snprintf(NULL, 0, "hinic_rxq%d", qp->q_id) + 1;
> > -	rxq->irq_name = devm_kzalloc(&netdev->dev, irqname_len, GFP_KERNEL);
> > +	rxq->irq_name = devm_kasprintf(&netdev->dev, GFP_KERNEL,
> > +				       "hinic_rxq%d", qp->q_id);
> >   	if (!rxq->irq_name)
> >   		return -ENOMEM;
> >   -	sprintf(rxq->irq_name, "hinic_rxq%d", qp->q_id);
> > -
> >   	pkts = rx_alloc_pkts(rxq);
> >   	if (!pkts) {
> >   		err = -ENOMEM;
>
>
>
--8323329-573815791-1560514884=:9068--
