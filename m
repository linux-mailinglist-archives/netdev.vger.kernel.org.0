Return-Path: <netdev+bounces-11934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 999DD73558A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 542242810B8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E67C2DC;
	Mon, 19 Jun 2023 11:14:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D2D2F1
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:14:25 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E39C6
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:14:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id C8430207AC;
	Mon, 19 Jun 2023 13:14:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7osX8Hv12rH2; Mon, 19 Jun 2023 13:14:21 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 4EB7E20078;
	Mon, 19 Jun 2023 13:14:21 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 484AD80004A;
	Mon, 19 Jun 2023 13:14:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 19 Jun 2023 13:14:21 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 19 Jun
 2023 13:14:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 81B95318172B; Mon, 19 Jun 2023 13:14:20 +0200 (CEST)
Date: Mon, 19 Jun 2023 13:14:20 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net] xfrm: Linearize the skb after offloading if needed.
Message-ID: <ZJA4jFWxAs19rXK2@gauss3.secunet.de>
References: <20230614100202.1-YtK7H5@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230614100202.1-YtK7H5@linutronix.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 12:02:02PM +0200, Sebastian Andrzej Siewior wrote:
> With offloading enabled, esp_xmit() gets invoked very late, from within
> validate_xmit_xfrm() which is after validate_xmit_skb() validates and
> linearizes the skb if the underlying device does not support fragments.
> 
> esp_output_tail() may add a fragment to the skb while adding the auth
> tag/ IV. Devices without the proper support will then send skb->data
> points to with the correct length so the packet will have garbage at the
> end. A pcap sniffer will claim that the proper data has been sent since
> it parses the skb properly.
> 
> It is not affected with INET_ESP_OFFLOAD disabled.
> 
> Linearize the skb after offloading if the sending hardware requires it.
> It was tested on v4, v6 has been adopted.
> 
> Fixes: 7785bba299a8d ("esp: Add a software GRO codepath")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Applied to the ipsec tree, thanks a lot!

