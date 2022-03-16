Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5A4DB70E
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 18:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242766AbiCPRZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 13:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiCPRZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 13:25:55 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2284D9FE5
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 10:24:40 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef39.dynamic.kabel-deutschland.de [95.90.239.57])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 977F161EA192E;
        Wed, 16 Mar 2022 18:24:38 +0100 (CET)
Message-ID: <5e7fa480-b8a0-1178-04c2-36244221fd7e@molgen.mpg.de>
Date:   Wed, 16 Mar 2022 18:24:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC net] bnx2x: fix built-in kernel driver load failure
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Manish Chopra <manishc@marvell.com>
Cc:     buczek@molgen.mpg.de, kuba@kernel.org, netdev@vger.kernel.org,
        aelior@marvell.com, it+netdev@molgen.mpg.de,
        regressions@lists.linux.dev
References: <20220316111842.28628-1-manishc@marvell.com>
 <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
In-Reply-To: <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Manish,


Am 16.03.22 um 18:09 schrieb Paul Menzel:

> Thank you for the patch.
> 
> Am 16.03.22 um 12:18 schrieb Manish Chopra:
>> commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
>> added request_firmware() logic in probe() which caused
>> built-in kernel driver load failure as access to firmware
>> file is not feasible during the probe time.
> 
> … for example, when the initrd does not provide the firmware files.
> 
> Please also paste one example error message.
> 
>> This patch fixes this issue by -
>>
>> 1. Removing request_firmware() logic from the probe() such
>>     that open() handle it as it used to handle it earlier
>>
>> 2. Relaxing a bit FW version comparisons against the loaded FW
>>     (to allow many close/compatible FWs to run together now)
> 
> I’d prefer if you also pasted one error message, and even split this out 
> into a separate commit with elaborate problem description.
> 
> Style note: For the commit message, it’d be great if you used 75 
> characters per line.
> 
>> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
> 
> The regzbot also asks to add the tag below [1].
> 
> Link: 
> https://lore.kernel.org/r/46f2d9d9-ae7f-b332-ddeb-b59802be2bab@molgen.mpg.de 
> 
> 
>> Signed-off-by: Manish Chopra <manishc@marvell.com>
>> Signed-off-by: Ariel Elior <aelior@marvell.com>
>> ---
>>
>> Note that this patch is just for test and get feedback
>> from Paul Menzel about the issue reported by him on built-in
>> driver probe failure due to firmware files not found
> 
> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
> 
> Dell PowerEdge R910/0KYD3D, BIOS 2.10.0 08/29/2013 with patch on top of 
> Linux 5.10.103 with 7.13.15.0 on the root partition:
> 
> $ lspci -nn -s 45:00.1
> 45:00.1 Ethernet controller [0200]: Broadcom Inc. and subsidiaries 
> NetXtreme II BCM57711 10-Gigabit PCIe [14e4:164f]
> $ ethtool -i net05
> driver: bnx2x
> version: 5.10.103.mx64.429-00016-g597b02
> firmware-version: 7.8.16 bc 6.2.26 phy aa0.406
> expansion-rom-version:
> bus-info: 0000:45:00.1
> supports-statistics: yes
> supports-test: yes
> supports-eeprom-access: yes
> supports-register-dump: yes
> supports-priv-flags: yes
> ```
> 
>>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 --
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 28 +++++++++++--------
>>   .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 15 ++--------
>>   3 files changed, 19 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h 
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> index a19dd6797070..2209d99b3404 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> @@ -2533,6 +2533,4 @@ void bnx2x_register_phc(struct bnx2x *bp);
>>    * Meant for implicit re-load flows.
>>    */
>>   int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
>> -int bnx2x_init_firmware(struct bnx2x *bp);
>> -void bnx2x_release_firmware(struct bnx2x *bp);
>>   #endif /* bnx2x.h */
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c 
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> index 8d36ebbf08e1..5729a5ab059d 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> @@ -2364,24 +2364,30 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 
>> load_code, bool print_err)
>>       /* is another pf loaded on this engine? */
>>       if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
>>           load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
>> -        /* build my FW version dword */
>> -        u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
>> -                (bp->fw_rev << 16) + (bp->fw_eng << 24);
>> +        u8 loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng;
>> +        u32 loaded_fw;
>>
>>           /* read loaded FW from chip */
>> -        u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
>> +        loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
>>
>> -        DP(BNX2X_MSG_SP, "loaded fw %x, my fw %x\n",
>> -           loaded_fw, my_fw);
>> +        loaded_fw_major = loaded_fw & 0xff;
>> +        loaded_fw_minor = (loaded_fw >> 8) & 0xff;
>> +        loaded_fw_rev = (loaded_fw >> 16) & 0xff;
>> +        loaded_fw_eng = (loaded_fw >> 24) & 0xff;
>> +
>> +        DP(BNX2X_MSG_SP, "loaded fw 0x%x major 0x%x minor 0x%x rev 0x%x eng 0x%x\n",
>> +           loaded_fw, loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng);
> 
> Hmm, with `CONFIG_BNX2X=y` and `bnx2x.debug=0x0100000`, bringing up 
> net05 (.1) and then net04 (.0), I only see:
> 
>      [ 3333.883697] bnx2x: [bnx2x_compare_fw_ver:2378(net04)]loaded fw f0d07 major 7 minor d rev f eng 0
> 
> For another patch, but the currently loaded firmware, and when loading 
> new firmware, the version of it, should also be logged by Linux (by 
> default, and not with debug level).
> 
> Also copying the 7.13.21.0 firmware on the running system, bringing the 
> interfaces down and up again, the newer firmware is not loaded, but it 
> stays with the 7.13.15.0:
> 
>      [ 3533.374046] bnx2x: [bnx2x_compare_fw_ver:2378(net04)]loaded fw f0d07 major 7 minor d rev f eng 0

Starting the system with 7.13.21.0 in `/lib/firmware` bringing up the 
partner port(?) of a device this message confirms that the newer 
firmware is loaded:

     [  919.466778] bnx2x: [bnx2x_compare_fw_ver:2378(net05)]loaded fw 
120d07 major 7 minor d rev 12 eng 0

>>           /* abort nic load if version mismatch */
>> -        if (my_fw != loaded_fw) {
>> +        if (loaded_fw_major != BCM_5710_FW_MAJOR_VERSION ||
>> +            loaded_fw_minor != BCM_5710_FW_MINOR_VERSION ||
>> +            loaded_fw_eng != BCM_5710_FW_ENGINEERING_VERSION ||
>> +            loaded_fw_rev < BCM_5710_FW_REVISION_VERSION_V15) {
>>               if (print_err)
>> -                BNX2X_ERR("bnx2x with FW %x was already loaded which mismatches my %x FW. Aborting\n",
>> -                      loaded_fw, my_fw);
>> +                BNX2X_ERR("loaded FW incompatible. Aborting\n");
>>               else
>> -                BNX2X_DEV_INFO("bnx2x with FW %x was already loaded which mismatches my %x FW, possibly due to MF UNDI\n",
>> -                           loaded_fw, my_fw);
>> +                BNX2X_DEV_INFO("loaded FW incompatible, possibly due to MF UNDI\n");
>> +
>>               return -EBUSY;
>>           }
>>       }
>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c 
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> index eedb48d945ed..c19b072f3a23 100644
>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> @@ -12319,15 +12319,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>>
>>       bnx2x_read_fwinfo(bp);
>>
>> -    if (IS_PF(bp)) {
>> -        rc = bnx2x_init_firmware(bp);
>> -
>> -        if (rc) {
>> -            bnx2x_free_mem_bp(bp);
>> -            return rc;
>> -        }
>> -    }
>> -
>>       func = BP_FUNC(bp);
>>
>>       /* need to reset chip if undi was active */
>> @@ -12340,7 +12331,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>>
>>           rc = bnx2x_prev_unload(bp);
>>           if (rc) {
>> -            bnx2x_release_firmware(bp);
>>               bnx2x_free_mem_bp(bp);
>>               return rc;
>>           }
>> @@ -13409,7 +13399,7 @@ do {                                    \
>>            (u8 *)bp->arr, len);                    \
>>   } while (0)
>>
>> -int bnx2x_init_firmware(struct bnx2x *bp)
>> +static int bnx2x_init_firmware(struct bnx2x *bp)
>>   {
>>       const char *fw_file_name, *fw_file_name_v15;
>>       struct bnx2x_fw_file_hdr *fw_hdr;
>> @@ -13509,7 +13499,7 @@ int bnx2x_init_firmware(struct bnx2x *bp)
>>       return rc;
>>   }
>>
>> -void bnx2x_release_firmware(struct bnx2x *bp)
>> +static void bnx2x_release_firmware(struct bnx2x *bp)
>>   {
>>       kfree(bp->init_ops_offsets);
>>       kfree(bp->init_ops);
>> @@ -14026,7 +14016,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
>>       return 0;
>>
>>   init_one_freemem:
>> -    bnx2x_release_firmware(bp);
>>       bnx2x_free_mem_bp(bp);
>>
>>   init_one_exit:
>> -- 
>> 2.35.1.273.ge6ebfd0
> 
> So why was the earlier firmware version comparison needed in commit 
> b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")?
> 
> I let the maintainers decide how to best go forward.


Kind regards,

Paul


> [1]: https://linux-regtracking.leemhuis.info/regzbot/mainline/
>       (click on the array to expand the information)
