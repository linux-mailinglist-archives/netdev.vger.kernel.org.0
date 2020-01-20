Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB0142F27
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 17:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgATQCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 11:02:44 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:44075 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgATQCo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 11:02:44 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 00KG273t001572;
        Mon, 20 Jan 2020 17:02:12 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 282991228FC;
        Mon, 20 Jan 2020 17:02:03 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1579536123; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzn1+kiTTbQRfzDcKUMnYRw23BnDOCtFw37Gdplq3W8=;
        b=UgSakFBK2frzr8ktrnPbuslLzIwZ3+mIvw1KP5lxywgFr98/1xB0S1glYN5EXGEm7ZyeZR
        KrSCijXOkbVwLOCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1579536123; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzn1+kiTTbQRfzDcKUMnYRw23BnDOCtFw37Gdplq3W8=;
        b=k7RgmoAPij3y5m/i9wOIlSAtNnmTu7Mu73/otLExCtTLul+Vi976KpcWHj91zMSpO6srDf
        Fn1KJDCdkwKBd6tvFPNbe0ip4DwqX7iPADlD3Th8po176BW1HljTwxjRKSr3+PlK8hvP21
        SUDQWyvZ0VOHHygItLrpOF9HkRgutuJi1tt5FCEykJb3cLX+J4fge95uxEFT7QL7W+Jbgm
        UlleyK0tXQAdzFPAd7WAYwghI74zil8IEBbz/uVM1YyPij8ncVZMd6M1V2ubyoyZ3/eRF4
        aTWKheeOrljgrfMTLiIx9H943NXB5f8fHwGDeWUqdkVC8F1C873GU/R4IH7xyA==
Date:   Mon, 20 Jan 2020 17:02:03 +0100
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
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net] vxlan: fix vxlan6_get_route() adding a call to
 xfrm_lookup_route()
Message-Id: <20200120170203.19663047eb00b221778ff465@uniroma2.it>
In-Reply-To: <20200116142839.98b04af5d16f8ec3ed209288@uniroma2.it>
References: <20200115192231.3005-1-andrea.mayer@uniroma2.it>
        <20200115211621.GA573446@bistromath.localdomain>
        <20200116142839.98b04af5d16f8ec3ed209288@uniroma2.it>
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

On Thu, 16 Jan 2020 14:28:39 +0100
Andrea Mayer <andrea.mayer@uniroma2.it> wrote:

> On Wed, 15 Jan 2020 22:16:21 +0100
> Sabrina Dubroca <sd@queasysnail.net> wrote:
> 
> > 2020-01-15, 20:22:31 +0100, Andrea Mayer wrote:
> > > currently IPSEC cannot be used to encrypt/decrypt IPv6 vxlan traffic.
> > > The problem is that the vxlan module uses the vxlan6_get_route()
> > > function to find out the route for transmitting an IPv6 packet, which in
> > > turn uses ip6_dst_lookup() available in ip6_output.c.
> > > Unfortunately ip6_dst_lookup() does not perform any xfrm route lookup,
> > > so the xfrm framework cannot be used with vxlan6.
> > 
> > That's not the case anymore, since commit 6c8991f41546 ("net:
> > ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup").
> > 
> > Can you retest on the latest net tree?
> > 
> > Thanks.
> > 
> > -- 
> > Sabrina
> > 
> 
> Hi Sabrina,
> thanks for sharing the fix.
> Sorry, my net tree was a bit outdated. I will retest with the fix and let you know.
> 
> -- 
> Andrea Mayer <andrea.mayer@uniroma2.it>

Hi,
I've tested the new net tree in my setup and now vxlan6 and IPSec seems to work good.

Thanks.

-- 
Andrea Mayer <andrea.mayer@uniroma2.it>
