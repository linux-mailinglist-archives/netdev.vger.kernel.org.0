Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1293349DC
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCJVdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:33:39 -0500
Received: from z11.mailgun.us ([104.130.96.11]:31323 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhCJVdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:33:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615412018; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LZBL/ng3u2865rRR20pd9fpyeV9TuEsDH8GDB4KYjgI=;
 b=gRffde7dToemSt8bWf467CHlqSfLZvtXtwrtkD+PARWFhjS//N9SPcbf08sn1Ef/sdFdI1cU
 g/BrHEhhQcEQhDToRj/VXBGX1H1bKeBgYi4magf5JNaCyMhfaf2L4TuB15tzvgEZSJnqh7M/
 cyL05oDZPn8AoJ36qD+EtTslTBg=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60493b2d0c7cf0f56c5bdb44 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Mar 2021 21:33:33
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B9E1EC433ED; Wed, 10 Mar 2021 21:33:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A9ADC433CA;
        Wed, 10 Mar 2021 21:33:32 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Mar 2021 14:33:32 -0700
From:   subashab@codeaurora.org
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipv6: addrconf: Add accept_ra_prefix_route.
In-Reply-To: <d7bb2c1d-1e9a-5191-96bd-c3d567df2da1@gmail.com>
References: <1615402193-12122-1-git-send-email-subashab@codeaurora.org>
 <d7bb2c1d-1e9a-5191-96bd-c3d567df2da1@gmail.com>
Message-ID: <cbcfa6d3c4fa057051bbee6851e9d4e7@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-10 12:28, David Ahern wrote:
> On 3/10/21 11:49 AM, Subash Abhinov Kasiviswanathan wrote:
>> Added new procfs flag to toggle the automatic addition of prefix
>> routes on a per device basis. The new flag is accept_ra_prefix_route.
>> 
>> A value of 0 for the flag maybe used in some forwarding scenarios
>> when a userspace daemon is managing the routing.
>> Manual deletion of the kernel installed route was not sufficient as
>> kernel was adding back the route.
>> 
>> Defaults to 1 as to not break existing behavior.
>> 
>> Signed-off-by: Subash Abhinov Kasiviswanathan 
>> <subashab@codeaurora.org>
>> ---
>>  Documentation/networking/ip-sysctl.rst | 10 ++++++++++
>>  include/linux/ipv6.h                   |  1 +
>>  include/uapi/linux/ipv6.h              |  1 +
>>  net/ipv6/addrconf.c                    | 16 +++++++++++++---
>>  4 files changed, 25 insertions(+), 3 deletions(-)
>> 
>> diff --git a/Documentation/networking/ip-sysctl.rst
>> b/Documentation/networking/ip-sysctl.rst
>> index c7952ac..9f0d92d 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -2022,6 +2022,16 @@ accept_ra_mtu - BOOLEAN
>>  		- enabled if accept_ra is enabled.
>>  		- disabled if accept_ra is disabled.
>> 
>> +accept_ra_prefix_route - BOOLEAN
>> +	Apply the prefix route based on the RA. If disabled, kernel
>> +	does not install the route. This can be used if a userspace
>> +	daemon is managing the routing.
>> +
>> +	Functional default:
>> +
>> +		- enabled if accept_ra_prefix_route is enabled
>> +		- disabled if accept_ra_prefix_route is disabled
>> +
>>  accept_redirects - BOOLEAN
>>  	Accept Redirects.
>> 
> 
> this seems to duplicate accept_ra_pinfo

Thanks David. We will try out that entry instead and check.
