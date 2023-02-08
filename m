Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4171468F2D9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjBHQIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBHQIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:08:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BEE2E829;
        Wed,  8 Feb 2023 08:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675872526; x=1707408526;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EcIKwJD+3hFwSJk94Pfa8H+WZsfhuUQLgievc2a55ks=;
  b=SpEAm+tahXVoFJoJvYSfmXTLGNFmfUIjRPznY2LVqe2yAE53PWNbqgc+
   /4YkCaUMzct2WPwH/dN9OL1d2AWK7e4NdIHrTntQe/2YWriz1atCQvD6V
   oPJ/h+fmVgfTqKDMROUJ/Qe1M3LbdGnPkSVYY6EZVu7ELwYqvfFqAjCCE
   TngEvY+X30Q7+HgdmSf6Hu9j2afcaBFAMZJG0fShiIHwgSulmBOjDcpkL
   s0wrexshYJz56ijgVVewk5K8gYePbDcbuKw+8ml5A4xsD2rbB2kHbkVy0
   fNSJdgqPNIEVIRNQaAaVRc2ap6td0NvHuxxQjlB15kMlKIGQgFqGyvk5y
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="331126960"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="331126960"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 08:08:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="667301931"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="667301931"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga002.jf.intel.com with ESMTP; 08 Feb 2023 08:08:36 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pPmzo-004CAx-37;
        Wed, 08 Feb 2023 18:08:32 +0200
Date:   Wed, 8 Feb 2023 18:08:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Cc:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        yury.norov@gmail.com, Jonathan.Cameron@huawei.com,
        baohua@kernel.org, bristot@redhat.com, bsegall@google.com,
        davem@davemloft.net, dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, kuba@kernel.org,
        leonro@nvidia.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@redhat.com,
        netdev@vger.kernel.org, peter@n8pjl.ca, peterz@infradead.org,
        rostedt@goodmis.org, saeedm@nvidia.com, tariqt@nvidia.com,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        ttoukan.linux@gmail.com, vincent.guittot@linaro.org,
        vschneid@redhat.com
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <Y+PJADTk88OTPCx1@smile.fi.intel.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230208153905.109912-1-pawel.chmielewski@intel.com>
 <CAH-L+nO+KyzPSX_F0fh+9i=0rW1hoBPFTGbXc1EX+4MGYOR1kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH-L+nO+KyzPSX_F0fh+9i=0rW1hoBPFTGbXc1EX+4MGYOR1kA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 09:18:14PM +0530, Kalesh Anakkur Purayil wrote:
> On Wed, Feb 8, 2023 at 9:11 PM Pawel Chmielewski <
> pawel.chmielewski@intel.com> wrote:

...

> > +       u16 v_idx, cpu = 0;
> >
> [Kalesh]: if you initialize v_idx to 0 here, you can avoid the assignment
> below

I would avoid doing this.

The problem is that it will become harder to maintain and more error prone
during development.

So, please leave as is.

-- 
With Best Regards,
Andy Shevchenko


