Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D89503FF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 09:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfFXHwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 03:52:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:34514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbfFXHwd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 03:52:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6B0BAEEE;
        Mon, 24 Jun 2019 07:52:31 +0000 (UTC)
Date:   Mon, 24 Jun 2019 16:52:26 +0900
From:   Benjamin Poirier <bpoirier@suse.com>
To:     David Miller <davem@davemloft.net>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/16] qlge: Factor out duplicated expression
Message-ID: <20190624075225.GA27959@f1>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-10-bpoirier@suse.com>
 <20190623.105935.2293591576103857913.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623.105935.2293591576103857913.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/06/23 10:59, David Miller wrote:
> From: Benjamin Poirier <bpoirier@suse.com>
> Date: Mon, 17 Jun 2019 16:48:52 +0900
> 
> > Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> > ---
> >  drivers/net/ethernet/qlogic/qlge/qlge.h      |  6 ++++++
> >  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 18 ++++++------------
> >  2 files changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h b/drivers/net/ethernet/qlogic/qlge/qlge.h
> > index 5a4b2520cd2a..0bb7ccdca6a7 100644
> > --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> > +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> > @@ -77,6 +77,12 @@
> >  #define LSD(x)  ((u32)((u64)(x)))
> >  #define MSD(x)  ((u32)((((u64)(x)) >> 32)))
> >  
> > +#define QLGE_FIT16(value) \
> > +({ \
> > +	typeof(value) _value = value; \
> > +	(_value) == 65536 ? 0 : (u16)(_value); \
> > +})
> > +
> 
> "(u16) 65536" is zero and the range of these values is 0 -- 65536.
> 
> This whole expression is way overdone.

Indeed, I missed that a simple cast is enough :/

What I inferred from the presence of that expression though is that in
the places where it is used, the device interprets a value of 0 as
65536. Manish, can you confirm that? As David points out, the expression
is useless. A comment might not be however.
