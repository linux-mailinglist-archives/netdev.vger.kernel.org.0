Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA8B38CFB
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 16:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfFGO3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 10:29:05 -0400
Received: from mail.us.es ([193.147.175.20]:47052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbfFGO3F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 10:29:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3381BAE9A
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 16:29:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3D4CDA701
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 16:29:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7522DA715; Fri,  7 Jun 2019 16:29:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 433E5DA701;
        Fri,  7 Jun 2019 16:28:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Jun 2019 16:28:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0386D4265A2F;
        Fri,  7 Jun 2019 16:28:58 +0200 (CEST)
Date:   Fri, 7 Jun 2019 16:28:58 +0200
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
Message-ID: <20190607142858.vgkljqohn34rxhe2@salvia>
References: <20190606114142.15972-1-christian@brauner.io>
 <20190606114142.15972-2-christian@brauner.io>
 <20190606081440.61ea1c62@hermes.lan>
 <20190606151937.mdpalfk7urvv74ub@brauner.io>
 <20190606163035.x7rvqdwubxiai5t6@salvia>
 <20190607132516.q3zwmzrynvqo7mzn@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607132516.q3zwmzrynvqo7mzn@brauner.io>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 03:25:16PM +0200, Christian Brauner wrote:
> On Thu, Jun 06, 2019 at 06:30:35PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 06, 2019 at 05:19:39PM +0200, Christian Brauner wrote:
> > > On Thu, Jun 06, 2019 at 08:14:40AM -0700, Stephen Hemminger wrote:
> > > > On Thu,  6 Jun 2019 13:41:41 +0200
> > > > Christian Brauner <christian@brauner.io> wrote:
> > > > 
> > > > > +struct netns_brnf {
> > > > > +#ifdef CONFIG_SYSCTL
> > > > > +	struct ctl_table_header *ctl_hdr;
> > > > > +#endif
> > > > > +
> > > > > +	/* default value is 1 */
> > > > > +	int call_iptables;
> > > > > +	int call_ip6tables;
> > > > > +	int call_arptables;
> > > > > +
> > > > > +	/* default value is 0 */
> > > > > +	int filter_vlan_tagged;
> > > > > +	int filter_pppoe_tagged;
> > > > > +	int pass_vlan_indev;
> > > > > +};
> > > > 
> > > > Do you really need to waste four bytes for each
> > > > flag value. If you use a u8 that would work just as well.
> > > 
> > > I think we had discussed something like this but the problem why we
> > > can't do this stems from how the sysctl-table stuff is implemented.
> > > I distinctly remember that it couldn't be done with a flag due to that.
> > 
> > Could you define a pernet_operations object? I mean, define the id and size
> > fields, then pass it to register_pernet_subsys() for registration.
> > Similar to what we do in net/ipv4/netfilter/ipt_CLUSTER.c, see
> > clusterip_net_ops and clusterip_pernet() for instance.
> 
> Hm, I don't think that would work. The sysctls for br_netfilter are
> located in /proc/sys/net/bridge under /proc/sys/net which is tightly
> integrated with the sysctls infrastructure for all of net/ and all the
> folder underneath it including "core", "ipv4" and "ipv6".
> I don't think creating and managing files manually in /proc/sys/net is
> going to fly. It also doesn't seem very wise from a consistency and
> complexity pov. I'm also not sure if this would work at all wrt to file
> creation and reference counting if there are two different ways of
> managing them in the same subfolder...
> (clusterip creates files manually underneath /proc/net which probably is
> the reason why it gets away with it.)

br_netfilter is now a module, and br_netfilter_hooks.c is part of it
IIRC, this file registers these sysctl entries from the module __init
path.

It would be a matter of adding a new .init callback to the existing
brnf_net_ops object in br_netfilter_hooks.c. Then, call
register_net_sysctl() from this .init callback to register the sysctl
entries per netns.

There is already a brnf_net area that you can reuse for this purpose,
to place these pernetns flags...

struct brnf_net {
        bool enabled;
};

which is going to be glad to have more fields (under the #ifdef
CONFIG_SYSCTL) there.
