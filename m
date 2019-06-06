Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B7A37989
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfFFQan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 12:30:43 -0400
Received: from mail.us.es ([193.147.175.20]:43848 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfFFQan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 12:30:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B56ACC1DFD
        for <netdev@vger.kernel.org>; Thu,  6 Jun 2019 18:30:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A50BADA738
        for <netdev@vger.kernel.org>; Thu,  6 Jun 2019 18:30:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90936DA718; Thu,  6 Jun 2019 18:30:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EA9CDA703;
        Thu,  6 Jun 2019 18:30:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Jun 2019 18:30:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (barqueta.lsi.us.es [150.214.188.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B3CE4265A2F;
        Thu,  6 Jun 2019 18:30:37 +0200 (CEST)
Date:   Thu, 6 Jun 2019 18:30:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian Brauner <christian@brauner.io>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de
Subject: Re: [PATCH RESEND net-next 1/2] br_netfilter: add struct netns_brnf
Message-ID: <20190606163035.x7rvqdwubxiai5t6@salvia>
References: <20190606114142.15972-1-christian@brauner.io>
 <20190606114142.15972-2-christian@brauner.io>
 <20190606081440.61ea1c62@hermes.lan>
 <20190606151937.mdpalfk7urvv74ub@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606151937.mdpalfk7urvv74ub@brauner.io>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 05:19:39PM +0200, Christian Brauner wrote:
> On Thu, Jun 06, 2019 at 08:14:40AM -0700, Stephen Hemminger wrote:
> > On Thu,  6 Jun 2019 13:41:41 +0200
> > Christian Brauner <christian@brauner.io> wrote:
> > 
> > > +struct netns_brnf {
> > > +#ifdef CONFIG_SYSCTL
> > > +	struct ctl_table_header *ctl_hdr;
> > > +#endif
> > > +
> > > +	/* default value is 1 */
> > > +	int call_iptables;
> > > +	int call_ip6tables;
> > > +	int call_arptables;
> > > +
> > > +	/* default value is 0 */
> > > +	int filter_vlan_tagged;
> > > +	int filter_pppoe_tagged;
> > > +	int pass_vlan_indev;
> > > +};
> > 
> > Do you really need to waste four bytes for each
> > flag value. If you use a u8 that would work just as well.
> 
> I think we had discussed something like this but the problem why we
> can't do this stems from how the sysctl-table stuff is implemented.
> I distinctly remember that it couldn't be done with a flag due to that.

Could you define a pernet_operations object? I mean, define the id and size
fields, then pass it to register_pernet_subsys() for registration.
Similar to what we do in net/ipv4/netfilter/ipt_CLUSTER.c, see
clusterip_net_ops and clusterip_pernet() for instance.
