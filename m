Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F99E2A257C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbgKBHob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgKBHob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:44:31 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A4CC0617A6;
        Sun,  1 Nov 2020 23:44:30 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id k9so8367430pgt.9;
        Sun, 01 Nov 2020 23:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5UJiyEj0RQblTrXTDdoPSJMcQ8VLJhQ7hN0tGhIHA2Q=;
        b=UJCrEWg8deF3Ip1k67cosY86XQ0hGH+1DT1fDExcgdx2ooGq2pATmQonhUYeEOBR+c
         0c9GTpiw7y3CpefJIztawRxRfBGdc43jC8IBR7y+RAWQhs954QqV+YJagfRhWQE64VpE
         0PZdk35Mi2pd9Oo90QN2P9219MNvfml3F9A+5oHs7nE0RTw9eN3N97CdPnFNwHG0n3r3
         /PsDIm2/+wKMdxDz8YT5yl+4veL25xTS9Mm+rrAndQVkhFaXCn4AkW625ER2pxbHgYBP
         hcm2NkDn8U51sjxtkXcxNeDyrn36mGLt/Q01/Q7vfE9FFn5+LK6t10Q8gpijZSEW/+s+
         nydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5UJiyEj0RQblTrXTDdoPSJMcQ8VLJhQ7hN0tGhIHA2Q=;
        b=XRkkb+cHPku+eCXWfXQbXVeY+6qBy/83cheE4e4I82u6dd9IZ60cUC9M7NpRW8XA5s
         4uzFV6x/jNHP03CNe1SyrK6j65//dAO6Ay3IGeGXmEjfxwD6UrOdj4D/UcZPLWRQKU49
         8BDqlnwqmhTawVtuaFXNNn7NbV3g1W2wby8cuBhM4bmIbmW+VsnetEcrwYMAubw7JGSo
         sAjo/StlBwOif+82KZnoU78ENGkHEn77NNP0JzMJGyoSsY3bOVbTU5CbdSECej3f0dAw
         nxACY91RvRsO+HdYn7K8ioSVWI06pRObA0ou0MBgwmZoSGV3FP6L5NVcRhHG+T2/rlJ6
         24sA==
X-Gm-Message-State: AOAM532vtGmcETjRQSdXaUZftzQRboTR9U+gOgTaEGxwD92/6RO89NQd
        nQAgvOKEPenSfGdWrZDddDxf0FHmwiCEWn93h8I=
X-Google-Smtp-Source: ABdhPJwe9gamoPaXUo8fQFD4rDwBbHeFdkRzJLFhVI4etvw6IO1hkdtnAsXYjEg9duoz3oT8dhtbNg==
X-Received: by 2002:a65:6204:: with SMTP id d4mr12665142pgv.206.1604303070204;
        Sun, 01 Nov 2020 23:44:30 -0800 (PST)
Received: from [192.168.0.104] ([49.207.221.93])
        by smtp.gmail.com with ESMTPSA id 199sm5215712pgg.18.2020.11.01.23.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2020 23:44:29 -0800 (PST)
Subject: Re: [PATCH] net: can: prevent potential access of uninitialized value
 in canfd_rcv()
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
References: <20201102031326.430048-1-anant.thazhemadam@gmail.com>
 <1817819d-3aeb-8034-a4ec-7c70040b0cf0@pengutronix.de>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <8c65ee4b-3cb8-907f-fa98-9bf4bd4293d3@gmail.com>
Date:   Mon, 2 Nov 2020 13:14:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1817819d-3aeb-8034-a4ec-7c70040b0cf0@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02-11-2020 12:40, Marc Kleine-Budde wrote:
> On 11/2/20 4:13 AM, Anant Thazhemadam wrote:
>> In canfd_rcv(), cfd->len is uninitialized when skb->len = 0, and this
>> uninitialized cfd->len is accessed nonetheless by pr_warn_once().
>>
>> Fix this uninitialized variable access by checking cfd->len's validity
>> condition (cfd->len > CANFD_MAX_DLEN) separately after the skb->len's
>> condition is checked, and appropriately modify the log messages that
>> are generated as well.
>> In case either of the required conditions fail, the skb is freed and
>> NET_RX_DROP is returned, same as before.
>>
>> Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
>> Tested-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> ---
>> This patch was locally tested using the reproducer and .config file 
>> generated by syzbot.
>>
>>  net/can/af_can.c | 19 ++++++++++++++-----
>>  1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/can/af_can.c b/net/can/af_can.c
>> index ea29a6d97ef5..1b9f2e50f065 100644
>> --- a/net/can/af_can.c
>> +++ b/net/can/af_can.c
>> @@ -694,16 +694,25 @@ static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,
> Can you create a similar patch for "can_rcv()"?

Yes, I can. Would it be alright if that was part of the v2 itself (since it's similar changes)?
Or would I have to split them up into 2 different patches and send it as a 2-patch series
(since the changes made are in different functions)?

>
>>  {
>>  	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
>>  
>> -	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU ||
>> -		     cfd->len > CANFD_MAX_DLEN)) {
>> -		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuf: dev type %d, len %d, datalen %d\n",
>> +	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CANFD_MTU)) {
>> +		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d\n",
>> +			     dev->type, skb->len);
>> +		goto free_skb;
>> +	}
>> +
>> +	// This check is made separately since cfd->len would be uninitialized if skb->len = 0.
> Please don't use C++ comment style in the kernel.

Noted. I'll have this fixed in the v2.

>
>> +	else if (unlikely(cfd->len > CANFD_MAX_DLEN)) {
> Please move the "else" right after the closing curly bracket: "} else if () {"
> or convert it into an "if () {"

Noted.

>
>> +		pr_warn_once("PF_CAN: dropped non conform CAN FD skbuff: dev type %d, len %d, datalen %d\n",
>>  			     dev->type, skb->len, cfd->len);
>> -		kfree_skb(skb);
>> -		return NET_RX_DROP;
>> +		goto free_skb;
>>  	}
>>  
>>  	can_receive(skb, dev);
>>  	return NET_RX_SUCCESS;
>> +
>> +free_skb:
>> +	kfree_skb(skb);
>> +	return NET_RX_DROP;
>>  }
>>  
>>  /* af_can protocol functions */
>>
> regards,
> Marc

Thank you for your time.

Thanks,
Anant

