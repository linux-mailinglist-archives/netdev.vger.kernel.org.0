Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1987F3C0AF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbfFKApV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:45:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60121 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbfFKApU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:45:20 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <dann.frazier@canonical.com>)
        id 1haUuc-0003h7-67
        for netdev@vger.kernel.org; Tue, 11 Jun 2019 00:45:18 +0000
Received: by mail-io1-f69.google.com with SMTP id j18so8770300ioj.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QMa7qyqdKtqSEB3wVhM8/baQDLr+QEE8dqFeHm/HoKs=;
        b=sa3NSIJTFvBBSEOkhW+xdw8u36BbXAR2nAX6PAtUF4KR4RFKGda5iJCL7JUjPObNMK
         SCf5VUo15hJ3OFggn55x65zhWQLx6OowlEcG3CJaS9ok8JqiXO8qdpcZqCLpnSIikX21
         z2yQ7M5EN+eYfobuFrHgyZC282LlnGfkF0SSuHKYYM5LJNVESL1Oifqn7oJk4LyYC1vL
         0eZkpWuwK34BLe/QnbagwjgWpQ7Uro6nLyh5gWaFYh/jsldI9QsUVh20JlF9OY2eOK5H
         +v5RiLeiINdpo7P/nRU5umfE6kFCBacn+LCw34y+LmlBHQWJe/snTrbpBRtcxnzZrPTs
         gddw==
X-Gm-Message-State: APjAAAV6DraxAE8CrHB8im6qDrQx+m9TsbQdBE2ncebOLqRrmTuDePxf
        sl6MORfG+IMHg1lv561suGoBwmSUQt6b0ragvqs1d8jhP5hYc3tjE5a6bAtTPkGvQ9LQnFu6/ho
        XtjZcnDWf+yyghOpnk8Pz6/9fSfSodukenA==
X-Received: by 2002:a24:5c05:: with SMTP id q5mr16811614itb.110.1560213916705;
        Mon, 10 Jun 2019 17:45:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzSyd6IZrboGSl9qQQCjbEZvrbef5ybzwRftJZUY96L0KN3jEGTJJpVT5SD5CddFcWYLmSv0Q==
X-Received: by 2002:a24:5c05:: with SMTP id q5mr16811590itb.110.1560213916304;
        Mon, 10 Jun 2019 17:45:16 -0700 (PDT)
Received: from xps13.canonical.com (c-71-56-235-36.hsd1.co.comcast.net. [71.56.235.36])
        by smtp.gmail.com with ESMTPSA id 15sm4139051ioe.46.2019.06.10.17.45.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 17:45:15 -0700 (PDT)
Date:   Mon, 10 Jun 2019 18:45:14 -0600
From:   dann frazier <dann.frazier@canonical.com>
To:     Xue Chaojing <xuechaojing@huawei.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, luoshaokai@huawei.com,
        cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: fix a bug in set rx mode
Message-ID: <20190611004514.GA23302@xps13.dannf>
References: <20190527221005.10073-1-xuechaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527221005.10073-1-xuechaojing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 10:10:05PM +0000, Xue Chaojing wrote:
> in set_rx_mode, __dev_mc_sync and netdev_for_each_mc_addr will
> repeatedly set the multicast mac address. so we delete this loop.

fyi, I'm told this fixes the following Oops (in case it makes sense to
queue it for stable):

