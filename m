Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DF435FFD5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhDOCHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:07:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:14866 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhDOCHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 22:07:15 -0400
IronPort-SDR: OAj1+TXC/xDBgbGHh87mJqGcG+AeH130Sdv57AwUnKGs+gMlaGX7hXN7gg5nBbfomPG4Pj6/UG
 nfDStuembbcg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="192648863"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="192648863"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 19:06:53 -0700
IronPort-SDR: XfNeBLI887Qp5AIn4Mtpvqr7TMGB4r1tIYsEOb/+S1DvwzmWZLsPyymzajdWHKDKLzvsRaQDpc
 FaMdnn/wDzVw==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="383874988"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.19.126])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 19:06:52 -0700
Date:   Wed, 14 Apr 2021 19:06:52 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     kerneljasonxing@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     anthony.l.nguyen@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: Re: [PATCH net v3] i40e: fix the panic when running bpf in xdpdrv
 mode
Message-ID: <20210414190652.00006680@intel.com>
In-Reply-To: <20210414023428.10121-1-kerneljasonxing@gmail.com>
References: <20210413025011.1251-1-kerneljasonxing@gmail.com>
        <20210414023428.10121-1-kerneljasonxing@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kerneljasonxing@gmail.com wrote:

> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Fix this panic by adding more rules to calculate the value of @rss_size_max
> which could be used in allocating the queues when bpf is loaded, which,
> however, could cause the failure and then trigger the NULL pointer of
> vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
> cpus are online and then allocates 256 queues on the machine with 32 cpus
> online actually.
> 
> Once the load of bpf begins, the log will go like this "failed to get
> tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
> failed".
> 
> Thus, I attach the key information of the crash-log here.
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000
> RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
> Call Trace:
> [2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
> [2160294.717666]  dev_xdp_install+0x4f/0x70
> [2160294.718036]  dev_change_xdp_fd+0x11f/0x230
> [2160294.718380]  ? dev_disable_lro+0xe0/0xe0
> [2160294.718705]  do_setlink+0xac7/0xe70
> [2160294.719035]  ? __nla_parse+0xed/0x120
> [2160294.719365]  rtnl_newlink+0x73b/0x860
> 
> Fixes: 41c445ff0f48 ("i40e: main driver core")
> Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

@Jakub/@DaveM - feel free to apply this directly.
