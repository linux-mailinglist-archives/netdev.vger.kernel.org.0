Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 118054DC79E
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiCQNdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiCQNdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:33:20 -0400
Received: from mx1.molgen.mpg.de (unknown [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A611D7880;
        Thu, 17 Mar 2022 06:32:02 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5aef3c.dynamic.kabel-deutschland.de [95.90.239.60])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AE25F61EA1928;
        Thu, 17 Mar 2022 14:31:45 +0100 (CET)
Message-ID: <1986e70f-9e3b-cc64-4c15-dbc2abd1dc8d@molgen.mpg.de>
Date:   Thu, 17 Mar 2022 14:31:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [EXT] Re: [PATCH net] bnx2x: fix built-in kernel driver load
 failure
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>, regressions@lists.linux.dev,
        stable@vger.kernel.org, it+netdev@molgen.mpg.de
References: <20220316214613.6884-1-manishc@marvell.com>
 <35d305f5-aa84-2c47-7efd-66fffb91c398@molgen.mpg.de>
 <BY3PR18MB46129020BC8C93377CA16FB8AB129@BY3PR18MB4612.namprd18.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <BY3PR18MB46129020BC8C93377CA16FB8AB129@BY3PR18MB4612.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RDNS_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Dear Manish,


Am 17.03.22 um 10:55 schrieb Manish Chopra:
>> -----Original Message-----
>> From: Paul Menzel <pmenzel@molgen.mpg.de>
>> Sent: Thursday, March 17, 2022 1:03 PM

[…]

>> Am 16.03.22 um 22:46 schrieb Manish Chopra:
>>> commit b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0") added
>>> request_firmware() logic in probe() which caused built-in kernel
>>> driver (CONFIG_BNX2X=y) load failure (below), as access to firmware
>>> file is not feasible during the probe.
>>
>> I think it’s important to document, that the firmware was not present in the
>> initrd.
> 
> I believe this problem has nothing to do with initrd module/FW but
> rather a module built in the kernel/vmlinuz (CONFIG_BNX2X=y) itself, 
> A module load from initrd works fine and can access the initrd FW
> files present in initrd file system even during the probe. For
> example, when I had CONFIG_BNX2X=m, it loads the module fine from
> initrd with FW files present in initrd file system. When I had
> CONFIG_BNX2X=y, which I believe doesn't install/load module in/from
> initrd but in kernel (vmlinuz) itself, that's where it can't access
> the firmware file and cause the load failure.

I can only say, that adding the firmware to the initrd worked around the 
problem on our side with `CONFIG_BNX2X=y`.

>>> "Direct firmware load for bnx2x/bnx2x-e2-7.13.21.0.fw
>>> failed with error -2"
>>
>> I’d say, no line break for log message. Maybe paste the excerpt below:
>>
>>       [   20.534985] bnx2x 0000:45:00.0: msix capability found
>>       [   20.540342] bnx2x 0000:45:00.0: part number 394D4342-31373735-31314131-473331
>>       [   20.548605] bnx2x 0000:45:00.0: Direct firmware load for bnx2x/bnx2x-e1h-7.13.21.0.fw failed with error -2
>>       [   20.558373] bnx2x 0000:45:00.0: Direct firmware load for bnx2x/bnx2x-e1h-7.13.15.0.fw failed with error -2
>>       [   20.568319] bnx2x: probe of 0000:45:00.0 failed with error -2
>>
>>> This patch fixes this issue by -
>>>
>>> 1. Removing request_firmware() logic from the probe()
>>>      such that .ndo_open() handle it as it used to handle
>>>      it earlier
>>>
>>> 2. Given request_firmware() is removed from probe(), so
>>>      driver has to relax FW version comparisons a bit against
>>>      the already loaded FW version (by some other PFs of same
>>>      adapter) to allow different compatible/close FWs with which
>>>      multiple PFs may run with (in different environments), as the
>>>      given PF who is in probe flow has no idea now with which firmware
>>>      file version it is going to initialize the device in ndo_open()
>>
>> Please be specific and state, that the revision part in the version has
>> to be greater, and that downgrading is not allowed.
> 
> I didn't get it, you can't downgrade to any firmware unless you
> downgrade the kernel/driver, driver with these recent commits/fixes
> are always supposed to run with this minimum older FW version
> (7.13.15.0) or a greater FW version (for example now 7.13.21.0). if
> you want to use the FW version even older to these then you have to 
> downgrade the driver/kernel as well which won't have these
> commits/logics in them.
I just want you to explicitly describe the added condition in the commit
message.

>>> Cc: stable@vger.kernel.org
>>> Link: https://urldefense.proofpoint.com/v2/url?u=https-
>> 3A__lore.kernel.org_all_46f2d9d9-2Dae7f-2Db332-2Dddeb-
>> 2Db59802be2bab-
>> 40molgen.mpg.de_&d=DwIDaQ&c=nKjWec2b6R0mOyPaz7xtfQ&r=bMTgx2X4
>> 8QVXyXOEL8ALyI4dsWoR-m74c5n3d-ruJI8&m=FmUvhi_ygxQI4mnQmg5pU-
>> th-BWb_aEXUni5bpt6e934rZh0Wp-
>> KuVdfW7N2O0za&s=t3mHF8L4_cacsuvE5TqHUBSqD70Yfsbk3or973FvyEQ&e=

Thank you Outlook for protecting the word. :/

>>> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
>>> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
>>> Fixes: b7a49f73059f ("bnx2x: Utilize firmware 7.13.21.0")
>>> Signed-off-by: Manish Chopra <manishc@marvell.com>
>>> Signed-off-by: Ariel Elior <aelior@marvell.com>
>>> ---
>>>    drivers/net/ethernet/broadcom/bnx2x/bnx2x.h   |  2 --
>>>    .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 28 +++++++++++--------
>>>    .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 15 ++--------
>>>    3 files changed, 19 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> index a19dd6797070..2209d99b3404 100644
>>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
>>> @@ -2533,6 +2533,4 @@ void bnx2x_register_phc(struct bnx2x *bp);
>>>     * Meant for implicit re-load flows.
>>>     */
>>>    int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
>>> -int bnx2x_init_firmware(struct bnx2x *bp);
>>> -void bnx2x_release_firmware(struct bnx2x *bp);
>>>    #endif /* bnx2x.h */
>>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>>> index 8d36ebbf08e1..5729a5ab059d 100644
>>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
>>> @@ -2364,24 +2364,30 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp,
>> u32 load_code, bool print_err)
>>>    	/* is another pf loaded on this engine? */
>>>    	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
>>>    	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
>>> -		/* build my FW version dword */
>>> -		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
>>> -				(bp->fw_rev << 16) + (bp->fw_eng << 24);
>>> +		u8 loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng;
>>> +		u32 loaded_fw;
>>>
>>>    		/* read loaded FW from chip */
>>> -		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
>>> +		loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
>>>
>>> -		DP(BNX2X_MSG_SP, "loaded fw %x, my fw %x\n",
>>> -		   loaded_fw, my_fw);
>>> +		loaded_fw_major = loaded_fw & 0xff;
>>> +		loaded_fw_minor = (loaded_fw >> 8) & 0xff;
>>> +		loaded_fw_rev = (loaded_fw >> 16) & 0xff;
>>> +		loaded_fw_eng = (loaded_fw >> 24) & 0xff;
>>> +
>>> +		DP(BNX2X_MSG_SP, "loaded fw 0x%x major 0x%x minor 0x%x rev 0x%x eng 0x%x\n",
>>> +		   loaded_fw, loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng);
>>>
>>>    		/* abort nic load if version mismatch */
>>> -		if (my_fw != loaded_fw) {
>>> +		if (loaded_fw_major != BCM_5710_FW_MAJOR_VERSION ||
>>> +		    loaded_fw_minor != BCM_5710_FW_MINOR_VERSION ||
>>> +		    loaded_fw_eng != BCM_5710_FW_ENGINEERING_VERSION ||
>>
>> The engineering version comes after the revision, so I’d assume they can
>> also be relaxed and differ?
> 
> We don't change the engineering version at all, it's just for sanity
> and going to always remain as zero. We use this only for debugging
> purpose, to differentiate debug FW version vs official FW version.

Please add a comment to make that clean. (Also the existing comment
should be updated.)

>>> +		    loaded_fw_rev < BCM_5710_FW_REVISION_VERSION_V15) {
>>>    			if (print_err)
>>
>> Unrelated, this print_err argument added in commit 91ebb929b6f8 (bnx2x:
>> Add support for Multi-Function UNDI) is not so elegant.
>>
>>> -				BNX2X_ERR("bnx2x with FW %x was already loaded which mismatches my %x FW. Aborting\n",
>>> -					  loaded_fw, my_fw);
>>> +				BNX2X_ERR("loaded FW incompatible. Aborting\n");
>>
>> Please add the versions to the error message to give the user more clues.
> 
> I didn't keep it purposely here (to get rid of 100 chars warning) :- ), given the debug print just before this already logs
> all the version info about the already loaded_fw which can be enabled to get those info. I would prefer a seeparate commit
> on refining/enabling messages or adding any new informative messages for user about FW versioning related.

Well, the warning does not apply to log messages, so – as it’s present 
before – and debug logging is cumbersome to enable, please leave it.


Kind regards,

Paul


>>>    			else
>>> -				BNX2X_DEV_INFO("bnx2x with FW %x was already loaded which mismatches my %x FW, possibly due to MF UNDI\n",
>>> -					       loaded_fw, my_fw);
>>> +				BNX2X_DEV_INFO("loaded FW incompatible, possibly due to MF UNDI\n");
>>> +
>>>    			return -EBUSY;
>>>    		}
>>>    	}
>>> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>>> index eedb48d945ed..c19b072f3a23 100644
>>> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>>> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
>>> @@ -12319,15 +12319,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>>>
>>>    	bnx2x_read_fwinfo(bp);
>>>
>>> -	if (IS_PF(bp)) {
>>> -		rc = bnx2x_init_firmware(bp);
>>> -
>>> -		if (rc) {
>>> -			bnx2x_free_mem_bp(bp);
>>> -			return rc;
>>> -		}
>>> -	}
>>> -
>>>    	func = BP_FUNC(bp);
>>>
>>>    	/* need to reset chip if undi was active */
>>> @@ -12340,7 +12331,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>>>
>>>    		rc = bnx2x_prev_unload(bp);
>>>    		if (rc) {
>>> -			bnx2x_release_firmware(bp);
>>>    			bnx2x_free_mem_bp(bp);
>>>    			return rc;
>>>    		}
>>> @@ -13409,7 +13399,7 @@ do {
>> 				\
>>>    	     (u8 *)bp->arr, len);					\
>>>    } while (0)
>>>
>>> -int bnx2x_init_firmware(struct bnx2x *bp)
>>> +static int bnx2x_init_firmware(struct bnx2x *bp)
>>>    {
>>>    	const char *fw_file_name, *fw_file_name_v15;
>>>    	struct bnx2x_fw_file_hdr *fw_hdr;
>>> @@ -13509,7 +13499,7 @@ int bnx2x_init_firmware(struct bnx2x *bp)
>>>    	return rc;
>>>    }
>>>
>>> -void bnx2x_release_firmware(struct bnx2x *bp)
>>> +static void bnx2x_release_firmware(struct bnx2x *bp)
>>>    {
>>>    	kfree(bp->init_ops_offsets);
>>>    	kfree(bp->init_ops);
>>> @@ -14026,7 +14016,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
>>>    	return 0;
>>>
>>>    init_one_freemem:
>>> -	bnx2x_release_firmware(bp);
>>>    	bnx2x_free_mem_bp(bp);
>>>
>>>    init_one_exit:
>>
>>
>> Kind regards,
>>
>> Paul
