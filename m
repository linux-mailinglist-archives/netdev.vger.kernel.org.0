Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373CF27BC32
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 06:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbgI2Ew1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 00:52:27 -0400
Received: from mxout70.expurgate.net ([91.198.224.70]:21195 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgI2Ew0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 00:52:26 -0400
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kN7ce-000XXd-Kp; Tue, 29 Sep 2020 06:52:16 +0200
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kN7cc-0002oc-8s; Tue, 29 Sep 2020 06:52:14 +0200
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 2FF2124004B;
        Tue, 29 Sep 2020 06:52:13 +0200 (CEST)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 215FE240047;
        Tue, 29 Sep 2020 06:52:13 +0200 (CEST)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B9BA920CA0;
        Tue, 29 Sep 2020 04:52:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Sep 2020 06:52:12 +0200
From:   Martin Schiller <ms@dev.tdt.de>
To:     David Miller <davem@davemloft.net>
Cc:     andrew.hendry@gmail.com, kuba@kernel.org, edumazet@google.com,
        xiyuyang19@fudan.edu.cn, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/x25: Fix null-ptr-deref in x25_connect
Organization: TDT AG
In-Reply-To: <20200928.184326.1754311969939569006.davem@davemloft.net>
References: <20200928092327.329-1-ms@dev.tdt.de>
 <20200928.184326.1754311969939569006.davem@davemloft.net>
Message-ID: <162dd41ee6717ad46e0a37003d922ea1@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1601355134-0001EE7D-F1ADBCC2/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-29 03:43, David Miller wrote:
> From: Martin Schiller <ms@dev.tdt.de>
> Date: Mon, 28 Sep 2020 11:23:27 +0200
> 
>> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
>> index 0bbb283f23c9..0524a5530b91 100644
>> --- a/net/x25/af_x25.c
>> +++ b/net/x25/af_x25.c
>> @@ -820,7 +820,7 @@ static int x25_connect(struct socket *sock, struct 
>> sockaddr *uaddr,
>> 
>>  	rc = x25_wait_for_connection_establishment(sk);
>>  	if (rc)
>> -		goto out_put_neigh;
>> +		goto out;
> 
> If x25_wait_for_connection_establishment() returns because of an 
> interrupting
> signal, we are not going to call x25_disconnect().
> 
> The case you are fixing only applies _sometimes_ when
> x25_wait_for_connection_establishment() returns.  But not always.
> 
> That neighbour has to be released at this spot otherwise.

OK, thanks for the hint. So I think the simplest solution would be to 
check
that x25->neighbour is != NULL like this:

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 0bbb283f23c9..046d3fee66a9 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -825,7 +825,7 @@ static int x25_connect(struct socket *sock, struct 
sockaddr *uaddr,
         sock->state = SS_CONNECTED;
         rc = 0;
  out_put_neigh:
-       if (rc) {
+       if (rc && x25->neighbour) {
                 read_lock_bh(&x25_list_lock);
                 x25_neigh_put(x25->neighbour);
                 x25->neighbour = NULL;
-- 

What do you think?
If that would be OK, I'll send a v2 of the Patch.

- Martin

