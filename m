Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250534F1395
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 13:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbiDDLIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 07:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359322AbiDDLIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 07:08:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F8636311;
        Mon,  4 Apr 2022 04:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649070369; x=1680606369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OfZd8m/j4x2eSf+mhhw4j+5Z5vtb4dvGYE8LqR6i3e0=;
  b=V5Q/TmA5+njIs+8kBGf6s6h9bgKNqLTHUFmTMogzjd9/ArC7VyHaCDyl
   rY4fdqJt0qyPSVB5bD6+4zD1d3aoOQAPCJYTvRj5sCSetfN9+Ndgi+dyw
   iXsIAErK3J5PsTXI8jiVppF9QMzYZ0VyLzzHbuG9aVa43zMky94ATg5OH
   8zRTABB/mXQLylIXyrk2Pv8qeu9SnAP7LGjQlnvmDRn/FZidQu4AHG2q/
   TpsWaJ9DRDQK1WJN00J00MHUjntprqZOayz67h+gZNAptd1T5U/MGGoWd
   qG8zb9oCx2gSCvUuvcZ+bR7w1omSsNyFeEruDKHjofUkCgeDq01+qNGgv
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="259320410"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="259320410"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 04:06:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="651456697"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 04 Apr 2022 04:06:06 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 234B64TR032733;
        Mon, 4 Apr 2022 12:06:04 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt@redhat.com,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>, poros@redhat.com,
        Madhu Chittim <madhu.chittim@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix use-after-free
Date:   Mon,  4 Apr 2022 13:04:07 +0200
Message-Id: <20220404110407.1106047-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404100615.23525-1-ivecera@redhat.com>
References: <20220404100615.23525-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Mon,  4 Apr 2022 12:06:14 +0200

> When CONFIG_RFS_ACCEL is enabled the driver uses CPU affinity
> reverse-maps that set CPU affinity notifier in the background.
> 
> If the interface is put down then ice_vsi_free_irq() is called
> via ice_vsi_close() and this clears affinity notifiers of IRQs
> associated with the VSI and old notifier's release callback
> is called - for this case this is cpu_rmap_release() that
> frees allocated cpu_rmap.
> 
> During device removal (ice_remove()) free_irq_cpu_rmap() is called
> and it tries to free already de-allocated cpu_rmap.
> 
> Do not clear IRQ affinity notifier in ice_vsi_free_irq() when
> CONFIG_RFS_ACCEL is enabled. This is a code-path that
> commit 28bf26724fdb ("ice: Implement aRFS") forgot to handle.

Hey, thanks for the fix!
I posted a patch which supercedes these changes to the internal
review on Friday. I would proceed with applying mine (which I'll
submit in 2 hours, it should've waited for the internal acks first),
but for sure I can add you as 'Co-Developed-by:' if you want (or
vice versa, me as co-dev-by?).

> 
> Reproducer:
> [root@host ~]# ip link set ens7f0 up
> [root@host ~]# ip link set ens7f0 down

--- 8< ---

>  		/* clear the affinity_mask in the IRQ descriptor */
>  		irq_set_affinity_hint(irq_num, NULL);
> -- 
> 2.35.1

Thanks,
Al
