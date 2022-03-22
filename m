Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B014E458E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 18:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbiCVRzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 13:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbiCVRzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 13:55:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA5BBE30;
        Tue, 22 Mar 2022 10:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647971617; x=1679507617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GOSyCMT3Bo8pMPfvKQ6OUb28JkU8aRwvgc6c1E/p/HM=;
  b=B+kfcUm0RBWon1+HvTZuAamntyPWOB6ublxkKUZjpHfGJHvukY1g9EBF
   EMnIuNeQjMt/Nyets3Mw1czzTe0qbi/Wtr0EgiBQ1tYmk1nwuNC4Y/4mC
   ATptsjFDWml1ABeU/xKh62bayEPEK/8sSGLXFeIgb9TvBCLLxzLZj7732
   sqi5D9YWulrKU+4umpigMu5QfTJWZGz1gPsn3CGeyx6c6b/Smasp712Gv
   IRYqjgQT8EokoXjZDwoyiei/Y80CdYJDsW1cVoG+fZJedSboMwhvTCqE1
   kHG9Zd/aU8uqg7o+UUo0UKX5yK8fMM6nxgUUUlkAuonBP3hxTVl6vA28i
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="245374809"
X-IronPort-AV: E=Sophos;i="5.90,202,1643702400"; 
   d="scan'208";a="245374809"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2022 10:52:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,202,1643702400"; 
   d="scan'208";a="692645180"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2022 10:51:58 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22MHpvJb002184;
        Tue, 22 Mar 2022 17:51:57 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "'Wan Jiabing'" <wanjiabing@vivo.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Date:   Tue, 22 Mar 2022 18:50:38 +0100
Message-Id: <20220322175038.2691665-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com>
References: <20220321135947.378250-1-wanjiabing@vivo.com> <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Mon, 21 Mar 2022 16:02:20 +0000

> From: Wan Jiabing
> > Sent: 21 March 2022 14:00
> >
> > Fix the following coccicheck warning:
> > ./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity for min()
> >
> > Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> > ---
> > Changelog:
> > v2:
> > - Use typeof(bytes_left) instead of u8.
> > ---
> >  drivers/net/ethernet/intel/ice/ice_gnss.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
> > index 35579cf4283f..57586a2e6dec 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_gnss.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
> > @@ -76,8 +76,7 @@ static void ice_gnss_read(struct kthread_work *work)
> >  	for (i = 0; i < data_len; i += bytes_read) {
> >  		u16 bytes_left = data_len - i;
> 
> Oh FFS why is that u16?
> Don't do arithmetic on anything smaller than 'int'

Any reasoning? I don't say it's good or bad, just want to hear your
arguments (disasms, perf and object code measurements) etc.

> 
> 	David
> 
> >
> > -		bytes_read = bytes_left < ICE_MAX_I2C_DATA_SIZE ? bytes_left :
> > -					  ICE_MAX_I2C_DATA_SIZE;
> > +		bytes_read = min_t(typeof(bytes_left), bytes_left, ICE_MAX_I2C_DATA_SIZE);
> >
> >  		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
> >  				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
> > --
> > 2.35.1
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

Thanks,
Al
