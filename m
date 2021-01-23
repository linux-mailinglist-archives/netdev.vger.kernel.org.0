Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6E530183B
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAWUKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:10:05 -0500
Received: from mga04.intel.com ([192.55.52.120]:2301 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbhAWUKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:10:03 -0500
IronPort-SDR: MgNsff2tHQWl2no2cZ3mUpAGQd1Oqhs4EPeOX6aP2qKYuvpdt+TwoyqoQDQ7IQn1CSL2qscLF5
 yaSo2tG6GuKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9873"; a="177008883"
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="177008883"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2021 12:09:17 -0800
IronPort-SDR: KC8P61i1leZJ9TrCS+6n3lStrkoT4Vbs8r861R+jj3bqYOq3o+I2tz7F4kEHPh6cPW2aqgW6To
 Y5NiRqWSBSmQ==
X-IronPort-AV: E=Sophos;i="5.79,369,1602572400"; 
   d="scan'208";a="469413293"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.57.78]) ([10.212.57.78])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2021 12:09:16 -0800
Subject: Re: [net-next V9 14/14] net/mlx5: Add devlink subfunction port
 documentation
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, alexander.duyck@gmail.com,
        edwin.peer@broadcom.com, dsahern@kernel.org, kiran.patil@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        dan.j.williams@intel.com, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210121085237.137919-1-saeed@kernel.org>
 <20210121085237.137919-15-saeed@kernel.org>
 <d5ef3359-ff3c-0e71-8312-0f24c3af4bce@intel.com>
 <20210122001157.GE4147@nvidia.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <89d0c6de-18e3-5728-a220-3440ca263616@intel.com>
Date:   Sat, 23 Jan 2021 12:09:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122001157.GE4147@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/2021 4:11 PM, Jason Gunthorpe wrote:
> On Thu, Jan 21, 2021 at 12:59:55PM -0800, Samudrala, Sridhar wrote:
>
>>> +                 mlx5_core.sf.4
>>> +          (subfunction auxiliary device)
>>> +                       /\
>>> +                      /  \
>>> +                     /    \
>>> +                    /      \
>>> +                   /        \
>>> +      mlx5_core.eth.4     mlx5_core.rdma.4
>>> +     (sf eth aux dev)     (sf rdma aux dev)
>>> +         |                      |
>>> +         |                      |
>>> +      p0sf88                  mlx5_0
>>> +     (sf netdev)          (sf rdma device)
>> This picture seems to indicate that when SF is activated, a sub
>> function auxiliary device is created
> Yes
>
>> and when a driver is bound to that sub function aux device and
>> probed, 2 additional auxiliary devices are created.
> More than two, but yes
>
>> Is this correct? Are all these auxiliary devices seen on the same
>> aux bus?
> Yes
>
>> Why do we need another sf eth aux device?
> The first aux device represents the physical HW and mlx5_core binds to it,
> the analog is like a pci_device.

OK. So looks like you are creating a function level aux device and a 
subsytem-level aux
device for each subsystem including ethernet.

>
> The other aux devices represent the subsystem split of the mlx5 driver
> - mlx5_core creates them and each subsystem in turn binds to the
> mlx5_core driver. This already exists, and Intel will be doing this as
> well whenever the RDMA driver is posted again..

Yes. I see that the intel RDMA patches are now submitted. We are 
creating an aux device to
expose RDMA functionality, but  not planning to create an aux device for 
ethernet subsystem
on a PF/SF as the function-level pci/aux device can represent the 
default ethernet.

