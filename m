Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02426623F21
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiKJJzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiKJJzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:55:31 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025706AED7;
        Thu, 10 Nov 2022 01:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668074132; x=1699610132;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P8QMfD/hql6MIfKYEhb1Q4SRp9fdkDMS3q6vD+aOowE=;
  b=YNKYchqd2DRQAdyHRKaFP8sjhE06R0DseC9WpVSY1eq0PgLshAtESMqu
   +gSECO3WWMa4QiviUVPMQffpMNQdXg9f7Yd5e8ql0JYQvuokwPN8wvRi+
   +7UkGgiAVyRjwEZMlxPHdX3txX0s+tyFdbPTozFa1OujWCFnN9pT1JsCU
   n77QeB2MF0o4BetT/7eKaSQkyFHpgFIm7KbvKoXOs1TGYgzsUdrQRAfHJ
   xUCTveFf4g41CADBg3h251MrUcAFsq/8UWV2MNvxTzeD6On1U959nWz4w
   G1dSxbM3bw3wGh6sd4BlWYdGQNAGgRgIJKnYRoacu40OMRnujxodwHmq1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="313042912"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="313042912"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 01:55:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="631600624"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="631600624"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.251.183.157]) ([10.251.183.157])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 01:55:27 -0800
Message-ID: <03053677-059f-1ee9-436b-20846caddaa7@linux.intel.com>
Date:   Thu, 10 Nov 2022 11:55:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Intel-wired-lan] [PATCH v2] e1000e: Fix TX dispatch condition
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org, Yan Vugenfirer <yan@daynix.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20221028130000.7318-1-akihiko.odaki@daynix.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20221028130000.7318-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/2022 16:00, Akihiko Odaki wrote:
> e1000_xmit_frame is expected to stop the queue and dispatch frames to
> hardware if there is not sufficient space for the next frame in the
> buffer, but sometimes it failed to do so because the estimated maxmium
> size of frame was wrong. As the consequence, the later invocation of
> e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
> remained forever, resulting in a watchdog failure.
> 
> This change fixes the estimated size by making it match with the
> condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
> account for the following lines which determines the space requirement
> for not causing NETDEV_TX_BUSY:
>      ```
>      	/* reserve a descriptor for the offload context */
>      	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
>      		count++;
>      	count++;
> 
>      	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);
>      ```
> 
> This issue was found when running http-stress02 test included in Linux
> Test Project 20220930 on QEMU with the following commandline:
> ```
> qemu-system-x86_64 -M q35,accel=kvm -m 8G -smp 8
> 	-drive if=virtio,format=raw,file=root.img,file.locking=on
> 	-device e1000e,netdev=netdev
> 	-netdev tap,script=ifup,downscript=no,id=netdev
> ```
> 
> Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
