Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A5162BE79
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbiKPMpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKPMpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:45:00 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F8725FF4;
        Wed, 16 Nov 2022 04:44:59 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47AEC1516;
        Wed, 16 Nov 2022 04:45:05 -0800 (PST)
Received: from [10.57.70.190] (unknown [10.57.70.190])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F16B3F663;
        Wed, 16 Nov 2022 04:44:55 -0800 (PST)
Message-ID: <94af81ef-782a-9cf5-b656-f2c304a8e4ef@arm.com>
Date:   Wed, 16 Nov 2022 12:44:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] arm64: dts: fsd: Change the reg properties from 64-bit to
 32-bit
Content-Language: en-GB
From:   Robin Murphy <robin.murphy@arm.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, Alim Akhtar <alim.akhtar@samsung.com>,
        linux-fsd@tesla.com, Rob Herring <robh+dt@kernel.org>
Cc:     linux-can@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com,
        ajaykumar.rs@samsung.com
References: <CGME20221116090644epcas5p3a0fa6d51819a2b2a9570f236191748ea@epcas5p3.samsung.com>
 <20221116091247.52388-1-vivek.2311@samsung.com>
 <37d42235-1960-4001-9be9-20a85de54730@app.fastmail.com>
 <d63b59c3-f67d-e5ee-6cbf-9f97eec0aeaa@arm.com>
In-Reply-To: <d63b59c3-f67d-e5ee-6cbf-9f97eec0aeaa@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-16 12:38, Robin Murphy wrote:
> On 2022-11-16 11:16, Arnd Bergmann wrote:
>> On Wed, Nov 16, 2022, at 10:12, Vivek Yadav wrote:
>>> Change the reg properties from 64-bit to 32-bit for all IPs, as none of
>>> the nodes are above 32-bit range in the fsd SoC.
>>>
>>> Since dma-ranges length does not fit into 32-bit size, keep it 64-bit
>>> and move it to specific node where it is used instead of SoC section.
>>
>> I don't think that works, the dma-ranges property is part of the
>> bus, not a particular device:
>>
>>           mdma0: dma-controller@10100000 {
>>               compatible = "arm,pl330", "arm,primecell";
>> -            reg = <0x0 0x10100000 0x0 0x1000>;
>> +            reg = <0x10100000 0x1000>;
>>               interrupts = <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>;
>>               #dma-cells = <1>;
>>               clocks = <&clock_imem IMEM_DMA0_IPCLKPORT_ACLK>;
>>               clock-names = "apb_pclk";
>>               iommus = <&smmu_imem 0x800 0x0>;
>> +            #address-cells = <2>;
>> +            #size-cells = <2>;
>> +            dma-ranges = <0x0 0x0 0x0 0x10 0x0>;
>>           };
>>
>> Since the dma-controller has no children, I don't see how this has
>> any effect. Also, translating a 36-bit address into a 32-bit
>> address just means it gets truncated anyway, so there is no
>> point in making it appear to have a larger address range.
> 
> Yes, this is definitely bogus on both counts.

Oh, and also that PL330 can only do 32-bit DMA anyway :)

Thanks,
Robin.