[ 642.914581] Internal error: Oops: 96000005 [#1] SMP
[ 642.919444] Modules linked in: hinic(-) 8021q garp mrp stp llc ses enclosure sg nls_utf8 isofs vfat fat loop ipmi_ssif crc32_ce crct10dif_ce ghash_c e sha2_ce sha256_arm64 sha1_ce sbsa_gwdt hns_roce_hw_v2 hns_roce ib_core ipmi_si ipmi_devintf ipmi_msghandler xfs libcrc32c marvell hibmc_drm drm_kms_h elper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm qla2xxx ixgbe drm mpt3sas nvme_fc hns3 hisi_sas_v3_hw igb nvme_fabrics hisi_sas_main hclge mdio scsi_transport_fc nvme libsas hnae3 raid_class nvme_core scsi_transport_sas i2c_algo_bit gpio_dwapb gpio_generic dm_mirror dm_region_hash dm_log dm_mo d [last unloaded: hinic]
[ 642.974177] CPU: 4 PID: 5339 Comm: kworker/u256:1 Kdump: loaded Not tainted 4.18.0-74.el8.aarch64 #1
[ 642.983293] Hardware name: Huawei TaiShan 2280 V2/BC82AMDA, BIOS TA BIOS 2280-A CS V2.16.01 03/16/2019
[ 642.992591] Workqueue: hinic_dev set_rx_mode [hinic]
[ 642.997542] pstate: 00c00009 (nzcv daif +PAN +UAO)
[ 643.002320] pc : add_mac_addr+0xa4/0x100 [hinic]
[ 643.006924] lr : set_rx_mode+0x88/0xc0 [hinic]
[ 643.011353] sp : ffff00003228fd40
[ 643.014653] x29: ffff00003228fd40 x28: 0000000000000000
[ 643.019952] x27: ffffb955c362ff38 x26: ffff27ccd2cc3110
[ 643.025250] x25: 0000000000000000 x24: ffffb955025c6b08
[ 643.030547] x23: ffffb955025c6000 x22: 0000000000000010
[ 643.035845] x21: ffff27cc56040488 x20: ffffb955025c6ac0
[ 643.041142] x19: 0000000000000000 x18: 0000000000000010
[ 643.046440] x17: 0000ffffb7135830 x16: ffff27ccd2259bb8
[ 643.051737] x15: ffffffffffffffff x14: 2030302031302039
[ 643.057035] x13: 33203d2072646461 x12: 2063616d20746573
[ 643.062332] x11: 203a296465726574 x10: 0000000000000d10
[ 643.067630] x9 : ffff00003228f9f0 x8 : ffffb95501756170
[ 643.072927] x7 : 198c000940300814 x6 : ffff00003228fd08
[ 643.078225] x5 : 0000000000000000 x4 : 0000000000000000
[ 643.083523] x3 : 0000000000000000 x2 : 0000000000000001
[ 643.088820] x1 : 0000000000000010 x0 : 00000000000000e3
[ 643.094118] Process kworker/u256:1 (pid: 5339, stack limit = 0x0000000023b4f182)
[ 643.101498] Call trace:
[ 643.103932] add_mac_addr+0xa4/0x100 [hinic]
[ 643.108189] set_rx_mode+0x88/0xc0 [hinic]
[ 643.112272] process_one_work+0x1ac/0x3e0
[ 643.116268] worker_thread+0x44/0x448
[ 643.119916] kthread+0x130/0x138
[ 643.123130] ret_from_fork+0x10/0x18
[ 643.126692] Code: a9425bf5 a94363f7 a8c47bfd d65f03c0 (394016c7)
[ 643.132828] SMP: stopping secondary CPUs
[ 643.139859] Starting crashdump kernel...
[ 643.143771] Bye!

  -dann

> Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_main.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index e64bc664f687..cfd3f4232cac 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -724,7 +724,6 @@ static void set_rx_mode(struct work_struct *work)
>  {
>  	struct hinic_rx_mode_work *rx_mode_work = work_to_rx_mode_work(work);
>  	struct hinic_dev *nic_dev = rx_mode_work_to_nic_dev(rx_mode_work);
> -	struct netdev_hw_addr *ha;
>  
>  	netif_info(nic_dev, drv, nic_dev->netdev, "set rx mode work\n");
>  
> @@ -732,9 +731,6 @@ static void set_rx_mode(struct work_struct *work)
>  
>  	__dev_uc_sync(nic_dev->netdev, add_mac_addr, remove_mac_addr);
>  	__dev_mc_sync(nic_dev->netdev, add_mac_addr, remove_mac_addr);
> -
> -	netdev_for_each_mc_addr(ha, nic_dev->netdev)
> -		add_mac_addr(nic_dev->netdev, ha->addr);
>  }
>  
>  static void hinic_set_rx_mode(struct net_device *netdev)
