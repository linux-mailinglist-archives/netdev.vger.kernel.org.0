Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57EEF15355C
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBEQie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:38:34 -0500
Received: from smtp.uniroma2.it ([160.80.6.23]:33558 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgBEQie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 11:38:34 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 015GbSSg024337;
        Wed, 5 Feb 2020 17:37:33 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 0CA3B122908;
        Wed,  5 Feb 2020 17:37:24 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1580920644; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+Z0uxaSywbrA//eJ07SOsgCkYFSRxtQ2TCp73WsBbo=;
        b=QQC6AW2a6Xqxv4zeLYlsyu+fT3ES6fE6xMlHSde1JioMLGYidxl0IW4a6QaAxweri6tefd
        sYl4PEMEmUe54TDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1580920644; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+Z0uxaSywbrA//eJ07SOsgCkYFSRxtQ2TCp73WsBbo=;
        b=gbZaRipvvSdsWz+UR789bhLhOJwLQa3/YZP63UGihpUcq0Eb/LpdzRp/A3X8KP1jZwp7EQ
        Vx52BecSRnbswjFORMRBgaAfKc0d2iwvvLdk/+n8+dt9uHgCq0EkaG7Zcv1RjMqzAkTCla
        NwRsuuQJA4lvrknp53ox+asW0+6dSwfUirRK8A+moH3V4r3+21y5krAeugoaKI9d62qx1X
        2hxQRwJz23D1iLKAJuzaQBDg9w932gD6HcRJ6P8byMt/I0LxlSP1GBjE6K95PsU6ns9eH9
        SIwjKwBtl8rVCsLQNe16gnE+FSpTyei8Y98gtiqf4ERPTI/o6IJu5KNsAIuKNQ==
Date:   Wed, 5 Feb 2020 17:37:23 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Lebrun <dav.lebrun@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>
Subject: Re: [net-next] seg6: add support for optional attributes during
 behavior construction
Message-Id: <20200205173723.927eeaab1c37d5d94173457e@uniroma2.it>
In-Reply-To: <20200203150800.GQ414821@unreal>
References: <20200203143658.1561-1-andrea.mayer@uniroma2.it>
        <20200203150800.GQ414821@unreal>
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

On Mon, 3 Feb 2020 17:08:00 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Feb 03, 2020 at 03:36:58PM +0100, Andrea Mayer wrote:
> > before this patch, each SRv6 behavior specifies a set of required
> > [...]
> >
> > diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> > index 85a5447a3e8d..480f1ab35221 100644
> > --- a/net/ipv6/seg6_local.c
> > +++ b/net/ipv6/seg6_local.c
> > @@ -7,6 +7,13 @@
> >   *  eBPF support: Mathieu Xhonneux <m.xhonneux@gmail.com>
> >   */
> >
> > +/* Changes:
> > + *
> > + * Andrea Mayer <andrea.mayer@uniroma2.it>
> > + *	add support for optional attributes during behavior construction
> > + *
> > + */
> 
> The lines above look strange in 2020 when all of us are using git.
> 
> Thanks

Hi Leon,

We forgot to remove it from the patch. I will remove in the next revision. 
Thanks

-- 
Andrea Mayer <andrea.mayer@uniroma2.it>
