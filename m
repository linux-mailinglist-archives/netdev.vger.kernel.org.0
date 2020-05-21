Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974081DD6CB
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgEUTL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgEUTL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 15:11:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D974720738;
        Thu, 21 May 2020 19:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590088318;
        bh=BOaCzvsugTAtR2o4ZnY/slrtQWaIKEKMV9EkbrmZAWc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y0bd9oGtneMZeTibUjjwOOlvSpbTQWi9dkXDEuWehN+p+7Qq7Q1ZxuZ+p+mQ4t4yp
         PDyzvjxEaWdW/jd43wFXa1Zot1t4O9gzJzj9zo0K/DvsQKWWLT7M+umeIS0thjT6Lw
         3U0S7dWOKshkhHXfkwdNDknqGI76pxD0uPnDa5sU=
Date:   Thu, 21 May 2020 12:11:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Starovoytov <mstarovoitov@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmitry Bezrukov <dbezrukov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 03/12] net: atlantic: changes for
 multi-TC support
Message-ID: <20200521121156.7f776ef8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CH2PR18MB323861420A81270EC7207300D3B70@CH2PR18MB3238.namprd18.prod.outlook.com>
References: <20200520134734.2014-1-irusskikh@marvell.com>
        <20200520134734.2014-4-irusskikh@marvell.com>
        <20200520140154.6b6328de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CH2PR18MB323861420A81270EC7207300D3B70@CH2PR18MB3238.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 09:18:44 +0000 Mark Starovoytov wrote:
> Hi Jakub,
> 
> > > In the first generation of our hardware (A1), a whole traffic class is
> > > consumed for PTP handling in FW (FW uses it to send the ptp data and
> > > to send back timestamps).
> > > Since this conflicts with QoS (user is unable to use the reserved
> > > TC2), we suggest using module param to give the user a choice:
> > > disabling PTP allows using all available TCs.  
> > 
> > Is there really no way to get the config automatically chosen when user sets
> > up TCs or does SIOCSHWTSTAMP? It's fine to return -EOPNOTSUPP when too
> > many things are enabled, but user having to set module parameters upfront
> > is quite painful.  
> 
> Module param is not a must have for usage, default config allows the
> user to use TCs and PTP features simultaneously with one major
> limitation: TC2 is reserved for PTP, so if the user tries to
> send/receive anything on TC2, if won't quite work unfortunately. If
> the user wants to get "everything" from QoS/TC (e.g. use all the TCs)
> - he can explicitly disable the PTP via module param.
> 
> Right now we really aren't sure we can dynamically rearrange
> resources between QoS and PTP, since disabling/enabling PTP requires
> a complete HW reconfiguration unfortunately. Even more unfortunate is
> the fact that we can't change the TC, which is reserved for PTP,
> because TC2 is hardcoded in firmware.
> 
> We would prefer to keep things as is for now, if possible. We'll
> discuss this with HW/FW team(s) and submit a follow-up patch, if we
> find a way to automatically choose the config.

Module parameters are very strongly discouraged for networking drivers.
They also constitute uAPI, and can't be changed, short-term solution
like that is really far from ideal.
