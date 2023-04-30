Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CB66F27A7
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 07:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjD3FDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 01:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjD3FDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 01:03:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F98F19AC;
        Sat, 29 Apr 2023 22:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682830995; x=1714366995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q7SEF4bArk/xxwIRZ987yc+xrZpMH3afDQGaBkiO/LA=;
  b=EfFc+EaXNGNfs9iV4vt9Ow16OpkrOuxBVu82jt2OApTno4NTjDIllNNt
   vDWA6ZTBw3LaonwfIHfw0OUHb70RapzPj2tQJHAnyH46gt8n2fJ06ehwK
   6VaQk5YMi/dTTH1Fcfhln3vEFNZKL8GsXYMO0FW7+WQ5LGwPSdsbnW/ba
   yNMCNzE7z3L+c+0IXbJzrx9zimvt7Dx/u8uBguMAbQ6vG2s3gDR6Oh/p3
   tFSmxK4whzZNjGX1zgXMK8seNzpKzIK8ItV6+O6akqlW32HNXMu/G8bHj
   BDB6rrQAdx4lEy6eB31xtA1hIdfRyn8AfLNfn8u0IRxtjFO+7GFzKe3i2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10695"; a="411108972"
X-IronPort-AV: E=Sophos;i="5.99,238,1677571200"; 
   d="scan'208";a="411108972"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2023 22:03:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10695"; a="941652643"
X-IronPort-AV: E=Sophos;i="5.99,238,1677571200"; 
   d="scan'208";a="941652643"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.36]) ([10.13.12.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2023 22:03:08 -0700
Message-ID: <7733369a-c3a6-89d4-fb32-ab2bcdc1def0@linux.intel.com>
Date:   Sun, 30 Apr 2023 08:03:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net 1/1] igc: read before write to
 SRRCTL register
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     xdp-hints@xdp-project.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230413151222.1864307-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/2023 18:12, Song Yoong Siang wrote:
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> Thus, this commit read the register value before write to SRRCTL
> register. This commit is tested by using xdp_hw_metadata bpf selftest
> tool. The tool enables Rx hardware timestamp and then attach XDP program
> to igc driver. It will display hardware timestamp of UDP packet with
> port number 9092. Below are detail of test steps and results.
> 
> Command on DUT:
>    sudo ./xdp_hw_metadata <interface name>
> 
> Command on Link Partner:
>    echo -n skb | nc -u -q1 <destination IPv4 addr> 9092
> 
> Result before this patch:
>    skb hwtstamp is not found!
> 
> Result after this patch:
>    found skb hwtstamp = 1677762212.590696226
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_base.h | 7 +++++--
>   drivers/net/ethernet/intel/igc/igc_main.c | 5 ++++-
>   2 files changed, 9 insertions(+), 3 deletions(-)

Tested-by: Naama Meir <naamax.meir@linux.intel.com>
