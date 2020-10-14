Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3234228E0F4
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731031AbgJNNCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:02:02 -0400
Received: from correo.us.es ([193.147.175.20]:35144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbgJNNCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:02:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3419FC5F0
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:01:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B327EDA797
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 15:01:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7AABDA78E; Wed, 14 Oct 2020 15:01:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC45ADA791;
        Wed, 14 Oct 2020 15:01:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 15:01:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F9E14301DE0;
        Wed, 14 Oct 2020 15:01:56 +0200 (CEST)
Date:   Wed, 14 Oct 2020 15:01:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netfilter-devel@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: iptables userspace API broken due to added value in nf_inet_hooks
Message-ID: <20201014130156.GB21886@salvia>
References: <CAHmME9q_ExkdWXg6TMRnhwp7KGRQExooiP-jdpXiPqc=s1p4SA@mail.gmail.com>
 <20201014130115.GA21886@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201014130115.GA21886@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 03:01:15PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 14, 2020 at 02:59:47PM +0200, Jason A. Donenfeld wrote:
> > Hey Pablo,
> > 
> > In 60a3815da702fd9e4759945f26cce5c47d3967ad, you added another enum
> > value to nf_inet_hooks:
> > 
> > --- a/include/uapi/linux/netfilter.h
> > +++ b/include/uapi/linux/netfilter.h
> > @@ -45,6 +45,7 @@ enum nf_inet_hooks {
> >        NF_INET_FORWARD,
> >        NF_INET_LOCAL_OUT,
> >        NF_INET_POST_ROUTING,
> > +       NF_INET_INGRESS,
> >        NF_INET_NUMHOOKS
> > };
> > 
> > That seems fine, but actually it changes the value of
> > NF_INET_NUMHOOKS, which is used in struct ipt_getinfo:
> > 
> > /* The argument to IPT_SO_GET_INFO */
> > struct ipt_getinfo {
> >        /* Which table: caller fills this in. */
> >        char name[XT_TABLE_MAXNAMELEN];
> > 
> >        /* Kernel fills these in. */
> >        /* Which hook entry points are valid: bitmask */
> >        unsigned int valid_hooks;
> > 
> >        /* Hook entry points: one per netfilter hook. */
> >        unsigned int hook_entry[NF_INET_NUMHOOKS];
> > 
> >        /* Underflow points. */
> >        unsigned int underflow[NF_INET_NUMHOOKS];
> > 
> >        /* Number of entries */
> >        unsigned int num_entries;
> > 
> >        /* Size of entries. */
> >        unsigned int size;
> > };
> > 
> > This in turn makes that struct bigger, which means this check in
> > net/ipv4/netfilter/ip_tables.c fails:
> > 
> > static int get_info(struct net *net, void __user *user, const int *len)
> > {
> >        char name[XT_TABLE_MAXNAMELEN];
> >        struct xt_table *t;
> >        int ret;
> > 
> >        if (*len != sizeof(struct ipt_getinfo))
> >                return -EINVAL;
> > 
> > This is affecting my CI, which attempts to use an older iptables with
> > net-next and fails with:
> > 
> > iptables v1.8.4 (legacy): can't initialize iptables table `filter':
> > Module is wrong version
> > Perhaps iptables or your kernel needs to be upgraded.
> > 
> > Is this kind of breakage okay? If there's an exception carved out for
> > breaking the iptables API, just let me know, and I'll look into making
> > adjustments to work around it in my CI. On the other hand, if this
> > breakage was unintentional, now you know.
> 
> Oh right, I'll need a new IPT_INET_NUMHOOKS for this.
> 
> I'll submit a patch, that's for the heads up.

s/that's/thanks
