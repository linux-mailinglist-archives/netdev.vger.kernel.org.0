Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE8A31A5D6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 21:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhBLUMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:12:15 -0500
Received: from so15.mailgun.net ([198.61.254.15]:16307 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhBLUMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 15:12:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1613160714; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=gi+8GIcTymdb+kcyC0kc7XPeJibIh/Q06KpbbYygZqs=;
 b=b7oDH/Y1p4fJ7mBXx/DGAJQWsUFNTlKoXTef1paOaXblCp31rF08IlV8p1QbcWlDQIOATyX9
 k5HvKqp6bz2LJV5mq7lHcTQR2C1+HL1Yld358K54mI1hZTgdlwVQotsg2MXAqitw+YpMkixQ
 aNhE16PoKQBTff8kzm22W3ky5Og=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 6026e0ef8e43a988b7d6aaab (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Feb 2021 20:11:27
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36083C433CA; Fri, 12 Feb 2021 20:11:27 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F691C433C6;
        Fri, 12 Feb 2021 20:11:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 12 Feb 2021 13:11:26 -0700
From:   subashab@codeaurora.org
To:     Alex Elder <elder@ieee.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net:ethernet:rmnet:Support for downlink MAPv5 csum
 offload
In-Reply-To: <dfa87271-0ade-f8b5-b41f-1128353b3248@ieee.org>
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
 <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
 <20210211180459.500654b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1c4e21bf-5903-bc45-6d6e-64b68e494542@ieee.org>
 <20210212105120.01b04172@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dfa87271-0ade-f8b5-b41f-1128353b3248@ieee.org>
Message-ID: <f950b355214bd78f80df24391b85c4cc@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-12 12:06, Alex Elder wrote:
> On 2/12/21 12:51 PM, Jakub Kicinski wrote:
>> On Fri, 12 Feb 2021 08:01:15 -0600 Alex Elder wrote:
>>> On 2/11/21 8:04 PM, Jakub Kicinski wrote:
>>>> On Fri, 12 Feb 2021 03:05:23 +0530 Sharath Chandra Vurukala wrote:
>>>>> +/* MAP CSUM headers */
>>>>> +struct rmnet_map_v5_csum_header {
>>>>> +	u8  next_hdr:1;
>>>>> +	u8  header_type:7;
>>>>> +	u8  hw_reserved:5;
>>>>> +	u8  priority:1;
>>>>> +	u8  hw_reserved_bit:1;
>>>>> +	u8  csum_valid_required:1;
>>>>> +	__be16 reserved;
>>>>> +} __aligned(1);
>>>> 
>>>> Will this work on big endian?
>>> 
>>> Sort of related to this point...
>>> 
>>> I'm sure the response to this will be to add two versions
>>> of the definition, surrounded __LITTLE_ENDIAN_BITFIELD
>>> and __BIG_ENDIAN_BITFIELD tests.
>>> 
>>> I really find this non-intuitive, and every time I
>>> look at it I have to think about it a bit to figure
>>> out where the bits actually lie in the word.
>>> 
>>> I know this pattern is used elsewhere in the networking
>>> code, but that doesn't make it any easier for me to
>>> understand...
>>> 
>>> Can we used mask, defined in host byte order, to
>>> specify the positions of these fields?
>>> 
>>> I proposed a change at one time that did this and
>>> this *_ENDIAN_BITFIELD thing was used instead.
>>> 
>>> I will gladly implement this change (completely
>>> separate from what's being done here), but thought
>>> it might be best to see what people think about it
>>> before doing that work.
>> 
>> Most definitely agree, please convert.
> 
> KS, would you like me to do this to the existing code
> first?
> 
> I don't think it will take me very long.  If it were
> a priority I could probably get it done by the end of
> today, but I'd want to ensure the result worked for
> the testing you do.
> 
> 					-Alex

Sorry, I am not convinced that it is helping
to improve anything. It just adds a big
overhead of testing everything again without any
apparent improvement of performance or readablity
of code.
