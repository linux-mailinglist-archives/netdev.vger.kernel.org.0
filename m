Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322801F2150
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgFHVJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:09:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:4792 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgFHVJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 17:09:08 -0400
IronPort-SDR: pigDRql+fRd4Ju4Ts1fHZYMlOjqX2kTALj9tB0Vv3lW+s6Pp+dzF1gU3t2k18bsOjvKAUOi6+4
 uV1HK8LWkp+A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 14:09:06 -0700
IronPort-SDR: frmd7NyexTaQPNjw1Wq1AJSAV6dMLQE7KIOqLtiiSTgWfM1QMpgYdkgCZm7nHZaMI3r22Vvpob
 O5elf8Oxn2/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400"; 
   d="scan'208";a="288603314"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2020 14:09:06 -0700
Date:   Mon, 8 Jun 2020 14:09:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] virtio_net: Unregister and re-register xdp_rxq across
 freeze/restore
Message-ID: <20200608210906.GG8223@linux.intel.com>
References: <20200605214624.21430-1-sean.j.christopherson@intel.com>
 <20200607091542-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607091542-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 07, 2020 at 09:23:03AM -0400, Michael S. Tsirkin wrote:
> On Fri, Jun 05, 2020 at 02:46:24PM -0700, Sean Christopherson wrote:
> > @@ -1480,17 +1495,10 @@ static int virtnet_open(struct net_device *dev)
> >  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> >  				schedule_delayed_work(&vi->refill, 0);
> >  
> > -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i);
> > +		err = virtnet_reg_xdp(&vi->rq[i].xdp_rxq, dev, i);
> >  		if (err < 0)
> >  			return err;
> >  
> > -		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> > -						 MEM_TYPE_PAGE_SHARED, NULL);
> > -		if (err < 0) {
> > -			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> > -			return err;
> > -		}
> > -
> >  		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> >  		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
> >  	}
> > @@ -2306,6 +2314,7 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> >  
> >  	if (netif_running(vi->dev)) {
> >  		for (i = 0; i < vi->max_queue_pairs; i++) {
> > +			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> >  			napi_disable(&vi->rq[i].napi);
> >  			virtnet_napi_tx_disable(&vi->sq[i].napi);
> 
> I suspect the right thing to do is to first disable all NAPI,
> then play with XDP. Generally cleanup in the reverse order
> of init is a good idea.

Hmm, I was simply following virtnet_close().  Actually, the entire loop
could be factored out into a separate helper.  Perhaps do that as part of
the fix, and then invert the ordering in a separate patch?

> >  		}
> > @@ -2313,6 +2322,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
> >  }
> >  
> >  static int init_vqs(struct virtnet_info *vi);
> > +static void virtnet_del_vqs(struct virtnet_info *vi);
> > +static void free_receive_page_frags(struct virtnet_info *vi);
> 
> I'd really rather we reordered code so forward decls are not necessary.

Yeah, no argument from me.  Would you prefer the reordering in a separate
patch on top, e.g. to simplify potential backporting?

> >  static int virtnet_restore_up(struct virtio_device *vdev)
> >  {
> > @@ -2331,6 +2342,10 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> >  				schedule_delayed_work(&vi->refill, 0);
> >  
> >  		for (i = 0; i < vi->max_queue_pairs; i++) {
> > +			err = virtnet_reg_xdp(&vi->rq[i].xdp_rxq, vi->dev, i);
> > +			if (err)
> > +				goto free_vqs;
> > +
> >  			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> >  			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
> >  					       &vi->sq[i].napi);
> > @@ -2340,6 +2355,12 @@ static int virtnet_restore_up(struct virtio_device *vdev)
> >  	netif_tx_lock_bh(vi->dev);
> >  	netif_device_attach(vi->dev);
> >  	netif_tx_unlock_bh(vi->dev);
> > +	return 0;
> > +
> > +free_vqs:
> > +	cancel_delayed_work_sync(&vi->refill);
> > +	free_receive_page_frags(vi);
> > +	virtnet_del_vqs(vi);
> 
> 
> I am not sure this is safe to do after device-ready.
> 
> Can reg xdp happen before device ready?

From a code perspective, I don't see anything that will explode, but I have
no idea if that's correct/sane behavior.

FWIW, the xdp error handling in virtnet_open() also looks bizarre to me,
e.g. bails in the middle of a loop without doing any cleanup.  I assume
virtnet_close() wouldn't called if open failed?  But I can't determine
whether or not that holds true based on code inspection, there are too many
call sites that lead to open and close.
