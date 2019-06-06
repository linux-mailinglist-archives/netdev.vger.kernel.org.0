Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1F38142
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfFFWvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:51:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33387 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbfFFWvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:51:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <dann.frazier@canonical.com>)
        id 1hZ1E6-0000YZ-5W
        for netdev@vger.kernel.org; Thu, 06 Jun 2019 22:51:18 +0000
Received: by mail-io1-f69.google.com with SMTP id b197so168132iof.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0mKcd9JDpaqkBbeFapI3fjbNYZFF/Dwmmx0vxB+WOXI=;
        b=jLQaig91BksK+ccp+j2R9FCYSyyqI01Tk5hiXuteTd1mCcmV5kfrTRbEfkkOv59c73
         rq4RbEvs0sgY+yYpsdQxMfzlw0ygpbPkYKEimrCwtwg4Y8ejW+dfShbhRyXuleOfbFiw
         avVXBhP/tD0XvjaaJvqVbpPPavNbO0HPocwsumQhOhUxCc/P5DbytOugcTZMvpnG9ImE
         PL63FrI7exDlBG9+pBqA+O1n3G/PPDjAKhq+GUKqAGfuXHMFnUfnGirDrYzCeiZY7oiZ
         47sRF3IdFOitTfOToQo8pVvDbcK0qYlx5a8V6PXCXswikOlbOR0oo6nWmA7xfg8ZEIOk
         gcZw==
X-Gm-Message-State: APjAAAW+oTH6Qk3fCi+AN3HM6l/w0GgR7VaqpZtXH7z1V1LtPcjra9aF
        WZ7wvE5rSecS6rTlDhs33tn0gP60MXL6bHiUCUFreYtHhGdm8PRbMmfY5UJ5Dxr4CQxS6ANEn2P
        UxkVxrSQbd6cFsXPjiusWqiDlFPboNautRw==
X-Received: by 2002:a5d:8c81:: with SMTP id g1mr30443056ion.239.1559861476515;
        Thu, 06 Jun 2019 15:51:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYpJ7WyAy1WoskFZPjky7vCE+14TkCcOxgp9GOx1Y3LPFs/2Q7NEHxIgYENjly+UZfX9RFAg==
X-Received: by 2002:a5d:8c81:: with SMTP id g1mr30443035ion.239.1559861476133;
        Thu, 06 Jun 2019 15:51:16 -0700 (PDT)
Received: from xps13.canonical.com (c-71-56-235-36.hsd1.co.comcast.net. [71.56.235.36])
        by smtp.gmail.com with ESMTPSA id g21sm62859ita.43.2019.06.06.15.51.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 15:51:15 -0700 (PDT)
Date:   Thu, 6 Jun 2019 16:51:14 -0600
From:   dann frazier <dann.frazier@canonical.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shannon Nelson <shannon.nelson@oracle.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ixgbe: Avoid NULL pointer dereference with VF on
 non-IPsec hw
Message-ID: <20190606225114.GA31678@xps13.dannf>
References: <20190522232258.10353-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522232258.10353-1-dann.frazier@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hey David, Jeff - is it possible to get this queued up as a fix for 5.2?

 -dann
 
