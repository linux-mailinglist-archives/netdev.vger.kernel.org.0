Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9491268AB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 19:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfLSSGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 13:06:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfLSSGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 13:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=llmwKlK3ZgeojEH55qh6qVfXYVHDzQIw+Mvg9FHgI7Y=; b=jlOatqGOmXRBljUNArgDm5cQBw
        TkaikdZHc6+C2ZSqNkdeoMWMi3SWKKzQvk6Bkp3i8SBosicMogeh8QTTjQrMotelxkOpIjLQPA1cN
        rLR/S6H8CwOQCifDnh11jVS9on9kH8DBOM47ng0umc4AXeE3fb2r8TcGcCicejGjvOPY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ii0By-0003eL-0Y; Thu, 19 Dec 2019 19:06:30 +0100
Date:   Thu, 19 Dec 2019 19:06:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     netdev@vger.kernel.org, "Kwok, WingMan" <w-kwok2@ti.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com
Subject: Re: RSTP with switchdev question
Message-ID: <20191219180629.GK17475@lunn.ch>
References: <c234beeb-5511-f33c-1232-638e9c9a3ac2@ti.com>
 <7ca19413-1ac5-946c-c4d0-3d9d5d88e634@ti.com>
 <20191217112122.GB17965@lunn.ch>
 <93982e05-e15b-7589-de38-ea64a87580fd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93982e05-e15b-7589-de38-ea64a87580fd@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 12:30:06PM -0500, Murali Karicheri wrote:
> Hi Andrew,
> 
> Thanks for responding to this.
> 
> On 12/17/2019 06:21 AM, Andrew Lunn wrote:
> > On Mon, Dec 16, 2019 at 11:55:05AM -0500, Murali Karicheri wrote:
> > > + switchdev/DSA experts
> > 
> > Hi Murali
> > 
> > I did not reply before because this is a pure switchdev issue. DSA
> > does things differently. The kernel FDB and the switches FDB are not
> > kept in sync. With DSA, when a port changes state, we flush the switch
> > FDB. For STP, that seems to be sufficient. There have been reports for
> > RSTP this might not be enough, but that conversation did not go very
> > far.
> I am new to RSTP and trying to understand what is required to be done
> at the driver level when switchdev is used.
> 
> Looks like topology changes are handled currectly when only Linux bridge
> is used and L2 forwarding is not offloaded to switch (Plain Ethernet
> interface underneath).
> 
> This is my understanding. Linux bridge code uses BR_USER_STP to handle
> user space  handling. So daemon manages the STP state machine and update
> the STP  state to bridge which then get sent to device driver through
> switchdev SET attribute command in the same way as kernel STP. From the
> RSTP point of view, AFAIK, the quick data path switch over happens by
> purging and re-learning when topology changes (TCN BPDUs). Currently
> we are doing the following workaround which seems to solve the issue
> based on the limited testing we had. Idea is for the switchdev based
> switch driver to monitor the RTP state per port and if there is any
> change in state, do a purge of learned MAC address in switch and send a
> notification to bridge using
> call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info);

Are you saying the hardware should send a notification to the software
bridge? That seems the wrong way around. It is the software bridge
which is in control of everything. It should be the software bridge
which tells the hardware to purge its cache.

> Following transition to be monitored and purged on any port:-
>  Blocking   -> Learning  (assuming blocking to forward doesn't happen
>                directly)
>  Blocking   -> Forward (Not sure if this is possible. Need to check the
>                spec.
>  Learning   -> Blocked
>  Forwarding -> Blocked

What we have for dsa is:

int dsa_port_set_state(struct dsa_port *dp, u8 state,
                       struct switchdev_trans *trans)
{
        struct dsa_switch *ds = dp->ds;
        int port = dp->index;

        if (switchdev_trans_ph_prepare(trans))
                return ds->ops->port_stp_state_set ? 0 : -EOPNOTSUPP;

        if (ds->ops->port_stp_state_set)
                ds->ops->port_stp_state_set(ds, port, state);

        if (ds->ops->port_fast_age) {
                /* Fast age FDB entries or flush appropriate forwarding database
                 * for the given port, if we are moving it from Learning or
                 * Forwarding state, to Disabled or Blocking or Listening state.
                 */

                if ((dp->stp_state == BR_STATE_LEARNING ||
                     dp->stp_state == BR_STATE_FORWARDING) &&
                    (state == BR_STATE_DISABLED ||
                     state == BR_STATE_BLOCKING ||
                     state == BR_STATE_LISTENING))
                        ds->ops->port_fast_age(ds, port);
        }

        dp->stp_state = state;

        return 0;
}

This gets called from the software bridge. The first call into the DSA
driver changes the port state. If ds->ops->port_fast_age is
implemented in the DSA driver, it is used. For STP, ideally you age
out entries quicker. If the hardware cannot do that, the driver is
expected to just flush them.

I don't know what RSTP requires. Is fast ageing also used in RSTP, or
is a complete flush expected?

> Hope the above are correct. Do you know if DSA is checking the above
> transitions? Also when the learned address are purged in the switch
> hardware, send event notification to Linux bridge to sync up with it's
> database.

Nope. We expect the software bridge performs its own flush. With DSA,
we have two databases, one in the hardware, and one in the software
bridge. No attempt is made to keep them in sync. Each performs its own
learning and ageing.

	 Andrew
