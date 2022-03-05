Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC54CE319
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiCEFkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCEFkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:40:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3508CADD67;
        Fri,  4 Mar 2022 21:40:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C70A060A6F;
        Sat,  5 Mar 2022 05:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83642C340EE;
        Sat,  5 Mar 2022 05:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646458802;
        bh=6DhOwJx5m+Etdnfg4q7LUPFaVS97iP6TaGZP2zeFvZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aw1iEaPaNE6rO2cxFNyohcnCrsOnTFPxHyrovQO/up2h1VckyiNPIhtzkQSuXbgxk
         2B+4vy1Oc7193yf4ndm9og/pk4V3BBSl0uHxkkRwYy08lzt51BwJehizRaJTiDWAS7
         ix7x09/mDUC1iQGUClusydJLAsVF85hL8u+fvZvNp3xNsUxG4OuzGgHquLClRNVx0O
         e2tFkn5OFl6ATWD3xGrF7z4h+X+P/bbgeBczdfZpmJB8plKtUrchaktkusTx6LXAFz
         df+obcRewhOeroq+6OwUJSApYj3HyT7PHr6sLtMhPHSyHmxov3DbEaxdBrPUH7h3Df
         lNB1dhWSMBv2Q==
Date:   Fri, 4 Mar 2022 21:40:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v2 net-next] net-core: add rx_otherhost_dropped counter
Message-ID: <20220304214000.597c7165@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMzD94SRmG12Zot+eZTDcSDaviceBqn6egCdGZBoy_cbJLa5xw@mail.gmail.com>
References: <20220303003034.1906898-1-jeffreyjilinux@gmail.com>
        <CAMzD94SRmG12Zot+eZTDcSDaviceBqn6egCdGZBoy_cbJLa5xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Mar 2022 13:59:58 -0800 Brian Vazquez wrote:
> LGTM, thanks Jeffrey!
> 
> Reviewed-by: Brian Vazquez <brianvv@google.com>

Please keep Brian's review tag..

> On Wed, Mar 2, 2022 at 4:30 PM Jeffrey Ji <jeffreyjilinux@gmail.com> wrote:
> >
> > From: jeffreyji <jeffreyji@google.com>
> >
> > Increment rx_otherhost_dropped counter when packet dropped due to
> > mismatched dest MAC addr.
> >
> > An example when this drop can occur is when manually crafting raw
> > packets that will be consumed by a user space application via a tap
> > device. For testing purposes local traffic was generated using trafgen
> > for the client and netcat to start a server
> >
> > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > with "{eth(daddr=$INCORRECT_MAC...}", verified that iproute2 showed the
> > counter was incremented. (Also had to modify iproute2 to show the stat,
> > additional patch for that coming next.)
> >
> > changelog:
> >
> > v2: add kdoc comment

move the changelog under the '---' separator

> > Signed-off-by: jeffreyji <jeffreyji@google.com>
> > ---
> >  include/linux/netdevice.h    | 3 +++
> >  include/uapi/linux/if_link.h | 5 +++++
> >  net/core/dev.c               | 2 ++
> >  net/ipv4/ip_input.c          | 1 +
> >  net/ipv6/ip6_input.c         | 1 +
> >  5 files changed, 12 insertions(+)

> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index e315e53125f4..17e74385fca8 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -211,6 +211,9 @@ struct rtnl_link_stats {
> >   * @rx_nohandler: Number of packets received on the interface
> >   *   but dropped by the networking stack because the device is
> >   *   not designated to receive packets (e.g. backup link in a bond).
> > + *
> > + * @rx_otherhost_dropped: Number of packets dropped due to mismatch in
> > + * packet's destination MAC address.
> >   */
> >  struct rtnl_link_stats64 {
> >         __u64   rx_packets;
> > @@ -243,6 +246,8 @@ struct rtnl_link_stats64 {
> >         __u64   rx_compressed;
> >         __u64   tx_compressed;
> >         __u64   rx_nohandler;
> > +
> > +       __u64   rx_otherhost_dropped;
> >  };
> >
> >  /* The struct should be in sync with struct ifmap */

rebase on latest net-next/master and repost. 

Looks like it's conflicting with recently merged 
commit 9309f97aef6d ("net: dev: Add hardware stats support")
