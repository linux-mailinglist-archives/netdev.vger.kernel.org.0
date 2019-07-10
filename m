Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48864EC7
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 00:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfGJWr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 18:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfGJWr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 18:47:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92A10C0586D8;
        Wed, 10 Jul 2019 22:47:27 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-116-215.ams2.redhat.com [10.36.116.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFFA560C05;
        Wed, 10 Jul 2019 22:47:26 +0000 (UTC)
Date:   Thu, 11 Jul 2019 00:47:24 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>
Subject: Re: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
Message-ID: <20190710224724.GA28254@bistromath.localdomain>
References: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
 <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 10 Jul 2019 22:47:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-07-10, 16:07:43 +0100, Edward Cree wrote:
> On 10/07/2019 14:52, Sabrina Dubroca wrote:
> > -static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> > +static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> >  				    struct packet_type **ppt_prev)
> >  {
> >  	struct packet_type *ptype, *pt_prev;
> >  	rx_handler_func_t *rx_handler;
> > +	struct sk_buff *skb = *pskb;
> Would it not be simpler just to change all users of skb to *pskb?
> Then you avoid having to keep doing "*pskb = skb;" whenever skb changes
>  (with concomitant risk of bugs if one gets missed).

Yes, that would be less risky. I wrote a version of the patch that did
exactly that, but found it really too ugly (both the patch and the
resulting code). We have more than 50 occurences of skb, including
things like:

    atomic_long_inc(&skb->dev->rx_dropped);

-- 
Sabrina
