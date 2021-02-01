Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E514730AFCF
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhBASyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:54:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229996AbhBASyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:54:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612205599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQVROIJBZJimrNT5zujh9c6zhxtdo4MhqtcVHix96uQ=;
        b=L/JiauS1+iDr2i3B/Op7PmzED1Qbo1xpOTRfw+xqLT5zeJ5xuax9nRydayr0nvLE118Kq7
        R6/IT3FsgPGQ+aq+pWGHUMOwNRuluyV4Pq7QzZTjYvR4ci9nT0zVnm9FTJC6umtrOTDx4K
        7CaH5jjdMqJqe0GqmJZjQke6ydR7sBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-9Dp9ltqnO4-eI5e3B-1ctA-1; Mon, 01 Feb 2021 13:53:15 -0500
X-MC-Unique: 9Dp9ltqnO4-eI5e3B-1ctA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6AE11107ACE6;
        Mon,  1 Feb 2021 18:53:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.10.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EF56614FC;
        Mon,  1 Feb 2021 18:53:13 +0000 (UTC)
Message-ID: <408a5a3589c2acbe59824a8dbee8cbcd2afefbf4.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net: mhi: Add mbim proto
From:   Dan Williams <dcbw@redhat.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Carl =?UTF-8?Q?Yin=28=E6=AE=B7=E5=BC=A0=E6=88=90=29?= 
        <carl.yin@quectel.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Date:   Mon, 01 Feb 2021 12:53:12 -0600
In-Reply-To: <CAMZdPi_-b9GWrOcj8GBX8jnxyZN9WZ6nr9KPzXPZZKWfyPW3sQ@mail.gmail.com>
References: <1611766877-16787-1-git-send-email-loic.poulain@linaro.org>
         <1611766877-16787-3-git-send-email-loic.poulain@linaro.org>
         <20210129182108.771dc2fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <0bd01c51c592aa24c2dabc8e3afcbdbe9aa23bdc.camel@redhat.com>
         <CAMZdPi_-b9GWrOcj8GBX8jnxyZN9WZ6nr9KPzXPZZKWfyPW3sQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-02-01 at 19:27 +0100, Loic Poulain wrote:
> On Mon, 1 Feb 2021 at 19:17, Dan Williams <dcbw@redhat.com> wrote:
> > On Fri, 2021-01-29 at 18:21 -0800, Jakub Kicinski wrote:
> > > On Wed, 27 Jan 2021 18:01:17 +0100 Loic Poulain wrote:
> > > > MBIM has initially been specified by USB-IF for transporting
> > > > data
> > > > (IP)
> > > > between a modem and a host over USB. However some modern modems
> > > > also
> > > > support MBIM over PCIe (via MHI). In the same way as
> > > > QMAP(rmnet),
> > > > it
> > > > allows to aggregate IP packets and to perform context
> > > > multiplexing.
> > > > 
> > > > This change adds minimal MBIM support to MHI, allowing to
> > > > support
> > > > MBIM
> > > > only modems. MBIM being based on USB NCM, it reuses some
> > > > helpers
> > > > from
> > > > the USB stack, but the cdc-mbim driver is too USB coupled to be
> > > > reused.
> > > > 
> > > > At some point it would be interesting to move on a factorized
> > > > solution,
> > > > having a generic MBIM network lib or dedicated MBIM netlink
> > > > virtual
> > > > interface support.
> > 
> > What would a kernel-side MBIM netlink interface do?  Just data-
> > plane
> > stuff (like channel setup to create new netdevs), or are you
> > thinking
> > about control-plane stuff like APN definition, radio scans, etc?
> 
> Just the data-plane (mbim encoding/decoding/muxing).

Ah yes :) If so, then fully agree.

But is that really specific to MBIM? eg, same kinds of things happen
for QMI. Johannes referred to a more generic WWAN framework that we had
discussed 1.5+ years ago to address these issues. Might be worth
restarting that, perhaps simplifying, and figuring out the minimal set
of generic bits needed to describe/add/delete a data channel for WWAN
control protocols.
Dan

