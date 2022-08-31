Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D345A7E49
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbiHaNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiHaNJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:09:13 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998C5BBA57
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:09:11 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imsva.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 303857F543;
        Wed, 31 Aug 2022 15:09:10 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D44734064;
        Wed, 31 Aug 2022 15:09:10 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 042C13405A;
        Wed, 31 Aug 2022 15:09:10 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 15:09:09 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id C75117F543;
        Wed, 31 Aug 2022 15:09:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1661951349; bh=g5lktrys0u/UibwU7w+0sD3/nc//+Wm0Tuqns/It8FU=;
        h=Date:Subject:To:CC:References:From:In-Reply-To:From;
        b=hbN0pZBfV5JthgL4qpAxEePirVKRf6xEt3OcG1UA3DWTIZW3cMDfzSfxG8K3ohCKo
         5JA8nPAvWq62/RuOSCJIYiQcc9rMJ0N8g8kvqJnoEnxwZxapSkpTTe8bNiks78gzF6
         nfe0Az1XZa/QqpLPgHM83WHa6gao6Z4t2TMaO0Wx3/LEF6zvlhXSYEp6M+Mx5vXPHl
         Xr8R5K8pfmN24x8Ha71afJS3IQm2Vq5W2CqkjAqo33CgRrHRTzOwplRot3LO7YtVrP
         fQRwFwN+cudzKvDgQuk2Et3T+nS8UjQcb1zcmhIQZ7zriLyu0XT/Qp+/4ktx9KA9Of
         iZB//vABziokg==
Received: from [10.254.7.28] (10.254.7.28) by atlas.intranet.prolan.hu
 (10.254.0.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id 15.1.2507.12; Wed, 31
 Aug 2022 15:09:09 +0200
Message-ID: <6f008565-b1a9-2826-79e9-85f235627016@prolan.hu>
Date:   Wed, 31 Aug 2022 15:09:09 +0200
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
 <Yw4ClKHWACSP2EQ1@lunn.ch> <bbe8a924-7291-14f9-1e88-802a211ca0f4@prolan.hu>
 <Yw4q616Nl4LJdy/a@lunn.ch>
From:   =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>
In-Reply-To: <Yw4q616Nl4LJdy/a@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.254.7.28]
X-ClientProxiedBy: atlas.intranet.prolan.hu (10.254.0.229) To
 atlas.intranet.prolan.hu (10.254.0.229)
X-EsetResult: clean, is OK
X-EsetId: 37303A29971EF456637D67
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


On 2022. 08. 30. 17:21, Andrew Lunn wrote:
> You are not taking a mutex, you are taking a spinlock. You can do that
> in atomic context. Can you protect everything which needs protecting
> with a spinlock? And avoid sleeping...

You are correct, the issue Marc experienced turns out to be caused by a 
`mutex_lock()` introduced in 6a4d7234ae9a3bb31181f348ade9bbdb55aeb5c5...

On 2022. 08. 31. 5:41, Richard Cochran wrote:
 > Just replace the mutex with a spinlock.

Will do. Disregard this patch and see "[PATCH] Use a spinlock to guard 
`fep->ptp_clk_on`" instead

Bence
