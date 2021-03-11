Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B423380EF
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCKWxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:53:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhCKWwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:52:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B375464F88;
        Thu, 11 Mar 2021 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615503152;
        bh=4QgAP0kdRp+SvY/5gfVIOzzcM8Q+PCJdBWaJ2ssOVig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gzFd5WjUEeVa2WCswkfsMUpVVPomdYorr/uhTZmrtvrgkDArbOefq95A2kVkl15zV
         PxZma4wyVTPlWpp39UJJlwEUD6ccGvO++nM6sxs/ZALSDJpeN8NcnCcshqXkC/7/SD
         FPyovlg887Tr443uPWOYN6xoHGhFLhTeBZcyQZsybyzbihDMlcCjLd4pddvY4AWBwr
         pxCcgs9n3omYa5ZCWNzdN6xDypLqgTdd4oJyPfVjVU408oUgcieJPShI/AaECZoIVD
         rJO0tBEI5ib35G3z8pBnx/yJB7CDCJD00DFo96XqQrnh70w/fDNhOSYAlQ0r43v5Lu
         VkM0h6aIF3mtg==
Date:   Thu, 11 Mar 2021 14:52:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking
 whether the netif is running
Message-ID: <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
References: <20210311072311.2969-1-xie.he.0141@gmail.com>
        <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 13:12:25 -0800 Xie He wrote:
> On Thu, Mar 11, 2021 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Is this a theoretical issues or do you see a path where it triggers?
> >
> > Who are the callers sending frames to a device which went down?  
> 
> This is a theoretical issue. I didn't see this issue in practice.
> 
> When "__dev_queue_xmit" and "sch_direct_xmit" call
> "dev_hard_start_xmit", there appears to be no locking mechanism
> preventing the netif from going down while "dev_hard_start_xmit" is
> doing its work.

Normally driver's ndo_stop() calls netif_tx_disable() which takes TX
locks, so unless your driver is lockless (LLTX) there should be no xmit
calls after that point.
