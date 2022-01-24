Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A63497E5C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 12:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238064AbiAXL5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 06:57:40 -0500
Received: from kylie.crudebyte.com ([5.189.157.229]:45581 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXL5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 06:57:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=PaRHB0N2VyP/cPc04W5opSXEJ069a6Jl4lq7u/k4wcQ=; b=RSIveJ6x/hIAp7y/bt3fxnFbs4
        DRl4Y93odukaOEf82Wo5t4wGXQ+fpasG8gXPez6/q8240Vb9eEfQqxQDUtipE5TmHFKzijFFsqh5B
        4b2Z7kL0g8rJm0X01+jAcyXYIIZoN7YOAH2AL08tqkQpDqbEcPI07x8ofWll4f89ag8uDSpdAbCRR
        bSPWljZzZ/cRRK5iMbkgODIvLLlCjojXnRN2AMq81Op4jZK9pNfZyq5FvdytiKXgVqTSWLXI/IEYh
        icVB/fl79oeo0wwxCo68tkT5kSCu5yIs2b9wSD9WQsHYyXxQxQR/U8rb5LuPEmrl/Z9VtVlkg82VT
        /FXIgh+6P/m7BLR0Qgy2uUTvl3TDJl4YQxq5p9WTWGWBHTdhJ2IcQmkoASy04LeCbAmUcHtm2GxW+
        RtISQrYI7rnLpcCH7NUGybfCEFZM2lPDk3ppR51BtGBW9ZiS3LHFcQv8GtPCyCdwmKuI9HGHshOdH
        M5dsZKfQsIVgHwQbF20ateLmj8ys/E1JxzFyykfenEFJGQGOYfNbhw7uOq0qMXJxzgTzxmnhHwk8k
        XC6U9whjsJDlKenNmC5fa0gEeVnn1OJJ8WLgUtGu9zDgLJDsKX+u/Lb1PjWbkFvbrV1CYChWJcATw
        jaUwjoy0/FlmKhlyPnCeypS/oJmUn3oQYGaNLS95g=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Date:   Mon, 24 Jan 2022 12:57:35 +0100
Message-ID: <22204794.ZpPF1Y2lYg@silver>
In-Reply-To: <Ye6IaIqQcwAKv0vb@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com> <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net> <Ye6IaIqQcwAKv0vb@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 24. Januar 2022 12:07:20 CET Dominique Martinet wrote:
> Nikolay Kichukov wrote on Mon, Jan 24, 2022 at 11:21:08AM +0100:
> > It works, sorry for overlooking the 'known limitations' in the first
> > place. When do we expect these patches to be merged upstream?
> 
> We're just starting a new development cycle for 5.18 while 5.17 is
> stabilizing, so this mostly depends on the ability to check if a msize
> given in parameter is valid as described in the first "STILL TO DO"
> point listed in the cover letter.

I will ping the Redhat guys on the open virtio spec issue this week. If you 
want I can CC you Dominique on the discussion regarding the virtio spec 
changes. It's a somewhat dry topic though.

> I personally would be happy considering this series for this cycle with
> just a max msize of 4MB-8k and leave that further bump for later if
> we're sure qemu will handle it.

I haven't actually checked whether there was any old QEMU version that did not 
support exceeding the virtio queue size. So it might be possible that a very 
ancient QEMU version might error out if msize > (128 * 4096 = 512k).

Besides QEMU, what other 9p server implementations are actually out there, and 
how would they behave on this? A test on their side would definitely be a good 
idea.

> We're still seeing a boost for that and the smaller buffers for small
> messages will benefit all transport types, so that would get in in
> roughly two months for 5.18-rc1, then another two months for 5.18 to
> actually be released and start hitting production code.
> 
> 
> I'm not sure when exactly but I'll run some tests with it as well and
> redo a proper code review within the next few weeks, so we can get this
> in -next for a little while before the merge window.

Especially the buffer size reduction patches needs a proper review. Those 
changes can be tricky. So far I have not encountered any issues with tests at 
least. OTOH these patches could be pushed through separately already, no 
matter what the decision regarding the virtio issue will be.

Best regards,
Christian Schoenebeck


