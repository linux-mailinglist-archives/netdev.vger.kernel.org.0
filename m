Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B1F524780
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351270AbiELH7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351196AbiELH7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:59:10 -0400
Received: from mxout02.lancloud.ru (mxout02.lancloud.ru [45.84.86.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7640168318;
        Thu, 12 May 2022 00:59:07 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 4A00E20566BC
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH v3 4/5] ravb: Use separate clock for gPTP
To:     Paolo Abeni <pabeni@redhat.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
References: <20220510090336.14272-1-phil.edworthy@renesas.com>
 <20220510090336.14272-5-phil.edworthy@renesas.com>
 <041789819aa163907ef27fed537dfca16d293f4d.camel@redhat.com>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <99c49555-8dc6-5eaa-4f1b-b2d17562ddf4@omp.ru>
Date:   Thu, 12 May 2022 10:59:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <041789819aa163907ef27fed537dfca16d293f4d.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/22 10:02 AM, Paolo Abeni wrote:

>> RZ/V2M has a separate gPTP reference clock that is used when the
>> AVB-DMAC Mode Register (CCC) gPTP Clock Select (CSEL) bits are
>> set to "01: High-speed peripheral bus clock".
>> Therefore, add a feature that allows this clock to be used for
>> gPTP.
>>
>> Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
>> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>> Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>

[...]
>> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
>> index 8ccc817b8b5d..ef6967731263 100644
>> --- a/drivers/net/ethernet/renesas/ravb_main.c
>> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
>> @@ -2721,6 +2725,15 @@ static int ravb_probe(struct platform_device *pdev)
>>  	}
>>  	clk_prepare_enable(priv->refclk);
>>  
>> +	if (info->gptp_ref_clk) {
>> +		priv->gptp_clk = devm_clk_get(&pdev->dev, "gptp");
>> +		if (IS_ERR(priv->gptp_clk)) {
>> +			error = PTR_ERR(priv->gptp_clk);
>> +			goto out_release;
>> +		}
>> +		clk_prepare_enable(priv->gptp_clk);
>> +	}
>> +
> 
> I guess you need to a conditional
> 
> 	clk_disable_unprepare(info->gptp_ref_clk)
> 
> in the error path? And even in ravb_remove()?

   Indeed! How could I miss it? :-/

[...]

MBR, Sergey
