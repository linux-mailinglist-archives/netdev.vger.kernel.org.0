Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8021E613B88
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiJaQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiJaQkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:40:47 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F9F389B
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:40:38 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 9EB1518846BA;
        Mon, 31 Oct 2022 16:40:36 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 96AD02500015;
        Mon, 31 Oct 2022 16:40:36 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 893569EC0007; Mon, 31 Oct 2022 16:40:36 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 31 Oct 2022 17:40:36 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
In-Reply-To: <Y1/fLCe3xApcBXCE@shredder>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
 <0b1655f30a383f9b12c0d0c9c11efa56@kapio-technology.com>
 <Y1/fLCe3xApcBXCE@shredder>
User-Agent: Gigahost Webmail
Message-ID: <4b70a4630474c0ce543e0fed70a36eaa@kapio-technology.com>
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

On 2022-10-31 15:43, Ido Schimmel wrote:
> On Sun, Oct 30, 2022 at 11:09:31PM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2022-10-25 12:00, Ido Schimmel wrote:
>> > @@ -943,6 +946,14 @@ static int br_setport(struct net_bridge_port *p,
>> > struct nlattr *tb[],
>> >  	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS,
>> > BR_NEIGH_SUPPRESS);
>> >  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
>> >  	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
>> > +	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
>> > +
>> > +	if ((p->flags & BR_PORT_MAB) &&
>> > +	    (!(p->flags & BR_PORT_LOCKED) || !(p->flags & BR_LEARNING))) {
>> > +		NL_SET_ERR_MSG(extack, "MAB can only be enabled on a locked port
>> > with learning enabled");
>> 
>> It's a bit odd to get this message when turning off learning on a port 
>> with
>> MAB on, e.g....
>> 
>> # bridge link set dev a2 learning off
>> Error: MAB can only be enabled on a locked port with learning enabled.
> 
> It's better if you suggest something else. How about:
> 
> "Bridge port must be locked and have learning enabled when MAB is 
> enabled"
> 
> ?

Yes, I think that is better in case it should not be split into more 
than one
message. At least it is not bound to a specific action.
