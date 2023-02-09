Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAEC69128E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 22:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBIVTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 16:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIVTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 16:19:06 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175A32B615;
        Thu,  9 Feb 2023 13:19:04 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BA479D5C;
        Thu,  9 Feb 2023 22:19:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1675977541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uvE0zVf5S+NnP5tghw0fX80CCw17goZcg06vSqjn5U=;
        b=zkkZtig/xH8iDYl8HsgcBuICq5abxdrmzTMKDv/wWJoXkYgahpw5PLwTf9T3t6HGMbuDi2
        8CPxgywptO2/jJq+YFyy2im0SFqcX1lhbN8VSWtmCkGatOiANwSkOZ2CaeL1uu6OZFZfzc
        0G3ND3rwtlYBMmAc2GuGldnc3h5VPyFIZFz2HMLaMz/yZudBOtelw4Orsg06M6fHU2c4xf
        PMCJHUsPH9QEDOc30ltbbtzBwyCIGiMHf5DnXsO5MTi5DahU+sQqtCm4UQS/rxepgzgJN0
        bhTJ3gV+ZJXLMrylWRToUsWPtFCrlu3E9qWh5e72bJAB2+wxDWCHiR2I/JRqtg==
MIME-Version: 1.0
Date:   Thu, 09 Feb 2023 22:19:01 +0100
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ajay.Kathat@microchip.com, heiko.thiery@gmail.com,
        Claudiu.Beznea@microchip.com, kvalo@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Amisha.Patel@microchip.com
Subject: Re: wilc1000 MAC address is 00:00:00:00:00:00
In-Reply-To: <20230209130725.0b04a424@kernel.org>
References: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
 <e027bfcf-1977-f2fa-a362-8faed91a19f9@microchip.com>
 <20230209094825.49f59208@kernel.org>
 <51134d12-1b06-6d6f-e798-7dd681a8f3ae@microchip.com>
 <20230209130725.0b04a424@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <2d548e01b266f7b1ad19a5ea979d00bf@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-02-09 22:07, schrieb Jakub Kicinski:
> On Thu, 9 Feb 2023 18:51:58 +0000 Ajay.Kathat@microchip.com wrote:
>> > netdev should be created with a valid lladdr, is there something
>> > wifi-specific here that'd prevalent that? The canonical flow is
>> > to this before registering the netdev:
>> 
>> Here it's the timing in wilc1000 by when the MAC address is available 
>> to
>> read from NV. NV read is available in "mac_open" net_device_ops 
>> instead
>> of bus probe function. I think, mostly the operations on netdev which
>> make use of mac address are performed after the "mac_open" (I may be
>> missing something).
>> 
>> Does it make sense to assign a random address in probe and later read
>> back from NV in mac_open to make use of stored value?
> 
> Hard to say, I'd suspect that may be even more confusing than
> starting with zeroes. There aren't any hard rules around the
> addresses AFAIK, but addrs are visible to user space. So user
> space will likely make assumptions based on the most commonly
> observed sequence (reading real addr at probe).

Maybe we should also ask the NetworkManager guys. IMHO random
MAC address sounds bogus.

I don't understand the "we load the firmware when the interface
is brought up" thing. Esp. with network manager scanning in the
background, the firmware gets loaded so many times.

-michael
