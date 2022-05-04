Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3F51A543
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353009AbiEDQWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiEDQWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:22:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79E346648
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 09:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651681158; x=1683217158;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7Z5WUv/evxnhfc2HGYJkA07rz7g+y6wGCXDi2RcmaJQ=;
  b=gGzPbOKXyelGaXb6CFziBHIZWPCfEvazhquoRK1T3WdIc2Wkh3epjfmK
   o8bHd08pwv4CIQHSVXbJJwCj/yBXoNy0mcbk2O5Qi1ldNc0I/ZA69QMCW
   NqcA9WBFFt1hT/H9wNNHmwVD3vXSV2ZPeXIr8GjfKkI1D4WLo8fObcFz+
   0hZrIiAgyTqglHL3tYjNGd9iGCGqnRCXDjXFEhoVus12bDwEhrNg/sYVB
   8DeM7+1xqp108zCDE9FP3y1PirdMYCgeG0qa6GozSPVUW3o+xbQFGSOUn
   GFZuvBAP3WHtkBJN3tpSS2DStZc1quZLypBnikXJZq4K5gUhaKRUXSdLw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248353048"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="248353048"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 09:19:18 -0700
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="562793943"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.186.96]) ([10.215.186.96])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 09:19:15 -0700
Message-ID: <6caa4c33-583c-65ff-6303-296f1c87a762@linux.intel.com>
Date:   Wed, 4 May 2022 21:49:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] net: wwan: fix port open
Content-Language: en-US
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
References: <20220504142006.3804-1-m.chetan.kumar@linux.intel.com>
 <CAMZdPi9DB09dsjuFt-d6U5-NdVsoZ3NqDbmegLyCndRU9G9gJQ@mail.gmail.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <CAMZdPi9DB09dsjuFt-d6U5-NdVsoZ3NqDbmegLyCndRU9G9gJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

On 5/4/2022 8:14 PM, Loic Poulain wrote:
> Hi Chetan,
> 
> On Wed, 4 May 2022 at 16:09, M Chetan Kumar
> <m.chetan.kumar@linux.intel.com> wrote:
>>
>> Wwan device registered port can be opened as many number of times.
>> The first port open() call binds dev file to driver wwan port device
>> and subsequent open() call references to same wwan port instance.
>>
>> When dev file is opened multiple times, all contexts still refers to
>> same instance of wwan port. So in tx path, the received data will be
>> fwd to wwan device but in rx path the wwan port has a single rx queue.
>> Depending on which context goes for early read() the rx data gets
>> dispatched to it.
>>
>> Since the wwan port is not handling dispatching of rx data to right
>> context restrict wwan port open to single context.
> 
> The reason for this behavior comes from:
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2313348.html
> 
> Especially:
> ---
> "I told you before, do not try to keep a device node from being opened
> multiple times, as it will always fail (think about passing file
> handles around between programs...) If userspace wants to do this, it
> will do it.  If your driver can't handle that, that's fine, userspace
> will learn not to do that. But the kernel can not prevent this from
> happening."
> ---
> 
> So maybe a user-side solution would be more appropriate, /var/lock/ ?

OK. So this means user space application like modem manager should lock the wwan 
port so that wwan port will not be available for other programs ?

Regards,
Chetan
