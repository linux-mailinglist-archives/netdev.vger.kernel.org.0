Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D4020FE78
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgF3VG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:06:28 -0400
Received: from smtp6.emailarray.com ([65.39.216.46]:59971 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgF3VG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:06:28 -0400
Received: (qmail 16693 invoked by uid 89); 30 Jun 2020 21:06:26 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 30 Jun 2020 21:06:26 -0000
Date:   Tue, 30 Jun 2020 14:06:25 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH 07/11] net: Introduce global queues
Message-ID: <20200630210625.ytur4nwzrekhazvi@bsd-mbp.dhcp.thefacebook.com>
References: <20200624171749.11927-1-tom@herbertland.com>
 <20200624171749.11927-8-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624171749.11927-8-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 10:17:46AM -0700, Tom Herbert wrote:
> Global queues, or gqids, are an abstract representation of NIC
> device queues. They are global in the sense that the each gqid
> can be map to a queue in each device, i.e. if there are multiple
> devices in the system, a gqid can map to a different queue, a dqid,
> in each device in a one to many mapping.  gqids are used for
> configuring packet steering on both send and receive in a generic
> way not bound to a particular device.
> 
> Each transmit or receive device queue may be reversed mapped to
> one gqid. Each device maintains a table mapping gqids to local
> device queues, those tables are used in the data path to convert
> a gqid receive or transmit queue into a device queue relative to
> the sending or receiving device.

I'm confused by this word salad, can it be simplified?

So a RX device queue maps to one global queue, implying that there's a
one way relationship here.  But at the same time, the second sentence
implies each device can map a global RX queue to a device queue.

This would logically mean that for a given device, there's a 1:1
relationship between global and device queue, and the only 'one-to-many'
portion is coming from mapping global queues across different devices.

How would I do this:
    given device eth0
    create new RSS context 200
    create RX queues 800, 801, added to RSS context 200
    create global RX queue for context 200 
    attach 4 sockets to context 200

I'm assuming that each socket ends up being flow-assigned to one of the
underlying device queues (800 or 801), correct?
-- 
Jonathan
