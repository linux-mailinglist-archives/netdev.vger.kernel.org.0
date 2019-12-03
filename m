Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4870510FBDB
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 11:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfLCKiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 05:38:14 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:36543 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCKiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 05:38:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1575369492;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=o9i3/yanwDyaN0+23FOIDMIC4RdoI5wBh4FGxZDhL/A=;
        b=UaoPpRXQMqj4GhUq/jJ+ahNInZkU0YYIm4NpH0YyOJ1C+3NVwTgYEa1tOeoCy60y6c
        Vi5+Ep2lcnGUPJyIL7tUiVS5Mo8yE1amZxc88KvMjW5Olr8uD9X5g5dLRhLZQyGaKasI
        frKvAPNS3gsX7ZhcodNSFGN2wyBVT9cIvV36pWKefJ/IkNo+i+4CFjQyZvLGjwoIUTzO
        iccQXRu8tJNnLhpXjJx0g3rcxvpCREpANHajUJ643beXdyr/TzQrawyz0gfVEW+YnKke
        RV9MmGwILPDsL+RgE9D0LqDbfLmC1B7r4cvxdE7/sirK8F0npUrD480/TFpYLUd8NmbN
        nQJQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3jXdVqE32oRVrGn+26OxA=="
X-RZG-CLASS-ID: mo00
Received: from [10.180.55.161]
        by smtp.strato.de (RZmta 46.0.2 SBL|AUTH)
        with ESMTPSA id 90101evB3Ac33Ap
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 3 Dec 2019 11:38:03 +0100 (CET)
Subject: Re: KMSAN: uninit-value in can_receive
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
 <c1f80bac-bb75-e671-ba32-05cfae86569c@hartkopp.net>
 <0f395f1e-b7d4-6254-2a0c-54029b4dc38f@pengutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <82b02a62-51ff-4568-c33d-90223a2aed86@hartkopp.net>
Date:   Tue, 3 Dec 2019 11:37:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0f395f1e-b7d4-6254-2a0c-54029b4dc38f@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No. I have analyzed several solutions which turn out to be either unsafe 
in processing or need some changes in af_packet :-(

I'm currently very busy @work but will come up with a discussion until 
end of this week.

There is no big pressure as the problem is more unpleasant than causing 
a real problem right now.

Best regards,
Oliver

On 03/12/2019 11.09, Marc Kleine-Budde wrote:
> On 11/20/19 9:10 PM, Oliver Hartkopp wrote:
> [...]
>> So the KMSAN detection was right at the end :-(
>>
>> I'll take a closer look to enable PF_PACKET to send CAN frames again
>> which will fix up the entire  problem.
> 
> I'm going to send a pull request today. Do you already have a fix for this?
> 
> regards,
> Marc
> 
