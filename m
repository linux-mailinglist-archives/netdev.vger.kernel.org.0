Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C917A38992C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 00:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhESWRo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 18:17:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:21564 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229455AbhESWRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 18:17:44 -0400
IronPort-SDR: Uojl7CT7dYn5g84JACOtoyh2CEzv9BPdHJf9SwTbzKsWNN+ScO68QrpO/H/t+KtGYYBu4N5Cip
 937DHNOVOZNA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="262316163"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="262316163"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 15:16:01 -0700
IronPort-SDR: ATK5oUX/UmPtyN8L/+uGComviQx7UsAFoJIAM8/RR/5LaOLRTS9z6ZLJ+L+7o16LljT/UTYepc
 /BRJTfkCnfTA==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="473696521"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.165.64])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 15:16:01 -0700
Date:   Wed, 19 May 2021 15:16:00 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Qi Zhang <qi.z.zhang@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yahui Cao <yahui.cao@intel.com>,
        Beilei Xing <beilei.xing@intel.com>,
        "Simei Su" <simei.su@intel.com>, Jeff Guo <jia.guo@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] virtchnl: Add missing padding to virtchnl_proto_hdrs
Message-ID: <20210519151600.00006065@intel.com>
In-Reply-To: <20210519194350.1854798-1-geert@linux-m68k.org>
References: <20210519194350.1854798-1-geert@linux-m68k.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven wrote:

> On m68k (Coldfire M547x):
> 
>       CC      drivers/net/ethernet/intel/i40e/i40e_main.o
>     In file included from drivers/net/ethernet/intel/i40e/i40e_prototype.h:9,
> 		     from drivers/net/ethernet/intel/i40e/i40e.h:41,
> 		     from drivers/net/ethernet/intel/i40e/i40e_main.c:12:
>     include/linux/avf/virtchnl.h:153:36: warning: division by zero [-Wdiv-by-zero]
>       153 |  { virtchnl_static_assert_##X = (n)/((sizeof(struct X) == (n)) ? 1 : 0) }
> 	  |                                    ^
>     include/linux/avf/virtchnl.h:844:1: note: in expansion of macro ‘VIRTCHNL_CHECK_STRUCT_LEN’
>       844 | VIRTCHNL_CHECK_STRUCT_LEN(2312, virtchnl_proto_hdrs);
> 	  | ^~~~~~~~~~~~~~~~~~~~~~~~~
>     include/linux/avf/virtchnl.h:844:33: error: enumerator value for ‘virtchnl_static_assert_virtchnl_proto_hdrs’ is not an integer constant
>       844 | VIRTCHNL_CHECK_STRUCT_LEN(2312, virtchnl_proto_hdrs);
> 	  |                                 ^~~~~~~~~~~~~~~~~~~
> 
> On m68k, integers are aligned on addresses that are multiples of two,
> not four, bytes.  Hence the size of a structure containing integers may
> not be divisible by 4.
> 
> Fix this by adding explicit padding.

Thanks Geert, I checked and x86_64 adds this padding anyway, so doesn't
result in any functional changes AFAICS. In any case, this is more
correct for a structure that is part of an API (no implicit padding!)

BTW. the patch subject is a little wrong, should have been
[PATCH net]

But I think Tony can take care of that when sending to netdev list,
unless you want to send a v2.
 
> Fixes: 1f7ea1cd6a374842 ("ice: Enable FDIR Configure for AVF")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Compile-tested only.

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
