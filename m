Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BE3675E4C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 20:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjATTrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 14:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjATTrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 14:47:36 -0500
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72E62B2B8;
        Fri, 20 Jan 2023 11:47:33 -0800 (PST)
Received: from [192.168.1.103] (31.173.83.188) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Fri, 20 Jan
 2023 22:47:23 +0300
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH net 1/2] net: ravb: Fix lack of register setting after
 system resumed for Gen3
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20230119043920.875280-1-yoshihiro.shimoda.uh@renesas.com>
 <20230119043920.875280-2-yoshihiro.shimoda.uh@renesas.com>
Organization: Open Mobile Platform
Message-ID: <5b467103-6afc-171d-1293-cedebf64d878@omp.ru>
Date:   Fri, 20 Jan 2023 22:47:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230119043920.875280-2-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [31.173.83.188]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.59, Database issued on: 01/20/2023 19:30:15
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 174906 [Jan 20 2023]
X-KSE-AntiSpam-Info: Version: 5.9.59.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.83.188 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: {Found in DNSBL: 31.173.83.188 in (user)
 dbl.spamhaus.org}
X-KSE-AntiSpam-Info: omp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 31.173.83.188
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/20/2023 19:32:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/20/2023 4:31:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/23 7:39 AM, Yoshihiro Shimoda wrote:

> After system entered Suspend to RAM, registers setting of this
> hardware is resetted because the SoC will be turned off. On R-Car Gen3

   s/resetted/reset/.

> (info->ccc_gac), ravb_ptp_init() is called in ravb_probe() only. So,
> after system resumed, it lacks of the initial settings for ptp. So,
> add ravb_ptp_{init,stop}() into ravb_{resume,suspend}().
> 
> Fixes: f5d7837f96e5 ("ravb: ptp: Add CONFIG mode support")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
