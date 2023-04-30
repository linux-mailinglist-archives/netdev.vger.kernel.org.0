Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19086F27AE
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 07:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjD3FGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 01:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjD3FGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 01:06:07 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C85E19AC;
        Sat, 29 Apr 2023 22:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682831166; x=1714367166;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wUIy27kaA7x1m/LYtCGQz0bQD3AE4rfsj1cxLUC2Tzk=;
  b=MV/bw3PpAmXweL4gp3ujplDciWYiOscjXD+Z93RytSZUTYujoAssLg7R
   mrMCUUmOg/s52DkRNpN2+ut0k+4DbBuJmpjo5/iRbw5e6p8mC4AlSYej4
   JMAXdPpE3sv5DUCiaQqkUwvAH7fjB5N4uvc5x8E/b2vjsQ2XJJEM5B/yD
   uPRZi/9XKVs5tP98fkIeM7UTI/ErLQwQf0yOd6wLnOF+xEJjDS0uJnCiV
   JXUNr2n8IGKH3nFdXkY/UXV8k2W97P38PxRkbFt69qhDPgOhy089ZVN0p
   hGsC4R1oL5DTNQojPkTVGxR8PJn+l5ZcNvcxqDvI9vj0mgTDDLAqAhpXs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10695"; a="348029659"
X-IronPort-AV: E=Sophos;i="5.99,238,1677571200"; 
   d="scan'208";a="348029659"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2023 22:06:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10695"; a="728115425"
X-IronPort-AV: E=Sophos;i="5.99,238,1677571200"; 
   d="scan'208";a="728115425"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.36]) ([10.13.12.36])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2023 22:05:58 -0700
Message-ID: <499598fd-05fc-e3bc-be85-d74b47a0b46c@linux.intel.com>
Date:   Sun, 30 Apr 2023 08:05:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net v3 1/1] igc: read before write to
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
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     xdp-hints@xdp-project.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230414154902.2950535-1-yoong.siang.song@intel.com>
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

On 4/14/2023 18:49, Song Yoong Siang wrote:
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
>    found skb hwtstamp = 1677800973.642836757
> 
> Optionally, read PHC to confirm the values obtained are almost the same:
> Command:
>    sudo ./testptp -d /dev/ptp0 -g
> Result:
>    clock time: 1677800973.913598978 or Fri Mar  3 07:49:33 2023
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> v2 -> v3: Refactor SRRCTL definitions to more human readable definitions
> v1 -> v2: Fix indention
> ---
>   drivers/net/ethernet/intel/igc/igc_base.h | 11 ++++++++---
>   drivers/net/ethernet/intel/igc/igc_main.c |  7 +++++--
>   2 files changed, 13 insertions(+), 5 deletions(-)

Tested-by: Naama Meir <naamax.meir@linux.intel.com>
