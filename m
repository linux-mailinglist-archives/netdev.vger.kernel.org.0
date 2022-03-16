Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386374DB989
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357645AbiCPUjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358128AbiCPUhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:37:48 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E3A6A057
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:36:25 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef39.dynamic.kabel-deutschland.de [95.90.239.57])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 917F961EA192E;
        Wed, 16 Mar 2022 21:36:22 +0100 (CET)
Message-ID: <cb7d704a-60bd-a06f-6511-95889bc0bc5f@molgen.mpg.de>
Date:   Wed, 16 Mar 2022 21:36:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: bnx2x: How to log the firmware version? (was: [RFC net] bnx2x: fix
 built-in kernel driver load failure)
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ariel Elior <aelior@marvell.com>, it+netdev@molgen.mpg.de,
        regressions@lists.linux.dev
References: <20220316111842.28628-1-manishc@marvell.com>
 <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
 <BY3PR18MB4612DEDE441A89EEE0470850AB119@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <BY3PR18MB4612DEDE441A89EEE0470850AB119@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Manish,


Thank you for your answer.

Am 16.03.22 um 19:25 schrieb Manish Chopra:

>> -----Original Message-----
>> From: Paul Menzel <pmenzel@molgen.mpg.de>

[…]

>> Hmm, with `CONFIG_BNX2X=y` and `bnx2x.debug=0x0100000`, bringing up
>> net05 (.1) and then net04 (.0), I only see:
>>
>>       [ 3333.883697] bnx2x: [bnx2x_compare_fw_ver:2378(net04)]loaded fw f0d07 major 7 minor d rev f eng 0
> 
> I think this print is not good probably  (that's why it is default
> disabled), it’s not really the firmware driver is supposed to work
> with (it is something which was already loaded by any other PF
> somewhere or some residue from earlier loads),
Still interesting, when handling firmware files, and trying to wrap ones 
head around the different versions flying around.

> driver is always going to work with the firmware it gets from
> request_firmware(). I suggest you to enable below prints to know
> about which FW driver is going to work with. Perhaps, I will enable
> below default.
> 
>          BNX2X_DEV_INFO("Loading %s\n", fw_file_name);
> 
>          rc = request_firmware(&bp->firmware, fw_file_name, &bp->pdev->dev);
>          if (rc) {
>                  BNX2X_DEV_INFO("Trying to load older fw %s\n", fw_file_name_v15);

Indeed, after figuring out to enable `BNX2X_DEV_INFO()` by the probe 
flag 0x2 – so either `bnx2x.debug=0x2` or `ethtool -s net04 msglvl 0x2`, 
Linux logs:

     $ dmesg --level=info | grep bnx2x | tail -8
     [  242.987091] bnx2x 0000:45:00.1: fw_seq 0x0000003b
     [  242.994144] bnx2x 0000:45:00.1: drv_pulse 0x6404
     [  243.038239] bnx2x 0000:45:00.1: Loading bnx2x/bnx2x-e1h-7.13.21.0.fw
     [  243.356284] bnx2x 0000:45:00.1 net05: using MSI-X  IRQs: sp 57 
fp[0] 59 ... fp[7] 66
     [  571.774061] bnx2x 0000:45:00.0: fw_seq 0x0000003b
     [  571.781069] bnx2x 0000:45:00.0: drv_pulse 0x2149
     [  571.799963] bnx2x 0000:45:00.0: Loading bnx2x/bnx2x-e1h-7.13.21.0.fw
     [  571.811657] bnx2x 0000:45:00.0 net04: using MSI-X  IRQs: sp 46 
fp[0] 48 ... fp[7] 55
     $ dmesg --level=err | grep bnx2x
     [  571.979621] bnx2x 0000:45:00.0 net04: Warning: Unqualified SFP+ 
module detected, Port 0 from Intel Corp       part number AFBR-703SDZ-IN2

Maybe the firmware version could be added to the line with the MSI-X and 
IRQ info. Maybe also the old version on the device, which `ethtool -i 
net04` shows.

     $ ethtool -i net04 | grep firmware
     firmware-version: 7.8.16 bc 6.2.26 phy aa0.406

No idea, why ethtool does not show the loaded firmware.


Kind regards,

Paul
