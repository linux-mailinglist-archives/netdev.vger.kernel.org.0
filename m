Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88D17563C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 09:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCBIpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 03:45:51 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:25169 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgCBIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 03:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583138748;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=i6p9takFexSOT22m46ceOwKe8WY7h5G2l56FIqviAtA=;
        b=qGKAj/4tM54AZMKYBr8pPEuqO62tFP20adXro6V6a953IFBJ0rDpPKcyx98abw2KHw
        Oym8mdrUpp33svWWu5IYAygWMQaw6X0dax8FPMU9jJp84kl9upQF0BhGFpciTayQoaEA
        8gPXPyp8vf8PYHoN8K2ndQvC8+F586mzfvJxUiBFo1p1KL39Glvfiu4Rl/FrA6okLvgU
        3QGPlVqnmvffxEvtfzC7fInghLXLPMaH9IByZ4TU61W8IEj66PchqskOrOkpLUcOd3mp
        IV3rIKOWLNFeTxqFfO07WTcZG2B2ogZHTDxuO6jxQIM5L5IfdWE8LfSu1C2K9gBxBAn3
        86bg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVMh6kEtw"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id e0a4ffw228jf5Af
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 2 Mar 2020 09:45:41 +0100 (CET)
Subject: Re: [PATCH] bonding: do not enslave CAN devices
To:     David Miller <davem@davemloft.net>, mkl@pengutronix.de
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com,
        dvyukov@google.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stable@vger.kernel.org
References: <20200130133046.2047-1-socketcan@hartkopp.net>
 <767580d8-1c93-907b-609c-4c1c049b7c42@pengutronix.de>
 <20200226.202326.295871777946911500.davem@davemloft.net>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <d6d9368d-b468-3946-ac63-abedf6758154@hartkopp.net>
Date:   Mon, 2 Mar 2020 09:45:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226.202326.295871777946911500.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/02/2020 05.23, David Miller wrote:
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Tue, 25 Feb 2020 21:32:41 +0100
> 
>> On 1/30/20 2:30 PM, Oliver Hartkopp wrote:
>>> Since commit 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
>>> device struct can_dev_rcv_lists") the device specific CAN receive filter lists
>>> are stored in netdev_priv() and dev->ml_priv points to these filters.
>>>
>>> In the bug report Syzkaller enslaved a vxcan1 CAN device and accessed the
>>> bonding device with a PF_CAN socket which lead to a crash due to an access of
>>> an unhandled bond_dev->ml_priv pointer.
>>>
>>> Deny to enslave CAN devices by the bonding driver as the resulting bond_dev
>>> pretends to be a CAN device by copying dev->type without really being one.
>>>
>>> Reported-by: syzbot+c3ea30e1e2485573f953@syzkaller.appspotmail.com
>>> Fixes: 8df9ffb888c ("can: make use of preallocated can_ml_priv for per
>>> device struct can_dev_rcv_lists")
>>> Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
>>> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
>> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>
>> What's the preferred to upstream this? I could take this via the
>> linux-can tree.
> 
> What I don't get is why the PF_CAN is blindly dereferencing a device
> assuming what is behind bond_dev->ml_priv.
> 
> If it assumes a device it access is CAN then it should check the
> device by comparing the netdev_ops or via some other means.

Yes we do.

> This restriction seems arbitrary.

Since commit 8df9ffb888c the data structures for the CAN filters have 
been moved from net/can/af_can.c into netdev->ml_priv.

PF_CAN only works with CAN interfaces and therefore always checks 
dev->type to be ARPHRD_CAN before accessing netdev->ml_priv.

Bonding and Team driver copy most of the device data structures to 
create bonding/team devices.
They copy dev->type but *not* dev->ml_priv.
That leads to the problematic ml_priv access after passing the dev->type 
check ...

I don't know yet whether it makes sense to have CAN bonding/team 
devices. But if so we would need some more investigation. For now 
disabling CAN interfaces for bonding/team devices seems to be reasonable.

Regards,
Oliver
