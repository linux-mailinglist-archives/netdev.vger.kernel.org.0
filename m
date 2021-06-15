Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C43A7918
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 10:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhFOIf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 04:35:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50875 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhFOIfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 04:35:44 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lt4Vs-00013n-RL; Tue, 15 Jun 2021 08:33:36 +0000
Subject: Re: [PATCH] net: dsa: b53: Fix dereference of null dev
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210612144407.60259-1-colin.king@canonical.com>
 <20210614112812.GL1955@kadam>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <60c9a7c8-95f1-2673-abd0-73853483acb0@canonical.com>
Date:   Tue, 15 Jun 2021 09:33:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210614112812.GL1955@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2021 12:28, Dan Carpenter wrote:
> On Sat, Jun 12, 2021 at 03:44:07PM +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently pointer priv is dereferencing dev before dev is being null
>> checked so a potential null pointer dereference can occur. Fix this
>> by only assigning and using priv if dev is not-null.
>>
>> Addresses-Coverity: ("Dereference before null check")
>> Fixes: 16994374a6fc ("net: dsa: b53: Make SRAB driver manage port interrupts")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/net/dsa/b53/b53_srab.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
>> index aaa12d73784e..e77ac598f859 100644
>> --- a/drivers/net/dsa/b53/b53_srab.c
>> +++ b/drivers/net/dsa/b53/b53_srab.c
>> @@ -629,11 +629,13 @@ static int b53_srab_probe(struct platform_device *pdev)
>>  static int b53_srab_remove(struct platform_device *pdev)
>>  {
>>  	struct b53_device *dev = platform_get_drvdata(pdev);
>> -	struct b53_srab_priv *priv = dev->priv;
>>  
>> -	b53_srab_intr_set(priv, false);
>> -	if (dev)
>> +	if (dev) {
> 
> This is the remove function and "dev" can't be NULL at this point.
> Better to just remove the NULL check.

Will do.

> 
> regards,
> dan carpenter
> 

