Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126144E7D44
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiCYTgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiCYTgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:36:19 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4635E2E5189;
        Fri, 25 Mar 2022 12:09:37 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648232133; bh=0utGQUdnredYmwlCMqdQtSEkBccDpSSgRbC0K8pIlyE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=w6KsBX3PIGQNPBEgDloGd557TP6k0E++rJTP9enh7kdXUK8fIxK8ftlFsszFTkDqJ
         II+Y/Pgar/yJX6LDWXi3wvTO5jwnoNgZPUBUbZFGztXs4kAFdc5WiMPMD2h93vyAIV
         sHpYer3QEiC1v7Dkqh+TuWhgznbszU65z6D+NJ9WsKaIjQHHAgsPnJZY2z8q70XmrP
         onr1kPSQXO6u4FGkY6a53ST6TPH9eOX4hKDjTlEuDECQeSS3kUZihtZUFUgw131lWG
         FJj7lbn92eVVKRfL+qOZXdNSYBzv9KrFNJYpt58jEkoUh7mbwjy6sxdeFvrhyLKA2L
         qB6tWvUxyilfw==
To:     Christoph Hellwig <hch@lst.de>, Halil Pasic <pasic@linux.ibm.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
In-Reply-To: <20220325163204.GB16426@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name>
 <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
 <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
 <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
 <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
 <20220324190216.0efa067f.pasic@linux.ibm.com>
 <20220325163204.GB16426@lst.de>
Date:   Fri, 25 Mar 2022 19:15:32 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y20x7vaz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> On Thu, Mar 24, 2022 at 07:02:16PM +0100, Halil Pasic wrote:
>> > If 
>> > ddbd89deb7d3 alone turns out to work OK then I'd be inclined to try a 
>> > partial revert of just that one hunk.
>> >
>> 
>> I'm not against being pragmatic and doing the partial revert. But as
>> explained above, I do believe for correctness of swiotlb we ultimately
>> do need that change. So if the revert is the short term solution,
>> what should be our mid-term road-map?
>
> Unless I'm misunderstanding this thread we found the bug in ath9k
> and have a fix for that now?

According to Maxim's comment on the other subthread, that ath9k patch
wouldn't work on all platforms (and constitutes a bit of a violation of
the DMA API ownership abstraction). So not quite, I think?

-Toke
