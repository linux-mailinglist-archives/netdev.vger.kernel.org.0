Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB2A4BA3F1
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242148AbiBQPFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:05:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBQPFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:05:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C122177E75;
        Thu, 17 Feb 2022 07:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6729B82284;
        Thu, 17 Feb 2022 15:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0B1C340E8;
        Thu, 17 Feb 2022 15:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645110298;
        bh=6eo+ss2NaQ4aaexU80Am0OVsZOTFMqFINYOGQ7TKdaY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=U9C7SYoWqotR4fU/A5O/7My+s46ccTUUMx6BWD0p66hmvMPqd9tWXacmXIUdcLhdd
         qHKdMzbSHGh5UTkRs8hDppoG/4H12JMsLyiroMiRqhJ8GLR9OG5fDzkeMHwaL9wN6f
         hcmLkraWjwJ91/iDTvzPt7wR2RLdDSovR7uYQmsoera8K7DKc8Bc57zsMHxURuKwg5
         29aaVvu/7MUzoDTCCZ1jbKbvq9V2s9F/Z11VQLN6EXpH9CL6fSPDLTLMVWS8j77cK0
         nVojl6Fxaj8ZGOOMShphoEdPq0aGawzQMBHi5Y5l0jkr8dqzpXEcLJ7Z+31EdAk69T
         gyhlBZ2YzpTBA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH 2/2] staging: wfx: apply the necessary SDIO quirks for the Silabs WF200
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
        <20220216093112.92469-3-Jerome.Pouiller@silabs.com>
        <878ru924qr.fsf@kernel.org>
        <CAPDyKFqm3tGa+dtAGPn803rLnfY=tdcoX5DySnG-spFFqM=CrA@mail.gmail.com>
Date:   Thu, 17 Feb 2022 17:04:51 +0200
In-Reply-To: <CAPDyKFqm3tGa+dtAGPn803rLnfY=tdcoX5DySnG-spFFqM=CrA@mail.gmail.com>
        (Ulf Hansson's message of "Thu, 17 Feb 2022 15:54:05 +0100")
Message-ID: <87ley9zg8c.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On Thu, 17 Feb 2022 at 10:59, Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>>
>> > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> >
>> > Until now, the SDIO quirks are applied directly from the driver.
>> > However, it is better to apply the quirks before driver probing. So,
>> > this patch relocate the quirks in the MMC framework.
>>
>> It would be good to know how this is better, what's the concrete
>> advantage?
>
> The mmc core has a quirk interface for all types of cards
> (eMMC/SD/SDIO), which thus keeps these things from sprinkling to
> drivers. In some cases, the quirk needs to be applied already during
> card initialization, which is earlier than when probing an SDIO func
> driver or the MMC block device driver.
>
> Perhaps it's a good idea to explain a bit about this in the commit messag=
e.

I would add the whole paragraph to the commit log :)

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
