Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB5E5AA8A7
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 09:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiIBHS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 03:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiIBHS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 03:18:57 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7C65926E
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 00:18:54 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 54DF77F4BD;
        Fri,  2 Sep 2022 09:18:50 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F10E34064;
        Fri,  2 Sep 2022 09:18:50 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2519A3405A;
        Fri,  2 Sep 2022 09:18:50 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Fri,  2 Sep 2022 09:18:50 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id E07887F4BD;
        Fri,  2 Sep 2022 09:18:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1662103129; bh=U8RCUGEHIFR8BJssNnIj6o531o4mZYtAqF56h/zK0iw=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=MeaNBKBLhkgbwayB8PRFh08nxkJIqOJlL/VCyV0WOvPMma0QckcMCwy6VdqGFwWW1
         OT5O5BnCJRFGph+4Ww6PPxgd/xf3lk/0Pu1/qxwTB7jocEh9whRPzFO0kvMCAZxKcQ
         QBteX/gbEH17QDbq7insS+jC1Dc1oehDkWxdpvrcs4/o9zQVsmgPG0+nr7fVOEmdOx
         yGNV06Rsx9l525UTTBS6leCtIzjPYBaEIHOU4TbZwmv21/1MK3+jOUNahqDEVvvm9R
         /uT8M63PmZ3KM/VOrAroZDCCJ5uFViML7KdE6zaDXT6n49CsBx9p0TB2VWOSyOK5ud
         nq0b+fGFJcf/w==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Fri, 2
 Sep 2022 09:18:49 +0200
Message-ID: <cf2f3ba9-c4fa-1618-f795-9a27b065ef56@prolan.hu>
Date:   Fri, 2 Sep 2022 09:18:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
Content-Language: en-US
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
 <20220901150416.GA1237970@francesco-nb.int.toradex.com>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <20220901150416.GA1237970@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456627561
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022. 09. 01. 17:04, Francesco Dolcini wrote:
> On Thu, Sep 01, 2022 at 04:04:03PM +0200, Csókás Bence wrote:
>> Mutexes cannot be taken in a non-preemptible context,
>> causing a panic in `fec_ptp_save_state()`. Replacing
>> `ptp_clk_mutex` by `tmreg_lock` fixes this.
>>
>> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> This should be removed, there was no issue with just this commit. Am I
> wrong?
> 
> One of the reasons of the Fixes tag is to backport to stable releases,
> and you do not want this commit in 5.15.x.

I do want it, actually, because I got a PATCH AUTOSEL already for 
f79959220fa5fbda939592bf91c7a9ea90419040 for 5.15 & 5.19, but I told 
them not to backport until this fix is merged too.

Bence
