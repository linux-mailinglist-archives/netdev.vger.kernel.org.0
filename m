Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103E42FF691
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbhAUU5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:57:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:49819 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727258AbhAUU4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:56:31 -0500
IronPort-SDR: glEt/nDE6YJb6Lnj/OssmHFv5rIpe+fG0Jx0TREcOcsVdaOvKMopw7n13VDtGrp4W/sjFSDRnL
 1X1WB9QjFCwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="198082896"
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="198082896"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 12:52:49 -0800
IronPort-SDR: h4D8+wepymdZPDeIoXQ7aQwGRjYf+FzWyRZnYUtmybngXvL10fD/co+xkfYccV6ekH9h4otHhZ
 2fuNhbHBGLXA==
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="427504830"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.35.189]) ([10.212.35.189])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 12:52:46 -0800
Subject: Re: [net-next V9 04/14] devlink: Support get and set state of port
 function
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        alexander.duyck@gmail.com, edwin.peer@broadcom.com,
        dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-5-saeed@kernel.org>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <338c82b7-bb73-a793-2fe2-7e48bf0e4178@intel.com>
Date:   Thu, 21 Jan 2021 12:52:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210121085237.137919-5-saeed@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/2021 12:52 AM, Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
>
> devlink port function can be in active or inactive state.
> Allow users to get and set port function's state.
>
> When the port function it activated, its operational state may change
> after a while when the device is created and driver binds to it.
> Similarly on deactivation flow.
>
> To clearly describe the state of the port function and its device's
> operational state in the host system, define state and opstate
> attributes.
>
> Example of a PCI SF port which supports a port function:
> Create a device with ID=10 and one physical port.
Not clear what it means by creating a device with ID=10 and one physical 
port?
I only see a SF with sfnum 88 in the following steps.
>
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
>
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
>
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
>    function:
>      hw_addr 00:00:00:00:00:00 state inactive opstate detached
>
> $ devlink port show pci/0000:06:00.0/32768
> pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
>    function:
>      hw_addr 00:00:00:00:88:88 state inactive opstate detached
>
> $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88 state active
>
> $ devlink port show pci/0000:06:00.0/32768 -jp
> {
>      "port": {
>          "pci/0000:06:00.0/32768": {
>              "type": "eth",
>              "netdev": "ens2f0npf0sf88",
>              "flavour": "pcisf",
>              "controller": 0,
>              "pfnum": 0,
>              "sfnum": 88,
>              "external": false,
>              "splittable": false,
>              "function": {
>                  "hw_addr": "00:00:00:00:88:88",
>                  "state": "active",
>                  "opstate": "attached"
>              }
>          }
>      }
> }
>
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
<snip>

