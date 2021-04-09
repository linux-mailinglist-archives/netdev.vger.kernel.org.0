Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD4A359EF9
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhDIMn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:43:56 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:52513 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233600AbhDIMnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:43:50 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 139Ch8mx001701;
        Fri, 9 Apr 2021 14:43:15 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 2A742121E0D;
        Fri,  9 Apr 2021 14:43:15 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1617972195; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kUp98fdCAPlohVD1ejVkxp0CZh0wotw8WllozVBctI=;
        b=9h97YCRPoNzdxqarcc2uB5PX1DsNQgggEEsn8Qv3nsJ9KW2lozS7o2pJ86YVvrHPs+xO3t
        NC8TAzYbsvrOeVAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1617972195; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kUp98fdCAPlohVD1ejVkxp0CZh0wotw8WllozVBctI=;
        b=nc7z+4gJ1+LzoHctkvw+saCjsI+tbqrJce/o2BCL2WNDUCsEmWHnIREqbonlArdBOZhsQ3
        H3wB9ceSV/NLFEDJNQF+09IcunG30MZT9EgOXuzLKnqkqu+7qDKAMRHOlLKBpFz3e7jn60
        6w7BkI97L1RbgnuAls5fVll2BvNP0HgzsJyDcTqEgMqtOBj60nnBf4JH8/DQ3xm+WVl6xh
        RfWtC1TD8w4bwmcVPI5kcg1YoDdpWXDhtBsZ2Zoth1bsQErp13kzvl34RYz15rI75s4KJL
        yCnLu22l/4EYP8/Cx7j7Skuu3j6Uhz07fSVEojNYvg5OZvfW9VnZWLKZKX5AOg==
Date:   Fri, 9 Apr 2021 14:43:14 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [RFC net-next 1/1] seg6: add counters support for SRv6
 Behaviors
Message-Id: <20210409144314.bfdc37b91cee99d1761a84a4@uniroma2.it>
In-Reply-To: <20210407132404.59c95127@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210407180332.29775-1-andrea.mayer@uniroma2.it>
        <20210407180332.29775-2-andrea.mayer@uniroma2.it>
        <20210407132404.59c95127@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 13:24:04 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Wed,  7 Apr 2021 20:03:32 +0200 Andrea Mayer wrote:
> > This patch provides counters for SRv6 Behaviors as defined in [1], section
> > 6. For each SRv6 Behavior instance, the counters defined in [1] are:
> > 
> >  - the total number of packets that have been correctly processed;
> >  - the total amount of traffic in bytes of all packets that have been
> >    correctly processed;
> > 
> > In addition, we introduces a new counter that counts the number of packets
> > that have NOT been properly processed (i.e. errors) by an SRv6 Behavior
> > instance.
> > 
> > Each SRv6 Behavior instance can be configured, at the time of its creation,
> > to make use of counters.
> > This is done through iproute2 which allows the user to create an SRv6
> > Behavior instance specifying the optional "count" attribute as shown in the
> > following example:
> > 
> >  $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0
> > 
> > per-behavior counters can be shown by adding "-s" to the iproute2 command
> > line, i.e.:
> > 
> >  $ ip -s -6 route show 2001:db8::1
> >  2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0
> > 
> > [1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters
> > 
> > Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> 
> > +static int put_nla_counters(struct sk_buff *skb, struct seg6_local_lwt *slwt)
> > +{
> > +	struct seg6_local_counters counters = { 0, 0, 0 };
> > +	struct nlattr *nla;
> > +	int i;
> > +
> > +	nla = nla_reserve(skb, SEG6_LOCAL_COUNTERS, sizeof(counters));
> > +	if (!nla)
> > +		return -EMSGSIZE;
> 
> nla_reserve_64bit(), IIUC netlink guarantees alignment of 64 bit values.

Hi Jakub, thanks for your review!

Yes, we should guarantee alignment of 64 bit values.
I will definitely follow your advice.

Andrea
