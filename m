Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC43681F8F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 00:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjA3XXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 18:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjA3XXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 18:23:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856BF8691;
        Mon, 30 Jan 2023 15:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D7B612E4;
        Mon, 30 Jan 2023 23:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DD1C433EF;
        Mon, 30 Jan 2023 23:23:18 +0000 (UTC)
Date:   Mon, 30 Jan 2023 18:23:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/16] net: bridge: Add a tracepoint for MDB
 overflows
Message-ID: <20230130182316.53d787ac@gandalf.local.home>
In-Reply-To: <87ilgof20x.fsf@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
        <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
        <20230126125344.1b7b34e2@gandalf.local.home>
        <87ilgof20x.fsf@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Jan 2023 16:50:32 +0100
Petr Machata <petrm@nvidia.com> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > On Thu, 26 Jan 2023 18:01:14 +0100
> > Petr Machata <petrm@nvidia.com> wrote:
> >  
> >> +	TP_printk("dev %s af %u src %pI4/%pI6c grp %pI4/%pI6c/%pM vid %u",
> >> +		  __get_str(dev), __entry->af, __entry->src4, __entry->src6,
> >> +		  __entry->grp4, __entry->grp6, __entry->grpmac, __entry->vid)  
> >
> > And just have: 
> >
> > 	TP_printk("dev %s af %u src %pI6c grp %pI6c/%pM vid %u",
> > 		  __get_str(dev), __entry->af, __entry->src, __entry->grp,
> > 		  __entry->grpmac, __entry->vid)
> >
> > As the %pI6c should detect that it's a ipv4 address and show that.  
> 
> This means the IP addresses will always be IPv6, even for an IPv4 MDB
> entries. One can still figure out the true protocol from the address
> family field, but it might not be obvious. Plus the IPv4-mapped IPv6
> addresses are not really formatted as IPv4, though yeah, IPv4 notation
> is embedded in that.
> 
> All the information is still there, but... scrambled? Not sure the
> reduction in clarity is worth the 8 bytes that we save. The tracepoint
> is unlikely to trigger often.

8 bytes per event, and yes, ring buffer real estate is expensive.

And if you use trace-cmd or perf, we can always add a plugin to
libtraceevent that can format this much nicer based on the information that
is there.

-- Steve
