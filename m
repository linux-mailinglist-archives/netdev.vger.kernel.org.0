Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CA06F0A69
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244135AbjD0RA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbjD0RA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:00:57 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C5110DC;
        Thu, 27 Apr 2023 10:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=VY35CR0N+ZDTgEcRw5IUuyTLgtNiCtDZ/FIVsL1y6PM=; b=IyEXV1IrvDNYBhMp8VbJm9h2sY
        vuqxYwjjCDOs+hrN0dXCufM/8KHB6lZowlIwIoueLR4nfON1ikjtCcYmSrzAm2t6CAcl/xxrERr2U
        iMhnjGnFYxmXGQE4yueCE4CLLj1/7eWDS8BhNizWjGdqnNY20UPcr82hRYvHw2nkBAJ/3WldFOnaH
        rpaxw75v3rZE/MR0PccJPokoNiNtpgNDXHv0q4AiY8gnKMLwb/aSys3yYuGrLig0lzGTfKIw5vcWw
        aeLfssMRAxsoHIgozihQUDkL8S2OI4EkAhBcAVRfmfBHCOh0aYc65jCQl7D5xNE82QyMSOjKXEM/K
        Z+haDrVQ==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1ps4z6-000JZO-Kc; Thu, 27 Apr 2023 19:00:44 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ps4z5-000QuO-Us; Thu, 27 Apr 2023 19:00:43 +0200
Subject: Re: [PATCH bpf-next V2 1/5] igc: enable and fix RX hash usage by
 netstack
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, davem@davemloft.net,
        bpf@vger.kernel.org
Cc:     brouer@redhat.com, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        yoong.siang.song@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com,
        Stanislav Fomichev <sdf@google.com>, kuba@kernel.org,
        edumazet@google.com, hawk@kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <168182464270.616355.11391652654430626584.stgit@firesoul>
 <644544b3206f0_19af02085e@john.notmuch>
 <622a8fa6-ec07-c150-250b-5467b0cddb0c@redhat.com>
 <6446d5af80e06_338f220820@john.notmuch>
 <e6bc2340-9cb5-def1-b347-af25ce2f8225@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86517b44-b998-a4ac-da13-1f30d5f69975@iogearbox.net>
Date:   Thu, 27 Apr 2023 19:00:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e6bc2340-9cb5-def1-b347-af25ce2f8225@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26889/Thu Apr 27 09:25:48 2023)
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/23 10:43 AM, Jesper Dangaard Brouer wrote:
> On 24/04/2023 21.17, John Fastabend wrote:
>>>> Just curious why not copy the logic from the other driver fms10k, ice, ect.
>>>>
>>>>     skb_set_hash(skb, le32_to_cpu(rx_desc->wb.lower.hi_dword.rss),
>>>>              (IXGBE_RSS_L4_TYPES_MASK & (1ul << rss_type)) ?
>>>>              PKT_HASH_TYPE_L4 : PKT_HASH_TYPE_L3);
>>> Detail: This code mis-categorize (e.g. ARP) PKT_HASH_TYPE_L2 as
>>> PKT_HASH_TYPE_L3, but as core reduces this further to one SKB bit, it
>>> doesn't really matter.
>>>
>>>> avoiding the table logic. Do the driver folks care?
>>> The define IXGBE_RSS_L4_TYPES_MASK becomes the "table" logic as a 1-bit
>>> true/false table.  It is a more compact table, let me know if this is
>>> preferred.
>>>
>>> Yes, it is really upto driver maintainer people to decide, what code is
>>> preferred ?
>  >
>> Yeah doesn't matter much to me either way. I was just looking at code
>> compared to ice driver while reviewing.
> 
> My preference is to apply this patchset. We/I can easily followup and
> change this to use the more compact approach later (if someone prefers).

Consistency might help imo and would avoid questions/confusion on /why/
doing it differently for igc vs some of the others.

> I know net-next is "closed", but this patchset was posted prior to the
> close.  Plus, a number of companies are waiting for the XDP-hint for HW
> RX timestamp.  The support for driver stmmac is already in net-next
> (commit e3f9c3e34840 ("net: stmmac: add Rx HWTS metadata to XDP receive
> pkt")). Thus, it would be a help if both igc+stmmac changes land in same
> kernel version, as both drivers are being evaluated by these companies.

Given merge window is open now and net-next closed, it's too late to land
(unless Dave/Jakub thinks otherwise given it touches also driver bits).
I've applied the series to bpf-next right now.

Thanks,
Daniel
