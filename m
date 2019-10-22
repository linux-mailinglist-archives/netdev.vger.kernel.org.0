Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC784E0B7A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732548AbfJVSdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:33:16 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:11772 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVSdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:33:16 -0400
X-Greylist: delayed 716 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2019 14:33:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571769195;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=SUO95hzSSetluapukGk/6rTRVcsFbnMspEM+35/uuT4=;
        b=alWThASuhCMAIG3VYFJW3cr7HXEFou07OHqbHkWKg/TZNXnBsE14KIvZLT4dsLtC4e
        Xn362WNpG+Oogx0jul2w7hedZHLJfDzh3JVkctB/hehg0rKGMZTZ8N0DzoQU6Hob6oFl
        dhVf9fmDy+OKwG/97YHgY/G0jNEQBwmyFMa7UR2GFOPWzjz4rAebFQmqZvOraBEgsNL5
        9jCNnYXUUz6FpozyTR/iv1bURM1R5/rHiIXLckWHvNlvKI2Jp/vw6OhdSt18pUEKG7Uc
        KPYfnNHJfZDd5qaH3RsGKE10JHLlA9B84mv6j3vhQHGUMDdKDvVTFSw24rMWx8cFB+iL
        svuA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVsh5kk59"
X-RZG-CLASS-ID: mo00
Received: from [192.168.40.177]
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id 20981av9MILER1D
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 22 Oct 2019 20:21:14 +0200 (CEST)
Subject: Re: [PATCH v2] net: sch_generic: Use pfifo_fast as fallback scheduler
 for CAN hardware
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Prince <vincent.prince.fr@gmail.com>, jiri@resnulli.us,
        jhs@mojatatu.com, netdev@vger.kernel.org, dave.taht@gmail.com,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        xiyou.wangcong@gmail.com, davem@davemloft.net
References: <20190327165632.10711-1-mkl@pengutronix.de>
 <1571750597-14030-1-git-send-email-vincent.prince.fr@gmail.com>
 <84b8ce24-fe5d-ead0-0d1d-03ea24b36f71@pengutronix.de>
 <20191022094254.489fd6a4@hermes.lan>
 <b810b1b7-de82-a6ac-f063-5ee8a6460962@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <894a5426-b649-fd51-9aad-e66543374b9e@hartkopp.net>
Date:   Tue, 22 Oct 2019 20:21:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b810b1b7-de82-a6ac-f063-5ee8a6460962@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/10/2019 19.28, Eric Dumazet wrote
> On 10/22/19 9:42 AM, Stephen Hemminger wrote:
> 
>> Why not fix fq_codel to return the same errors as other qdisc?
>>
> 
> I believe the same problem would happen with any qdisc not doing tail drops.
> 
> Do we really want to enforce all qdisc to have a common drop strategy ?

CAN has no drop strategy. There is no transport protocol at this point 
which can handle and compensate drops. CAN is just about PDUs that are 
sent on a special medium.

And that's what this patch was about.

> 
> For example, FQ could implement a strategy dropping the oldest packet in the queue,
> which is absolutely not related to the enqueue order.
> 

We have a CAN ID related ematch rule in em_canid.c to be able to 
configure HTBs, delays or drops. But this is for testing and special 
use-cases. Silently dropped frames are not expected.

Regards,
Oliver



