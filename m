Return-Path: <netdev+bounces-3054-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D166070544F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF0A51C20C3C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6FE9E551;
	Tue, 16 May 2023 16:47:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2C882A
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:47:26 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6547C4EDD
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:47:24 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id yxpWppJUeNhDHyxpWpID6D; Tue, 16 May 2023 18:47:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1684255641;
	bh=7CfQRDvvwjhMVgiqSklBjw+t8X5eImK79qbg+xMooIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gUAxXW2E6dmUuYm6M0lQ0IvcXGTXAODy0RjazM/n9+9ZhGnKt2+diSTFSaq53JssM
	 NUNkEsLxOK4tsTp3qZxTHbOdUVRWZSvYGyHIsIWhCz4/B386m8wwwBY21tbxgE8Om+
	 fzcG6Y1MV0lRs0bafoUEVSJLrnZRkvNKRc1JCPIv7r5z65ctkiXF8XDeyQRlQfr9EY
	 RGqIHF+KZxKXDgNB/WkSxDLZ22Xwn/5wJ1E6rULf+8SLGHPHe8alPS2jINeCcTQXHk
	 eEPEF3RQSnfPWQI+rL/tXpYpMhnvPBoMo81YXTKOYIgisZbLTdadm6b5qQJqbs7fVO
	 MnFnVogKAHJpw==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 16 May 2023 18:47:21 +0200
X-ME-IP: 86.243.2.178
Message-ID: <86ff131e-c1d2-ca1f-89a4-37cec62877f4@wanadoo.fr>
Date: Tue, 16 May 2023 18:47:17 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] can: ctucanfd: Fix an error handling path in
 ctucan_probe_common()
Content-Language: fr, en-GB
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>, Ondrej Ille <ondrej.ille@gmail.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Martin Jerabek <martin.jerabek01@gmail.com>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-can@vger.kernel.org,
 netdev@vger.kernel.org
References: <4b78c848826fde1b8a3ccd53f32b80674812cb12.1684182962.git.christophe.jaillet@wanadoo.fr>
 <20230515-finisher-plating-8ab57747fea5-mkl@pengutronix.de>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20230515-finisher-plating-8ab57747fea5-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Le 15/05/2023 à 22:51, Marc Kleine-Budde a écrit :
> On 15.05.2023 22:36:28, Christophe JAILLET wrote:
>> If register_candev() fails, a previous netif_napi_add() needs to be undone.
>> Add the missing netif_napi_del() in the error handling path.
> 
> What about this path:
> free_candev(ndev) -> free_netdev() -> netif_napi_del()
> 
> | https://elixir.bootlin.com/linux/v6.3.2/source/net/core/dev.c#L10714
> 
> Marc
> 

Ok, thanks for the review,

so in fact this is the netif_napi_del() call in ctucan_platform_remove() 
that can be removed instead.

Harmless, but would be more consistent.
I'll send a patch for that.

CJ

