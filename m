Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C742D6102CD
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236370AbiJ0Ugn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbiJ0Ugl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:36:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53268792EB;
        Thu, 27 Oct 2022 13:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=MzB2rQ75d5Tt6rhAeYw/tTRK8zQ3E14+m3BrqpNczI0=;
        t=1666903000; x=1668112600; b=RoEoNYGlw3mh/iWEtMAc2tp0p3KUjqtXyREcg5k1GcIRLyJ
        Vuq7XFeg83qOgsK8d3pnqzkB4kf0W7LSk2kmyskpVVj10yYvFOi6GdobswO4GBFeuoiQmBqjyOV2y
        fRM2LpbeQMe6UzJQqTc9JXU8v7nDvMY4E3mTE8+rUsSFyus0JuYGHaQChOoWKhqJK7BzupxjZtIh3
        cQDgf6AWTA1x/epsbkNF81tvv3hiMw3IjGMB75LxBP9wIJcOOAbk3MFzY9VZ7hSp8EsdnFzjOcfAy
        orrW2Ri4P/i3kMHb4TrPr3P0tMZvyaFUjyVkuG4vFhuMMuL3MBUaWZToUEoxm6lA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oo9cA-000aU0-0l;
        Thu, 27 Oct 2022 22:36:34 +0200
Message-ID: <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Date:   Thu, 27 Oct 2022 22:36:33 +0200
In-Reply-To: <20221027133109.590bd74f@kernel.org>
References: <20220905100937.11459-1-fw@strlen.de>
         <20220905100937.11459-2-fw@strlen.de> <20221027133109.590bd74f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-27 at 13:31 -0700, Jakub Kicinski wrote:
> On Mon,  5 Sep 2022 12:09:36 +0200 Florian Westphal wrote:
> >  		struct {
> >  			s16 min, max;
> > +			u8 network_byte_order:1;
> >  		};
>=20
> This makes the union 64bit even on 32bit systems.
> Do we care? Should we accept that and start using
> full 64bits in other validation members?
>=20
> We can quite easily steal a bit elsewhere, which
> I reckon may be the right thing to do, but I thought
> I'd ask.

Personally, I guess I might have preferred to steal a bit out of the
type or validation_type. We have a lot of these structures... and I'd
guess 32-bit systems are typically more memory constrained.

In fact we could easily just have three extra types NLA_BE16, NLA_BE32
and NLA_BE64 types without even stealing a bit? We already have
NLA_MSECS which is basically the same as NLA_U64 but just with the
additional semantic information, for example.

johannes
