Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B846A277C
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBYGQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBYGQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:16:39 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6595E57D3B;
        Fri, 24 Feb 2023 22:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677305798; x=1708841798;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5yzxkyw6vplI7ISAgxlprD25mFCuSitymZLgOFTfxrk=;
  b=AdbeX+623WdNqCnegTfM7hxgpv9MTETc3D1fdyC2RLOL26a9dOe3tdhj
   LKzQpjicVVXeKrJW9ZAO35wYQ+TF4IwRp7ZLujYow2A7K6uQLkltM8yLt
   /lOQleiskIZjNl+NAeDqV2ICAiaswCh5g8accjxTWsQ+28kbPrhzxIVFx
   euGgLSO1sLH9eyI2rjvI3Yk5UGf0nt7KheKXMyw3Hk9l3PRxPYOVrk3Rj
   teR/GIA1bIwk4uK3jP/wb99sSFLLx0Skfb/UpNv4QYrXdggE1Cuqajs5O
   ZlTEKFpEN6DMRwbeGq/8Esw0cjcqoDKnWkOIOaPl6NsBq3+P0Oq0TpXp+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="314024967"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="314024967"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:16:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="796970744"
X-IronPort-AV: E=Sophos;i="5.97,327,1669104000"; 
   d="scan'208";a="796970744"
Received: from soniyas1-mobl.amr.corp.intel.com (HELO [10.212.244.166]) ([10.212.244.166])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 22:16:33 -0800
Message-ID: <2221692c-96d4-441e-019f-f62a77f70acd@linux.intel.com>
Date:   Fri, 24 Feb 2023 22:16:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 4/5] r8169: Use spinlock to guard config
 register locking
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, hkallweit1@gmail.com,
        nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
 <20230225034635.2220386-5-kai.heng.feng@canonical.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20230225034635.2220386-5-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/23 7:46 PM, Kai-Heng Feng wrote:
> Right now r8169 doesn't have parallel access to its config register, but
> the next patch makes the driver access config register at anytime.
> 
> So add a spinlock to protect the config register from any potential race.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v9:
>  - Replace mutex with spinlock so it can be used in softirq context.
> 
> v8:
>  - Swap the place when using the mutex. Protect when config register is
>    unlocked.
> 
> v7:
>  - This is a new patch.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a857650c2e82b..fb73b5386701f 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -613,6 +613,8 @@ struct rtl8169_private {
>  		struct work_struct work;
>  	} wk;
>  
> +	spinlock_t config_lock;
> +
>  	unsigned supports_gmii:1;
>  	unsigned aspm_manageable:1;
>  	dma_addr_t counters_phys_addr;
> @@ -662,10 +664,12 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
>  static void rtl_lock_config_regs(struct rtl8169_private *tp)
>  {
>  	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
> +	spin_unlock_bh(&tp->config_lock);

You mean spin_lock_bh() here right?

>  }
>  
>  static void rtl_unlock_config_regs(struct rtl8169_private *tp)
>  {
> +	spin_lock_bh(&tp->config_lock);
>  	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
>  }
>  
> @@ -5217,6 +5221,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		return rc;
>  	}
>  
> +	spin_lock_init(&tp->config_lock);
> +
>  	tp->mmio_addr = pcim_iomap_table(pdev)[region];
>  
>  	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
