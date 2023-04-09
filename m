Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5242A6DBF3A
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbjDIIsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 04:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIIsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 04:48:17 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1CB1FC1;
        Sun,  9 Apr 2023 01:48:15 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1plQib-00017v-JX; Sun, 09 Apr 2023 10:48:13 +0200
Message-ID: <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
Date:   Sun, 9 Apr 2023 10:48:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: Potential regression/bug in net/mlx5 driver
Content-Language: en-US, de-DE
To:     Paul Moore <paul@paul-moore.com>, Saeed Mahameed <saeed@kernel.org>
Cc:     Shay Drory <shayd@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        selinux@vger.kernel.org
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130>
 <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681030095;ba9ed88e;
X-HE-SMSGID: 1plQib-00017v-JX
X-Spam-Status: No, score=-2.9 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.03.23 03:27, Paul Moore wrote:
> On Wed, Mar 29, 2023 at 6:20 PM Saeed Mahameed <saeed@kernel.org> wrote:
>> On 28 Mar 19:08, Paul Moore wrote:
>>>
>>> Starting with the v6.3-rcX kernel releases I noticed that my
>>> InfiniBand devices were no longer present under /sys/class/infiniband,
>>> causing some of my automated testing to fail.  It took me a while to
>>> find the time to bisect the issue, but I eventually identified the
>>> problematic commit:
>>>
>>>  commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
>>>  Author: Shay Drory <shayd@nvidia.com>
>>>  Date:   Wed Jun 29 11:38:21 2022 +0300
>>>
>>>   net/mlx5: Enable management PF initialization
>>>
>>>   Enable initialization of DPU Management PF, which is a new loopback PF
>>>   designed for communication with BMC.
>>>   For now Management PF doesn't support nor require most upper layer
>>>   protocols so avoid them.
>>>
>>>   Signed-off-by: Shay Drory <shayd@nvidia.com>
>>>   Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
>>>   Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>>>   Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>>
>>> I'm not a mlx5 driver expert so I can't really offer much in the way
>>> of a fix, but as a quick test I did remove the
>>> 'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
>>> everything seemed to work okay on my test system (or rather the tests
>>> ran without problem).
>>>
>>> If you need any additional information, or would like me to test a
>>> patch, please let me know.
>>
>> Our team is looking into this, the current theory is that you have an old
>> FW that doesn't have the correct capabilities set.
> 
> That's very possible; I installed this card many years ago and haven't
> updated the FW once.
>
>  I'm happy to update the FW (do you have a
> pointer/how-to?), but it might be good to identify a fix first as I'm
> guessing there will be others like me ...

Nothing happened here for about ten days afaics (or was there progress
and I just missed it?). That made me wonder: how sound is Paul's guess
that there will be others that might run into this? If that's likely it
afaics would be good to get this regression fixed before the release,
which is just two or three weeks away.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

#regzbot poke

>> Can you please provide the FW version and the ConnectX device you are
>> testing ?
>>
>> $ devlink dev info
> 
> % devlink dev info; echo $?
> 0
> 
> No output and no error code.  However, I do see the following in dmesg:
> 
> [  255.251124] mlx5_core 0000:00:08.0: mlx5_fw_version_query:823:(pid
> 959): fw query isn't supported by the FW
> 
> ... which appears to support your theory about ancient hardware.
> 
>> $ lspci -s <pci_dev> -vv
> 
> While there is only one physical card, there are two PCI devices (it's
> a dual port card).  I'm only copying the first device since I'm
> guessing that's really all you need:
> 
> % lspci -s 00:07.0 -vv
> 00:07.0 Infiniband controller: Mellanox Technologies MT27700 Family [ConnectX-4]
>        Subsystem: Mellanox Technologies Device 0010
>        Physical Slot: 7
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>                 Stepping- SERR+ FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>                <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 11
>        Region 0: Memory at fa000000 (64-bit, prefetchable) [size=32M]
>        Expansion ROM at fe900000 [disabled] [size=1M]
>        Capabilities: [60] Express (v2) Endpoint, MSI 00
>                DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s
>                        unlimited, L1 unlimited
>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
>                        SlotPowerLimit 25W
>                DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-
>                        RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop+ FLReset-
>                        MaxPayload 256 bytes, MaxReadReq 512 bytes
>                DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr-
>                        TransPend-
>                LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM not supported
>                        ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
>                LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 8GT/s, Width x8
>                        TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>                DevCap2: Completion Timeout: Range ABCD, TimeoutDis+ NROPrPrP-
>                         LTR- 10BitTagComp+ 10BitTagReq- OBFF Not Supported,
>                         ExtFmt- EETLPPrefix- EmergencyPowerReduction
>                         Not Supported, EmergencyPowerReductionInit-
>                         FRS- TPHComp- ExtTPHComp-
>                AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR-
>                         10BitTagReq- OBFF Disabled,
>                AtomicOpsCtl: ReqEn-
>                LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+
>                         EqualizationPhase1+ EqualizationPhase2+
>                         EqualizationPhase3+ LinkEqualizationRequest-
>                         Retimer- 2Retimers- CrosslinkRes: unsupported
>        Capabilities: [48] Vital Product Data
>                Product Name: CX454A - ConnectX-4 QSFP28
>                Read-only fields:
>                        [PN] Part number: MCX454A-FCAT
>                        [EC] Engineering changes: AB
>                        [SN] Serial number: MT1730X05081
>                        [V0] Vendor specific: PCIeGen3 x8
>                        [RV] Reserved: checksum good, 0 byte(s) reserved
>                End
>        Capabilities: [9c] MSI-X: Enable+ Count=64 Masked-
>                Vector table: BAR=0 offset=00002000
>                PBA: BAR=0 offset=00003000
>        Capabilities: [c0] Vendor Specific Information: Len=18 <?>
>        Capabilities: [40] Power Management version 3
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>                       PME(D0-,D1-,D2-,D3hot-,D3cold+)
>                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>        Kernel driver in use: mlx5_core
>        Kernel modules: mlx5_core
> 
>> since boot:
>> $ dmesg
> 
> % devlink dev info
> % dmesg | grep mlx5
> [    4.739691] mlx5_core 0000:00:07.0: firmware version: 12.18.1000
> [    4.740134] mlx5_core 0000:00:07.0: 63.008 Gb/s available PCIe
> bandwidth (8.0GT/s PCIe x8 link)
> [    7.048567] mlx5_core 0000:00:07.0: Port module event: module 0,
> Cable plugged
> [    7.211879] mlx5_core 0000:00:08.0: firmware version: 12.18.1000
> [    7.212309] mlx5_core 0000:00:08.0: 63.008 Gb/s available PCIe
> bandwidth (8.0GT/s PCIe x8 link)
> [    7.897218] mlx5_core 0000:00:08.0: Port module event: module 1,
> Cable plugged
> [   10.875388] mlx5_core 0000:00:07.0 ibs7: renamed from ib0
> [   10.995115] mlx5_core 0000:00:08.0 ibs8: renamed from ib0
> [  181.471663] mlx5_core 0000:00:07.0: mlx5_fw_version_query:823:(pid
> 918): fw query isn't supported by the FW
> [  181.472286] mlx5_core 0000:00:08.0: mlx5_fw_version_query:823:(pid
> 918): fw query isn't supported by the FW
> 
