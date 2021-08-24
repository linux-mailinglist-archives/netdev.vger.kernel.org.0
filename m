Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852A93F58E3
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbhHXHXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:23:53 -0400
Received: from smtp2.axis.com ([195.60.68.18]:61983 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhHXHXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 03:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1629789788;
  x=1661325788;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IfhqP2RM3ChQYnmM5eJg3nw2hVwagJF4PQHhkcCi/ms=;
  b=nggq/7K2RjF8ZdnSHzmY8EwJXpPOOUpfAtrwHcxA8ad3Quc404HEdJ5W
   p0SLFWJMH/tbgPMwhU8xcfYjNLsMycNeJs+4fGDjkvaYcNgTIGsGbY0e5
   Dsb3Oc+cuIwcR/+zMRYgnD+WNnWrl9IpD/n77j5Vqn3Hm3IEogSqMVYNl
   6Je9a3Jm7dNv1fboniHb/ID9HmNVQlYwHNNY6k2fRsk/s673piYryYaP/
   JkcRybSsfft+Ujxv5c+08mfvt+A1yOWlZzsKCgOUvutCSFjyiolNzaejB
   zpiNtQaHzXAaE/SXP1aZF+0NNxa5+OnNaj4DxVqD1R0lV2GQms5n8CTK2
   g==;
Date:   Tue, 24 Aug 2021 09:23:06 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, kernel <kernel@axis.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vhost: add support for mandatory barriers
Message-ID: <20210824072306.GA29073@axis.com>
References: <20210823081437.14274-1-vincent.whitchurch@axis.com>
 <20210823171609-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210823171609-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 11:19:56PM +0200, Michael S. Tsirkin wrote:
> On Mon, Aug 23, 2021 at 10:14:37AM +0200, Vincent Whitchurch wrote:
> > vhost always uses SMP-conditional barriers, but these may not be
> > sufficient when vhost is used to communicate between heterogeneous
> > processors in an AMP configuration, especially since they're NOPs on
> > !SMP builds.
> > 
> > To solve this, use the virtio_*() barrier functions and ask them for
> > non-weak barriers if requested by userspace.
> > 
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
> I am inclined to say let's (ab)use VIRTIO_F_ORDER_PLATFORM for this.
> Jason what do you think?

OK, thanks, I'll look into that.

> Also is the use of DMA variants really the intended thing here? Could
> you point me at some examples please?

I'm using this on an ARM-based SoC.  The main processor is a Cortex-A53
(arm64) and this processor runs the virtio drivers.  The SoC also has
another processor which is a Cortex-A5 (arm32) and this processor runs
the virtio device end using vhost.  There is no coherency between these
two processors and to each other they look like any other DMA-capable
hardware.
