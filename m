Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB903B59D0
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 09:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhF1HgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 03:36:23 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:53400 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232246AbhF1HgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 03:36:21 -0400
X-UUID: 574c76e2c2aa4ea5935980c50dcfcddf-20210628
X-UUID: 574c76e2c2aa4ea5935980c50dcfcddf-20210628
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 253331028; Mon, 28 Jun 2021 15:33:51 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 28 Jun 2021 15:33:43 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Jun 2021 15:33:42 +0800
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
Date:   Mon, 28 Jun 2021 15:18:30 +0800
Message-ID: <20210628071829.14925-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNS4GzYHpxMWIH+1@kroah.com>
References: <YNS4GzYHpxMWIH+1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-24 at 18:51 +0200, Greg KH wrote:
On Thu, Jun 24, 2021 at 11:55:02PM +0800, Rocco Yue wrote:
>> On Thu, 2021-06-24 at 14:23 +0200, Greg KH wrote:
>> On Thu, Jun 24, 2021 at 07:53:49PM +0800, Rocco Yue wrote:
>>> 
>>> not have exports that no one uses.  Please add the driver to this patch
>>> series when you resend it.
>>> 
>> 
>> I've just took a look at what the Linux staging tree is. It looks like
>> a good choice for the current ccmni driver.
>> 
>> honstly, If I simply upload the relevant driver code B that calls
>> A (e.g. ccmni_rx_push), there is still a lack of code to call B.
>> This seems to be a continuty problem, unless all drivers codes are
>> uploaded (e.g. power on modem, get hardware status, complete tx/rx flow).
> 
> Great, send it all!  Why is it different modules, it's only for one
> chunk of hardware, no need to split it up into tiny pieces.  That way
> only causes it to be more code overall.
> 
>> 
>> Thanks~
>> 
>> Can I resend patch set as follows:
>> (1) supplement the details of pureip for patch 1/4;
>> (2) the document of ccmni.rst still live in the Documentation/...
>> (3) modify ccmni and move it into the drivers/staging/...
> 
> for drivers/staging/ the code needs to be "self contained" in that it
> does not require adding anything outside of the directory for it.
> 
> If you still require this core networking change, that needs to be
> accepted first by the networking developers and maintainers.
> 
> thanks,
> 
> greg k-h
> 

Hi Greg,

I am grateful for your help.

Both ccmni change and networking changes are needed, because as far
as I know, usually a device type should have at least one device to
use it, and pureip is what the ccmni driver needs, so I uploaded the
networking change and ccmni driver together;

Since MTK’s modem driver has a large amount of code and strong code
coupling, it takes some time to clean up them. At this stage, it may
be difficult to upstream all the codes together.

During this period, even if ccmni is incomplete, can I put the ccmni
driver initial code in the driver/staging first ? After that, we will
gradually implement more functions of ccmni in the staging tree, and
we can also gradually sort out and clean up modem driver in the staging.

In addition, due to the requirements of GKI 2.0, if ccmni device
uses RAWIP or NONE, it will hit ipv6 issue; and if ccmni uses
a device type other than PUREIP/RAWIP/NONE, there will be tethering
ebpf offload or clat ebpf offload can not work problems.

I hope PUREIP and ccmni can be accepted by the Linux community.

Thanks,
Rocco

