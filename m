Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A9BB489
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502114AbfIWM4O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Sep 2019 08:56:14 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59745 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437615AbfIWM4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 08:56:13 -0400
Received: from [2001:67c:670:100:79a6:a514:42de:7079] (helo=rettich)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1iCNsw-000354-Qt; Mon, 23 Sep 2019 14:56:10 +0200
Received: from jlu by rettich with local (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1iCNsu-00065l-Ix; Mon, 23 Sep 2019 14:56:08 +0200
Message-ID: <bc0acd2803c4f513babe6bcc006b95a6297484bc.camel@pengutronix.de>
Subject: Re: dsa traffic priorization
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
Date:   Mon, 23 Sep 2019 14:56:08 +0200
In-Reply-To: <bc70ddd1-0360-5c09-f03d-3560a0948f52@gmail.com>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
         <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
         <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
         <20190919084416.33ifxohtgkofrleb@pengutronix.de>
         <bc70ddd1-0360-5c09-f03d-3560a0948f52@gmail.com>
Organization: Pengutronix
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:79a6:a514:42de:7079
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding TC maintainers... (we're trying to find a mainline-acceptable
way to configure and offload strict port-based priorities in the
context of DSA/switchdev).

On Thu, 2019-09-19 at 10:12 -0700, Florian Fainelli wrote:
> On 9/19/19 1:44 AM, Sascha Hauer wrote:
> > On Wed, Sep 18, 2019 at 10:41:58AM -0700, Florian Fainelli wrote:
> > > On 9/18/19 7:36 AM, Vladimir Oltean wrote:
> > > > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > > > > The other part of the problem seems to be that the CPU port
> > > > > has no network device representation in Linux, so there's no
> > > > > interface to configure the egress limits via tc.
> > > > > This has been discussed before, but it seems there hasn't
> > > > > been any consensous regarding how we want to proceed?
> > > 
> > > You have the DSA master network device which is on the other side of the
> > > switch,
> > 
> > You mean the (in my case) i.MX FEC? Everything I do on this device ends
> > up in the FEC itself and not on the switch, right?
> 
> Yes, we have a way to overload specific netdevice_ops and ethtool_ops
> operations in order to use the i.MX FEC network device as configuration
> entry point, say eth0, but have it operate on the switch, because when
> the DSA switch got attached to the DSA master, we replaced some of that
> network device's operations with ones that piggy back into the switch.
> See net/dsa/master.c for details.

Currently, it overrides
for ethtool:
        ops->get_sset_count = dsa_master_get_sset_count;
        ops->get_ethtool_stats = dsa_master_get_ethtool_stats;
        ops->get_strings = dsa_master_get_strings;
        ops->get_ethtool_phy_stats = dsa_master_get_ethtool_phy_stats;
for ndo:
        ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;

In dsa/slave.c we have for ndo:
        .ndo_setup_tc           = dsa_slave_setup_tc,

So we would override ndo_setup_tc from dsa as well, maybe falling back
to the original ndo_setup_tc provided by the ethernet driver if we the
switch HW cannot handle a TC configuration?

That would allow us to configure and offload a CPU-port-specific TC
policy under the control of DSA. Is this interface reasonable?

Im not sure if the existing TC filters and qdiscs can match on bridge-
specific information (like the ingress port) yet, so this might require
extensions to TC filters as well...

Regards,
Jan
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

