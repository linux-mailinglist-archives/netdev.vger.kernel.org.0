Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081745899BE
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbiHDJNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiHDJNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:13:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BA061D67;
        Thu,  4 Aug 2022 02:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D4A4B82447;
        Thu,  4 Aug 2022 09:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337A7C433C1;
        Thu,  4 Aug 2022 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659604399;
        bh=IIE9Abyf1eiQoqzflF7AVfJj666NiWeX1LObw1zMpto=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BnBdTUWvgV1SomEAjzAqjbzrTqsM8+zQaDo7eg9ZFIG5lj2d5DC3ds4DsX6qFEihw
         Uz6pMAVvhhsWXA+1ItggOQrgQkQX4WJGNUy+8cx3UsMliH7PEvWNl53rW3ZJhZ4jfS
         0XFzhUzLpLzrzi3xhbxGuYhviCZKYmpF3BHLS3ZxDOXW/fhSlIYuYqsaD4HUp2qG/j
         upd5G8R6i51Tobsqeo2hJC1/HyV/qChEBzog8+GbIJzzXPZ+aVTdnGNa8vExs3fsYU
         WgQihjuFL/v16gVFUttvASXlwxZEZ++4daFhS3NcMPFg+vVhreXHQmnPhsNjDQUjO5
         fqGZ1it0Bu0og==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <aspriel@gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
References: <20220803101438.24327-1-pabeni@redhat.com>
        <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
Date:   Thu, 04 Aug 2022 12:13:12 +0300
In-Reply-To: <CAHk-=wjhSSHM+ESVnchxazGx4Vi0fEfmHpwYxE45JZDSC8SUAQ@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 3 Aug 2022 21:17:07 -0700")
Message-ID: <87les4id7b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Hmm. Another issue with the networking pull..
>
> On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0
>>
>> Veerendranath Jakkam (5):
>>       cfg80211: Indicate MLO connection info in connect and roam callbacks
>
> This one added a
>
>                 for_each_valid_link(cr, link) {
>                         if (WARN_ON_ONCE(!cr->links[link].bss))
>                                 break;
>                 }
>
> in net/wireless/sme.c, and it seems to trigger on my brand new M2 Macbook Air.
>
> Wireless still works fine (I'm writing this report on the machine),
> but you get a scary splat:
>
>   WARNING: CPU: 5 PID: 514 at net/wireless/sme.c:786
> __cfg80211_connect_result+0x2fc/0x5c0 [cfg80211]
>
> full call trace etc in the attachment.

Thanks for the report, adding also Arend and changing Johannes' email.
Unfortunately Johannes is away this week. Arend, would you be able to
look at this? I don't have any brcmfmac hardware.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
