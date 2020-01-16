Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6213DBD5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAPN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:29:06 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:58437 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPN3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:29:06 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 00GDSVjZ012263;
        Thu, 16 Jan 2020 14:28:38 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 6DAC91228FA;
        Thu, 16 Jan 2020 14:28:39 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1579181319; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHTCZ5Bl2oiJKvZCPiMq8xHmMGX8S9jJ3dLQloshk84=;
        b=A6E+hu/IZDC2rwHm6q+wVBcC4dgBk7RLIZMYRBt0PDSJqLIZrOClAtHbjd4TXyisD7ai3p
        sOygKbL4coDbD2BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1579181319; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHTCZ5Bl2oiJKvZCPiMq8xHmMGX8S9jJ3dLQloshk84=;
        b=hBmptfq6vu+k4pvcWPYsxuorIEYNYeKc04e+cwsrcpdCcnBNJUhdiIYUawlxtBo77i9OyT
        zCt6E0Fj5aLu/vczyhAWhhFMBrP6uv9VFfSaAQ2WexxwcqxjYU5berh6sMlqglohZ6OO2M
        giwnYH/NFXH6DA5PzVRwPyOl1Wg2SoHgALx6lcPbflzoDmN82nHskSM5fStBEQCtx9KwDg
        VCnm6ixWr5tUw6SBHvAwEvEA/tAskCNVbJEYAk1Bh7XujK2UDXQrA8tylvxFU1fwflv6el
        O+GIqpyfNkP+SFUZyXLyJvQ3q942Jx8peDc1AV6gp0fFP7AYNNY79YX4seUE9Q==
Date:   Thu, 16 Jan 2020 14:28:39 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Litao jiao <jiaolitao@raisecom.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: Re: [net] vxlan: fix vxlan6_get_route() adding a call to
 xfrm_lookup_route()
Message-Id: <20200116142839.98b04af5d16f8ec3ed209288@uniroma2.it>
In-Reply-To: <20200115211621.GA573446@bistromath.localdomain>
References: <20200115192231.3005-1-andrea.mayer@uniroma2.it>
        <20200115211621.GA573446@bistromath.localdomain>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jan 2020 22:16:21 +0100
Sabrina Dubroca <sd@queasysnail.net> wrote:

> 2020-01-15, 20:22:31 +0100, Andrea Mayer wrote:
> > currently IPSEC cannot be used to encrypt/decrypt IPv6 vxlan traffic.
> > The problem is that the vxlan module uses the vxlan6_get_route()
> > function to find out the route for transmitting an IPv6 packet, which in
> > turn uses ip6_dst_lookup() available in ip6_output.c.
> > Unfortunately ip6_dst_lookup() does not perform any xfrm route lookup,
> > so the xfrm framework cannot be used with vxlan6.
> 
> That's not the case anymore, since commit 6c8991f41546 ("net:
> ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup").
> 
> Can you retest on the latest net tree?
> 
> Thanks.
> 
> -- 
> Sabrina
> 

Hi Sabrina,
thanks for sharing the fix.
Sorry, my net tree was a bit outdated. I will retest with the fix and let you know.

-- 
Andrea Mayer <andrea.mayer@uniroma2.it>
