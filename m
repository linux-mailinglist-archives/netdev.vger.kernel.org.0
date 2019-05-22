Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A620C25DC3
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 07:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfEVFrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 01:47:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfEVFrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 01:47:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D0C16609EF; Wed, 22 May 2019 05:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558504059;
        bh=NHSxcTaQfC/av2LlFasucnPTE6q6sCmyoWTO1bzLkbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G0p89A7U4bfZwjPcVEweRGKmqal56V8bXMHIppujHCIqOH11/k/dOwoQvLB1wtRlv
         D4vow28m0sz1NXxzIRj5PAfDXsJg8lSnm02InS7kiLVXcSt3/CftsOm/gX9MmTA2P4
         iRpD67sJ50zpevJkbCGDTZg6FyhXw4ndszAcbq5M=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E1C7A60312;
        Wed, 22 May 2019 05:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558504058;
        bh=NHSxcTaQfC/av2LlFasucnPTE6q6sCmyoWTO1bzLkbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m5Uq7/8vSpc3GWwP2aSAq7eJ4T56JIgxFA4LUEO2AGMgE5I1pFiMFRpA/WH7svgtj
         6EqmKwB5zi/RQtPSM5pCYbcaZ6hWv91rPewiKbEa9iCo2IUHERo8CDb7odTfyO64DR
         TZU3JYNlS9Uo3cqtN+GH7A+dEUukHBeN2tU4BlBo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 May 2019 23:47:38 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] net: qualcomm: rmnet: Move common struct definitions
 to include
In-Reply-To: <e1b27721-19ff-2ae9-2885-90a7948f774f@linaro.org>
References: <1558467302-17072-1-git-send-email-subashab@codeaurora.org>
 <CAK8P3a0JpCnV59uWmrot7KeLPCOq_FqPb--xD_fMpaPd7x0zRg@mail.gmail.com>
 <20190521210804.GR31438@minitux>
 <e1b27721-19ff-2ae9-2885-90a7948f774f@linaro.org>
Message-ID: <c9da7461c054f90d641db4a97b5ba2f5@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> I think I'd just duplicate the structure definitions then, to avoid 
>>> having
>>> the bitfield definitions in a common header and using them in the new
>>> driver.
>>> 
>> 
>> Doing would allow each driver to represent the bits as suitable, at 
>> the
>> cost of some duplication and confusion. Confusion, because it doesn't
>> resolve the question of what the right bit order actually is.
> 

If we duplicate this definition, then it will be the third instance of
map header in kernel (1 in rmnet, 1 in qmi_wwan, 1 in ipa).

> Subash, if you don't mind, please acknowledge that again here
> so everyone knows.
> 
>> Subash stated yesterday that bit 0 is "CD", which in the current 
>> struct
>> is represented as the 8th bit, while Alex's patch changes the 
>> definition
>> so that this bit is the lsb. I.e. I read Subash answer as confirming
>> that patch 1/8 from Alex is correct.
> 
> I'm not sure about that but I don't want to confuse things further.
> 

Data over the wire is always big endian a.k.a network byte order.
When looking at the bits in the order in which they are seen in the 
network,
the command_data bit is the 0th bit. This is what is present in the 
rmnet
documentation which I had shared.

The struct definitions which are in the rmnet_map.h headers
are in little endian because that is what my ARM64 devices are using.
In little endian, the bits in the byte are read in the opposite order
i.e. most significant bit (7th) is command_data.

The addition of definitions for big endian in if_rmnet.h should now
cover any host supporting big endian bit schemes in addition to little
endian systems like ARM64.

> I have exchanged a few private messages with Subash.  He has said
> that it is the high-order bit that indicates whether a QMAP packet
> contains a command (1) or data (0).  That bit might be extracted
> this way:
> 
>     u8 byte = *(u8 *)skb->data;
>     bool command = !!(byte & 0x80);
> 

!!(byte & 0x80) gives the correct value of command_data bit.

>> Subash, as we're not addressing individual bits in this machine, so
>> given a pointer map_hdr to a struct rmnet_map_header, which of the
>> following ways would give you the correct value of pad_len:
>> 
>> u8 p = *(char*)map_hdr;
>> pad_len = p & 0x3f;
>> 

p & 0x3f gives the correct value of pad_len.

>> or:
>> 
>> u8 p = *(char*)map_hdr;
>> pad_len = p >> 2;
> 
> My new understanding is it's the latter.
> 
>> PS. I do prefer the two drivers share the definition of these
>> structures...
> 
> I agree with you completely.  I don't think it makes sense to
> have two definitions of the same structure.  Subash wants to
> reduce the impact my changes have on the "rmnet" driver, but
> duplicating things makes things worse, not better.  The IPA
> driver *assumes* it is talking to the rmnet driver; their
> interface definition should be common...
> 

That is right. If David has no objections to this patch,
then Alex can just rebase the ipa changes over this instead of
his rmnet series.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
