Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1618E1AB
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 15:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgCUOAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 10:00:46 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:20019 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgCUOAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 10:00:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1584799242;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=s0czIst+WW+j2/qCI7TgrMDLfOaTf0kM9P2DhBCjtAQ=;
        b=mpUL6sss6XHmDOR652UKiV/Mx58Z7utOIrDeGk/QfEBipCf3EVRLkGi/G1n9Jc2m70
        IxZwEIoFbvd8G20FOYquVx1ptrZNAFhmgu7tz3X/vSN4ZLxWsvHfYxPxygn0TfLTrsXB
        VeCOzErI9rbpvwlOrIoEY0oSmx25VZ5fHqKzzTrsKWT2BcSN4ac+T/A38PGwFZVVFeC9
        oIaXn9w+VbwtnOeXbCu0klt+D5jgIH/G2NNaFnRO+GOt37J9dFR4vMykwWqO9TEyORaL
        ZwVmXl7vTIf5AUS9f9b5cYDRFPZm28hC6em5EC4ILgfi4Qge5qG5Pu7UoMkqNt+q0ghz
        KUZA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGXsh6kk/L"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 46.2.1 DYNA|AUTH)
        with ESMTPSA id R0105bw2LE0U6ff
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 21 Mar 2020 15:00:30 +0100 (CET)
Subject: Re: [PATCH] bonding: do not enslave CAN devices
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stable@vger.kernel.org
References: <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
 <20200302.111249.471862054833131096.davem@davemloft.net>
 <03ff979e-a621-c9a3-9be3-13677c147f91@pengutronix.de>
 <20200306.211320.1410615421373955488.davem@davemloft.net>
 <d69b4a32-5d3e-d100-78d3-d713b97eb2ff@pengutronix.de>
 <20200313095610.x3iorvdotry54vb4@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <42aee2fd-b6d4-fa28-27fc-f8faab32c73f@hartkopp.net>
Date:   Sat, 21 Mar 2020 15:00:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200313095610.x3iorvdotry54vb4@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Sabrina Dubroca (takes care of team driver which has the same issue)

On 13/03/2020 10.56, Oleksij Rempel wrote:
> On Mon, Mar 09, 2020 at 11:25:50AM +0100, Marc Kleine-Budde wrote:
>> On 3/7/20 6:13 AM, David Miller wrote:

>>> Like this:
>>>
>>> if (netdev->ops != &can_netdev_ops)
>>> 	return;
>>
>> There is no single can_netdev_ops. The netdev_ops are per CAN-network
>> driver. But the ml_priv is used in the generic CAN code.
> 
> ping,
> 
> are there any other ways or ideas how to solve this issue?

Well, IMO the patch from
https://marc.info/?l=linux-can&m=158039108004683
is still valid.

Although the attribution that commit 8df9ffb888c ("can: make use of 
preallocated can_ml_priv for per device struct can_dev_rcv_lists")
introduced the problem could be removed.

Even before this commit dev->ml_priv of CAN interfaces has been used to 
store the filter lists. And either the bonding and the team driver do 
not take care of ml_priv.

They pretend to be CAN interfaces by faking dev->type to be ARPHRD_CAN - 
but they are not. When we dereference dev->ml_priv in (badly) faked CAN 
devices we run into the reported issue.

So the approach is to tell bonding and team driver to keep the fingers 
away from CAN interfaces like we do with some ARPHRD_INFINIBAND setups 
in bond_enslave() too.

Regards,
Oliver
