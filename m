Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFAD168C81E
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjBFVAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBFVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:00:19 -0500
Received: from sender4-op-o16.zoho.com (sender4-op-o16.zoho.com [136.143.188.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AA823C4A;
        Mon,  6 Feb 2023 13:00:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675717183; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=YCWwRuDdHCFI3y42hfY/nbUOP+GanWFxDNmJj675CvfKJYeKzDxmVX9oJvxqfKmeAZxDrcnFxYn8jVmadHHq+hiQZ3hyQTOtNCihZxZX6+qnnjtqkp4tVcmQbgerJkSgsfJHur3cqS2Mi7xVr2s55rTALn9DUtOtKFufJo3XkmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675717183; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/HPkf5YsTIOCnzVDtCplioRqVVDpwJJJeFUzxZkAr8c=; 
        b=DJmiFPA1+izZIHd/MPAMDzKt1ScYlEM6Cj2tyDZUf4+4wi80rvXWjpUVbPbc0SYr+qLSa/YcvNPju40N86aGq1MwF1of00t1saksy76ZJuBViR4CkRcLLAjDL2AGCnt+9Z3ci2kYruWmsn17WzeZQLOlA/BWj7LyY/T/UHv90Z8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675717183;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Message-Id:Reply-To;
        bh=/HPkf5YsTIOCnzVDtCplioRqVVDpwJJJeFUzxZkAr8c=;
        b=XSQBAMOHuPh/M8oUFzk9wiC7zF0vQIbHdqpMfrso1PMoPVtUqVtmH3Nc9kXWTZj9
        V32atz5//fuBnfSowrL6am+NLoCKhjENflu3u3SY85+lYet8/fuA0+ksU3lDTh7GPtt
        /2KS0+rHdGUcWw5ckspUJpNMcaT2u2b35Fc1AKTM=
Received: from [10.10.10.3] (31.223.26.239 [31.223.26.239]) by mx.zohomail.com
        with SMTPS id 1675717182038197.75552933950325; Mon, 6 Feb 2023 12:59:42 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------I37axy810XQiqT7HWyRq3zRz"
Message-ID: <d160cc60-d62a-e1a9-5580-48a50a2568df@arinc9.com>
Date:   Mon, 6 Feb 2023 23:59:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: dsa: mt7530: don't change PVC_EG_TAG when CPU
 port becomes VLAN-aware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, richard@routerhints.com
References: <20230205203906.i3jci4pxd6mw74in@skbuf>
 <b055e42f-ff0f-d05a-d462-961694b035c1@arinc9.com>
 <20230205235053.g5cttegcdsvh7uk3@skbuf>
 <116ff532-4ebc-4422-6599-1d5872ff9eb8@arinc9.com>
 <20230206174627.mv4ljr4gtkpr7w55@skbuf>
 <5e474cb7-446c-d44a-47f6-f679ae121335@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com>
 <20230206203335.6uxfiylftyktut5u@skbuf>
 <4ee5df8d-618b-db78-9c14-17a45e383b67@arinc9.com>
 <20230206204228.sa45cvco6bltidwq@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230206204228.sa45cvco6bltidwq@skbuf>
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------I37axy810XQiqT7HWyRq3zRz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6.02.2023 23:42, Vladimir Oltean wrote:
> On Mon, Feb 06, 2023 at 11:35:50PM +0300, Arınç ÜNAL wrote:
>> On 06/02/2023 23:33, Vladimir Oltean wrote:
>>> On Mon, Feb 06, 2023 at 10:41:47PM +0300, Arınç ÜNAL wrote:
>>>> One last thing. Specific to MT7530 switch in MT7621 SoC, if port@5 is the
>>>> only CPU port defined on the devicetree, frames sent from DSA master appears
>>>> malformed on the user port. Packet capture on computer connected to the user
>>>> port is attached.
>>>>
>>>> The ARP frames on the pcapng file are received on the DSA master, I captured
>>>> them with tcpdump, and put it in the attachments. Then I start pinging from
>>>> the DSA master and the malformed frames appear on the pcapng file.
>>>>
>>>> It'd be great if you could take a look this final issue.
>>>
>>> What phy-mode does port@5 use when it doesn't work? What about the DSA master?
>>
>> It's rgmii on port@5 and gmac1.
> 
> What kind of RGMII? Plain "rgmii" on both ends, with no internal delays?
> With RGMII, somebody must add a skew to the clock signal relative to the
> data signals, so that setup/hold times at the other end are not violated.
> Either the transmitter or the receiver can add RGMII delays in each
> direction of communication, but someone must do it, and no more than one
> entity should do it.
> 
> So my question would be: could you retry after replacing phy-mode = "rgmii"
> with phy-mode = "rgmii-id" on port@5? And if that doesn't change anything
> (unlikely but possible), also try "rgmii-txid" and "rgmii-rxid" in port@5?
> Don't change the phy-mode on gmac1.

Still getting malformed frames. Packet capture for each phy-mode is 
attached. Made sure the phy-mode with:

# cat /proc/device-tree/ethernet@1e100000/mac@1/phy-mode
rgmii

# cat 
/proc/device-tree/ethernet@1e100000/mdio-bus/switch@1f/ports/port@5/phy-mode
rgmii-id

# cat 
/proc/device-tree/ethernet@1e100000/mdio-bus/switch@1f/ports/port@5/phy-mode
rgmii-txid

# cat 
/proc/device-tree/ethernet@1e100000/mdio-bus/switch@1f/ports/port@5/phy-mode
rgmii-rxid

Arınç
--------------I37axy810XQiqT7HWyRq3zRz
Content-Type: application/x-pcapng; name="rgmii-id.pcapng"
Content-Disposition: attachment; filename="rgmii-id.pcapng"
Content-Transfer-Encoding: base64

Cg0NCrgAAABNPCsaAQAAAP//////////AgA2AEludGVsKFIpIENvcmUoVE0pIGk3LTg3MDBL
IENQVSBAIDMuNzBHSHogKHdpdGggU1NFNC4yKQAAAwAXAExpbnV4IDUuMTkuMC0yOS1nZW5l
cmljAAQAOgBEdW1wY2FwIChXaXJlc2hhcmspIDMuNi43IChHaXQgdjMuNi43IHBhY2thZ2Vk
IGFzIDMuNi43LTEpAAAAAAAAuAAAAAEAAABIAAAAAQAAAAAABAACAAYAZW5wOXMwAAAJAAEA
CQAAAAwAFwBMaW51eCA1LjE5LjAtMjktZ2VuZXJpYwAAAAAASAAAAAYAAABcAAAAAAAAAIZX
QRcJjCxpPAAAADwAAAD//17/mlc+eMWU+oItpwABCAAGAAABPnjFlNqCgKgCAQAAAAAAoMCo
AgIAAAAAAAAAAAAAAAAAAKg7CMJcAAAABgAAAFwAAAAAAAAAhldBF1VSMKU8AAAAPAAAAP//
//+f98CoAgIAAAAgAAAAAAAAAAAAAKg7GNIAAMUlNeOI8QgQKBicy8gTkRXjpE2mzAu1N5fC
ZpsOEVwAAAAGAAAAXAAAAAAAAACGV0EXPGk54jwAAAA8AAAA/////5//PnjFlNqCKaYAAQgA
hgAIAT54xZTagoCgAgEAAAAAACDAqAICAAAAAAAAAAAAAAAAAACoOxjWXAAAAAYAAABcAAAA
AAAAAIdXQRemS31YPAAAADwAAAD////////AqAICAAAAIAAAAAAAAAAAAACoOxjWAAACDL7U
AAMAAwAAAAQAAACEAAAAAQAAAKMAAAAEAABcAAAABgAAAFwAAAAAAAAAh1dBFx2PhZU8AAAA
PAAAAP///v+f9z54xZTagimmAAEIAIYACAE+eMWUWoKAgAIBAAAAAAAgwKgCAgAAAAAAAAAA
AAAAAAAAqDsY1lwAAAAGAAAAXAAAAAAAAACHV0EXWQaP0jwAAAA8AAAA///+/5//wKgCAgAA
ACAAAAAAAAAAAAAAqDsYwgAAAgxA8wADAAQAAAFwSDICAAAAAAMAACEEAAAAAAAAXAAAAAYA
AABcAAAAAAAAAIhXQRcL1d5HPAAAADwAAAD//17/mhc+eMWU2oIppgABCAAGAAABPnjFlNqC
gKACAQAAAAAAqMCoAgIAAAAAAAAAAAAAAAAAAKg7GNJcAAAABgAAAFwAAAAAAAAAiFdBFwv8
8oM8AAAAPAAAAP//Xv+aFz54xZTagimmAAEIAAYAAAE+eMWU2oKAqAIBAAAAAACgwKgCAgAA
AAAAAAAAAAAAAAAAqDsY0lwAAAAGAAAAXAAAAAAAAACIV0EXmJT8wDwAAAA8AAAA///+/5/3
wKgCAgAAACAAAAAAAAAAAAAAqDsY1gAAAAAADwAAAAAAAAABQnAQADAAAAAAACUDAAAABAAA
XAAAAAUAAABsAAAAAAAAAA70BQA9YaQ3AQAcAENvdW50ZXJzIHByb3ZpZGVkIGJ5IGR1bXBj
YXACAAgADvQFAD6QqTYDAAgADvQFAHlgpDcEAAgACQAAAAAAAAAFAAgAAAAAAAAAAAAAAAAA
bAAAAA==
--------------I37axy810XQiqT7HWyRq3zRz
Content-Type: application/x-pcapng; name="rgmii-rxid.pcapng"
Content-Disposition: attachment; filename="rgmii-rxid.pcapng"
Content-Transfer-Encoding: base64

Cg0NCrgAAABNPCsaAQAAAP//////////AgA2AEludGVsKFIpIENvcmUoVE0pIGk3LTg3MDBL
IENQVSBAIDMuNzBHSHogKHdpdGggU1NFNC4yKQAAAwAXAExpbnV4IDUuMTkuMC0yOS1nZW5l
cmljAAQAOgBEdW1wY2FwIChXaXJlc2hhcmspIDMuNi43IChHaXQgdjMuNi43IHBhY2thZ2Vk
IGFzIDMuNi43LTEpAAAAAAAAuAAAAAEAAABIAAAAAQAAAAAABAACAAYAZW5wOXMwAAAJAAEA
CQAAAAwAFwBMaW51eCA1LjE5LjAtMjktZ2VuZXJpYwAAAAAASAAAAAYAAADEAAAAAAAAAMBX
QReEiPzzpAAAAKQAAAD//17/mleyZWfY8I8ppsCoAgIAAAAAAAAAAAAAAAAAAA6eHugAAH1M
T36UCwIFhBg2/lTKHLbrDyHj2osMmkMN3Nmdf7s8mqk09L/dL5hiGMth+MQYbYLBPJ9WSoB2
4KzC1wTictugSsWV2nvXIHxyvSOKKewscluykrxdEKTEgR1lK7Ug4YZ4UU4PrzCBoT715RUG
gKzdMf/3sgByKPi5NocG0MQAAAAGAAAA3AAAAAAAAADBV0EX3lO4MLoAAAC6AAAA//9e/5v3
smVn2PCPKaYAAQgABgQAAbJlZ9hQj4AAAgEAAAAAAKDAqAICAAAAAAAAAAAAAAAAAAAOnl7o
AADFJTXjiPEIACgYnMuIE5kd46RNpkwLsTaXwmabDgGyhNUjnjAEOxykGGi5hMlQMYc8/GV5
HBggo/o/wrEQETQGYQBv6rIbV9ZQ5Tn1AYJigtqtTpk4DbOD3VNgUgrXhsQ1qItcAhEiZmTS
ND8fIhBAlC49vY+v9y8woTP8AADcAAAABgAAAFwAAAAAAAAAwVdBF3/twG08AAAAPAAAAP//
Xv+aV7JlZ9jwjymmAAEIAAYEAAHAqAICAAAAAAAAAAAAAAAAAAAOng7oAACZoGH+gEoQA0vo
WlEa0FwAAAAGAAAAXAAAAAAAAADBV0EX2N5L4zwAAAA8AAAA//9e/5pXwKgCAqAAIakAAAAA
AAAAAAAADp7e6AAAAgyrhwADAAIAAAACAAAAAHJlZ3VMYRBHci0zdjIAXAAAAAYAAABcAAAA
AAAAAMJXQRf4eCMfPAAAADwAAAD//17/m9fAqAICAAAhIAAAAAAAAAAAAAAOnl7oAAACDH78
gAMAAwAAAAQAAAAEAAAAAQAAAKMAAAAEAABcAAAABgAAAFwAAAAAAAAAwldBF2xSK1w8AAAA
PAAAAP//Xv+bV7JlZ9jwjymmAAEIAAYEAAGyZWfYAI+AAQIBAAAAAACowKgCAgAAAADAqAIC
AAAAAAAAAAAAAFwAAAAFAAAAbAAAAAAAAAAO9AUAQ8J2RgEAHABDb3VudGVycyBwcm92aWRl
ZCBieSBkdW1wY2FwAgAIAA70BQA1wqdFAwAIAA70BQCuwXZGBAAIAAYAAAAAAAAABQAIAAAA
AAAAAAAAAAAAAGwAAAA=
--------------I37axy810XQiqT7HWyRq3zRz
Content-Type: application/x-pcapng; name="rgmii-txid.pcapng"
Content-Disposition: attachment; filename="rgmii-txid.pcapng"
Content-Transfer-Encoding: base64

Cg0NCrgAAABNPCsaAQAAAP//////////AgA2AEludGVsKFIpIENvcmUoVE0pIGk3LTg3MDBL
IENQVSBAIDMuNzBHSHogKHdpdGggU1NFNC4yKQAAAwAXAExpbnV4IDUuMTkuMC0yOS1nZW5l
cmljAAQAOgBEdW1wY2FwIChXaXJlc2hhcmspIDMuNi43IChHaXQgdjMuNi43IHBhY2thZ2Vk
IGFzIDMuNi43LTEpAAAAAAAAuAAAAAEAAABIAAAAAQAAAAAABAACAAYAZW5wOXMwAAAJAAEA
CQAAAAwAFwBMaW51eCA1LjE5LjAtMjktZ2VuZXJpYwAAAAAASAAAAAYAAABcAAAAAAAAAKlX
QRdItN2pPAAAADwAAAD//17/mlcSyYnwpeIppgABCAAGAAABEsmJ8KXigKgCAQAAAAAAqMCo
AgIAAAAAAAAAAAAAAAAAAEg0FohcAAAABgAAAFwAAAAAAAAAqVdBF3R3Hec8AAAAPAAAAP//
DvuaBxLJifCl4immAAEIAAYAAAESyYnwBOKAAAIBAAAAAACowKgCAgAAAAAAAAAAAAAAAAAA
SDQWiFwAAAAGAAAAXAAAAAAAAACqV0EXn/YlJDwAAAA8AAAA//9e/5pXEsmJ8KXiKacAAQgA
BgAIARLJifCl4sCoAgEAAAAAAKjAqAICAAAAAAAAAAAAAAAAAABINBaIXAAAAAYAAABcAAAA
AAAAAKpXQRe38TaZPAAAADwAAAD//177mgcSyYnwpeIppgABCAAGAAABEsmJ8CTigKACAQAA
AAAAoMCoAgIAAAAAAAAAAAAAAAAAAEg0FohcAAAABgAAAFwAAAAAAAAAqldBFwskh9U8AAAA
PAAAAP//HvuaBxLJifCl4imnAAEIAAYAAAESyYnwBOKAoAIBAAAAAACowKgCAgAAAAAAAAAA
AAAAAAAASDQWiFwAAAAGAAAAXAAAAAAAAACrV0EXY8OPEjwAAAA8AAAA//8e+5oHEsmJ8KXi
KSYAAQgABgQAARLJifAE4oAAAgEAAAAAAKDAqAICAAAAAAAAAAAAAAAAAABINFaIXAAAAAYA
AABcAAAAAAAAAKtXQRfUuZSIPAAAADwAAAD//x77mgfAqAICAAAhqQAAAAAAAAAAAABINFaI
AAACDB9vAAMABAAAAXAIMgIAAAAAAwAAIQQAAAAAAABcAAAABgAAAFwAAAAAAAAAq1dBF8Lp
2cU8AAAAPAAAAP//Xv+aVxLJifCl4imnAAEIAAYAAAESyYnwpeLAqAIBAAAAAACowKgCAgAA
AAAAAAAAAAAAAAAASDQWiFwAAAAGAAAAXAAAAAAAAACsV0EXJefhAjwAAAA8AAAA//9e+5pH
EsmJ8KXiKaYAAQgABgAAARLJifCl4oCgAgEAAAAAAKjAqAICAAAAAAAAAAAAAAAAAABINBaI
XAAAAAUAAABsAAAAAAAAAA70BQCBXKVAAQAcAENvdW50ZXJzIHByb3ZpZGVkIGJ5IGR1bXBj
YXACAAgADvQFAKnb2T8DAAgADvQFAO1bpUAEAAgACQAAAAAAAAAFAAgAAAAAAAAAAAAAAAAA
bAAAAA==

--------------I37axy810XQiqT7HWyRq3zRz--
