Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6121D41DC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgENXw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:52:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:12598 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgENXw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 19:52:57 -0400
IronPort-SDR: G51XRBN/fa5VAiJRZfP/rPzf5ef8OBNfI2vV4EhaCZCOoJPoPbyWf+Vjn2mJIkqebgOtPzjMoE
 eHbjOuhWecmg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 16:52:57 -0700
IronPort-SDR: 1FScbakemESQdiWd4uS6nGXZwr50TYCni+ZyfJlvJeb9+dD0GzFcym9UzWvvEswJ0DBL8SPa43
 5fnR3YPKCtpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="341793022"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.26.254]) ([10.212.26.254])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 16:52:54 -0700
Subject: Re: [RFC v2] current devlink extension plan for NICs
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        valex@mellanox.com, linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
References: <20200501091449.GA25211@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
Date:   Thu, 14 May 2020 16:52:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200501091449.GA25211@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2020 2:14 AM, Jiri Pirko wrote:
> ==================================================================
> ||                                                              ||
> ||          SF (subfunction) user cmdline API draft             ||
> ||                                                              ||
> ==================================================================
> 
> Note that some of the "devlink port" attributes may be forgotten,
> misordered or omitted on purpose.
> 
> $ devlink port show
> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> pci/0000:06:00.0/2: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
>                     func: hw_addr 10:22:33:44:55:66 state active
> 
> There is one VF on the NIC.
> 
> Now create subfunction of SF0 on PF1, index of the port is going to be 100:
> 

Here, you say "SF0 on PF1", but you then specify sfnum as 10 below.. Is
there some naming scheme or terminology here?

> $ devlink port add pci/0000.06.00.0/100 flavour pcisf pfnum 1 sfnum 10
> 

Can you clarify what sfnum means here? and why is it different from the
index? I get that the index is a unique number that identifies the port
regardless of type, so sfnum must be some sort of hardware internal
identifier?

When looking at this with colleagues, there was a lot of confusion about
the difference between the index and the sfnum.

> The devlink kernel code calls down to device driver (devlink op) and asks
> it to create a SF port with particular attributes. Driver then instantiates
> the SF port in the same way it is done for VF.
> 

What do you mean by attributes here? what sort of attributes can be
requested?

> 
> Note that it may be possible to avoid passing port index and let the
> kernel assign index for you:
> $ devlink port add pci/0000.06.00.0 flavour pcisf pfnum 1 sfnum 10
> 
> This would work in a similar way as devlink region id assignment that
> is being pushed now.
> 

Sure, this makes sense to me after seeing Jakub's recent patch for
regions. I like this approach. Letting the user not have to pick an ID
ahead of time is useful.

Is it possible to skip providing an sfnum, and let the kernel or driver
pick one? Or does that not make sense?

> ==================================================================
> ||                                                              ||
> ||   VF manual creation and activation user cmdline API draft   ||
> ||                                                              ||
> ==================================================================
> 
> To enter manual mode, the user has to turn off VF dummies creation:
> $ devlink dev set pci/0000:06:00.0 vf_dummies disabled
> $ devlink dev show
> pci/0000:06:00.0: vf_dummies disabled
> 
> It is "enabled" by default in order not to break existing users.
> 
> By setting the "vf_dummies" attribute to "disabled", the driver
> removes all dummy VFs. Only physical ports are present:
> 
> $ devlink port show
> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> 
> Then the user is able to create them in a similar way as SFs:
> 
> $ devlink port add pci/0000:06:00.0/99 flavour pcivf pfnum 1 vfnum 8
> 

So in this case, you have to specify the VF index to create? So this
vfum is very similar to the sfnum (and pfnum?) above?

What about the ability to just say "please give me a VF, but I don't
care which one"?

> The devlink kernel code calls down to device driver (devlink op) and asks
> it to create a VF port with particular attributes. Driver then instantiates
> the VF port with func.
> 

> 
> ==================================================================
> ||                                                              ||
> ||                             PFs                              ||
> ||                                                              ||
> ==================================================================
> 
> There are 2 flavours of PFs:
> 1) Parent PF. That is coupled with uplink port. The flavour is:
>     a) "physical" - in case the uplink port is actual port in the NIC.
>     b) "virtual" - in case this Parent PF is actually a leg to
>        upstream embedded switch.

So "physical" is for the physical NIC port. Ok. And "virtual" is one
side of an internal embedded switch. This makes sense.

> 
>    $ devlink port show
>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> 
>    If there is another parent PF, say "0000:06:00.1", that share the
>    same embedded switch, the aliasing is established for devlink handles.
> 
>    The user can use devlink handles:
>    pci/0000:06:00.0
>    pci/0000:06:00.1
>    as equivalents, pointing to the same devlink instance.
> 
>    Parent PFs are the ones that may be in control of managing
>    embedded switch, on any hierarchy leve>
> 2) Child PF. This is a leg of a PF put to the parent PF. It is
>    represented by a port a port with a netdevice and func:
> 
>    $ devlink port show
>    pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
>    pci/0000:06:00.0/1: flavour pcipf pfnum 2 type eth netdev enp6s0f0pf2
>        func: hw_addr aa:bb:cc:aa:bb:87 state active
> 
>    This is a typical smartnic scenario. You would see this list on
>    the smartnic CPU. The port pci/0000:06:00.0/1 is a leg to
>    one of the hosts. If you send packets to enp6s0f0pf2, they will
>    go to the child PF.
> 
>    Note that inside the host, the PF is represented again as "Parent PF"
>    and may be used to configure nested embedded switch.
> 
> 

I'm not sure I understand this section. Child PF? Is this like a PF in
another host? Or representing the other side of the virtual link?
> 
> ==================================================================
> ||                                                              ||
> ||            Dynamic PFs user cmdline API draft                ||
> ||                                                              ||
> ==================================================================
> 
> User might want to create another PF, similar as VF.
> TODO
> 

Obviously this is a TODO, but how does this differ from the current
port_split and port_unsplit?
