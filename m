Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2030EA2E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbhBDC3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:29:00 -0500
Received: from smtp.uniroma2.it ([160.80.6.16]:47085 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhBDC27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:28:59 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 1142RWaa010460;
        Thu, 4 Feb 2021 03:27:37 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 9388512287D;
        Thu,  4 Feb 2021 03:27:27 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1612405648; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBzNtFmeR8mXuxoqjeFWbcuolAywphiZEEztgpv3tK8=;
        b=YHMRh3qCcMMur84PeqRWUt4FBxoMcJJ6Gs8Agi2OaitoubZErgfTdkpTsXyBO+S4JQg7Nd
        EC9JZ81jKUtzvrBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1612405648; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BBzNtFmeR8mXuxoqjeFWbcuolAywphiZEEztgpv3tK8=;
        b=fp5tyQWiYjxfPSHnNp85GtpIUMD8dI62n/3W9gKQNL4F0zTmoTCkjr4YhtFc3+2X2Z8PGI
        Mx5JLdP1AHrrGznDBxGzgMAju28ucknmH1vKmS0OVB27mH5S8dhqpZK/ZnMCSQIWjlbh24
        +rzUQMbN1BVNdPepWwgpJo5dfLakBlfFqODZMdjqo96YnF+oYV1MwP3cKZpDoozDcIoVwU
        x1wvuc3Nlbljgvc8sv8C3yKWc1tCakjyLdz+km/nJ4uolaIy4emho1MLHibhOjzUxBVWhy
        EWsSftTGQC7ezh+OrYklu2iZHB+2P4TED69rIh91hJ2jMleO92DZGm/rYluGdg==
Date:   Thu, 4 Feb 2021 03:27:27 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     David Ahern <dsahern@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH net-next] seg6: fool-proof the processing of SRv6
 behavior attributes
Message-Id: <20210204032727.ffd2c1ae3410147ba7598d78@uniroma2.it>
In-Reply-To: <6fe3beb2-4306-11cd-83ce-66072db81346@gmail.com>
References: <20210202185648.11654-1-andrea.mayer@uniroma2.it>
        <6fe3beb2-4306-11cd-83ce-66072db81346@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
thanks for your time.

On Wed, 3 Feb 2021 08:59:40 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 2/2/21 11:56 AM, Andrea Mayer wrote:
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index b07f7c1c82a4..7cc50d506902 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -31,6 +31,9 @@
> >  #include <linux/etherdevice.h>
> >  #include <linux/bpf.h>
> >  
> > +#define SEG6_F_ATTR(i)		BIT(i)
> > +#define SEG6_LOCAL_MAX_SUPP	32
> > +
> 
> SEG6_LOCAL_MAX_SUPP should not be needed; it can be derived from the type:
> 

Yes, we can avoid the SEG6_LOCAL_MAX_SUPP. Using the BITS_PER_TYPE macro seems
better to me and it avoids nailing the value 32 as the limit. At compile time,
the kernel build will fail if the total number of SRv6 attributes will exceed
the number of bits available in the unsigned long bitmap (whatever is the
reference architecture). Therefore, I'm going to follow your suggestion!

>     BUILD_BUG_ON(BITS_PER_TYPE(unsigned long) > SEG6_LOCAL_MAX)
> 

I think there is an issue here because BITS_PER_TYPE(unsigned long) is greater
than the SEG6_LOCAL_MAX (currently = 9).

I think it should be like this:

 BUILD_BUG_ON(SEG6_LOCAL_MAX + 1 > BITS_PER_TYPE(unsigned long))

I will send a v2 with the changes discussed so far.

Thank you,
Andrea
