Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDBA6F041D
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbjD0KVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243323AbjD0KVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:21:35 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCEC55B7
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:21:06 -0700 (PDT)
Message-ID: <8e2050f5-6476-9048-c33e-100a039ba3b4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682590861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3G/nU0Px8/ejhPGbb3UsW4rMKbAM1zhRCr8M1g7gDu8=;
        b=vpfCP46wVmNuM7i3ys2EAxtFKDkH0nL1eUxxHAyOEFkPwDO2wMaXZBx3sCd9AoycwYIABN
        8ZqZfRdC+iE3csaYeiQy7ZFY8qSbhzl4jQhV8k6LElEWNx766B29jpn94BPlGWHEpcKWJ2
        Ddf8s0uIFh0SItF7hYKU+td2M2O7p54=
Date:   Thu, 27 Apr 2023 11:20:58 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com> <ZA9Nbll8+xHt4ygd@nanopsycho>
 <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
 <ZBA8ofFfKigqZ6M7@nanopsycho>
 <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <ZBGOWQW+1JFzNsTY@nanopsycho> <20230403111812.163b7d1d@kernel.org>
 <ZDJulCXj9H8LH+kl@nanopsycho> <20230410153149.602c6bad@kernel.org>
 <ZDwg88x3HS2kd6lY@nanopsycho> <20230417124942.4305abfa@kernel.org>
 <e4e4046d53ce61ac0f7db882fa31556e8a9db94b.camel@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <e4e4046d53ce61ac0f7db882fa31556e8a9db94b.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2023 09:05, Paolo Abeni wrote:
> Hi,
> 
> On Mon, 2023-04-17 at 12:49 -0700, Jakub Kicinski wrote:
>> [resend with fixed CC list]
>>
>> On Sun, 16 Apr 2023 18:23:15 +0200 Jiri Pirko wrote:
>>>> What is index? I thought you don't want an index and yet there is one,
>>>> just scoped by random attributes :(
>>>
>>> Index internal within a single instance. Like Intel guys, they have 1
>>> clock wired up with multiple DPLLs. The driver gives every DPLL index.
>>> This is internal, totally up to the driver decision. Similar concept to
>>> devlink port index.
>>
>> devlink port index ended up as a pretty odd beast with drivers encoding
>> various information into it, using locally grown schemes.
>>
>> Hard no on doing that in dpll, it should not be exposed to the user.
> 
> I'm replying here just in case the even the above reply was lost.
> 
> I guess the last remark resolved this specific discussion.
> 
> @Vadim, @Arkadiusz, even if net-next is currently closed, there are no
> restrictions for RFC patches: feel free to share v7 when it fits you
> better!

Hi Paolo!
Thanks for reminder, the new version is almost ready, I was a bit 
distracted by other burning issues. Hopefully I'll publish it till the 
end of the week.

