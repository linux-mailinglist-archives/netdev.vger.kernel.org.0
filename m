Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821A3610F69
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ1LKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiJ1LKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:10:05 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAD429CBB;
        Fri, 28 Oct 2022 04:10:00 -0700 (PDT)
Received: from [192.168.1.103] (178.176.72.110) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Fri, 28 Oct
 2022 14:09:48 +0300
Subject: Re: [PATCH net-next v3 8/9] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <linux-renesas-soc@vger.kernel.org>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
 <20221028110420.3451088-9-jacob.e.keller@intel.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <ce3a9441-7bfd-a876-c21f-5337716da3a5@omp.ru>
Date:   Fri, 28 Oct 2022 14:09:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20221028110420.3451088-9-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.72.110]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/28/2022 10:13:41
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 173312 [Oct 28 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;178.176.72.110:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;omp.ru:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.72.110
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/28/2022 10:17:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10/28/2022 8:59:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 10/28/22 2:04 PM, Jacob Keller wrote:

> The ravb implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
> 
> Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
> function to calculate the new addend.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Cc: Sergey Shtylyov <s.shtylyov@omp.ru>

   You forgot to collect my R-b tag... :-/

> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Phil Edworthy <phil.edworthy@renesas.com>
> Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: linux-renesas-soc@vger.kernel.org
[...]

MBR, Sergey
