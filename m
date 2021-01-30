Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADE3095AD
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 15:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhA3OBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 09:01:01 -0500
Received: from mga18.intel.com ([134.134.136.126]:23276 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhA3OA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 09:00:56 -0500
IronPort-SDR: tKpUFGMx1kHW/bX8qlC3IYwz3rwj5B5Dzi04j8G6yp5coT7Bo2JMRmFP+VlSXsiyIQwFWn7bXr
 mzmSNTCzgSVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="168198474"
X-IronPort-AV: E=Sophos;i="5.79,388,1602572400"; 
   d="scan'208";a="168198474"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2021 06:00:15 -0800
IronPort-SDR: fRNZIQ3lfUSUfPMxtQ8Nr8HelD7nVsku3lJPsm0/o7drxBjbffkRSGXcfiaG/SPjOSPiZygvJq
 Mx2v/n4TQZcQ==
X-IronPort-AV: E=Sophos;i="5.79,388,1602572400"; 
   d="scan'208";a="389870816"
Received: from lgidonix-mobl2.ger.corp.intel.com (HELO [10.214.220.59]) ([10.214.220.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2021 06:00:12 -0800
Subject: Re: [PATCH net 1/4] igc: Report speed and duplex as unknown when
 device is runtime suspended
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
 <20210128213851.2499012-2-anthony.l.nguyen@intel.com>
 <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <107f90ab-0466-67e8-8cc5-7ac79513f939@intel.com>
Date:   Sat, 30 Jan 2021 16:00:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129222255.5e7115bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/2021 08:22, Jakub Kicinski wrote:
> On Thu, 28 Jan 2021 13:38:48 -0800 Tony Nguyen wrote:
>> From: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>
>> Similar to commit 165ae7a8feb5 ("igb: Report speed and duplex as unknown
>> when device is runtime suspended"), if we try to read speed and duplex
>> sysfs while the device is runtime suspended, igc will complain and
>> stops working:
> 
>> The more generic approach will be wrap get_link_ksettings() with begin()
>> and complete() callbacks, and calls runtime resume and runtime suspend
>> routine respectively. However, igc is like igb, runtime resume routine
>> uses rtnl_lock() which upper ethtool layer also uses.
>>
>> So to prevent a deadlock on rtnl, take a different approach, use
>> pm_runtime_suspended() to avoid reading register while device is runtime
>> suspended.
> 
> Is someone working on the full fix to how PM operates?
> 
> There is another rd32(IGC_STATUS) in this file which I don't think
> is protected either.
Hello Jakub,
What is another rd32(IGC_STATUS) you meant? in  igc_ethtool_get_regs? 
While the device in D3 state there is no configuration space registers 
access.
sasha
> 

