Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB378314BEE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhBIJmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhBIJjx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 04:39:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9095B64E4F;
        Tue,  9 Feb 2021 09:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612863552;
        bh=oXXyDGkkfcC0NZy3VvkRseX2X+WykyiMPqFn5yvQaZQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gish6tbCGv0xGppkRqoSpXYr2rf3/s5EyDdbwZYZa1F5aQzq0JirpMYdvklKVGNff
         6oa5qLla5IPROiPdzi9LRywTteMAd6jaC95nqdnftQwhim10nEzSSXV8MwiaQBfjAQ
         twteAnD+RooOI6EFLWIdU+8tVN1xA1L2M/1pPBS5Ni0o4us1/TYe80SUfNTeRfmcgX
         9V4JGNzb2ZFOaQ7t4d7U9jJ8osSAK702p73CenCdqUTc00toCKfeNV4YCUrHVXTT4j
         pqGezQ9xzU9sLKXkubo8XxBSIwU2iSXtsZ5/TrMTF3j7UqSfHjKiTBpsgIX4Lahf97
         /XsYaW4C3vcFw==
Message-ID: <26c5e58a79e32a1ea5ebae013a7a67285f5ba908.camel@kernel.org>
Subject: Re: [PATCH net-next 0/2] devlink: Add port function attribute to
 enable/disable roce
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, parav@nvidia.com
Date:   Tue, 09 Feb 2021 01:39:09 -0800
In-Reply-To: <20210203132605.7faf8ca0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210201175152.11280-1-yishaih@nvidia.com>
         <20210202181401.66f4359f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <d01dfcc6f46f2c70c4921139543e5823582678c8.camel@kernel.org>
         <20210203105102.71e6fa2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <38d73470cd4faac0dc6c09697f33c5fb90d13f4e.camel@kernel.org>
         <20210203132605.7faf8ca0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-03 at 13:26 -0800, Jakub Kicinski wrote:
> On Wed, 03 Feb 2021 11:22:44 -0800 Saeed Mahameed wrote:
> > On Wed, 2021-02-03 at 10:51 -0800, Jakub Kicinski wrote:
> > > On Tue, 02 Feb 2021 20:13:48 -0800 Saeed Mahameed wrote:  
> > > > yes, user in this case is the admin, who controls the
> > > > provisioned
> > > > network function SF/VFs.. by turning off this knob it allows to
> > > > create
> > > > more of that resource in case the user/admin is limited by
> > > > memory.  
> > > 
> > > Ah, so in case of the SmartNIC this extra memory is allocated on
> > > the
> > > control system, not where the function resides?
> > 
> > most of the memeory are actually allocated from where the function
> > resides, some are on the management system but it is not as
> > critical.
> > SFs for now can only be probed on the management system, so the
> > main
> > issue will be on the SmartNIC side for now.
> 
> Why not leave the decision whether to allocate that memory or not to
> the SF itself? If user never binds the RDMA driver to the SF they
> clearly don't care for RDMA. No extra knobs needed.
> 

Sorry about the late response.

But FW is already setup for RDMA weather SW wants it or not for this
specific function.
a system admin may want to deploy a leaner function to the client. we
can disable RoCE in FW before we even instantiate this function.

> > > My next question is regarding the behavior on the target system -
> > > what
> > > does "that user" see? Can we expect they will understand that the
> > > limitation was imposed by the admin and not due to some
> > > initialization
> > > failure or SW incompatibility?
> > 
> > the whole thing works with only real HW capabilities, there is no
> > synthetic SW capabilities. 
> > 
> > when mlx5 instance driver loads, it doesn't assume anything about
> > underlying HW, and it queries for the advertised FW capability
> > according to the HW spec before it enables a feature.
> > 
> > so this patch adds the ability for admin to enforce a specific HW
> > cap
> > "off" for a VF/SF hca slice.
> > 
> > > > RAW eth QP, i think you already know this one, it is a very
> > > > thin
> > > > layer
> > > > that doesn't require the whole rdma stack.  
> > > 
> > > Sorry for asking a leading question. You know how we'll feel
> > > about
> > > that one, do we need to talk this out or can we save ourselves
> > > the
> > > battle? :S  
> > 
> > I know, I know :/
> > 
> > So, there is no rdma bit/cap in HW.. to disable non-RoCE commands
> > we
> > will have to disable etherent capability. 
> 
> It's your driver, you can make it do what you need to. Why does 
> the RDMA driver bind successfully to a non-RoCE Ethernet device 
> in the first place?
> 

because RDMA people are greedy :), and they can create QPs that are not
RoCE..

this patch is only basic enable/disable RoCE feature on a specific
device slice, how rdma driver initializes itself is not related to this
patch at all, and it is just how rdma works, with or without this
patch.

> > The user interface here has no synthetic semantics, all knobs will
> > eventually be mapped to real HW/FW capabilities to get disabled.
> > 
> > the whole feature is about allowing admin to ship network functions
> > with different capabilities that are actually enforced by FW/HW.. 
> > so the user of the VF will see, RDMA/ETH only cards or both.
> 
> RDMA-only, ETH-only, RDMA+ETH makes sense to me. Having an ETH-only
> device also exposed though rdma subsystem does not.

But this has nothing to do with this patch. this is the rdma driver
implementation.



