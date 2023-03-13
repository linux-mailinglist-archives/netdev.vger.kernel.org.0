Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5C6B79E3
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCMOIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCMOIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:08:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2540A18AA0;
        Mon, 13 Mar 2023 07:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678716488; x=1710252488;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+9a6Q4ROlaZhxAPlgTuY3rn4U+rycgts0stX1J/hbAI=;
  b=XrbjRFPlblnJ5eqYGFvVB/StBiW0+mVi6JZ97x4QXf9L6kWAPXdT6f7x
   MnU26VuNaZbwiUSoBZdaSQWOiad7jXJwCKvDcoskE6NYaWWow3zo8D3Ei
   2H/F3cf7HxDlqX25e0gMTnVFI5IUUYrxFr3cLEXiYyBCqoC2DjZf9F2cU
   8e7M/8ErozvqAGlKWhQZv2cmSc8VurXg/L86acSqmHMrX4UAhNCr3waar
   gjefN2emN/1rQgeNJXM469NhvI7I2uz+Mf3lzK0nquvmTT1mtx5MdXjEG
   xYkA5cF/kYXN2/u9A8kK7fsvI0JSznvbWyNFyc5yGMVo6+uaLjfh/rde7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="335852311"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="335852311"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:08:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="655982281"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="655982281"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 07:08:01 -0700
Date:   Mon, 13 Mar 2023 15:07:52 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due to race condition
Message-ID: <ZA8uMtMyYKhcEYQ/@localhost.localdomain>
References: <20230313090002.3308025-1-zyytlz.wz@163.com>
 <ZA8rDCw+mJmyETEx@localhost.localdomain>
 <CAJedcCwgvo3meC=k_nPYrRzEj7Hzcy8kqrvHqHLvmPWLjCq_3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJedcCwgvo3meC=k_nPYrRzEj7Hzcy8kqrvHqHLvmPWLjCq_3Q@mail.gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:01:21PM +0800, Zheng Hacker wrote:
> Michal Swiatkowski <michal.swiatkowski@linux.intel.com> 于2023年3月13日周一 21:54写道：
> >
> > On Mon, Mar 13, 2023 at 05:00:02PM +0800, Zheng Wang wrote:
> > > In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
> > > to init priv->rings and bound &ring->work with p9_xen_response.
> > >
> > > When it calls xen_9pfs_front_event_handler to handle IRQ requests,
> > > it will finally call schedule_work to start the work.
> > >
> > > When we call xen_9pfs_front_remove to remove the driver, there
> > > may be a sequence as follows:
> > >
> > > Fix it by finishing the work before cleanup in xen_9pfs_front_free.
> > >
> > > Note that, this bug is found by static analysis, which might be
> > > false positive.
> > >
> > > CPU0                  CPU1
> > >
> > >                      |p9_xen_response
> > > xen_9pfs_front_remove|
> > >   xen_9pfs_front_free|
> > > kfree(priv)          |
> > > //free priv          |
> > >                      |p9_tag_lookup
> > >                      |//use priv->client
> > >
> > > Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
> > > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > > ---
> > > v2:
> > > - fix type error of ring found by kernel test robot
> > > ---
> > >  net/9p/trans_xen.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> > > index c64050e839ac..83764431c066 100644
> > > --- a/net/9p/trans_xen.c
> > > +++ b/net/9p/trans_xen.c
> > > @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_front_ids[] = {
> > >  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
> > >  {
> > >       int i, j;
> > > +     struct xen_9pfs_dataring *ring = NULL;
> > Move it before int i, j to have RCT.
> >
Sorry I didn't notice it before, move the definition to for loop.

> > >
> > >       write_lock(&xen_9pfs_lock);
> > >       list_del(&priv->list);
> > >       write_unlock(&xen_9pfs_lock);
> > >
> > >       for (i = 0; i < priv->num_rings; i++) {
Here:
struct xen_9pfs_dataring *ring = &priv->rings[i];

> > > +             /*cancel work*/
> > It isn't needed I think, the function cancel_work_sync() tells everything
> > here.
> >
> 
> Get it, will remove it in the next version of patch.
> 
> Best regards,
> Zheng
