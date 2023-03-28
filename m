Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867336CB92E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjC1ITF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjC1ITC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:19:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB84C27;
        Tue, 28 Mar 2023 01:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yr41f9OaW6GBOKNvZ668MEYtnEem+75Xrjr4jNlL+ts=;
        t=1679991534; x=1681201134; b=Q7GndPERV1JfPEhUFMLEmAUbczc1Xgu8oQfZahJQ9yWPoVL
        K+HTPs5cQFuwUuyyXH2Iu05lMX1tJpuBK7wruW3Bs/igk9wpgQkXCXowwGE5ueXATKdpVquXTNXHj
        mDZ4IAIPOhgJqw5E/Lix4YSQuY7gHIHGuLd5tcKdcIu+lN3Jat0lhfUpxgjno8zxapPxCJ4zeQb9n
        zdxsZw1Jn5Ry57LW81NkkQ5sNglIICtSMryhFBIEXApOKD+0QFdsXC1Zai4zjB2Ycjq8cUCs8xVJ+
        RB4c4883/0AREcxcFLBWw7AT21vZ7S5r3qCUYV4jzvZdBsmIb/mCjQxVyam3bkuA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ph4Xc-00Gbrk-0o;
        Tue, 28 Mar 2023 10:18:52 +0200
Message-ID: <d21a2b2cd2e83d91173dc8952871fc734fa40155.camel@sipsolutions.net>
Subject: Re: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Tue, 28 Mar 2023 10:18:51 +0200
In-Reply-To: <CANn89iJn6xmCK8VfJVAqhod9C=nNrqR6OprYKbWO-rrZXxoe_g@mail.gmail.com>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
         <20230327180950.79e064da@kernel.org>
         <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
         <CANn89iJn6xmCK8VfJVAqhod9C=nNrqR6OprYKbWO-rrZXxoe_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-28 at 01:16 -0700, Eric Dumazet wrote:
>=20
> About visibility: Even before 'drop reasons' developers can always use
> the call graph .
>=20
> perf record -a -g -e skb:kfree_skb ...

Yeah, except right now it doesn't work in mac80211 because we have these
"RX handlers" that just return a status, and then a single place drops
the skb.

> Really drop reasons are nice when you want filtering and convenience.
> But they are a lot of work to add/maintain.
> This all comes at a cost (both maintenance but also run time cost
> because we need to propagate reasons )

Right ... I don't think the runtime cost would be much of an issue here
(we just get them as a return value from one function to pass to
kfree_skb), but the maintenance is hard.

I guess we could also restructure the code to call kfree_skb() in all
those places that want drop it and then we have the call trace, but I
doubt that would actually be cheaper both in the maintenance sense
(always need to pay attention to it) or in the runtime sense.

johannes
