Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C743484ED
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 23:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhCXWun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 18:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbhCXWuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 18:50:32 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356CAC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 15:50:32 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4F5Njw1hDZzQjx4;
        Wed, 24 Mar 2021 23:50:28 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1616626226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eD2fAF4yzvFfv6huN60Xq2me2bdjrseoFf9r2ma+EXY=;
        b=jKOcva94CsPt1X8jaosATFWr0AH0YnfDtvDjsB7k+TWZJntypirYpyE4I5nkIDfO8dLwIU
        hFkVxD17cN8/+6tAYYuq8XKEfvD6e6pFFjxNBeqX5vvPWgRdr5DgPM3gZNusTZYZ4yUicP
        oKH785mTXF2t1cja208nXgDbKW3sv5zLaYCpyqJo0UKGvj36bzOIu3EzzWlqAcTZPW+36b
        7dBu5i9yUP+JSJOGwEcatmxTjlgLKsGk/Rb/luhzOfqeFS7v+fnDTBnfatbOYwFAJdHK8L
        yX4Lh5ASeYtd/zzAn40rli1kIEZ903zIBUYk/89M23E+tbbOIUuRltUpnj4OmA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id 7nPiudxEYOm7; Wed, 24 Mar 2021 23:50:24 +0100 (CET)
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
References: <CAFBinCArx6YONd+ohz76fk2_SW5rj=VY=ivvEMsYKUV-ti4uzw@mail.gmail.com>
 <20210324201331.camqijtggfbz7c3f@skbuf>
 <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: lantiq_xrx200: Ethernet MAC with multiple TX queues
Message-ID: <d354b9b3-5421-4018-c7ae-d0784d9ff163@hauke-m.de>
Date:   Wed, 24 Mar 2021 23:50:23 +0100
MIME-Version: 1.0
In-Reply-To: <874dd389-dd67-65a6-8ccc-cc1d9fa904a2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: ****
X-Rspamd-Score: 4.65 / 15.00 / 15.00
X-Rspamd-Queue-Id: 3BEE217E2
X-Rspamd-UID: f6a44b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 10:09 PM, Florian Fainelli wrote:
> 
> 
> On 3/24/2021 1:13 PM, Vladimir Oltean wrote:
>> Hi Martin,
>>
>> On Wed, Mar 24, 2021 at 09:04:16PM +0100, Martin Blumenstingl wrote:
>>> Hello,
>>>
>>> the PMAC (Ethernet MAC) IP built into the Lantiq xRX200 SoCs has
>>> support for multiple (TX) queues.
>>> This MAC is connected to the SoC's built-in switch IP (called GSWIP).
>>>
>>> Right now the lantiq_xrx200 driver only uses one TX and one RX queue.
>>> The vendor driver (which mixes DSA/switch and MAC functionality in one
>>> driver) uses the following approach:
>>> - eth0 ("lan") uses the first TX queue
>>> - eth1 ("wan") uses the second TX queue
>>>
>>> With the current (mainline) lantiq_xrx200 driver some users are able
>>> to fill up the first (and only) queue.
>>> This is why I am thinking about adding support for the second queue to
>>> the lantiq_xrx200 driver.
>>>
>>> My main question is: how do I do it properly?
>>> Initializing the second TX queue seems simple (calling
>>> netif_tx_napi_add for a second time).
>>> But how do I choose the "right" TX queue in xrx200_start_xmit then?
> 
> If you use DSA you will have a DSA slave network device which will be
> calling into dev_queue_xmit() into the DSA master which will be the
> xrx200 driver, so it's fairly simple for you to implement a queue
> selection within the xrx200 tagger for instance.
> 
> You can take a look at how net/dsa/tag_brcm.c and
> drivers/net/ethernet/broadcom/bcmsysport.c work as far as mapping queues
> from the DSA slave network device queue/port number into a queue number
> for the DSA master.
> 

Hi,

The PMAC in the xrx200 has 4 TX queues and 8 RX queues. We can not map 
one queue to each port as there are more ports than queues. I am also 
unsure if the DSL part which is using an out of tree driver uses some of 
these DMA resources.

Is it possible to configure a mapping between a DSA bridge and a queue 
on the mater device with tc from user space? We could expose these 4 TX 
queues on the mac driver to Linux and then Linux configure somehow a 
mapping between ports or bridges and queues.

Hauke
