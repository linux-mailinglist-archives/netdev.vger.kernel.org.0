Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B025F2F28
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJCK4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJCK4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:56:01 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A005601B;
        Mon,  3 Oct 2022 03:55:57 -0700 (PDT)
Received: from [192.168.1.103] (178.176.76.47) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Mon, 3 Oct 2022
 13:55:46 +0300
Subject: Re: [net-next v2 8/9] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
To:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivek Thampi <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        <linux-renesas-soc@vger.kernel.org>
References: <20220930204851.1910059-1-jacob.e.keller@intel.com>
 <20220930204851.1910059-9-jacob.e.keller@intel.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <d0a44463-e6ea-98dd-b0d5-65c663572e87@omp.ru>
Date:   Mon, 3 Oct 2022 13:55:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220930204851.1910059-9-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.76.47]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/03/2022 10:29:17
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 173000 [Oct 03 2022]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 500 500 6cc86d8f5638d79810308830d98d6b6279998c49
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 178.176.76.47 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;omp.ru:7.1.1;178.176.76.47:7.4.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {iprep_blacklist}
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.76.47
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/03/2022 10:33:00
X-KSE-AttachmentFiltering-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10/3/2022 9:02:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 9/30/22 11:48 PM, Jacob Keller wrote:

> The ravb implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
> 
> Convert this driver to .adjfine and use the adjust_by_scaled_ppm helper
> function to calculate the new addend.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Sergey Shtylyov <s.shtylyov@omp.ru>
> Cc: Biju Das <biju.das.jz@bp.renesas.com>
> Cc: Phil Edworthy <phil.edworthy@renesas.com>
> Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: linux-renesas-soc@vger.kernel.org

Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]

MBR, Sergey
