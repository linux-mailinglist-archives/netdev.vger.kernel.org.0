Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392F71C314C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 04:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEDCMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 22:12:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:18952 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgEDCMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 22:12:21 -0400
IronPort-SDR: xR99v8fkdsgQYFx7KAt+glS9ypjBYZvyOqSywkrGh5ocVxo75Tlth+Yxp1pUCGPDH1hZYun+d4
 32qoJ4vfQ74A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2020 19:12:20 -0700
IronPort-SDR: rhWbSwFkPhSWDykDfLu6C7I8kldM02mjPaQfeOEr08fbRklL+zndY2Zm00uZVW9dBQHKzD7Kle
 thBLXDIENDig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,350,1583222400"; 
   d="scan'208";a="304061755"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.41.206]) ([10.212.41.206])
  by FMSMGA003.fm.intel.com with ESMTP; 03 May 2020 19:12:18 -0700
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
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com
References: <20200501091449.GA25211@nanopsycho.orion>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <80453af6-7cb3-59a7-910e-2fc69263ebde@intel.com>
Date:   Sun, 3 May 2020 19:12:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200501091449.GA25211@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2020 2:14 AM, Jiri Pirko wrote:
> Hi all.
> 
> First, I would like to apologize for very long email. But I think it
> would be beneficial to the see the whole picture, where we are going.
> 
> Currently we are working internally on several features with
> need of extension of the current devlink infrastructure. I took a stab
> at putting it all together in a single txt file, inlined below.
> 
> Most of the stuff is based on a new port sub-object called "func"
> (called "slice" previously" and "subdev" originally in Yuval's patchsets
> sent some while ago).
> 
> The text describes how things should behave and provides a draft
> of user facing console input/outputs. I think it is important to clear
> that up before we go in and implement the devlink core and
> driver pieces.
> 
> I would like to ask you to read this and comment. Especially, I would
> like to ask vendors if what is described fits the needs of your
> NIC/e-switch.
> 
> Please note that something is already implemented, but most of this
> isn't (see "what needs to be implemented" section).
> 
> v1->v2
> - mainly move from separate slice object into port/func subobject
> - couple of small fixes here and there
> 

<snip>

> 
> 
> 
> ==================================================================
> ||                                                              ||
> ||             Port func user cmdline API draft                 ||
> ||                                                              ||
> ==================================================================
> 
> Note that some of the "devlink port" attributes may be forgotten or misordered.
> 
> Funcs are created as sub-objects of ports where it makes sense to have them
> The driver takes care of that. The "func" is a handle to configure "the other
> side of the wire". The original port object has port leve properties,
> the new "func" sub-object on the other hand has device level properties".
> 
> This is example for the HOST A from the example above:
> 
> $ devlink port show
> pci/0000:06:00.0/0: flavour physical pfnum 0 type eth netdev enp6s0f0np1
> pci/0000:06:00.0/1: flavour physical pfnum 1 type eth netdev enp6s0f0np2
> pci/0000:06:00.0/2: flavour pcipf pfnum 2 type eth netdev enp6s0pf2
>                      func: hw_addr 10:22:33:44:55:66 state active
> pci/0000:06:00.0/3: flavour pcivf pfnum 2 vfnum 0 type eth netdev enp6s0pf2vf0
>                      func: hw_addr 10:22:33:44:55:77 state active
> pci/0000:06:00.0/4: flavour pcivf pfnum 0 vfnum 0 type eth netdev enp6s0pf0vf0
>                      func: hw_addr 10:22:33:44:55:88 state active
> pci/0000:06:00.0/5: flavour pcisf pfnum 0 sfnum 1 type eth netdev enp6s0pf0sf1
>                      func: hw_addr 10:22:33:44:55:99 state active
> pci/0000:06:00.0/6: flavour pcivf pfnum 1 vfnum 2 type nvme
>                      func: state active


I am trying to understand how the current implementation of 'devlink 
port' is being refactored to support this new model.

Today 'devlink port show' on a system with 2 port mlx5 NIC with 1 VFs 
created on each PF shows

pci/0000:af:00.0/1: type eth netdev enp175s0f0np0 flavour physical port 0
pci/0000:af:00.1/1: type eth netdev enp175s0f1np1 flavour physical port 1
pci/0000:af:00.2/1: type eth netdev enp175s0f2np0 flavour virtual port 0
pci/0000:af:08.2/1: type eth netdev enp175s8f2np0 flavour virtual port 0


Can you tell me how this will be represented in the new model?

It looks like you are assigning a pfnum to physical port as well as PCI 
PF. However, i am little confused as both pfnum 0 and pfnum 1 which seem 
to be 2 physical ports have the same bus/dev/func 06:00.0 and also the 
VF ports.

Thanks
Sridhar
