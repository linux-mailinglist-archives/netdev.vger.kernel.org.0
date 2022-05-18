Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E452B34E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiERHTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiERHTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:19:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE8D3D4A8;
        Wed, 18 May 2022 00:19:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D338B81DF0;
        Wed, 18 May 2022 07:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2C3C385AA;
        Wed, 18 May 2022 07:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652858338;
        bh=7fYgeoge+NXi6dIVbh7wEGd2VdZVCmjEuo2jZ0QyhPk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Zr5BFiQFHSiY5gMplt9DVm9vQpCNg96qbRU7BZeSi2TKAFRMljjkNYtE1U60Q7Eim
         UAHl/LpsCPB0gpr6Mwd6rdTaR4mJPFLnSEN1tmnGaZD8WHTYgZ6MsRn+kBO3EMkW5/
         zeVci2LanmdcQEBwEc966Si1IfPBIMhOO27RozE+TkPkZvedvOV15cPZyXCijlXoOP
         0JXToXEl5uQiLdJH1iP3MtW85bqzJPMGH8CAL0Af220BDpEkqf4Od+/iZ+y/JpWplR
         gDswNFBX02p7r9p+Q935K7xo4T2ieNb6iF+ViZ9+oEahDG20w7/KIlwTKPRsfS4u+9
         3n7ILsE55rHdw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Govind Singh <govinds@codeaurora.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ath10k: do not enforce interrupt trigger type
References: <20220513151516.357549-1-krzysztof.kozlowski@linaro.org>
        <87zgjl4e8t.fsf@kernel.org>
        <3d856d44-a2d6-b5b8-ec78-ce19a3686986@kali.org>
        <3bf28d29-f841-81f7-68f8-3fb7f9c274bf@kali.org>
Date:   Wed, 18 May 2022 10:18:50 +0300
In-Reply-To: <3bf28d29-f841-81f7-68f8-3fb7f9c274bf@kali.org> (Steev
        Klimaszewski's message of "Sat, 14 May 2022 13:09:11 -0500")
Message-ID: <87y1yz2tr9.fsf@kernel.org>
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

Steev Klimaszewski <steev@kali.org> writes:

> On 5/14/22 12:05 AM, Steev Klimaszewski wrote:
>>
>> On 5/13/22 10:57 AM, Kalle Valo wrote:
>>> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> writes:
>>>
>>>> Interrupt line can be configured on different hardware in
>>>> different way,
>>>> even inverted.=C2=A0 Therefore driver should not enforce specific trig=
ger
>>>> type - edge rising - but instead rely on Devicetree to configure it.
>>>>
>>>> All Qualcomm DTSI with WCN3990 define the interrupt type as level high,
>>>> so the mismatch between DTSI and driver causes rebind issues:
>>>>
>>>> =C2=A0=C2=A0 $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_s=
noc/unbind
>>>> =C2=A0=C2=A0 $ echo 18800000.wifi > /sys/bus/platform/drivers/ath10k_s=
noc/bind
>>>> =C2=A0=C2=A0 [=C2=A0=C2=A0 44.763114] irq: type mismatch, failed to ma=
p hwirq-446 for
>>>> interrupt-controller@17a00000!
>>>> =C2=A0=C2=A0 [=C2=A0=C2=A0 44.763130] ath10k_snoc 18800000.wifi: error=
 -ENXIO: IRQ
>>>> index 0 not found
>>>> =C2=A0=C2=A0 [=C2=A0=C2=A0 44.763140] ath10k_snoc 18800000.wifi: faile=
d to initialize
>>>> resource: -6
>>> So you tested on WCN3990? On what firmware version? I can add the
>>> Tested-on tag if you provide that.
>>>
>> Hello Krzystof, Kalle,
>>
>> I have seen this issue as well on a Lenovo Flex 5G, which has a WCN3990:
>>
>> wcn3990 hw1.0 target 0x00000008 chip_id 0x00000000 sub 0000:0000
>> kconfig debug 0 debugfs 0 tracing 0 dfs 0 testmode 0
>> firmware ver=C2=A0 api 5 features wowlan,mgmt-tx-by-reference,non-bmi
>> crc32 b3d4b790
>> htt-ver 3.86 wmi-op 4 htt-op 3 cal file max-sta 32 raw 0 hwcrypto 1
>>
>> With this patch applied, I no longer see the error message in the
>> commit message, when I unbind/bind when wifi stops working.
>>
>> Tested-by: Steev Klimaszewski <steev@kali.org>
>>
>> -- Steev
>>
> Apologies for the second email - I've tested this now on both the
> Lenovo Flex 5G, as I have seen the issue on it as well, as well as on
> the Lenovo Yoga C630, where I did not but I did have issues with
> attempting to rebind the device, prior to this patch.
>
> Firmware version for the Flex 5G is
>
> qmi chip_id 0x30224 chip_family 0x4001 board_id 0xff soc_id 0x40060000
> qmi fw_version 0x32080009 fw_build_timestamp 2020-11-16 14:44
> fw_build_id
> QC_IMAGE_VERSION_STRING=3DWLAN.HL.3.2.0.c8-00009-QCAHLSWSC8180XMTPLZ-1
>
> Firmware version on the Yoga C630 is
>
> qmi chip_id 0x30214 chip_family 0x4001 board_id 0xff soc_id 0x40030001
> qmi fw_version 0x2009856b fw_build_timestamp 2018-07-19 12:28
> fw_build_id QC_IMAGE_VERSION_STRING=3DWLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

In the pending branch I added these to the commit log:

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.0.c8-00009-QCAHLSWSC8180XMTPLZ-1
Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Thanks for testing, very much appreciated!

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