On Wed, May 22, 2019 at 05:22:58PM -0600, dann frazier wrote:
> An ipsec structure will not be allocated if the hardware does not support
> offload. Fixes the following Oops:
> 
> [  191.045452] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> [  191.054232] Mem abort info:
> [  191.057014]   ESR = 0x96000004
> [  191.060057]   Exception class = DABT (current EL), IL = 32 bits
> [  191.065963]   SET = 0, FnV = 0
> [  191.069004]   EA = 0, S1PTW = 0
> [  191.072132] Data abort info:
> [  191.074999]   ISV = 0, ISS = 0x00000004
> [  191.078822]   CM = 0, WnR = 0
> [  191.081780] user pgtable: 4k pages, 48-bit VAs, pgdp = 0000000043d9e467
> [  191.088382] [0000000000000000] pgd=0000000000000000
> [  191.093252] Internal error: Oops: 96000004 [#1] SMP
> [  191.098119] Modules linked in: vhost_net vhost tap vfio_pci vfio_virqfd vfio_iommu_type1 vfio xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter devlink ebtables ip6table_filter ip6_tables iptable_filter bpfilter ipmi_ssif nls_iso8859_1 input_leds joydev ipmi_si hns_roce_hw_v2 ipmi_devintf hns_roce ipmi_msghandler cppc_cpufreq sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables x_tables autofs4 ses enclosure btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor hid_generic usbhid hid raid6_pq libcrc32c raid1 raid0 multipath linear ixgbevf hibmc_drm ttm
> [  191.168607]  drm_kms_helper aes_ce_blk aes_ce_cipher syscopyarea crct10dif_ce sysfillrect ghash_ce qla2xxx sysimgblt sha2_ce sha256_arm64 hisi_sas_v3_hw fb_sys_fops sha1_ce uas nvme_fc mpt3sas ixgbe drm hisi_sas_main nvme_fabrics usb_storage hclge scsi_transport_fc ahci libsas hnae3 raid_class libahci xfrm_algo scsi_transport_sas mdio aes_neon_bs aes_neon_blk crypto_simd cryptd aes_arm64
> [  191.202952] CPU: 94 PID: 0 Comm: swapper/94 Not tainted 4.19.0-rc1+ #11
> [  191.209553] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.20.01 04/26/2019
> [  191.218064] pstate: 20400089 (nzCv daIf +PAN -UAO)
> [  191.222873] pc : ixgbe_ipsec_vf_clear+0x60/0xd0 [ixgbe]
> [  191.228093] lr : ixgbe_msg_task+0x2d0/0x1088 [ixgbe]
> [  191.233044] sp : ffff000009b3bcd0
> [  191.236346] x29: ffff000009b3bcd0 x28: 0000000000000000
> [  191.241647] x27: ffff000009628000 x26: 0000000000000000
> [  191.246946] x25: ffff803f652d7600 x24: 0000000000000004
> [  191.252246] x23: ffff803f6a718900 x22: 0000000000000000
> [  191.257546] x21: 0000000000000000 x20: 0000000000000000
> [  191.262845] x19: 0000000000000000 x18: 0000000000000000
> [  191.268144] x17: 0000000000000000 x16: 0000000000000000
> [  191.273443] x15: 0000000000000000 x14: 0000000100000026
> [  191.278742] x13: 0000000100000025 x12: ffff8a5f7fbe0df0
> [  191.284042] x11: 000000010000000b x10: 0000000000000040
> [  191.289341] x9 : 0000000000001100 x8 : ffff803f6a824fd8
> [  191.294640] x7 : ffff803f6a825098 x6 : 0000000000000001
> [  191.299939] x5 : ffff000000f0ffc0 x4 : 0000000000000000
> [  191.305238] x3 : ffff000028c00000 x2 : ffff803f652d7600
> [  191.310538] x1 : 0000000000000000 x0 : ffff000000f205f0
> [  191.315838] Process swapper/94 (pid: 0, stack limit = 0x00000000addfed5a)
> [  191.322613] Call trace:
> [  191.325055]  ixgbe_ipsec_vf_clear+0x60/0xd0 [ixgbe]
> [  191.329927]  ixgbe_msg_task+0x2d0/0x1088 [ixgbe]
> [  191.334536]  ixgbe_msix_other+0x274/0x330 [ixgbe]
> [  191.339233]  __handle_irq_event_percpu+0x78/0x270
> [  191.343924]  handle_irq_event_percpu+0x40/0x98
> [  191.348355]  handle_irq_event+0x50/0xa8
> [  191.352180]  handle_fasteoi_irq+0xbc/0x148
> [  191.356263]  generic_handle_irq+0x34/0x50
> [  191.360259]  __handle_domain_irq+0x68/0xc0
> [  191.364343]  gic_handle_irq+0x84/0x180
> [  191.368079]  el1_irq+0xe8/0x180
> [  191.371208]  arch_cpu_idle+0x30/0x1a8
> [  191.374860]  do_idle+0x1dc/0x2a0
> [  191.378077]  cpu_startup_entry+0x2c/0x30
> [  191.381988]  secondary_start_kernel+0x150/0x1e0
> [  191.386506] Code: 6b15003f 54000320 f1404a9f 54000060 (79400260)
> 
> Fixes: eda0333ac2930 ("ixgbe: add VF IPsec management")
> Signed-off-by: dann frazier <dann.frazier@canonical.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> index ff85ce5791a36..31629fc7e820f 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> @@ -842,6 +842,9 @@ void ixgbe_ipsec_vf_clear(struct ixgbe_adapter *adapter, u32 vf)
>  	struct ixgbe_ipsec *ipsec = adapter->ipsec;
>  	int i;
>  
> +	if (!ipsec)
> +		return;
> +
>  	/* search rx sa table */
>  	for (i = 0; i < IXGBE_IPSEC_MAX_SA_COUNT && ipsec->num_rx_sa; i++) {
>  		if (!ipsec->rx_tbl[i].used)
