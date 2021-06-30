Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24C3B881E
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhF3SEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhF3SEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:04:06 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB1FC061756;
        Wed, 30 Jun 2021 11:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wcqLX5G5gEQMyvWZUZxUtldt7pffWzSGJmMUAEnc36E=; b=swg6Phuyki4q/bORDX6mwqYixy
        FISHlrpbI85yA0g0F5C9SSLbv00DCPG8TFkCOkMgmHoh7CjJ35n3PNDRZgwlup8TyuiRHTGx1Dy2N
        ABGxSxaZ8NkArIe6OS+vr9PjNXJymUTzCFzis78XhXNwjMk6CkoRU9Pg225k/SiQrQ8U=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lyeWi-0002UQ-TL; Wed, 30 Jun 2021 20:01:32 +0200
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Davis <davikovs@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
 <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name> <YNtdKb+2j02fxfJl@kroah.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name>
Date:   Wed, 30 Jun 2021 20:01:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YNtdKb+2j02fxfJl@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-29 19:49, Greg Kroah-Hartman wrote:
> On Tue, Jun 29, 2021 at 07:26:03PM +0200, Felix Fietkau wrote:
>> 
>> Hi,
>> 
>> On 2021-06-29 06:48, Davis wrote:
>> > Greetings!
>> > 
>> > Could it be possible that
>> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.12.13&id=a8c4d76a8dd4fb9666fc8919a703d85fb8f44ed8
>> > or at least its backport to 4.4 has the potential for memory
>> > corruption due to incorrect pointer calculation?
>> > Shouldn't the line:
>> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
>> > be:
>> >   struct ethhdr *ehdr = (struct ethhdr *) skb->data;
>> > 
>> > Later ehdr->h_dest is referenced, read and (when not equal to expected
>> > value) written:
>> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
>> >       !ether_addr_equal(ehdr->h_dest, sdata->vif.addr)))
>> >     ether_addr_copy(ehdr->h_dest, sdata->vif.addr);
>> > 
>> > In my case after cherry-picking
>> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.4.273&id=e3d4030498c304d7c36bccc6acdedacf55402387
>> > to 4.4 kernel of an ARM device occasional memory corruption was observed.
>> > 
>> > To investigate this issue logging was added - the pointer calculation
>> > was expressed as:
>> >   struct ethhdr *ehdr = (void *)skb_mac_header(skb);
>> >   struct ethhdr *ehdr2 = (struct ethhdr *) skb->data;
>> > and memory writing was replaced by logging:
>> >   if (unlikely(skb->protocol == sdata->control_port_protocol &&
>> >       (!ether_addr_equal(ehdr->h_dest, sdata->vif.addr) ||
>> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr))))
>> >     printk(KERN_ERR "Matching1: %u, matching2: %u, addr1: %px, addr2:
>> > %px", !ether_addr_equal(ehdr->h_dest, sdata->vif.addr),
>> > !ether_addr_equal(ehdr2->h_dest, sdata->vif.addr), ehdr->h_dest,
>> > ehdr2->h_dest);
>> > 
>> > During normal use of wifi (in residential environment) logging was
>> > triggered several times, in all cases matching1 was 1 and matching2
>> > was 0.
>> > This makes me think that normal control frames were received and
>> > correctly validated by !ether_addr_equal(ehdr2->h_dest,
>> > sdata->vif.addr), however !ether_addr_equal(ehdr->h_dest,
>> > sdata->vif.addr) was checking incorrect buffer and identified the
>> > frames as malformed/correctable.
>> > This also explains memory corruption - offset difference between both
>> > buffers (addr1 and addr2) was close to 64 KB in all cases, virtually
>> > always a random memory location (around 64 KB away from the correct
>> > buffer) will belong to something else, will have a value that differs
>> > from the expected MAC address and will get overwritten by the
>> > cherry-picked code.
>> It seems that the 4.4 backport is broken. The problem is the fact that
>> skb_mac_header is called before eth_type_trans(). This means that the
>> mac header offset still has the default value of (u16)-1, resulting in
>> the 64 KB memory offset that you observed.
>> 
>> I think that for 4.4, the code should be changed to use skb->data
>> instead of skb_mac_header. 4.9 looks broken in the same way.
>> 5.4 seems fine, so newer kernels should be fine as well.
> 
> Thanks for looking into this, can you submit a patch to fix this up in
> the older kernel trees?
Sorry, I don't have time to prepare and test the patches at the moment.

- Felix
