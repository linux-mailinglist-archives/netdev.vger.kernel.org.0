Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C444E57FB
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244898AbiCWR6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343916AbiCWR55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:57:57 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC216BC11;
        Wed, 23 Mar 2022 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648058187; x=1679594187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UVTweHN61rHkZzXfM5jm3uhIUIF0gAVJSjh3UNXQLgA=;
  b=OpbI+5o/lOXO5v4D58AS3A1G95+IOKmCOUKUOHIhMn54G98NlESI9H85
   FxUPQfbyXWVa9hNFV56tjrtSXC9sJEXQkGsrR1QnBN7ZGAa0jiUHUjyU3
   vn6RiOwh3gDIs1/Q2xddbzpRQgeFLanz8Mmzyk2jwvO4F+2H6XhViF4TS
   5K6Aqv7T9xvnYTeuUvFgApox/Fj6ZNmWzQTSrQWDQHcqshfOd0cSzdZAg
   JG6osqg3l8TXJdSylrHA8I0EzZTmHB4g2ID9gzxWs65SInQhfwo5qlTRG
   SVuECRLt3imJ2r3rGaM5XBbYgVE6gaAxuYjYPeMOPw20afRr8NOkRTkaz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10295"; a="344624096"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="344624096"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 10:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="501100457"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 23 Mar 2022 10:56:24 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22NHuMKm030590;
        Wed, 23 Mar 2022 17:56:22 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] ice: avoid sleeping/scheduling in atomic contexts
Date:   Wed, 23 Mar 2022 18:54:46 +0100
Message-Id: <20220323175446.2777027-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323104005.2a58a57c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220323124353.2762181-1-alexandr.lobakin@intel.com> <20220323104005.2a58a57c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 23 Mar 2022 10:40:05 -0700

> On Wed, 23 Mar 2022 13:43:51 +0100 Alexander Lobakin wrote:
> > --
> > Urgent fix, would like to make it directly through -net.
> 
> You may want to use three hyphens, two hyphens mean footer.
> Email clients gray those out, it's easy to miss :)

Good to know, thanks! :)

Al
