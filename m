Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27323FD704
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKOHgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:36:25 -0500
Received: from fd.dlink.ru ([178.170.168.18]:45614 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOHgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 02:36:25 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id 5F79F1B21219; Fri, 15 Nov 2019 10:36:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 5F79F1B21219
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1573803379; bh=auYJSdX39uan+gvUCsaNo2NaaQLgfRyrUszL7DhJUb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=SfuWrd47XdQioLUmZkIhQ3OMs+HeaDWSatiVwQEdzY6ZWJg2pT1l1h5EpRzPJOv1V
         iwF6IOh6Wr3/0/ynRcejg8zch7KZVc5GEmUbQMUJVgrUDcjeky25QHC4/jtsEcdxeX
         QQyOIe6XZqOm2o6R0+fxyLS063xmDUIB+DB8uGYo=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id D61961B203C6;
        Fri, 15 Nov 2019 10:36:08 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru D61961B203C6
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 9C6611B21209;
        Fri, 15 Nov 2019 10:36:08 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 15 Nov 2019 10:36:08 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 15 Nov 2019 10:36:08 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: allow fast GRO for skbs with Ethernet
 header in head
In-Reply-To: <20191114.172508.1027995193093100862.davem@davemloft.net>
References: <20191112122843.30636-1-alobakin@dlink.ru>
 <20191114.172508.1027995193093100862.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <097eb720466a7c429c8fd91c792e7cd5@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

David Miller wrote 15.11.2019 04:25:

> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Tue, 12 Nov 2019 15:28:43 +0300
> 
>> Commit 78d3fd0b7de8 ("gro: Only use skb_gro_header for completely
>> non-linear packets") back in May'09 (2.6.31-rc1) has changed the
>> original condition '!skb_headlen(skb)' to the current
>> 'skb_mac_header(skb) == skb_tail_pointer(skb)' in gro_reset_offset()
>> saying: "Since the drivers that need this optimisation all provide
>> completely non-linear packets".
> 
> Please reference the appropriate SHA1-ID both here in this paragraph 
> and
> also in an appropriate Fixes: tag.

Sorry for confusing. The SHA1-ID from commit message is correct
actually. At the moment of 2.6.31 we used skb->mac_header and skb->tail
pointers directly, so the original condition was
'skb->mac_header == skb->tail'.
Commit ced14f6804a9 ("net: Correct comparisons and calculations using
skb->tail and skb-transport_header") has changed this condition to
the referred 'skb_mac_header(skb) == skb_tail_pointer(skb)' without
any functional changes.
I didn't add the "Fixes:" tag because at the moment of 2.6.31 it was
a needed change, but it became obsolete later, so now we can revert
it back to speed up skbs with only Ethernet header in head.
Please let me know if I must send v2 of this patch with corrected
description before getting any further reviews.

Thanks.

> If this goes so far back that it is before GIT, then you need to 
> provide
> a reference to the patch posting via lore.kernel.org or similar because
> it is absolutely essentialy for people reviewing this patch to be able
> to do some digging into why the condition is code the way that it is
> currently.
> 
> Thank you.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
