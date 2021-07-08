Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F113BF48A
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhGHE1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:27:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:31750 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhGHE1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 00:27:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="209480889"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="209480889"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 21:24:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="487400097"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.185.169.17]) ([10.185.169.17])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 21:24:38 -0700
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igc: wait for the MAC copy when
 enabled MAC passthrough
To:     Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edri, Michael" <michael.edri@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Shalev, Avi" <avi.shalev@intel.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210702045120.22855-2-aaron.ma@canonical.com>
 <613e2106-940a-49ed-6621-0bb00bc7dca5@intel.com>
 <ad3d2d01-1d0a-8887-b057-e6a9531a05f4@canonical.com>
 <f9f9408e-9ba3-7ed9-acc2-1c71913b04f0@intel.com>
 <96106dfe-9844-1d9d-d865-619d78a0d150@canonical.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <47117935-10d6-98e0-5894-ba104912ce25@intel.com>
Date:   Thu, 8 Jul 2021 07:24:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <96106dfe-9844-1d9d-d865-619d78a0d150@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/2021 09:46, Aaron Ma wrote:
> 
> On 7/5/21 7:54 PM, Neftin, Sasha wrote:
>> Hello Aaron, Thanks to point me on this document. I see... This is 
>> recommendation for Windows driver. Anyway, "delay" approach is 
>> error-prone. We need rather ask for MNG FW confirmation (message) that 
>> MAC address is copied.
>> Can we call (in case we know that MNG FW copied MAC address):
>> igc_rar_set (method from igc_mac.c), update the mac.addr and then 
>> perform": memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len);?
> 
> Without delay, after igc_rar_set, the MAC address is all 0.
> The MAC addr is the from dock instead of MAC passthrough with the 
> original driver.
I would to like suggest checking the following direction:
1. principal question: can we update the netdev device address after it 
is already set during probe? I meant perform another:
memcpy(netdev->dev_addr, hw->mac.addr, netdev->addr_len) up to demand
2. We need to work with Intel's firmware engineer/group and define the 
message/event: MAC addressis changed and should be updated.
As I know MNG FW updates shadow registers. Since shadow registers are 
different from RAL/RAH registers - it could be a notification that the 
MAC address changed. Let's check it.
> 
> Thanks,
> Aaron

