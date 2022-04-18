Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3B7505FB1
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiDRWWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 18:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiDRWWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 18:22:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C9E29CBD;
        Mon, 18 Apr 2022 15:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650320383; x=1681856383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=tkMPhmpg8zUnNqBW3w1L4glAPuX9BfNfJ6dlQLQ2H9M=;
  b=STRyR/RdituV4m0VH/4ByF0w18ggDOcX57/KFCPcru1ARi7Fh/sqyudM
   7MJPMwIpxVU/XHICxZlDKjQpPnBwFsg95Nq5vwvVV/BPAGQb1Odjkrmed
   8/f7oTNr/QLYs4WYzPXl6JXqlfLwOHd43MtlK28+Z4ZEfBn/FnPbB8Qr/
   vveGeI5dUZA8WQGrNY/YkPTXfhEnYcvZPDpN96qlCVkh4rzb1MV5URxtH
   IzeFAB2mRQHsMMKnru3ER+rWXdeZtZ7mB18sBc9xO54sEIHklhwqBhGqL
   byfwlwwF+sJMM+Z59J+wA2YtVhB47FAu0KSx+YZKWhR0MDfiYESTfDem4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="245514082"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="245514082"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 15:19:43 -0700
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="726810261"
Received: from moseshab-mobl1.amr.corp.intel.com (HELO localhost) ([10.209.143.127])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 15:19:42 -0700
Date:   Mon, 18 Apr 2022 15:19:41 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     Julia Lawall <julia.lawall@inria.fr>, outreachy@lists.linux.dev,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] intel: igb: igb_ethtool.c: Convert kmap() to
 kmap_local_page()
Message-ID: <Yl3j/bOvoX13WGSW@iweiny-desk3>
References: <20220416111457.5868-1-eng.alaamohamedsoliman.am@gmail.com>
 <alpine.DEB.2.22.394.2204161331080.3501@hadrien>
 <df4c0f81-454d-ab96-1d74-1c4fbc3dbd63@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df4c0f81-454d-ab96-1d74-1c4fbc3dbd63@gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 16, 2022 at 03:14:57PM +0200, Alaa Mohamed wrote:
>    On ١٦‏/٤‏/٢٠٢٢ ١٣:٣١, Julia Lawall wrote:
> 
> 
>  On Sat, 16 Apr 2022, Alaa Mohamed wrote:
> 
> 
>  Convert kmap() to kmap_local_page()
> 
>  With kmap_local_page(), the mapping is per thread, CPU local and not
>  globally visible.
> 
>  It's not clearer. 
> 
>    I mean this " fix kunmap_local path value to take address of the mapped
>    page" be more clearer
> 
>  This is a general statement about the function.  You
>  need to explain why it is appropriate to use it here.  Unless it is the
>  case that all calls to kmap should be converted to call kmap_local_page.
> 
>    It's required to convert all calls kmap to kmap_local_page. So, I don't
>    what should the commit message be?
> 
>    Is this will be good :
> 
>    "kmap_local_page() was recently developed as a replacement for kmap(). 
>    The
>    kmap_local_page() creates a mapping which is restricted to local use by a
>    single thread of execution. "
> 

I think I am missing some thread context here.  I'm not sure who said what
above.  So I'm going to start over.

Alaa,

It is important to remember that a good commit message says 2 things.

	1) What is the problem you are trying to solve
	2) Overview of the solution

First off I understand your frustration.  In my opinion fixes and clean ups
like this are very hard to write good commit messages for because so often the
code diff seems so self explanatory.  However, each code change comes at the
identification of a problem.  And remember that 'problem' does not always mean
a bug fix.

The deprecation of kmap() may not seem like a problem.  I mean why can't we
just leave kmap() as it is?  It works right?

But the problem is that the kmap (highmem) interface has become stale and its
original purpose was targeted toward large memory systems with 32 bit kernels.
There are very few systems being run like that any longer.

So how do we clean up the kmap interface to be more useful to the kernel
community now that 32 bit kernels with highmem are so rare?

The community has identified that a first step of that is to move away from and
eventually remove the kmap() call.  This is due to the call being incorrectly
used to create long term mappings.  Most calls to kmap() are not used
incorrectly but those call sites needed something in between kmap() and
kmap_atmoic().  That call is kmap_local_page().

Now that kmap_local_page() exists the kmap() calls can be audited and most (I
hope most)[1] can be replaced with kmap_local_page().

The change you have below is correct.  But it lacks a good commit message.  We
need to cover the 2 points above.

	1) Julia is asking why you needed to do this change.  What is the
	   problem or reason for this change?  (Ira told you to is not a good
	   reason.  ;-)

	   PS In fact me telling you to may actually be a very bad reason...
	   j/k ;-)

	2) Why is this solution ok as part of the deprecation and removal of
	   kmap()?

A final note; the 2 above points don't need a lot of text.  Here I used
2 simple sentences.

https://lore.kernel.org/lkml/20220124015409.807587-2-ira.weiny@intel.com/

I hope this helps,
Ira

[1] But not all...  some uses of kmap() have been identified as being pretty
complex.

> 
>  julia
> 
> 
>  Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>  ---
>  changes in V2:
>          fix kunmap_local path value to take address of the mapped page.
>  ---
>  changes in V3:
>          edit commit message to be clearer
>  ---
>   drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
>  diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>  index 2a5782063f4c..c14fc871dd41 100644
>  --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
>  +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>  @@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
> 
>          frame_size >>= 1;
> 
>  -       data = kmap(rx_buffer->page);
>  +       data = kmap_local_page(rx_buffer->page);
> 
>          if (data[3] != 0xFF ||
>              data[frame_size + 10] != 0xBE ||
>              data[frame_size + 12] != 0xAF)
>                  match = false;
> 
>  -       kunmap(rx_buffer->page);
>  +       kunmap_local(data);
> 
>          return match;
>   }
>  --
>  2.35.2
