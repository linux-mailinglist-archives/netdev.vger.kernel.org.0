Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8983B772D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhF2R2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhF2R2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:28:35 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3642C061760;
        Tue, 29 Jun 2021 10:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:Cc:From:References:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AOushszHu5ObfXbLP9p4RXQc/aXFhbSNGGH/KTIl1EY=; b=JKSYz1SuRpHGX3wTr0CIwgVeDb
        WrFZt5r8EuLIGzivo6czR2/LR6VTTUsimjK5pPGjlGQSgr24n0DvceeyJnKg2M4E0F4P6W4pa0kAe
        +Z1SnAcG2VzWz2S0e48o1teDZphd/zKrY+CfGed2l9yXOAP+KR0U8PjaBH1kL7yaWuus=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lyHUp-0007j8-RS; Tue, 29 Jun 2021 19:26:03 +0200
To:     Davis <davikovs@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
Message-ID: <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name>
Date:   Tue, 29 Jun 2021 19:26:03 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

On 2021-06-29 06:48, Davis wrote:
> Greetings!
> 
> Could it be possible that
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.12.13&id=a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8
> or at least its backport to 4.4 has the potential for memory
> corruption due to incorrect pointer calculation?
> Shouldn't the line:
>   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
> be:
>   struct ethhdr *ehdr = (struct ethhdr *) skb->data;
> 
> Later ehdr->h_dest is referenced, read and (when not equal to expected
> value) written:
>   if (unlikely(skb->protocol == sdata->control_port_protocol &&
>       !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
>     ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
> 
> In my case after cherry-picking
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.273&id=e3d4030498c304d7c36bccc6acdedacf55402387
> to 4.4 kernel of an ARM device occasional memory corruption was observed.
> 
> To investigate this issue logging was added - the pointer calculation
> was expressed as:
>   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
>   struct ethhdr *ehdr2 = (struct ethhdr *) skb->data;
> and memory writing was replaced by logging:
>   if (unlikely(skb->protocol == sdata->control_port_protocol &&
>       (!ether_addr_equal(ehdr->h_dest, sdata->vif.addr) ||
> !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr))))
>     printk(KERN_ERR "Matching1: %u, matching2: %u, addr1: %px, addr2:
> %px", !ether_addr_equal(ehdr->h_dest, sdata->vif.addr),
> !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr), ehdr->h_dest,
> ehdr2->h_dest);
> 
> During normal use of wifi (in residential environment) logging was
> triggered several times, in all cases matching1 was 1 and matching2
> was 0.
> This makes me think that normal control frames were received and
> correctly validated by !ether_addr_equal(ehdr2->h_dest,
> sdata->vif.addr), however !ether_addr_equal(ehdr->h_dest,
> sdata->vif.addr) was checking incorrect buffer and identified the
> frames as malformed/correctable.
> This also explains memory corruption - offset difference between both
> buffers (addr1 and addr2) was close to 64 KB in all cases, virtually
> always a random memory location (around 64 KB away from the correct
> buffer) will belong to something else, will have a value that differs
> from the expected MAC address and will get overwritten by the
> cherry-picked code.
It seems that the 4.4 backport is broken. The problem is the fact that
skb_mac_header is called before eth_type_trans(). This means that the
mac header offset still has the default value of (u16)-1, resulting in
the 64 KB memory offset that you observed.

I think that for 4.4, the code should be changed to use skb->data
instead of skb_mac_header. 4.9 looks broken in the same way.
5.4 seems fine, so newer kernels should be fine as well.

- Felix
