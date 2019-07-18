Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0D86D00F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbfGROn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:43:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390574AbfGROn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 10:43:56 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83C208A004;
        Thu, 18 Jul 2019 14:43:55 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BF4B6056F;
        Thu, 18 Jul 2019 14:43:47 +0000 (UTC)
Date:   Thu, 18 Jul 2019 10:43:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     ? jiang <jiangkidd@hotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>
Subject: Re: [PATCH] virtio-net: parameterize min ring num_free for virtio
 receive
Message-ID: <20190718104307-mutt-send-email-mst@kernel.org>
References: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
 <20190718085836-mutt-send-email-mst@kernel.org>
 <bdd30ef5-4f69-8218-eed0-38c6daac42db@redhat.com>
 <20190718103641-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190718103641-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 18 Jul 2019 14:43:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 10:42:47AM -0400, Michael S. Tsirkin wrote:
> On Thu, Jul 18, 2019 at 10:01:05PM +0800, Jason Wang wrote:
> > 
> > On 2019/7/18 下午9:04, Michael S. Tsirkin wrote:
> > > On Thu, Jul 18, 2019 at 12:55:50PM +0000, ? jiang wrote:
> > > > This change makes ring buffer reclaim threshold num_free configurable
> > > > for better performance, while it's hard coded as 1/2 * queue now.
> > > > According to our test with qemu + dpdk, packet dropping happens when
> > > > the guest is not able to provide free buffer in avail ring timely.
> > > > Smaller value of num_free does decrease the number of packet dropping
> > > > during our test as it makes virtio_net reclaim buffer earlier.
> > > > 
> > > > At least, we should leave the value changeable to user while the
> > > > default value as 1/2 * queue is kept.
> > > > 
> > > > Signed-off-by: jiangkidd<jiangkidd@hotmail.com>
> > > That would be one reason, but I suspect it's not the
> > > true one. If you need more buffer due to jitter
> > > then just increase the queue size. Would be cleaner.
> > > 
> > > 
> > > However are you sure this is the reason for
> > > packet drops? Do you see them dropped by dpdk
> > > due to lack of space in the ring? As opposed to
> > > by guest?
> > > 
> > > 
> > 
> > Besides those, this patch depends on the user to choose a suitable threshold
> > which is not good. You need either a good value with demonstrated numbers or
> > something smarter.
> > 
> > Thanks
> 
> I do however think that we have a problem right now: try_fill_recv can
> take up a long time during which net stack does not run at all. Imagine
> a 1K queue - we are talking 512 packets. That's exceessive.  napi poll
> weight solves a similar problem, so it might make sense to cap this at
> napi_poll_weight.
> 
> Which will allow tweaking it through a module parameter as a
> side effect :) Maybe just do NAPI_POLL_WEIGHT.

Or maybe NAPI_POLL_WEIGHT/2 like we do at half the queue ;). Please
experiment, measure performance and let the list know

> Need to be careful though: queues can also be small and I don't think we
> want to exceed queue size / 2, or maybe queue size - napi_poll_weight.
> Definitely must not exceed the full queue size.
> 
> -- 
> MST
