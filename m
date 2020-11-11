Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB1D2AEE9D
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKKKQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:16:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726949AbgKKKQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605089772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7oSJCrXg185sOOaLxsZa44ct5AqFKH6HBr/ZnFW9I0g=;
        b=LorB2kCBfwu+40XbCynvqVs3E3s5IDTG7xNJ8SCuZ4YUgH7j4WqsDdcHWwYT7Z8rzHTc++
        ne+PxGrUZgOC7XfeJ29O/mt4vv4zyq6VUx5eEEAOX7Qh8ZAI5gOP62JboP3pFp1wNxhTeM
        xA9ry+tp5KKfgsCRIe0AJYCiRV5NA4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-l-Qi0otXNY2kZYMGUSOuaQ-1; Wed, 11 Nov 2020 05:16:08 -0500
X-MC-Unique: l-Qi0otXNY2kZYMGUSOuaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1C3710866A9;
        Wed, 11 Nov 2020 10:16:06 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6BE61A340;
        Wed, 11 Nov 2020 10:15:57 +0000 (UTC)
Date:   Wed, 11 Nov 2020 11:15:56 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, kuba@kernel.org, nhorman@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        davem@davemloft.net, sassmann@redhat.com, brouer@redhat.com
Subject: Re: [Intel-wired-lan] [PATCH net v3 3/6] igb: XDP extack message on
 error
Message-ID: <20201111111556.51d17e75@carbon>
In-Reply-To: <20201111093909.wukhqafy3khycks5@SvensMacbookPro.hq.voleatech.com>
References: <20201019080553.24353-1-sven.auhagen@voleatech.de>
        <20201019080553.24353-4-sven.auhagen@voleatech.de>
        <fc1f6aad-b587-25e2-0632-ea43f1032aad@molgen.mpg.de>
        <20201111093909.wukhqafy3khycks5@SvensMacbookPro.hq.voleatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 10:39:09 +0100
Sven Auhagen <sven.auhagen@voleatech.de> wrote:

> On Wed, Nov 11, 2020 at 08:11:46AM +0100, Paul Menzel wrote:
> > Dear Sven,
> > 
> > 
> > Am 19.10.20 um 10:05 schrieb sven.auhagen@voleatech.de:  
> > > From: Sven Auhagen <sven.auhagen@voleatech.de>
> > > 
> > > Add an extack error message when the RX buffer size is too small
> > > for the frame size.
> > > 
> > > Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > > ---
> > >   drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++++-----
> > >   1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> > > index 0a9198037b98..088f9ddb0093 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -2824,20 +2824,22 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
> > >   	}
> > >   }
> > > -static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > > +static int igb_xdp_setup(struct net_device *dev, struct netdev_bpf *bpf)
> > >   {
> > >   	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
> > >   	struct igb_adapter *adapter = netdev_priv(dev);
> > > +	struct bpf_prog *prog = bpf->prog, *old_prog;
> > >   	bool running = netif_running(dev);
> > > -	struct bpf_prog *old_prog;
> > >   	bool need_reset;
> > >   	/* verify igb ring attributes are sufficient for XDP */
> > >   	for (i = 0; i < adapter->num_rx_queues; i++) {
> > >   		struct igb_ring *ring = adapter->rx_ring[i];
> > > -		if (frame_size > igb_rx_bufsz(ring))
> > > +		if (frame_size > igb_rx_bufsz(ring)) {
> > > +			NL_SET_ERR_MSG_MOD(bpf->extack, "The RX buffer size is too small for the frame size");  
> > 
> > Could you please also add both size values to the error message?  
> 
> Dear Paul,
> 
> yes, sure.
> I will send a new series with that change.

I don't think it is possible to send this extra variable info via
extack (but the macro might have improved since last I checked).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

