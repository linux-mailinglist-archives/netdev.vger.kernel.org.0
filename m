Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709466F497B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjEBSJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbjEBSJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:09:37 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B604BEE;
        Tue,  2 May 2023 11:09:34 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 342I92lw033054;
        Tue, 2 May 2023 13:09:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1683050942;
        bh=57AUrOMbyVCCGvx1oTX7k++sR74io/rLQrdY43bX9yM=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=AR/LAfNKRaeC2FuuLHFOnnSczCZYRfVFVquOLTGm3ZlxwRzO/0BCv2F9EsmBgBqQ3
         xYdyiX8UNx/Zq2V9ywJbYhbdoEpO/TmCJc70Ys0F4S1ByiQMRwKCWlT7CxE49JsrdI
         xy16u6fGz6b9zD/bFze1ETIg1dZ+088UzITSs994=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 342I92KR089102
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 2 May 2023 13:09:02 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 2
 May 2023 13:09:01 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 2 May 2023 13:09:01 -0500
Received: from [128.247.81.95] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 342I91S0052079;
        Tue, 2 May 2023 13:09:01 -0500
Message-ID: <b31f3a6a-e6ab-71a3-fb78-d01f2fe00464@ti.com>
Date:   Tue, 2 May 2023 13:09:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/4] can: m_can: Add hrtimer to generate software
 interrupt
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
References: <20230501224624.13866-1-jm@ti.com>
 <20230501224624.13866-3-jm@ti.com>
 <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
Content-Language: en-US
From:   Judith Mendez <jm@ti.com>
In-Reply-To: <20230502-twiddling-threaten-d032287d4630-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc

On 5/2/23 01:37, Marc Kleine-Budde wrote:
> On 01.05.2023 17:46:22, Judith Mendez wrote:
>> Add an hrtimer to MCAN class device. Each MCAN will have its own
>> hrtimer instantiated if there is no hardware interrupt found and
>> poll-interval property is defined in device tree M_CAN node.
>>
>> The hrtimer will generate a software interrupt every 1 ms. In
>> hrtimer callback, we check if there is a transaction pending by
>> reading a register, then process by calling the isr if there is.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
> 
> I think this patch is as good as it gets, given the HW and SW
> limitations of the coprocessor.
> 
> Some minor nitpicks inline. No need to resend from my point of view,
> I'll fixup while applying the patch.

Thanks Marc, really appreciate your feedback and attention.

Same to everyone who helped make these patches better. (:

regards,
Judith
