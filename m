Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2738194932
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgCZUaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:30:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbgCZUaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:30:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CE7720722;
        Thu, 26 Mar 2020 20:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585254604;
        bh=v8II2Vo0wig/VmFEo9KEGqg/AMkWGH6DJkm7Nb/yqR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQxmMkWPd9eEtezKgixQHKBfcF/aerMRDFg4f3KMwI7Ab3zxRcoGxrtcZnhZzVrFi
         fsNzPxGDEsemGq3pZ4u+G+0to0LZyJzJXu1o0zqYp1hIQVRXaO9iyyoS6bluZFz4PO
         uZ9S3eXdKjSA6lW3dGq7DsgsRFpzDEcbWelXt1kc=
Date:   Thu, 26 Mar 2020 13:30:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, magnus.karlsson@intel.com
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200326145146.GX11304@nanopsycho.orion>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <20200321093525.GJ11304@nanopsycho.orion>
        <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200326144709.GW11304@nanopsycho.orion>
        <20200326145146.GX11304@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 15:51:46 +0100 Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 03:47:09PM CET, jiri@resnulli.us wrote:
> >>> >> >> $ devlink slice show
> >>> >> >> pci/0000:06:00.0/0: flavour physical pfnum 0 port 0 state active
> >>> >> >> pci/0000:06:00.0/1: flavour physical pfnum 1 port 1 state active
> >>> >> >> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 port 2 hw_addr 10:22:33:44:55:66 state active
> >>> >> >> pci/0000:06:00.0/3: flavour pcivf pfnum 0 vfnum 1 port 3 hw_addr aa:bb:cc:dd:ee:ff state active
> >>> >> >> pci/0000:06:00.0/4: flavour pcivf pfnum 1 vfnum 0 port 4 hw_addr 10:22:33:44:55:88 state active
> >>> >> >> pci/0000:06:00.0/5: flavour pcivf pfnum 1 vfnum 1 port 5 hw_addr 10:22:33:44:55:99 state active
> >>> >> >> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2      
> >>> >> >
> >>> >> >What are slices?      
> >>> >> 
> >>> >> Slice is basically a piece of ASIC. pf/vf/sf. They serve for
> >>> >> configuration of the "other side of the wire". Like the mac. Hypervizor
> >>> >> admin can use the slite to set the mac address of a VF which is in the
> >>> >> virtual machine. Basically this should be a replacement of "ip vf"
> >>> >> command.    
> >>> >
> >>> >I lost my mail archive but didn't we already have a long thread with
> >>> >Parav about this?    
> >>> 
> >>> I believe so.  
> >>
> >>Oh, well. I still don't see the need for it :( If it's one to one with
> >>ports why add another API, and have to do some cross linking to get
> >>from one to the other?
> >>
> >>I'd much rather resources hanging off the port.  
> >
> >Yeah, I was originally saying exactly the same as you do. However, there
> >might be slices that are not related to any port. Like NVE. Port does
> >not make sense in that world. It is just a slice of device.
> >Do we want to model those as "ports" too? Maybe. What do you think?  
> 
> Also, the slice is to model "the other side of the wire":
> 
> eswitch - devlink_port ...... slice
> 
> If we have it under devlink port, it would probably
> have to be nested object to have the clean cut.

So the queues, interrupts, and other resources are also part 
of the slice then?

How do slice parameters like rate apply to NVMe?

Are ports always ethernet? and slices also cover endpoints with
transport stack offloaded to the NIC?
