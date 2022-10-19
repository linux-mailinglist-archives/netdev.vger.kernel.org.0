Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8361604BDF
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiJSPm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiJSPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:41:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DC015746F;
        Wed, 19 Oct 2022 08:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666193884; x=1697729884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NZtj2PvHE3lr/k+j1KIDoLkV7QJwuUpV7FlO9PwlBig=;
  b=jlQbTLIvPrpxoZX5erVbKFGXyIAI8n0BaqxlDxbjbvGifVI7WnsynRGg
   zmxDv3YeXlg6xXJG/xSA0JTN9KruyBD61cFuhh2bVadewEFVacvaGYf1w
   C/TxQyqWk6+7Tq5HlQDjkWwBpl1vg2CtfcuKtcytXmOMQ9e+NK0g1ofXI
   pzdsdbyPvYmDjRX7Ee4JO6cm4+jjnUqieR889mCbIu2T1QbOI4Mlmz1cm
   0u6Dg2G9F61Xy40W2mW4+A6qbFPoijvWjh9MZR08LsHegJU91wNBft3ic
   RA+Bwzxe+hz50+ZP8TyYUVsCqgM4zCDNKJBUl+4Bnvn4d7cAFBCrPJ/KO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="392748151"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="392748151"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 08:36:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="958392707"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="958392707"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2022 08:36:49 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 29JFam8v001006;
        Wed, 19 Oct 2022 16:36:48 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 6/6] netlink: add universal 'bigint' attribute type
Date:   Wed, 19 Oct 2022 17:34:52 +0200
Message-Id: <20221019153452.2679589-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018125358.34bc1a32@kernel.org>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com> <20221018140027.48086-7-alexandr.lobakin@intel.com> <20221018125358.34bc1a32@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 18 Oct 2022 12:53:58 -0700

> On Tue, 18 Oct 2022 16:00:27 +0200 Alexander Lobakin wrote:
> > @@ -235,12 +236,15 @@ enum nla_policy_validation {
> >   *                         given type fits, using it verifies minimum length
> >   *                         just like "All other"
> >   *    NLA_BITFIELD32       Unused
> > + *    NLA_BIGINT           Number of bits in the big integer

[...]

> > +		break;
> > +
> 
> Very good stuff, the validation vs type separation is the big question.

Another round of great comments, copied to the TODO. Will dig out
everything and return with v3, for now at least most of those sound
possible and reasonable.

Thanks,
Olek
