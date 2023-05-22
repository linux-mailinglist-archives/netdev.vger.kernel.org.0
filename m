Return-Path: <netdev+bounces-4376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 741D870C419
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FF2E1C20B6C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3270216415;
	Mon, 22 May 2023 17:18:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D191640F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:18:35 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5B5D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:18:33 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id 19Azq1MIc0h9k19AzqvahE; Mon, 22 May 2023 19:18:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1684775912;
	bh=RACWwSG+Hb9eOENQpBti3yzC14aelYWu586byj6TxBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a55CHq6gXnelkrtko2pskwk2BzcGk8HFsYmXYYrewWPHJ9FmxUM+ZpgWQ6yzods6A
	 BEuGjnaLFF1Sa7QvRUD/rb55TxY/BRTJKpy2QKdptb6EBx2R7J9f9+mSwJjWwL6zgH
	 BcubzWufdl/IscEzx5iLKm4vY2pAsdtQt9NIF9OLG6xS1W8vOKbvuuSqoIgsOCBjKr
	 snVA/owi1puimyOKc7xYxOmvZXoHtMa3KtayKKYiIYl6Ene3wMwM/+0hHcnmAJv5f3
	 7fsra+9oLsX0DPOq2hXPRjuahYXL5jy7ArdHLjXvmj3yz6dHwGbXcsL3GeqkGe7DYq
	 Gq669Z/75CFeg==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 22 May 2023 19:18:32 +0200
X-ME-IP: 86.243.2.178
Message-ID: <59ca8e12-a4ab-7f5b-68ba-fe04683b3cf5@wanadoo.fr>
Date: Mon, 22 May 2023 19:18:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] 3c589_cs: Fix an error handling path in tc589_probe()
Content-Language: fr, en-GB
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 netdev@vger.kernel.org
References: <d8593ae867b24c79063646e36f9b18b0790107cb.1684575975.git.christophe.jaillet@wanadoo.fr>
 <ZGthVr9FppjWDA9F@corigine.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <ZGthVr9FppjWDA9F@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Le 22/05/2023 à 14:34, Simon Horman a écrit :
> On Sat, May 20, 2023 at 11:48:55AM +0200, Christophe JAILLET wrote:
>> Should tc589_config() fail, some resources need to be released as already
>> done in the remove function.
>>
>> Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
> 
> That commit is probably going back far enough, but I actually
> suspect the problem has been there since the beginning of git history.

In fact, before that commit, the probe was always returning 0, so there 
was no need for an error handling path.

FYI, commit 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() 
functions") messed up many drivers for the same reason.
I sent a few patches to see if there was an interest to fix these 
(really) old drivers, most linked with pcmcia which seems to slowly be 
removed from the kernel.

So I'm a bit unsure if fixing it really matters.
Let see if I collect some other R-b tags for the other patches.

CJ

> 
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> 
> 


