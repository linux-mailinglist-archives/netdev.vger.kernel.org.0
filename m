Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1746E1F39
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDNJZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDNJZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:25:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467DB1FD0;
        Fri, 14 Apr 2023 02:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=VM9tH7QSTI+0701/u/I+2lNg6NhoQ4qekGF6MTWfhWE=;
        t=1681464312; x=1682673912; b=pSUfVkEFGQwEn/AkafMqowR5qUmzcSBSOcP/AHNzY33Gt7m
        dxc6yOb7XtMm7JekriELeqq4z/pnvMRFShmObTQqIdHgQSOuFsrNIyYFq2M9gNKjIduTVKMkvWtYb
        WfbZVTwxFXRUlyWArB1g1o+cg3p1NdFIX5O+OsrESXeFHj7SI/E7zfxMcekeRhH9Gu+7GzVHWXeUF
        j7EdTDzDFBzxHul13PXxBNJXLK7j/NtrD7mrIoHX7gRkaTdHrhqhtNpCqYnrClPO8fHgM7uJzc9fM
        MQgkwrl086Dr7szePHS878gNzl2QjKLHXRzoJMTEWDmbIXMeDhSHNLsiT43QN15Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pnFg5-00FWht-2d;
        Fri, 14 Apr 2023 11:25:09 +0200
Message-ID: <9b5c442ce63c885514a833e5b7a422eed19a4314.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] net: extend drop reasons for multiple subsystems
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 14 Apr 2023 11:25:08 +0200
In-Reply-To: <20230331213621.0993e25b@kernel.org>
References: <20230330212227.928595-1-johannes@sipsolutions.net>
         <20230331213621.0993e25b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 21:36 -0700, Jakub Kicinski wrote:
>=20
> > +/* Note: due to dynamic registrations, access must be under RCU */
> > +extern const struct drop_reason_list __rcu *
> > +drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM];
> > +
> > +void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
> > +				  const struct drop_reason_list *list);
> > +void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys=
);
>=20
> dropreason.h is included by skbuff.h because history, but I don't think
> any of the new stuff must be visible in skbuff.h.
>=20
> Could you make a new header, and put as much of this stuff there as
> possible? Our future selves will thank us for shorter rebuild times..

Sure. Not sure it'll make a big difference in rebuild, but we'll see :)

I ended up moving dropreason.h to dropreason-core.h first, that way we
also have a naming scheme for non-core dropreason files should they
become visible outside of the subsystem (i.e. mac80211 just has them
internally).

Dunno, let me know if you prefer something else, I just couldn't come up
with a non-confusing longer name for the new thing.

> Weak preference to also take the code out of skbuff.c but that's not as
> important.

I guess I can create a new dropreason.c, but is that worth it? It's only
a few lines. Let me know, then I can resend.

> You To'd both wireless and netdev, who are you expecting to apply this?
> :S

Good question :)

The first patch (patches in v3) really should go through net-next I
suppose, and I wouldn't mind if the other one did as well, it doesn't
right now touch anything likely to change.

johannes
