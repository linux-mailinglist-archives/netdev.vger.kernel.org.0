Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64286CF291
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjC2S5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjC2S5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:57:31 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA31D5251;
        Wed, 29 Mar 2023 11:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=pM8ulVGVCx+HFUHyjXmlEYig7gRCScbLpQSmmvC68OE=;
        t=1680116250; x=1681325850; b=PNw3S6f8ByRabHV3al6YN41hitZvJt2utF+nsLvW55Dcga3
        6zpzke5bUD+5tOG97d3WLaszWhFv0BrZcuDESsmdDRdE/dqhznSnszH2WvEkdUA0eduG3ReKUMoyb
        hS25FVf8G0+YGU+nRMJ1oVu7bkpjGl3uhM4X74h1TgA6OzdKeWACzMXwLjYIRJuE8RyjVjuEAWCU1
        FYQm4XFASgYfqzeJASV7/+9YuO2u5glqzpoF7T+VMpC3lUBFvWt8WoGNhdE+rpegTHvJKFtM4resk
        /SWuYI4PqU/GtQuEnt0FfqTkCEoRjEMVQSD7W9uy0cRYVLjprctE6zcl7pOENk3g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phaz9-000CVe-1i;
        Wed, 29 Mar 2023 20:57:27 +0200
Message-ID: <37311ab0f31d719a65858de31cec7a840cf8fe40.camel@sipsolutions.net>
Subject: Re: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Wed, 29 Mar 2023 20:57:26 +0200
In-Reply-To: <20230329110205.1202eb60@kernel.org>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
         <20230327180950.79e064da@kernel.org>
         <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
         <20230328155826.38e9e077@kernel.org>
         <8304ec7e430815edf3b79141c90272e36683e085.camel@sipsolutions.net>
         <20230329110205.1202eb60@kernel.org>
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

On Wed, 2023-03-29 at 11:02 -0700, Jakub Kicinski wrote:
>=20
> No, no what I was trying to say is that instead of using the upper bits
> to identify the space (with 0 being the current enum skb_drop_reason)
> we could use entries in enum skb_drop_reason. In hope that it'd make
> the fine grained subsystem reason seem more like additional information
> than a completely parallel system.

Ah! Looking at your code example ... right, so you'd see "mac80211 drop
unusable" or "mac80211 drop to monitor", and fine-grained in the higher
bits.

> But it's just a thought, all of the approaches seem acceptable.

I _think_ I like the one I prototyped this morning better, I'm not sure
I like the subsystem =3D=3D existing reason part _that_ much. It ultimately
doesn't matter much, it just feels odd that you'd be allowed to have a,
I don't know picking a random example, SKB_DROP_REASON_DUP_FRAG with a
fine-grained higher bits value?

Not that we'll ever be starved for space ...

> Quick code change perhaps illustrates it best:
>=20

Yeah, that ends up really looking very similar :-)

Then again thinking about the implementation, we'd not be able to use a
simple array for the sub-reasons, or at least that'd waste a bunch of
space, since there are already quite a few 'main' reasons and we'd
want/need to add the mac80211 ones (with sub-reason) at the end. So that
makes a big array for the sub-reasons that's very sparsely populated (*)
Extending with a high 'subsystem' like I did this morning is more
compact here.

(*) or put the sub-reasons pointer/num with the 'main' reasons into the
drop_reasons[] array but that would take the same additional space


So ... which one do _you_ like better? I think I somewhat prefer the one
with adding a high bits subsystem, but I can relatively easily rejigger
my changes from this morning to implement the semantics you had here
too.

Anyone else have an opinion? :)

johannes
