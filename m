Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F39F165328
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 00:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBSXra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 18:47:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgBSXra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 18:47:30 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2648C24656;
        Wed, 19 Feb 2020 23:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582156049;
        bh=X3UuJYkLBpTG/zlZ1vGpF8EeMBW3zGtM8db2LnXPQpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kRmI+4Zo1/lVOKoTqoj4poy3ncPnuVD4gAjf8b5e4igOT8YVKKZJBhIQORxfhNzP9
         Tg5Z3D0UH+RyZMTGBaXVmdNoXa3U9SjQqqYigXHXq3MwerRyJ/WVrRL8+RPpcFsGLM
         +Fh3XH9n95qOTXatgrR83SrxlE9gvzbTt/iWW4CA=
Date:   Wed, 19 Feb 2020 15:47:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [RFC PATCH v2 06/22] ice: add basic handler for devlink
 .info_get
Message-ID: <20200219154727.5b52aa73@kicinski-fedora-PC1C0HJN>
In-Reply-To: <70001e87-b369-bab4-f318-ad4514e7dcfb@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
        <20200214232223.3442651-7-jacob.e.keller@intel.com>
        <20200218184552.7077647b@kicinski-fedora-PC1C0HJN>
        <6b4dd025-bcf8-12de-99b0-1e05e16333e8@intel.com>
        <20200219115757.5af395c5@kicinski-fedora-PC1C0HJN>
        <70001e87-b369-bab4-f318-ad4514e7dcfb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 13:37:50 -0800 Jacob Keller wrote:
> Jakub,
> 
> Thanks for your excellent feedback.
> 
> On 2/19/2020 11:57 AM, Jakub Kicinski wrote:
> > On Wed, 19 Feb 2020 09:33:09 -0800 Jacob Keller wrote:  
> >> "fw.psid.api" -> what was the "nvm.psid". This I think needs a bit more
> >> work to define. It makes sense to me as some sort of "api" as (if I
> >> understand it correctly) it is the format for the parameters, but does
> >> not itself define the parameter contents.  
> > 
> > Sounds good. So the contents of parameters would be covered by the
> > fw.bundle now and not have a separate version?
> >   
> 
> I'm actually not sure if we have any way to identify the parameters.
> I'll ask around about that. My understanding is that these would include
> parameters that can be modified by the driver such as Wake on LAN
> settings, so I'm also not sure if they'd be covered in the fw.bundle
> either. The 'defaults' that were selected when the image was created
> would be covered, but changes to them wouldn't update the value.
> 
> Hmmmmm.

Ah, so these are just defaults, then if there's no existing version 
I wouldn't worry.

> >> The original reason for using "fw" and "nvm" was because we (internally)
> >> use fw to mean the management firmware.. where as these APIs really
> >> combine the blocks and use "fw.mgmt" for the management firmware. Thus I
> >> think it makes sense to move from
> >>
> >> I also have a couple other oddities that need to be sorted out. We want
> >> to display the DDP version (piece of "firmware" that is loaded during
> >> driver load, and is not permanent to the NVM). In some sense this is our
> >> "fw.app", but because it's loaded by driver at load and not as
> >> permanently stored in the NVM... I'm not really sure that makes sense to
> >> put this as the "fw.app", since it is not updated or really touched by
> >> the firmware flash update.  
> > 
> > Interesting, can DDP be persisted to the flash, though? Is there some
> > default DDP, or is it _never_ in the flash? 
> 
> There's a version of this within the flash, but it is limited, and many
> device features get disabled if you don't load the DDP package file.
> (You may have seen patches for this for implementing "safe mode").
> 
> My understanding is there is no mechanism for persisting a different DDP
> to the flash.

I see, so this really isn't just parser extensions.

I'm a little surprised you guys went this way, loading FW from disk
becomes painful for network boot and provisioning :S  All the first
stage images must have it built in, which is surprisingly painful.

Perhaps the "safe mode" FW is enough to boot, but then I guess once
real FW is available there may be a loss of link as the device resets?

> > Does it not have some fun implications for firmware signing to have
> > part of the config/ucode loaded from the host?
> 
> I'm not sure how it works exactly. As far as I know, the DDP file is
> itself signed.

Right, that'd make sense :)

> > IIRC you could also load multiple of those DDP packages? Perhaps they
> > could get names like fw.app0, fw.app1, etc?  
> 
> You can load different ones, each has their own version and name
> embedded. However, only one can be loaded at any given time, so I'm not
> sure if multiples like this make sense.

I see. Maybe just fw.app works then..

> > Also if DDP controls a
> > particular part of the datapath (parser?) feel free to come up with a
> > more targeted name, up to you.
> 
> Right, it's my understanding that this defines the parsing logic, and
> not the complete datapath microcode.
> 
> In theory, there could be at least 3 DDP versions
> 
> 1) the version in the NVM, which would be the very basic "safe mode"
> compatible one.
> 
> 2) the version in the ddp firmware file that we search for when we load
> 
> 3) the one that actually got activated. It's a sort of
> first-come-first-serve and sticks around until a device global reset.
> This should in theory always be the same as (2) unless you do something
> weird like load different drivers on the multiple functions.
> 
> I suppose we could use "running" and "stored" for this, to have "stored"
> be what's in the NVM, and "running" for the active one.. but that's ugly
> and misusing what stored vs running is supposed to represent.

Ouff. Having something loaded from disk breaks the running vs stored
comparison :( But I think Dave was pretty clear on his opinion about
load FW from disk and interpret it in the kernel to extract the version.

Can we leave stored meaning "stored on the device" and running being
loaded on the chip?

It's perfectly fine for a component to only be reported in running and
not stored, nfp already does that:

https://elixir.bootlin.com/linux/v5.6-rc1/source/drivers/net/ethernet/netronome/nfp/nfp_devlink.c#L238

> >> Finally we also have a component we call the "netlist", which I'm still
> >> not fully up to speed on exactly what it represents, but it has multiple
> >> pieces of data including a 2-digit Major.Minor version of the base, a
> >> type field indicating the format, and a 2-digit revision field that is
> >> incremented on internal and external changes to the contents. Finally
> >> there is a hash that I think might *actually* be something like a psid
> >> or a bundle to uniquely represent this component. I haven't included
> >> this component yet because I'm still trying to grasp exactly what it
> >> represents and how best to describe each piece.  
> > 
> > Hmm. netlist is a Si term, perhaps it's chip init data? nfp had
> > something called chip.init which I think loaded all the very low 
> > level Si configs.
> >   
> 
> I'm asking some colleagues to provide further details on this. Right now
> the "version" for a netlist is just a display of all these fields munged
> together "a.b.c-d.e.f", which I'd rather avoid.
> 
> > My current guess is that psid is more of the serdes and maybe clock
> > data. 
> > 
> > Thinking about it now, it seems these versions mirror the company
> > structure. chip.init comes from the Si team. psid comes from the 
> > board design guys. fw.mgmt comes from the BSP/FW team.
> > 
> > None of them are really fixed but the frequency of changes increases
> > from chip.init changing very rarely to mgmt fw having a regular release
> > cadence.
> >   
> 
> Without further information I don't know for sure, but I don't think
> chip.init makes sense. I'll try to find out more.
