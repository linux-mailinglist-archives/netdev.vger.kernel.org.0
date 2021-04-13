Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A86635E880
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346799AbhDMVuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhDMVuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 17:50:10 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0784AC061574;
        Tue, 13 Apr 2021 14:49:49 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4FKfQf4Sj0zQk0t;
        Tue, 13 Apr 2021 23:49:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1618350583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcwULY5BNf9oos//YKEDdWvIBBNg5SiQobq9K+Vw9TY=;
        b=tpd0JICgm/SLIZomHrFJfkxOmsAtnMlhNfM8CPLYOc6zKcJBzn+aOpShZkxowW71RPi+sJ
        VA8Nl1LuM80lfYejitI3b0h3WsSckfOS3UPJaxcNwFOOJ0UKAyamBxA+rqt0UhfCcUDQOr
        Nej91iyfgWPV/HvqxKW5JiTfVtgj2uivmur+PdmE7CC/gVnryoiLOV+C1viF5kPAd6885S
        TN+RxDqBYQy6FjQZGf/AeAEukOoTxAhO32MLohEzLW4Fe04LcpiqwXcZAyvLFUV7LFJUJ3
        ZhN1aLzI/07L/qfCemmTQ/n3YBp9eRLv5qM3JsDMAjw78QhdhglZSpzMjnATNQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id 9yv280CbIP7v; Tue, 13 Apr 2021 23:49:41 +0200 (CEST)
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com>
 <YHODYWgHQOuwoTf4@lunn.ch>
 <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <a7d99915-a65e-8f3d-67da-57fe39986bd3@hauke-m.de>
Date:   Tue, 13 Apr 2021 23:49:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.73 / 15.00 / 15.00
X-Rspamd-Queue-Id: 424A915F8
X-Rspamd-UID: 52b41f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 12:24 AM, Martin Blumenstingl wrote:
> Hi Andrew,
> 
> On Mon, Apr 12, 2021 at 1:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Sun, Apr 11, 2021 at 10:55:11PM +0200, Martin Blumenstingl wrote:
>>> Add support for .get_regs_len and .get_regs so it is easier to find out
>>> about the state of the ports on the GSWIP hardware. For this we
>>> specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
>>> register #defines as these contain the current port status (as well as
>>> the result of the auto polling mechanism). Other global and per-port
>>> registers which are also considered useful are included as well.
>>
>> Although this is O.K, there has been a trend towards using devlink
>> regions for this, and other register sets in the switch. Take a look
>> at drivers/net/dsa/mv88e6xxx/devlink.c.
>>
>> There is a userspace tool for the mv88e6xxx devlink regions here:
>>
>> https://github.com/lunn/mv88e6xxx_dump
>>
>> and a few people have forked it and modified it for other DSA
>> switches. At some point we might want to try to merge the forks back
>> together so we have one tool to dump any switch.
> actually I was wondering if there is some way to make the registers
> "easier to read" in userspace.
> It turns out there is :-)
> 
> Hauke, which approach do you recommend?:
> - update this patch with your suggestion and ask Andrew to still merge
> it soon-ish
> - put this topic somewhere on my or your TODO-list and come up with a
> devlink solution at some point in the future

Would you work on the devlink solution in the next weeks?
I think this is part of the ABI when we add it, can we later remove the 
ethtool registers when we add devlink support or is this not allowed?

Hauke
