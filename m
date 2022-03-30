Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9881B4EC432
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344849AbiC3Mgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345037AbiC3Mfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:35:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1164A8303A;
        Wed, 30 Mar 2022 05:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648642894; x=1680178894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OXzBCDD0s+U+ac+j1S8pe7nAWp2yh4vu1aPuuDcA/hE=;
  b=WNS5Q/+VIXRt1P9pE7NMIqhuqdvP3iS3x0bL6PMQ1XqeRfmb3giQcN+k
   xFUK0wOMnL2yb2v9CwQHw48Zl8Bp9RmfB0PNinRYHTliSC9ijg6zM1592
   nyWUaiSGcFUSZJ7pW/t2j+9pQa3TrctD30meQ7N+QsCVDTFkNJ412/WC4
   6HmKxl5OJjpB8Jx9y5GlSo5NCmsAZlfWE3uV7KlIhyxzSbC3Tl/mJ41QS
   XIKsYd8m+KVm/bp4b4e6TLRwlrd5ipZ6CGD4ovmeumcJBwE2tUm/+xWH3
   rsOxuyWSiSLxoW9wDyyUFNsxSNUPtmOGa1xzBe+oGDTmnFpaABD9zmXyF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="345965530"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="345965530"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 05:21:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="837252293"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 30 Mar 2022 05:21:15 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22UCLE8c019312;
        Wed, 30 Mar 2022 13:21:14 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] ice: Fix MAC address setting
Date:   Wed, 30 Mar 2022 14:18:35 +0200
Message-Id: <20220330121835.2737360-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CO1PR11MB508954503C974FD6D9E162FCD61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220325132524.1765342-1-ivecera@redhat.com> <CO1PR11MB508954503C974FD6D9E162FCD61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Mon, 28 Mar 2022 17:53:19 +0000

Hey netdev maintainers,

> > -----Original Message-----
> > From: Ivan Vecera <ivecera@redhat.com>
> > Sent: Friday, March 25, 2022 6:25 AM
> > To: netdev@vger.kernel.org
> > Cc: poros <poros@redhat.com>; mschmidt <mschmidt@redhat.com>;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jakub
> > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; moderated
> > list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; open list <linux-
> > kernel@vger.kernel.org>
> > Subject: [PATCH net v2] ice: Fix MAC address setting
> > 
> > Commit 2ccc1c1ccc671b ("ice: Remove excess error variables") merged
> > the usage of 'status' and 'err' variables into single one in
> > function ice_set_mac_address(). Unfortunately this causes
> > a regression when call of ice_fltr_add_mac() returns -EEXIST because
> > this return value does not indicate an error in this case but
> > value of 'err' remains to be -EEXIST till the end of the function
> > and is returned to caller.
> > 
> > Prior mentioned commit this does not happen because return value of
> > ice_fltr_add_mac() was stored to 'status' variable first and
> > if it was -EEXIST then 'err' remains to be zero.
> > 
> > Fix the problem by reset 'err' to zero when ice_fltr_add_mac()
> > returns -EEXIST.
> > 
> > Fixes: 2ccc1c1ccc671b ("ice: Remove excess error variables")
> > Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> > ---
> 
> Thanks for the v2. This looks great. Good analysis of how this happened in the commit message, I appreciate that.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

This is an urgent fix, so we would like it to go through -net, not
IWL.
It has this Reviewed-by, and also

Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>

> 
> >  drivers/net/ethernet/intel/ice/ice_main.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 

--- 8< ---

> > --
> > 2.34.1

Thanks,
Al
