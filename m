Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942E0108D93
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfKYMLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 07:11:12 -0500
Received: from a27-185.smtp-out.us-west-2.amazonses.com ([54.240.27.185]:55104
        "EHLO a27-185.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfKYMLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 07:11:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574683870;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=WA8L41etKerEMPhjYhfgg3Lt6XxJcn9BfYkWy5icFe8=;
        b=mLjUl6GxoW/wRN3ZqrC367pGr9y4jV9HigYWQU2sW625FJKw1J04bx38dNjo6q6N
        BtbL/k4zi3ig+003k7BwJKgWDqiMRrxyxNvFV+XVK8hl8ITF0TEwQYMfhJJagtcXl2T
        58NcuxSYtw5o/f1iXPlFSHtpJFPPrJvYqx+f98jA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574683870;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=WA8L41etKerEMPhjYhfgg3Lt6XxJcn9BfYkWy5icFe8=;
        b=EElOjMlBWBaXPq9Do5BLtt7WQftCI8aw9rjLMpDv/SQIOf/9CVqKPTH6jCUBhrfe
        cn6O+afjP7F597M4F3a5amFKnlhOYvq5JMhe06b232uhb3e40Q0N26+Q1ZR6/5yGy0X
        sYEX2/JekMlolXHqhhN9ACz0zk2GSZmYR4/uA/Qw=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0ECF5C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, jiri@mellanox.com,
        edumazet@google.com, idosch@mellanox.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
References: <20191014080033.12407-1-alobakin@dlink.ru>
        <20191015.181649.949805234862708186.davem@davemloft.net>
        <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
        <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
        <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
        <746f768684f266e5a5db1faf8314cd77@dlink.ru>
        <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
        <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
        <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
        <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
        <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
Date:   Mon, 25 Nov 2019 12:11:10 +0000
In-Reply-To: <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
        (Paolo Abeni's message of "Mon, 25 Nov 2019 12:42:44 +0100")
Message-ID: <0101016ea2790643-5f91d22f-e322-497e-8c58-34f5942bd2af-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.25-54.240.27.185
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Mon, 2019-11-25 at 12:05 +0100, Johannes Berg wrote:
>> On Mon, 2019-11-25 at 13:58 +0300, Alexander Lobakin wrote:
>>
>> > Agree. I mean, we _can_ handle this particular problem from networking
>> > core side, but from my point of view only rethinking driver's logic is
>> > the correct way to solve this and other issues that may potentionally
>> > appear in future.
>> 
>> Do tell what you think it should be doing :)
>> 
>> One additional wrinkle is that we have firmware notifications, command
>> completions and actual RX interleaved, so I think we do want to have
>> interrupts for the notifications and command completions?
>
> I think it would be nice moving the iwlwifi driver to full/plain NAPI
> mode. The interrupt handler could keep processing extra work as it does
> now and queue real pkts on some internal queue, and than schedule the
> relevant napi, which in turn could process such queue in the napi poll
> method. Likely I missed tons of details and/or oversimplified it...

Sorry for hijacking the thread, but I have a patch pending for ath10k
(another wireless driver) which adds NAPI support to SDIO devices:

https://patchwork.kernel.org/patch/11188393/

I think it does just what you suggested, but I'm no NAPI expert and
would appreciate if someone more knowledgeable could take a look :)

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
