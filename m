Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBD63B339A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFXQMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:12:22 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:51564 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229445AbhFXQMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:12:20 -0400
X-UUID: 8279eec4480b4048a414ccc5cbd21ae2-20210625
X-UUID: 8279eec4480b4048a414ccc5cbd21ae2-20210625
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2104162736; Fri, 25 Jun 2021 00:09:59 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 25 Jun 2021 00:09:58 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 25 Jun 2021 00:09:56 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH 4/4] drivers: net: mediatek: initial implementation of ccmni
Date:   Thu, 24 Jun 2021 23:55:02 +0800
Message-ID: <20210624155501.10024-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNR5QuYqknaZS9+j@kroah.com>
References: <YNR5QuYqknaZS9+j@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 14:23 +0200, Greg KH wrote:
On Thu, Jun 24, 2021 at 07:53:49PM +0800, Rocco Yue wrote:
>> 
>> without MTK ap ccci driver (modem driver), ccmni_rx_push() and
>> ccmni_hif_hook() are not be used.
>> 
>> Both of them are exported as symbols because MTK ap ccci driver
>> will be compiled to the ccci.ko file.
> 
> But I do not see any code in this series that use these symbols.  We can

will delete these symbols.

> not have exports that no one uses.  Please add the driver to this patch
> series when you resend it.
> 

I've just took a look at what the Linux staging tree is. It looks like
a good choice for the current ccmni driver.

honstly, If I simply upload the relevant driver code B that calls
A (e.g. ccmni_rx_push), there is still a lack of code to call B.
This seems to be a continuty problem, unless all drivers codes are
uploaded (e.g. power on modem, get hardware status, complete tx/rx flow).

>> In addition, the code of MTK's modem driver is a bit complicated,
>> because this part has more than 30,000 lines of code and contains
>> more than 10 modules. We are completeing the upload of this huge
>> code step by step. Our original intention was to upload the ccmni
>> driver that directly interacts with the kernel first, and then
>> complete the code from ccmni to the bottom layer one by one from
>> top to bottom. We expect the completion period to be about 1 year.
> 
> Again, we can not add code to the kernel that is not used, sorry.  That
> would not make any sense, would you want to maintain such a thing?
> 
> And 30k of code seems a bit excesive for a modem driver.   Vendors find
> that when they submit code for inclusion in the kernel tree, in the end,
> they end up 1/3 the original size, so 10k is reasonable.
> 
> I can also take any drivers today into the drivers/staging/ tree, and
> you can do the cleanups there as well as getting help from others.
> 
> 1 year seems like a long time to do "cleanup", good luck!
> 

Thanks~

Can I resend patch set as follows:
(1) supplement the details of pureip for patch 1/4;
(2) the document of ccmni.rst still live in the Documentation/...
(3) modify ccmni and move it into the drivers/staging/...

>>> +++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.h
>>> 
>>> Why do you have a .h file for a single .c file?  that shouldn't be
>>> needed.
>> 
>> I add a .h file to facilitate subsequent code expansion. If it's
>> not appropriate to do this here, I can add the content of .h into
>> .c file.
> 
> If nothing other than a single .c file needs it, put it into that .c
> file please.

will do.

Thanks,
Rocco

