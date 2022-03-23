Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DDD4E51DC
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbiCWMKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiCWMJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:09:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4FD5FB1;
        Wed, 23 Mar 2022 05:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648037309; x=1679573309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kh1zhhFyD5e+xt5v88i7C1KQ20psD7NhVkn7j6I0Ibg=;
  b=VSa6/4lN+YZv/0e9kHxkhYlyMs4WD1hJ6E7kfkYpbb2fm35rxTRgT8a5
   kjHTHv1XuqSZEado4eatgKrQo49GzLNpN1v7wwnY7VhI+0palFtlN+HfJ
   /jWuykeONY0bcVUq8SgnVH3FymQxPXYfpBJ1uZKabwIRhprliNAXSoWJ0
   AU27MhTrRU1RW7MVqOZg8GaxWIkpVC2Wp6hdTvhKP8QCRhUbi2SZfcgqh
   RqMLDu2uhg2aaB6X5Ij0LyWPVAlKqFbOzFnU5tZF/xgZABkBiNLCc6/oG
   wkQv4o5mkz63PkZamQumn/+dxFB2Eq8D9bYsftsFfBU7a1APZpe3H6p+L
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="344527497"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="344527497"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 05:08:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="544167582"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2022 05:08:24 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22NC8N9O006846;
        Wed, 23 Mar 2022 12:08:23 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Wan Jiabing <wanjiabing@vivo.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        "Paolo Abeni" <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [Intel-wired-lan] Don't do arithmetic on anything smaller than 'int' (was: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss)
Date:   Wed, 23 Mar 2022 13:06:43 +0100
Message-Id: <20220323120643.2759011-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <68ccb162-459b-cb95-19cf-3e0335e4c981@molgen.mpg.de>
References: <20220321135947.378250-1-wanjiabing@vivo.com> <f888e3cf09944f9aa63532c9f59e69fb@AcuMS.aculab.com> <20220322175038.2691665-1-alexandr.lobakin@intel.com> <af3fa59809654c9b9939f1e0bd8ca76b@AcuMS.aculab.com> <20220322112730.482d674d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <68ccb162-459b-cb95-19cf-3e0335e4c981@molgen.mpg.de>
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

From: Paul Menzel <pmenzel@molgen.mpg.de>
Date: Tue, 22 Mar 2022 22:02:06 +0100

> Dear Linux folks,
> 
> 
> Am 22.03.22 um 19:27 schrieb Jakub Kicinski:
> > On Tue, 22 Mar 2022 18:12:08 +0000 David Laight wrote:
> >>>> Oh FFS why is that u16?
> >>>> Don't do arithmetic on anything smaller than 'int'
> >>>
> >>> Any reasoning? I don't say it's good or bad, just want to hear your
> >>> arguments (disasms, perf and object code measurements) etc.
> >>
> >> Look at the object code on anything except x86.
> >> The compiler has to add instruction to mask the value
> >> (which is in a full sized register) down to 16 bits
> >> after every arithmetic operation.
> >
> > Isn't it also slower on some modern x86 CPUs?
> > I could have sworn someone mentioned that in the past.
> 
> I know of Scott's article *Small Integers: Big Penalty* from 2012 [1].

Thank you all guys, makes sense!

Apart from this article, I tested some stuff on MIPS32 yesterday.
Previously I was sure that it's okay to put u16 on stack to conserve
it and there will be no code difference. I remember even having some
bloat-o-meter data. Well, human memory tends to lie sometimes.
I have a bunch of networking stats on stack which I collect during
a NAPI cycle (receiving 64 packets), it's about 20 counters. I made
them as u16 initially as it is (sizeof(u32) - sizeof(u16)) * 20 = 40
bytes. So I converted them yesterday to u32 and instead of having
+40 bytes of .text, I got -36 in one function and even -88 in
another one!
So it really makes no sense to declare anything on stack smaller
than u32 or int unless it is something to be passed to some HW or
standardized structures, e.g. __be16 etc.

Another interesting observation, on x86_64, is that u32 = u64
assignments take more instructions as well. I converted some
structure field recently from u64 to u32, but forgot that I'm
assigning it in one function from an onstack variable, which was
still unconverted from u64 to u32. When I did the latter, the .text
size became smaller.

> 
> 
> Kind regards,
> 
> Paul
> 
> 
> [1]: https://notabs.org/coding/smallIntsBigPenalty.htm

Thanks,
Al
