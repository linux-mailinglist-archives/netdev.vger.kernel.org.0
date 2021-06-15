Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0912C3A76F0
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhFOGPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:15:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhFOGPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 02:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327EC613FA;
        Tue, 15 Jun 2021 06:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623737611;
        bh=+bikqx1R8Mse0yV7OLvPjcj2aOx3fEnK7C5MCZz5WpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MwyOwqVj3kCPSwmjPRYosrF5mw1yTG6Fs2McPL1N5XgSzKz7N15ORaobolV8zYbrm
         w6q9Jd4303bGfgWAGVjmAllZka4uIm+EYI3GONcy6M9/WMDMdcKex1VH54tBSaI8F+
         LesXad4QgKihmtXKJ0GyMA8aVvjzkfdYsU1HCv3uW1KmVlTtRzUUpacf49GAUuKnP8
         4/CU/VYH8b0XwieD/aS4ogfpFU+04lNks/92XlLD9UdAbeiJowtcr97yKf6T3kuNXT
         3FnVsnKPlD7AmxERZD9syMgvKOxsGM85sGfBp90l/su7+uXbAep48NZxu0bgsMJfMX
         4mJ9vz8aXm3JA==
Date:   Tue, 15 Jun 2021 09:13:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] uapi: add missing virtio related headers
Message-ID: <YMhFB+esV4zQRbxh@unreal>
References: <20210423174011.11309-1-stephen@networkplumber.org>
 <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <41c8cf83-6b7d-1d55-fd88-5b84732f9d70@gmail.com>
 <20210611092132.5f66f710@hermes.local>
 <78f32159-24d7-0ea6-6be3-add0186b97c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78f32159-24d7-0ea6-6be3-add0186b97c2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 07:03:36PM -0600, David Ahern wrote:
> On 6/11/21 10:21 AM, Stephen Hemminger wrote:
> > On Thu, 10 Jun 2021 20:54:45 -0600
> > David Ahern <dsahern@gmail.com> wrote:
> > 
> >> On 6/8/21 11:15 PM, Parav Pandit wrote:
> >>> Hi Stephen,
> >>>
> >>> vdpa headers were present in commit c2ecc82b9d4c at [1].
> >>>
> >>> I added them at [1] after David's recommendation in [2].
> >>>
> >>> Should we remove [1]?
> >>> Did you face compilation problem without this fix?
> >>>
> >>> [1] ./vdpa/include/uapi/linux/vdpa.h
> >>> [2] https://lore.kernel.org/netdev/abc71731-012e-eaa4-0274-5347fc99c249@gmail.com/
> >>>
> >>> Parav  
> >>
> >> Stephen: Did you hit a compile issue? vdpa goes beyond networking and
> >> features go through other trees AIUI so the decision was to put the uapi
> >> file under the vdpa command similar to what rdma is doing.
> >>
> > 
> > In iproute2, all kernel headers used during the build should come from include/uapi.
> > If new command or function needs a new header, then the sanitized version should be
> > included.
> > 
> > I update these with an automated script, and making special case for vdpa
> > seems to be needless effort. Please just let iproute's include/uapi just be
> > a copy of what kernel "make install_headers" generates.
> > 
> 
> an exception was made for rdma because of the order in which uapi
> updates hit the net-next tree. The same exception was being made for
> vdpa for the same reason.

Right, and almost all RDMA features are accompanied by the commit like
this which brings headers cycle earlier than they will appear in net-next.

commit 212e2c1d0cb27f0d1f87b9cc6454b8afbeb2d467
Author: Gal Pressman <galpress@amazon.com>
Date:   Thu Apr 29 09:48:02 2021 +0300

    rdma: update uapi headers

    Update rdma_netlink.h file upto kernel commit
    6cc9e215eb27 ("RDMA/nldev: Add copy-on-fork attribute to get sys command")

    Signed-off-by: Gal Pressman <galpress@amazon.com>
    Acked-by: Leon Romanovsky <leonro@nvidia.com>
    Signed-off-by: David Ahern <dsahern@kernel.org>

