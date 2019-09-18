Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4AAB6CA3
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbfIRTb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 15:31:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfIRTb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 15:31:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 490C561515; Wed, 18 Sep 2019 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568835087;
        bh=GQ9PWHWoNFmoNwP5Ff8xmLoLlYzHhmoeyH7kt5bWxlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DoW2evWrM0ixe8eQE/GaN1BFm/PidoR0huH+O7qc4Lj5IMlgEWMHMo/4Wv9WxGfbm
         fGOEFRRmiZ0yQ3gZbym1bqhzJZplIJixNTaELwRKcE1L2pWNEMMIlroDrqkjcFwU/V
         F+dTsgb8idv1zjnWwSKt2OK47hdGL9Czqdp3cUr0=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 4E00B602F2;
        Wed, 18 Sep 2019 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568835086;
        bh=GQ9PWHWoNFmoNwP5Ff8xmLoLlYzHhmoeyH7kt5bWxlY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IhwungRmSNTm2D8wKL2dj3iY5z1JBPtqZB9ktJRU4rDAwhzKzEUTnbIVupngRlHMM
         LPQVvw8Vd+1tnUtWdvi7gMnDTq0eTTV3HK88tYL1wzvi4NQZIPGkbOrRxuK9fP0Vcx
         ljb9bwEoms7IHgrfCRS0Yu0RE1CNoqsx+7wJ8Sac=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Sep 2019 13:31:26 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
In-Reply-To: <20190918165817.GA3431@localhost.localdomain>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190918165817.GA3431@localhost.localdomain>
Message-ID: <621219c0a965d6ccc05b80081218ff7e@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-09-18 10:58, Marcelo Ricardo Leitner wrote:
> On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
>> On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
>> <steffen.klassert@secunet.com> wrote:
>> >
>> > This patchset adds support to do GRO/GSO by chaining packets
>> > of the same flow at the SKB frag_list pointer. This avoids
>> > the overhead to merge payloads into one big packet, and
>> > on the other end, if GSO is needed it avoids the overhead
>> > of splitting the big packet back to the native form.
>> >
>> > Patch 1 Enables UDP GRO by default.
>> >
>> > Patch 2 adds a netdev feature flag to enable listifyed GRO,
>> > this implements one of the configuration options discussed
>> > at netconf 2019.
>> >
>> > Patch 3 adds a netdev software feature set that defaults to off
>> > and assigns the new listifyed GRO feature flag to it.
>> >
>> > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
>> >
>> > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
>> > GRO supported socket is found.
>> 
>> Very nice feature, Steffen. Aside from questions around performance,
>> my only question is really how this relates to GSO_BY_FRAGS.
> 
> They do the exact same thing AFAICT: they GSO according to a
> pre-formatted list of fragments/packets, and not to a specific size
> (such as MSS).
> 
>> 
>> More specifically, whether we can remove that in favor of using your
>> new skb_segment_list. That would actually be a big first step in
>> simplifying skb_segment back to something manageable.
> 
> The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
> dealing with frags instead of frag_list was considered easier to be
> offloaded, if ever attempted.  So this would be a step back on that
> aspect.  Other than this, it should be doable.

Is there an existing userspace interface for GSO_BY_FRAGS for UDP?
Per my understanding, the current UDP_GSO CMSG option only allows
for a specific GSO_SIZE segmentation.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
