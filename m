Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5725B3073
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 09:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiIIHjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 03:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiIIHiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 03:38:55 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2ED4DF07;
        Fri,  9 Sep 2022 00:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662708956; x=1694244956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m3YnqdItTBfQHuTJjhU/D3X2vYT7bLo7zCxA7BZS5Gg=;
  b=ddkUvZ8gAEZdc45JaMhFgdZxyPONLu341eDyd8/EiILhqJQd62dOhFcV
   mbrzL7j+oFmbBlfVetxwnimJe6zZwYoSzZUZQuUabp9AT3l54na7yU+MZ
   D7iXigyN0HR8Ok1KqF0bF4BBZVQkU2TThWnlBqIZHYhtdktwYEkYFD1eh
   HKuKYPWDyopWZRyAhMUUnVvbRSqxQUMfSEsSKKVujOYgMkPvXRR4wBVvd
   /RJMCMuPBPznOlSpcPpIsDSrblwndLGcuOfR8Cq8Kj+j920zN3fNSctZq
   FaP8FvRpgau/OjWODsH3v07ustfMzjkAuS8DsS4uF1WSnJaxsDCr8+oAB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="296155491"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="296155491"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 00:35:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="645435049"
Received: from yuyongfe-mobl1.ccr.corp.intel.com (HELO [10.249.174.117]) ([10.249.174.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 00:35:11 -0700
Message-ID: <8eabb29b-7302-d0a2-5949-d7aa6bc59809@linux.intel.com>
Date:   Fri, 9 Sep 2022 15:34:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net/ncsi: Add Intel OS2BMC OEM command
To:     Paul Fertser <fercerpav@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20220909025716.2610386-1-jiaqing.zhao@linux.intel.com>
 <YxrWPfErV7tKRjyQ@home.paul.comp>
Content-Language: en-US
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
In-Reply-To: <YxrWPfErV7tKRjyQ@home.paul.comp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-09 13:59, Paul Fertser wrote:
> Hello,
> 
> On Fri, Sep 09, 2022 at 10:57:17AM +0800, Jiaqing Zhao wrote:
>> The Intel OS2BMC OEM NCSI command is used for controlling whether
>> network traffic between host and sideband is allowed or not. By
>> default such traffic is disallowed, meaning that if the device using
>> NCS (usually BMC) does not have extra active connection, it cannot
>> reach the host.
> 
> Can you please explain the rationale behind introducing this as a
> compile-time kernel config option? I can probably imagine how this can
> make sense as a DT switch (e.g. to describe hardware where there's no
> other communication channel between the host and BMC) but even this
> feels far-fetched.

Previously I submitted a patch to make the NCSI configurable in DT[1], but
it was not accepted by kernel community. A limitation is that currently NCSI
is not a standalone device node, it is controlled by "use-ncsi" option in the
MAC device DT node (like ftgmac100).

Other features like keep phy (also intel-specific oem) also uses kernel option.
(CONFIG_NCSI_OEM_CMD_KEEP_PHY)

[1] https://lore.kernel.org/netdev/20220610165940.2326777-4-jiaqing.zhao@linux.intel.com/T/

> Can you please outline some particular use cases for this feature?
> 
It enables access between host and BMC when BMC shares the network connection
with host using NCSI, like accessing BMC via HTTP or SSH from host. 
