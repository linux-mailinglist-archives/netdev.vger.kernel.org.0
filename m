Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1B4E9A1C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiC1OxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244073AbiC1Owy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:52:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F033F8A7;
        Mon, 28 Mar 2022 07:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648479074; x=1680015074;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NfAB6q1sKLnFh0vuC4wfIlbov6wWZwy/ABr3cKE3ZmM=;
  b=nuwR580k3tp9Cz5z8DhEcKfJ1IFx7SbzRUvfXSgkpqgAajWc+GIzxna8
   9rnQ9MugTX0oqliNNo2FA9ulWejHtUl+lKLpkKVBMhnHsn+QWprhHVFQG
   NgvnQlcOGPjn7irxhjTdblDwzKPqT8QAgSCVOR+BwOB3fat86UVyNVzEQ
   NTcJ1jfwVBaMN1GtJtCxc5lxtr9jIOK/QRlHOJwwHgdKp0nljxgRp0+dr
   W4GKQkTL1GIUafCSGeIC/1LZgELh2h9pcwMTOKuVVZ/KbSZhqoSs9J6Po
   qgsO71f0r/Z/6By1D1nwczvGQQysjHROO+PLKHy94yIKgPBxNnkcxk/bq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="241169976"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="241169976"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:51:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="518163954"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Mar 2022 07:51:11 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22SEpAP5014114;
        Mon, 28 Mar 2022 15:51:10 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org
Subject: Re: [PATCH bpf 0/4] xsk: another round of fixes
Date:   Mon, 28 Mar 2022 16:48:44 +0200
Message-Id: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Mon, 28 Mar 2022 16:21:19 +0200

> Hello,
> 
> yet another fixes for XSK from Magnus and me.
> 
> Magnus addresses the fact that xp_alloc() can return NULL, so this needs
> to be handled to avoid clearing entries in the SW ring on driver side.
> Then he addresses the off-by-one problem in Tx desc cleaning routine for
> ice ZC driver.
> 
> From my side, I am adding protection to ZC Rx processing loop so that
> cleaning of descriptors wouldn't go over already processed entries.
> Then I also fix an issue with assigning XSK pool to Tx queues.

Nice, thanks!
For the series:

Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> 
> This is directed to bpf tree.
> 
> Thanks!
> 
> Maciej Fijalkowski (2):
>   ice: xsk: stop Rx processing when ntc catches ntu
>   ice: xsk: fix indexing in ice_tx_xsk_pool()
> 
> Magnus Karlsson (2):
>   xsk: do not write NULL in SW ring at allocation failure
>   ice: xsk: eliminate unnecessary loop iteration
> 
>  drivers/net/ethernet/intel/ice/ice.h     | 2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
>  net/xdp/xsk_buff_pool.c                  | 8 ++++++--
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> -- 
> 2.27.0

Thanks,
Al
