Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4191A4D354E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiCIQhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237879AbiCIQbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:31:12 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1023818F20B;
        Wed,  9 Mar 2022 08:25:15 -0800 (PST)
Received: from [192.168.0.2] (ip5f5aef7a.dynamic.kabel-deutschland.de [95.90.239.122])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6EB5C61E64846;
        Wed,  9 Mar 2022 17:15:27 +0100 (CET)
Message-ID: <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
Date:   Wed, 9 Mar 2022 17:15:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Cc:     kuba@kernel.org, netdev@vger.kernel.org, aelior@marvell.com,
        palok@marvell.com, pkushwaha@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        it+netdev@molgen.mpg.de, regressions@leemhuis.info,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware 7.13.21.0
Content-Language: en-US
To:     Manish Chopra <manishc@marvell.com>
References: <20211217165552.746-1-manishc@marvell.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20211217165552.746-1-manishc@marvell.com>
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


Am 17.12.21 um 17:55 schrieb Manish Chopra:
> This new firmware addresses few important issues and enhancements
> as mentioned below -
> 
> - Support direct invalidation of FP HSI Ver per function ID, required for
>    invalidating FP HSI Ver prior to each VF start, as there is no VF start
> - BRB hardware block parity error detection support for the driver
> - Fix the FCOE underrun flow
> - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> - Maintains backward compatibility
> 
> This patch incorporates this new firmware 7.13.21.0 in bnx2x driver.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> ---
> 
> v1->v2:
> ------------
> * Modified the patch such that driver to be backward compatible
>    with older firmware too (New fw v7.13.21.0 on linux-firmware.git
>    enables driver to maintain backward compatibility)
> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        | 11 +++-
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  6 +-
>   .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |  2 +
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |  3 +-
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   | 75 +++++++++++++++-------
>   5 files changed, 69 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> index 2b06d78b..a19dd67 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
> @@ -1850,6 +1850,14 @@ struct bnx2x {
>   
>   	/* Vxlan/Geneve related information */
>   	u16 udp_tunnel_ports[BNX2X_UDP_PORT_MAX];
> +
> +#define FW_CAP_INVALIDATE_VF_FP_HSI	BIT(0)
> +	u32 fw_cap;
> +
> +	u32 fw_major;
> +	u32 fw_minor;
> +	u32 fw_rev;
> +	u32 fw_eng;
>   };
>   
>   /* Tx queues may be less or equal to Rx queues */
> @@ -2525,5 +2533,6 @@ enum {
>    * Meant for implicit re-load flows.
>    */
>   int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
> -
> +int bnx2x_init_firmware(struct bnx2x *bp);
> +void bnx2x_release_firmware(struct bnx2x *bp);
>   #endif /* bnx2x.h */
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 54a2334..8d36ebb 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -2365,10 +2365,8 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
>   	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
>   	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
>   		/* build my FW version dword */
> -		u32 my_fw = (BCM_5710_FW_MAJOR_VERSION) +
> -			(BCM_5710_FW_MINOR_VERSION << 8) +
> -			(BCM_5710_FW_REVISION_VERSION << 16) +
> -			(BCM_5710_FW_ENGINEERING_VERSION << 24);
> +		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
> +				(bp->fw_rev << 16) + (bp->fw_eng << 24);
>   
>   		/* read loaded FW from chip */
>   		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
> index 3f84352..a84d015 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h
> @@ -241,6 +241,8 @@
>   	IRO[221].m2))
>   #define XSTORM_VF_TO_PF_OFFSET(funcId) \
>   	(IRO[48].base + ((funcId) * IRO[48].m1))
> +#define XSTORM_ETH_FUNCTION_INFO_FP_HSI_VALID_E2_OFFSET(fid)	\
> +	(IRO[386].base + ((fid) * IRO[386].m1))
>   #define COMMON_ASM_INVALID_ASSERT_OPCODE 0x0
>   
>   /* eth hsi version */
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
> index 622fadc..611efee 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h
> @@ -3024,7 +3024,8 @@ struct afex_stats {
>   
>   #define BCM_5710_FW_MAJOR_VERSION			7
>   #define BCM_5710_FW_MINOR_VERSION			13
> -#define BCM_5710_FW_REVISION_VERSION		15
> +#define BCM_5710_FW_REVISION_VERSION		21
> +#define BCM_5710_FW_REVISION_VERSION_V15	15
>   #define BCM_5710_FW_ENGINEERING_VERSION		0
>   #define BCM_5710_FW_COMPILE_FLAGS			1
>   
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index aec666e..125dafe 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -74,9 +74,19 @@
>   	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
>   	__stringify(BCM_5710_FW_REVISION_VERSION) "."	\
>   	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
> +
> +#define FW_FILE_VERSION_V15				\
> +	__stringify(BCM_5710_FW_MAJOR_VERSION) "."      \
> +	__stringify(BCM_5710_FW_MINOR_VERSION) "."	\
> +	__stringify(BCM_5710_FW_REVISION_VERSION_V15) "."	\
> +	__stringify(BCM_5710_FW_ENGINEERING_VERSION)
> +
>   #define FW_FILE_NAME_E1		"bnx2x/bnx2x-e1-" FW_FILE_VERSION ".fw"
>   #define FW_FILE_NAME_E1H	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION ".fw"
>   #define FW_FILE_NAME_E2		"bnx2x/bnx2x-e2-" FW_FILE_VERSION ".fw"
> +#define FW_FILE_NAME_E1_V15	"bnx2x/bnx2x-e1-" FW_FILE_VERSION_V15 ".fw"
> +#define FW_FILE_NAME_E1H_V15	"bnx2x/bnx2x-e1h-" FW_FILE_VERSION_V15 ".fw"
> +#define FW_FILE_NAME_E2_V15	"bnx2x/bnx2x-e2-" FW_FILE_VERSION_V15 ".fw"
>   
>   /* Time in jiffies before concluding the transmitter is hung */
>   #define TX_TIMEOUT		(5*HZ)
> @@ -747,9 +757,7 @@ static int bnx2x_mc_assert(struct bnx2x *bp)
>   		  CHIP_IS_E1(bp) ? "everest1" :
>   		  CHIP_IS_E1H(bp) ? "everest1h" :
>   		  CHIP_IS_E2(bp) ? "everest2" : "everest3",
> -		  BCM_5710_FW_MAJOR_VERSION,
> -		  BCM_5710_FW_MINOR_VERSION,
> -		  BCM_5710_FW_REVISION_VERSION);
> +		  bp->fw_major, bp->fw_minor, bp->fw_rev);
>   
>   	return rc;
>   }
> @@ -12308,6 +12316,15 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>   
>   	bnx2x_read_fwinfo(bp);
>   
> +	if (IS_PF(bp)) {
> +		rc = bnx2x_init_firmware(bp);
> +
> +		if (rc) {
> +			bnx2x_free_mem_bp(bp);
> +			return rc;
> +		}
> +	}
> +
>   	func = BP_FUNC(bp);
>   
>   	/* need to reset chip if undi was active */
> @@ -12320,6 +12337,7 @@ static int bnx2x_init_bp(struct bnx2x *bp)
>   
>   		rc = bnx2x_prev_unload(bp);
>   		if (rc) {
> +			bnx2x_release_firmware(bp);
>   			bnx2x_free_mem_bp(bp);
>   			return rc;
>   		}
> @@ -13317,16 +13335,11 @@ static int bnx2x_check_firmware(struct bnx2x *bp)
>   	/* Check FW version */
>   	offset = be32_to_cpu(fw_hdr->fw_version.offset);
>   	fw_ver = firmware->data + offset;
> -	if ((fw_ver[0] != BCM_5710_FW_MAJOR_VERSION) ||
> -	    (fw_ver[1] != BCM_5710_FW_MINOR_VERSION) ||
> -	    (fw_ver[2] != BCM_5710_FW_REVISION_VERSION) ||
> -	    (fw_ver[3] != BCM_5710_FW_ENGINEERING_VERSION)) {
> +	if (fw_ver[0] != bp->fw_major || fw_ver[1] != bp->fw_minor ||
> +	    fw_ver[2] != bp->fw_rev || fw_ver[3] != bp->fw_eng) {
>   		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be %d.%d.%d.%d\n",
> -		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
> -		       BCM_5710_FW_MAJOR_VERSION,
> -		       BCM_5710_FW_MINOR_VERSION,
> -		       BCM_5710_FW_REVISION_VERSION,
> -		       BCM_5710_FW_ENGINEERING_VERSION);
> +			  fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
> +			  bp->fw_major, bp->fw_minor, bp->fw_rev, bp->fw_eng);
>   		return -EINVAL;
>   	}
>   
> @@ -13404,34 +13417,51 @@ static void be16_to_cpu_n(const u8 *_source, u8 *_target, u32 n)
>   	     (u8 *)bp->arr, len);					\
>   } while (0)
>   
> -static int bnx2x_init_firmware(struct bnx2x *bp)
> +int bnx2x_init_firmware(struct bnx2x *bp)
>   {
> -	const char *fw_file_name;
> +	const char *fw_file_name, *fw_file_name_v15;
>   	struct bnx2x_fw_file_hdr *fw_hdr;
>   	int rc;
>   
>   	if (bp->firmware)
>   		return 0;
>   
> -	if (CHIP_IS_E1(bp))
> +	if (CHIP_IS_E1(bp)) {
>   		fw_file_name = FW_FILE_NAME_E1;
> -	else if (CHIP_IS_E1H(bp))
> +		fw_file_name_v15 = FW_FILE_NAME_E1_V15;
> +	} else if (CHIP_IS_E1H(bp)) {
>   		fw_file_name = FW_FILE_NAME_E1H;
> -	else if (!CHIP_IS_E1x(bp))
> +		fw_file_name_v15 = FW_FILE_NAME_E1H_V15;
> +	} else if (!CHIP_IS_E1x(bp)) {
>   		fw_file_name = FW_FILE_NAME_E2;
> -	else {
> +		fw_file_name_v15 = FW_FILE_NAME_E2_V15;
> +	} else {
>   		BNX2X_ERR("Unsupported chip revision\n");
>   		return -EINVAL;
>   	}
> +
>   	BNX2X_DEV_INFO("Loading %s\n", fw_file_name);
>   
>   	rc = request_firmware(&bp->firmware, fw_file_name, &bp->pdev->dev);
>   	if (rc) {
> -		BNX2X_ERR("Can't load firmware file %s\n",
> -			  fw_file_name);
> -		goto request_firmware_exit;
> +		BNX2X_DEV_INFO("Trying to load older fw %s\n", fw_file_name_v15);
> +
> +		/* try to load prev version */
> +		rc = request_firmware(&bp->firmware, fw_file_name_v15, &bp->pdev->dev);
> +
> +		if (rc)
> +			goto request_firmware_exit;
> +
> +		bp->fw_rev = BCM_5710_FW_REVISION_VERSION_V15;
> +	} else {
> +		bp->fw_cap |= FW_CAP_INVALIDATE_VF_FP_HSI;
> +		bp->fw_rev = BCM_5710_FW_REVISION_VERSION;
>   	}
>   
> +	bp->fw_major = BCM_5710_FW_MAJOR_VERSION;
> +	bp->fw_minor = BCM_5710_FW_MINOR_VERSION;
> +	bp->fw_eng = BCM_5710_FW_ENGINEERING_VERSION;
> +
>   	rc = bnx2x_check_firmware(bp);
>   	if (rc) {
>   		BNX2X_ERR("Corrupt firmware file %s\n", fw_file_name);
> @@ -13487,7 +13517,7 @@ static int bnx2x_init_firmware(struct bnx2x *bp)
>   	return rc;
>   }
>   
> -static void bnx2x_release_firmware(struct bnx2x *bp)
> +void bnx2x_release_firmware(struct bnx2x *bp)
>   {
>   	kfree(bp->init_ops_offsets);
>   	kfree(bp->init_ops);
> @@ -14004,6 +14034,7 @@ static int bnx2x_init_one(struct pci_dev *pdev,
>   	return 0;
>   
>   init_one_freemem:
> +	bnx2x_release_firmware(bp);
>   	bnx2x_free_mem_bp(bp);
>   
>   init_one_exit:

This change was added to Linux in commit b7a49f73059f (bnx2x: Utilize 
firmware 7.13.21.0) [1] to Linux v5.17-rc1, and backported to the stable 
series, for example, Linux v5.10.95.

Due to CVE-2022-0847 (Dirty Pipe) [1] we updated systems from, for 
example, Linux 5.10.24 to Linux v5.10.103 and noticed that the Broadcom 
network devices failed to initialize.

```
[   20.477325] bnx2 0000:02:00.0 eth0: Broadcom NetXtreme II BCM5709 
1000Base-T (C0) PCI Express found at mem c6000000, IRQ 41, node addr 
c8:1f:66:cf:34:45
[   20.491782] bnx2 0000:02:00.1 eth1: Broadcom NetXtreme II BCM5709 
1000Base-T (C0) PCI Express found at mem c8000000, IRQ 42, node addr 
c8:1f:66:cf:34:47
[   20.506223] bnx2 0000:03:00.0 eth2: Broadcom NetXtreme II BCM5709 
1000Base-T (C0) PCI Express found at mem ca000000, IRQ 43, node addr 
c8:1f:66:cf:34:49
[   20.520644] bnx2 0000:03:00.1 eth3: Broadcom NetXtreme II BCM5709 
1000Base-T (C0) PCI Express found at mem cc000000, IRQ 44, node addr 
c8:1f:66:cf:34:4b
[   20.534985] bnx2x 0000:45:00.0: msix capability found
[   20.540342] bnx2x 0000:45:00.0: part number 
394D4342-31373735-31314131-473331
[   20.548605] bnx2x 0000:45:00.0: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.21.0.fw failed with error -2
[   20.558373] bnx2x 0000:45:00.0: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.15.0.fw failed with error -2
[   20.568319] bnx2x: probe of 0000:45:00.0 failed with error -2
[   20.574148] bnx2x 0000:45:00.1: msix capability found
[   20.579470] bnx2x 0000:45:00.1: part number 
394D4342-31373735-31314131-473331
[   20.587708] bnx2x 0000:45:00.1: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.21.0.fw failed with error -2
[   20.597479] bnx2x 0000:45:00.1: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.15.0.fw failed with error -2
[   20.607355] bnx2x: probe of 0000:45:00.1 failed with error -2
[   20.613179] bnx2x 0000:46:00.0: msix capability found
[   20.618501] bnx2x 0000:46:00.0: part number 
394D4342-31373735-31314131-473331
[   20.626805] bnx2x 0000:46:00.0: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.21.0.fw failed with error -2
[   20.636580] bnx2x 0000:46:00.0: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.15.0.fw failed with error -2
[   20.646453] bnx2x: probe of 0000:46:00.0 failed with error -2
[   20.652279] bnx2x 0000:46:00.1: msix capability found
[   20.657593] bnx2x 0000:46:00.1: part number 
394D4342-31373735-31314131-473331
[   20.665813] bnx2x 0000:46:00.1: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.21.0.fw failed with error -2
[   20.675590] bnx2x 0000:46:00.1: Direct firmware load for 
bnx2x/bnx2x-e1h-7.13.15.0.fw failed with error -2
[   20.685457] bnx2x: probe of 0000:46:00.1 failed with error -2
```

Due to reasons, we do not have firmware in the initrd, and the firmware 
files are only the root partition in `/lib/firmware`.

Logging in using other means¹, and removing the PCI devices, and 
rescanning brought the devices online.

     $ echo 1 | sudo tee /sys/bus/pci/devices/0000\:{45,46}\:00.{0,1}/remove
     $ echo 1 | sudo tee /sys/bus/pci/rescan

Adding the firmware files to the initrd also fixes the issue.

I didn’t bisect the change, but the refactoring of the init methods 
looks like the reason for the change of behavior. As it’s not documented 
in the commit message, was that intentional? I think it breaks Linux’ no 
regression rule, and the commit (and follow-ups) should be reverted in 
Linux v5.17 and backed out from the stable series.


Kind regards,

Paul


¹ Why can’t even without proper firmware, the card at least initialize 
to have a network connection even if it’s degraded?
