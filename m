Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F278551824
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 14:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241846AbiFTMDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 08:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242147AbiFTMCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 08:02:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDD318B01;
        Mon, 20 Jun 2022 05:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655726564; x=1687262564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8PAiqpimhJJzwDMe9fbD8XaA/eNCpQcNAwUwKc/oOn8=;
  b=DCuKUJI3lQCh1D9P4+RP2hNouR0H93e0x9dQEbREKsjV6sCGr4dkaB8Q
   xLBVV8sx9mUUzJE9pSUFz7WynCKj1UNHP0ueokbCmUJ+Np3IT0Zsfwq+w
   QaYNT5ajk83ON5G7FgIuGIUmtGDt2/QDe/pwjmVb2ngvDjHACqqyG69QN
   5EPk5HBSBhQoS3dLkXKKKr3hhc+NuWSnJAxCeSYRhVVyCShw+JXiBwtcL
   XWfCcbJe0KLI4vTTMQhsYXoQc7la0D1+ZJsCxK/zDf+H1l45ew8epSupB
   MiQ9sPoURVM0nmQJIVSaaU+1BhVbGhaZDPfcf66g1/M+Xt37GtkQfOlV+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="366202090"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="366202090"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 05:02:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="676511099"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Jun 2022 05:02:41 -0700
Date:   Mon, 20 Jun 2022 14:02:40 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org
Subject: Re: [PATCH v4 bpf-next 09/10] selftests: xsk: rely on pkts_in_flight
 in wait_for_tx_completion()
Message-ID: <YrBh4PsLY1GID3Uj@boxer>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-10-maciej.fijalkowski@intel.com>
 <62ad3ed172224_24b342084d@john.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ad3ed172224_24b342084d@john.notmuch>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 07:56:17PM -0700, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > Some of the drivers that implement support for AF_XDP Zero Copy (like
> > ice) can have lazy approach for cleaning Tx descriptors. For ZC, when
> > descriptor is cleaned, it is placed onto AF_XDP completion queue. This
> > means that current implementation of wait_for_tx_completion() in
> > xdpxceiver can get onto infinite loop, as some of the descriptors can
> > never reach CQ.
> > 
> > This function can be changed to rely on pkts_in_flight instead.
> > 
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> 
> Sorry I'm going to need more details to follow whats going on here.
> 
> In send_pkts() we do the expected thing and send all the pkts and
> then call wait_for_tx_completion().
> 
> Wait for completion is obvious,
> 
>  static void wait_for_tx_completion(struct xsk_socket_info *xsk)               
>  {                                                   
>         while (xsk->outstanding_tx)                                                      
>                 complete_pkts(xsk, BATCH_SIZE);
>  }  
> 
> the 'outstanding_tx' counter appears to be decremented in complete_pkts().
> This is done by looking at xdk_ring_cons__peek() makes sense to me until
> it shows up here we don't know the pkt has been completely sent and
> can release the resources.

This is necessary for scenarios like l2fwd in xdpsock where you would be
taking entries from cq back to fq to refill the rx hw queue and keep going
with the flow.

> 
> Now if you just zero it on exit and call it good how do you know the
> resources are safe to clean up? Or that you don't have a real bug
> in the driver that isn't correctly releasing the resource.

xdpxceiver spawns two threads one for tx and one for rx. from rx thread
POV if receive_pkts() ended its job then this implies that tx thread
transmitted all of the frames that rx thread expected to receive. this
zeroing is then only to terminate the tx thread and finish the current
test case so that further cases under the current mode can be executed.

> 
> How are users expected to use a lazy approach to tx descriptor cleaning
> in this case e.g. on exit like in this case. It seems we need to
> fix the root cause of ice not putting things on the completion queue
> or I misunderstood the patch.

ice puts things on cq lazily on purpose as we added batching to Tx side
where we clean descs only when it's needed.

We need to exit spawned threads before we detach socket from interface.
Socket detach is done from main thread and in that case driver goes
through tx ring and places descriptors that are left to completion queue.

> 
> 
> >  tools/testing/selftests/bpf/xdpxceiver.c | 3 ++-
> >  tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> > index de4cf0432243..13a3b2ac2399 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -965,7 +965,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
> >  
> >  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
> >  {
> > -	while (xsk->outstanding_tx)
> > +	while (pkts_in_flight)
> >  		complete_pkts(xsk, BATCH_SIZE);
> >  }
> >  
> > @@ -1269,6 +1269,7 @@ static void *worker_testapp_validate_rx(void *arg)
> >  		pthread_mutex_unlock(&pacing_mutex);
> >  	}
> >  
> > +	pkts_in_flight = 0;
> >  	pthread_exit(NULL);
> >  }
