Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C88E641D37
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 14:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiLDN0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 08:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDN0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 08:26:48 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E83178BA;
        Sun,  4 Dec 2022 05:26:46 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 9A7DA18838DB;
        Sun,  4 Dec 2022 13:26:43 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 80C4B25003AB;
        Sun,  4 Dec 2022 13:26:43 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 70F3C9EC002A; Sun,  4 Dec 2022 13:26:43 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 04 Dec 2022 14:26:43 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 2/2] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221115222312.lix6xpvddjbsmoac@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-1-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221112203748.68995-3-netdev@kapio-technology.com>
 <20221115222312.lix6xpvddjbsmoac@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <c8340cea42d0c2b098c7e62de0d6dace@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-15 23:23, Vladimir Oltean wrote:
> 
> Is it beneficial in any way to pass the violation type to
> mv88e6xxx_handle_violation(), considering that we only call it from the
> "miss" code path, and if we were to call it with something else 
> ("member"),
> it would return a strange error code (1)?
> 
> I don't necessarily see any way in which we'll need to handle the
> "member" (migration, right?) violation any different in the future,
> except ignore it, either.
> 

MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION will also be handled, and it could 
be
that MV88E6XXX_G1_ATU_OP_FULL_VIOLATION would want handling, though I 
don't
know of plans for that.

The MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION interrupt can be suppressed if 
we
want.

I think a switch on the type is the most readable code form.


p.s. I have changed it, so that global1_atu.c reads:

         if (val & MV88E6XXX_G1_ATU_OP_MISS_VIOLATION) {
                 dev_err_ratelimited(chip->dev,
                                     "ATU miss violation for %pM portvec 
%x spid %d\n",
                                     entry.mac, entry.portvec, spid);
                 chip->ports[spid].atu_miss_violation++;

                 if (!fid) {
                         err = -EINVAL;
                         goto out;
                 }

                 if (chip->ports[spid].mab)
                         err = mv88e6xxx_handle_violation(chip, spid, 
&entry,
                                                          fid, 
MV88E6XXX_G1_ATU_OP_MISS_VIOLATION);
                 if (err)
                         goto out;
         }

with the use of out_unlock in the chip mutex locked case.
