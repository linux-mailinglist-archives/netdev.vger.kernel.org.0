Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1404A4E25C1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346418AbiCUL5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiCUL5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:57:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAD210F4;
        Mon, 21 Mar 2022 04:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647863736; x=1679399736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mfbOq5iAK8SE23byJMRPvctNFXZ1aD5KZOZcb0LP44M=;
  b=DR1QgoQYQrVhL1OfDhk99/W8xfaqNFPlazz/dykZD0GDkIJP93wqzIhD
   awC3UUtM1nrB+iLWH8RAW7VsU70EeuA5y666w5PP8IPduIHVTuOZ/Lq4v
   vPhiXw64yvg9LFdBQQMyxtahGPMbB1ssPT+FigKb5NbuAnYLDpafsdSe6
   TzM/MuRBjZ9XfdKcI+0/syGuWjKuBPaNBoW8dymp01Nsx11Gwq8aiEImB
   M/2KOBzcR+c0XgO1ZR2uTq2MrDtlvKX2SoeLTMEVfthg873xrjvMzYeUr
   o7s+fnBZYYE5GF7RR9c2MAAwjHBC3waxYtMopoW+hyO5ewQNcA7Oodq9D
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="237475047"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="237475047"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 04:55:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="692147795"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 21 Mar 2022 04:55:33 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22LBtV4B012712;
        Mon, 21 Mar 2022 11:55:31 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH] ice: use min() to make code cleaner in ice_gnss
Date:   Mon, 21 Mar 2022 12:54:11 +0100
Message-Id: <20220321115412.844440-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <8822dfa2-bdb8-fceb-e920-94afb50881e8@intel.com>
References: <20220318094629.526321-1-wanjiabing@vivo.com> <8822dfa2-bdb8-fceb-e920-94afb50881e8@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>
Date: Fri, 18 Mar 2022 13:19:26 -0700

> On 3/18/2022 2:46 AM, Wan Jiabing wrote:

Hey Wan,

> > Fix the following coccicheck warning:
> > ./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity for min()
> >
> > Use min() to make code cleaner.
> >
> > Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> 
> There are build issues with this patch:
> 
> In file included from ./include/linux/kernel.h:26,
>                  from drivers/net/ethernet/intel/ice/ice.h:9,
>                  from drivers/net/ethernet/intel/ice/ice_gnss.c:4:
> drivers/net/ethernet/intel/ice/ice_gnss.c: In function 'ice_gnss_read':
> ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>    20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>       |                                   ^~
> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>    26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>       |                  ^~~~~~~~~~~
> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>    36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>       |                               ^~~~~~~~~~
> ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
>    45 | #define min(x, y)       __careful_cmp(x, y, <)
>       |                         ^~~~~~~~~~~~~
> drivers/net/ethernet/intel/ice/ice_gnss.c:79:30: note: in expansion of macro 'min'
>    79 |                 bytes_read = min(bytes_left, ICE_MAX_I2C_DATA_SIZE);
>       |                              ^~~

Use `min_t(typeof(bytes_left), ICE_MAX_I2C_DATA_SIZE)` to avoid
this. Plain definitions are usually treated as `unsigned long`
unless there's a suffix (u, ull etc.).

> cc1: all warnings being treated as errors 

Thanks,
Al
