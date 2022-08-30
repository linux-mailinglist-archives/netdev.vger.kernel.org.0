Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249085A66D9
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiH3PFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiH3PFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:05:34 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BDA74B93
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 08:05:31 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 453427F51C;
        Tue, 30 Aug 2022 17:05:26 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30EA034064;
        Tue, 30 Aug 2022 17:05:26 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 176A13405A;
        Tue, 30 Aug 2022 17:05:26 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Tue, 30 Aug 2022 17:05:26 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id DBBC07F51C;
        Tue, 30 Aug 2022 17:05:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661871925; bh=zGkheMbY8FyNTGHBsCG4L5Q/LOWPNpy5gDhjKkobn/U=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=yeEF20IMjCJAk1NKkMXOjPZ6X2J4qylzIkXLYh7pgxbi6NWOKrTdPXFaSQ3YbuP5a
         WYgbxv3gttjpZyhSXr1iXl5VJ1cDVEzBNJU4s8WWzQyWxFWnuH7naYcgFljnmGKDFc
         VWoXTN2NpVyxgyFRPmfGl0No1ycg3N5k/5/4Ogm5jdg4dNecsv2avTwmhNMLLb6nS3
         1nKMouVRjpV2rYqa+166c/UMAAura+YgbklbJrqU+1B9mG9TeNBlFOxFxTtI52QZNE
         iF3L1fd+jLgJMnAH3Xf1579KowtBfs2JDjr1siSJ1uE5iJxTdKP7nuIjJe8hL7sFqI
         dt+COp6JLCGEQ==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Tue, 30
 Aug 2022 17:05:25 +0200
Message-ID: <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
Date:   Tue, 30 Aug 2022 17:05:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net: fec: Use unlocked timecounter reads for saving
 state
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <qiangqing.zhang@nxp.com>,
        <kernel@pengutronix.de>, Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220830111516.82875-1-csokas.bence@prolan.hu>
 <Yw4ClKHWACSP2EQ1@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <Yw4ClKHWACSP2EQ1@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456637261
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



On 2022. 08. 30. 14:29, Andrew Lunn wrote:
>> -	fec_ptp_gettime(&fep->ptp_caps, &fep->ptp_saved_state.ts_phc);
>> +	if (preempt_count_equals(0)) {
> 
> ~/linux/drivers$ grep -r preempt_count_equals *
> ~/linux/drivers$
> 
> No other driver plays games like this.
> 
> Why not unconditionally take the lock?

Because then we would be back at the original problem (see Marc's message):

| [   14.001542] BUG: sleeping function called from invalid context at 
kernel/locking/mutex.c:283 

| [   14.010604] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 
13, name: kworker/0:1 

| [   14.018737] preempt_count: 201, expected: 0

We cannot take a mutex in atomic context. However, we also don't *need 
to* take a mutex in atomic context.

> 
>      Andrew

If someone has a better solution, I'm open to suggestions. But to me, it 
seems that there are only 3 options:

1. Unconditionally taking the mutex was what I originally did, but that 
caused issues in Marc's setup.
2. Not taking the mutex at all is what I proposed in v1 of this patch. 
But as Richard pointed out, `timecounter_read()` actually does a 
Read-Modify-Write on the `FEC_ATIME_CTRL` register, that *could* get 
interrupted if not guarded by the mutex (or atomic context).
3. The final option, check if we are in an atomic or otherwise 
non-interruptible context, and if not, take a mutex. Otherwise, proceed 
normally. Which is this version of the patch.

Bence
