Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6F502B5D
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354196AbiDON7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244328AbiDON7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 09:59:17 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D565DA73;
        Fri, 15 Apr 2022 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650031009; x=1681567009;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v7unE14WbUKaCZVPi7jLQZ+PksxOmPjhyzrGT7gMB60=;
  b=Pw5T44ZDGTnPLTz36aivPdEFhX/H+D/cvWXuvoRNefRbo8S7NuuLS/D+
   X1ewhA5l4Z+uf+T321WDBuc6Jum8H88hMzlVGEYOBUx19Tx+8+cUWlcMY
   AGYrl8a6m0w3UlR7rJmE9GO0cWQX48QpVhvKJs7JKfvOaLidfkrrHrsQR
   Jy9Nhm9rrqnj4gZtFE9I3gLF64gaNNSMnTAPrDLnxQqpMsuzER3Pf1O35
   chQv02CwxYUBAjXnt3VWIYDF+fNv83b/jydINVThQjJbhR3T62gy6AS/6
   2L0VrBPAyLsSUtQkbiBEA87d+zZkqyRJKEa6Irtn4zDuVFnjnd+C51pi+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="326059413"
X-IronPort-AV: E=Sophos;i="5.90,262,1643702400"; 
   d="scan'208";a="326059413"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 06:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,262,1643702400"; 
   d="scan'208";a="527400057"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 15 Apr 2022 06:56:46 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 23FDui6E023636;
        Fri, 15 Apr 2022 14:56:44 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Fei Liu <feliu@redhat.com>, netdev@vger.kernel.org,
        mschmidt@redhat.com, Brett Creeley <brett@pensando.io>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by cfg_lock in ice_vc_process_vf_msg()
Date:   Fri, 15 Apr 2022 15:53:54 +0200
Message-Id: <20220415135354.478687-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <YlldsfrRJURXpp5d@boxer>
References: <20220413072259.3189386-1-ivecera@redhat.com> <YlldFriBVkKEgbBs@boxer> <YlldsfrRJURXpp5d@boxer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date: Fri, 15 Apr 2022 13:57:37 +0200

> On Fri, Apr 15, 2022 at 01:55:10PM +0200, Maciej Fijalkowski wrote:
> > On Wed, Apr 13, 2022 at 09:22:59AM +0200, Ivan Vecera wrote:
> > > Previous patch labelled "ice: Fix incorrect locking in
> > > ice_vc_process_vf_msg()"  fixed an issue with ignored messages
> > 
> > tiny tiny nit: double space after "
> > Also, has mentioned patch landed onto some tree so that we could provide
> > SHA-1 of it? If not, then maybe squashing this one with the mentioned one
> > would make sense?
> 
> Again, Brett's Intel address is bouncing, so:
> CC: Brett Creeley <brett@pensando.io>

Cc: Jacob Keller <jacob.e.keller@intel.com>

> 
> > 
> > > sent by VF driver but a small race window still left.

--- 8< ---

> > > -- 
> > > 2.35.1

Al
