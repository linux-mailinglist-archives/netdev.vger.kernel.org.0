Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20897607
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHUJZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:25:48 -0400
Received: from mga12.intel.com ([192.55.52.136]:11309 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfHUJZs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:25:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Aug 2019 02:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="183481352"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.145])
  by orsmga006.jf.intel.com with ESMTP; 21 Aug 2019 02:25:44 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i0Ms9-0005I5-DX; Wed, 21 Aug 2019 12:25:41 +0300
Date:   Wed, 21 Aug 2019 12:25:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v1] ocfs2/dlm: Move BITS_TO_BYTES() to bitops.h for wider
 use
Message-ID: <20190821092541.GW30120@smile.fi.intel.com>
References: <20190820163112.50818-1-andriy.shevchenko@linux.intel.com>
 <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a3e6660-10d2-e66c-2880-24af64c7f120@linux.alibaba.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 09:29:04AM +0800, Joseph Qi wrote:
> On 19/8/21 00:31, Andy Shevchenko wrote:
> > There are users already and will be more of BITS_TO_BYTES() macro.
> > Move it to bitops.h for wider use.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h | 1 -
> >  fs/ocfs2/dlm/dlmcommon.h                         | 4 ----
> >  include/linux/bitops.h                           | 1 +
> >  3 files changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > index 066765fbef06..0a59a09ef82f 100644
> > --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h
> > @@ -296,7 +296,6 @@ static inline void bnx2x_dcb_config_qm(struct bnx2x *bp, enum cos_mode mode,
> >   *    possible, the driver should only write the valid vnics into the internal
> >   *    ram according to the appropriate port mode.
> >   */
> > -#define BITS_TO_BYTES(x) ((x)/8)>
> I don't think this is a equivalent replace, or it is in fact
> wrong before?

I was thinking about this one and there are two applications:
- calculus of the amount of structures of certain type per PAGE
  (obviously off-by-one error in the original code IIUC purpose of STRUCT_SIZE)
- calculus of some threshold based on line speed in bytes per second
  (I dunno it will have any difference on the Gbs / 100 MBs speeds)

> >  /* CMNG constants, as derived from system spec calculations */
> >  
> > diff --git a/fs/ocfs2/dlm/dlmcommon.h b/fs/ocfs2/dlm/dlmcommon.h
> > index aaf24548b02a..0463dce65bb2 100644
> > --- a/fs/ocfs2/dlm/dlmcommon.h
> > +++ b/fs/ocfs2/dlm/dlmcommon.h
> > @@ -688,10 +688,6 @@ struct dlm_begin_reco
> >  	__be32 pad2;
> >  };
> >  
> > -
> > -#define BITS_PER_BYTE 8
> > -#define BITS_TO_BYTES(bits) (((bits)+BITS_PER_BYTE-1)/BITS_PER_BYTE)
> > -
> For ocfs2 part, it looks good to me.
> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

Thanks!

> 
> >  struct dlm_query_join_request
> >  {
> >  	u8 node_idx;
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> > index cf074bce3eb3..79d80f5ddf7b 100644
> > --- a/include/linux/bitops.h
> > +++ b/include/linux/bitops.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/bits.h>
> >  
> >  #define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
> > +#define BITS_TO_BYTES(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE)
> >  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
> >  
> >  extern unsigned int __sw_hweight8(unsigned int w);
> > 

-- 
With Best Regards,
Andy Shevchenko


