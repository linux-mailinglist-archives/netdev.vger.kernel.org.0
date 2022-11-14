Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77C96283D3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbiKNP14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235925AbiKNP1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:27:52 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFBA205F4;
        Mon, 14 Nov 2022 07:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668439671; x=1699975671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CeP8y2+ZHtojspOJP0iBEQbFRPuMHMLTBfjgk9VQkng=;
  b=K6+fGhIUQVz3xDRTH80TjGTLM1NWJ95H2YeLYTzr/7pweXzMFEK1i3Yj
   TkLmQfjR/pUzT1zxRxfE0Ohx1t36lzaFe7DpQJ4JrXY41IQpqTLFIPAuf
   p1WenAlRTShqqNO0i+heYEDPNb+dxHK0Du60zRScS3QJi58ShEKnZMCWq
   TlEN5TbyvBS0SuIe/B5XE2IlnrLk3v2MlhxKSCl7oZdWZWZ6chRhonXKO
   0SguueyUbV8tOLjINaf0wL1fbOSlAxXJIrTOexw47JaVKeh3qRm40i0SP
   bm5XJ9UHgcmp7d5B+80jD7QgKTEtcK4FnJeBXNejsIKv6atSdcXBiBIYr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="309625356"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="309625356"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 07:27:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="967608289"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="967608289"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 14 Nov 2022 07:27:48 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEFRlhn028426;
        Mon, 14 Nov 2022 15:27:47 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Wei Fang <wei.fang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/1] net: fec: add xdp and page pool statistics
Date:   Mon, 14 Nov 2022 16:27:36 +0100
Message-Id: <20221114152736.702858-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <PAXPR04MB918591AA3C3A41AE794DB41489059@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221111153505.434398-1-shenwei.wang@nxp.com> <20221114134542.697174-1-alexandr.lobakin@intel.com> <PAXPR04MB918591AA3C3A41AE794DB41489059@PAXPR04MB9185.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shenwei Wang <shenwei.wang@nxp.com>
Date: Mon, 14 Nov 2022 14:53:00 +0000

> > -----Original Message-----
> > From: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Sent: Monday, November 14, 2022 7:46 AM
> > To: Shenwei Wang <shenwei.wang@nxp.com>
> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>; David S. Miller
> > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
> > Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> >> @@ -29,6 +29,7 @@ config FEC
> >>       select CRC32
> >>       select PHYLIB
> >>       select PAGE_POOL
> >> +     select PAGE_POOL_STATS
> >
> > Drivers should never select PAGE_POOL_STATS. This Kconfig option was made to
> > allow user to choose whether he wants stats or better performance on slower
> > systems. It's pure user choice, if something doesn't build or link, it must be
> > guarded with IS_ENABLED(CONFIG_PAGE_POOL_STATS).
> 
> As the PAGE_POOL_STATS is becoming the infrastructure codes for many drivers, it is
> redundant for every driver to implement the stub function in case it is not selected. These
> stub functions should be provided by PAGE_POOL_STATS itself if the option is not selected.

Correct, but I think you added 'select PAGE_POOL_STATS' due to some
build issues on PPC64, or not? So if there are any when
!PAGE_POOL_STATS, it's always better to handle this at the Page Pool
API level in a separate patch.

> 
> >
> >>       imply NET_SELFTESTS
> >>       help
> >>         Say Y here if you want to use the built-in 10/100 Fast

Thanks,
Olek
