Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF41044CD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKTUKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:10:43 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:29651 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfKTUKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:10:42 -0500
X-Greylist: delayed 85531 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2019 15:10:41 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574280640;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=NahboDlRlc3eCYDpxjFEpMFnFTZfVr97Z4fujsnDEvU=;
        b=V/QaMcJ0e3pHNTjC8XSPZ4Rh8VElr3rPI6ylXELwCbxkjJY1XRLnBhhhN6xcMIvbl4
        wDMgTHvFY/9h7vCOlNUhcF1LVCT6P7GFgZZkrABX4NVGXjMYjsQf9qrxyqnU69IQhnWc
        SRzEgij6Bj4xWrJW9+BpBkz11c9N4XSuRB8HDJp1AubQmm3xnLE49iAPSUv+ineUoj81
        +NMR3oo2VWNvSucUJGaG1yh9FYA7mC2MfKqVZN8o/2mEijE3U/QpwndHvQsu4X5O4nlq
        xmoZJrGtBs6B7z0F7WGupbaX2APiDo1vqZNm3Jc42istlTfuOkB9moTbixodUjdJMhpX
        Zveg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGUch5lU37"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id C03a03vAKKAT9y9
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 20 Nov 2019 21:10:29 +0100 (CET)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <0000000000005c08d10597a3a05d@google.com>
 <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de>
 <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de>
 <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
 <9e06266a-67f3-7352-7b87-2b9144c7c9a9@gmail.com>
 <3142c032-e46a-531c-d1b8-d532e5b403a6@hartkopp.net>
 <92c04159-b83a-3e33-91da-25a727a692d0@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <c1f80bac-bb75-e671-ba32-05cfae86569c@hartkopp.net>
Date:   Wed, 20 Nov 2019 21:10:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <92c04159-b83a-3e33-91da-25a727a692d0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/11/2019 22.09, Eric Dumazet wrote:
> On 11/19/19 12:24 PM, Oliver Hartkopp wrote:
>> Please check commit d3b58c47d330d ("can: replace timestamp as unique skb attribute").
> 
> Oh well... This notion of 'unique skb attribute' is interesting...

Yes. The problem is that the joined filter needs to detect the identical 
skb which is delivered several times to raw_rcv() to process filters 
that are logical ANDed.

>> can_skb_prv(skb)->skbcnt is set to 0 at skb creation time when sending CAN frames from local host or receiving CAN frames from a real CAN interface.
> 
> We can not enforce this to happen with a virtual interface.

You are right. I just discovered that I'm not able to send CAN frames 
via PF_PACKET sockets anymore.

Receiving with a simple test program and Wireshark is fine - but sending 
does not work. PF_PACKET is not creating the same kind of skbs as e.g. 
the CAN_RAW socket does.

So the KMSAN detection was right at the end :-(

I'll take a closer look to enable PF_PACKET to send CAN frames again 
which will fix up the entire  problem.

Thanks for your feedback!

Best,
Oliver
