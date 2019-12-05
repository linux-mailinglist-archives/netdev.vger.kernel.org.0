Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9F211494E
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 23:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfLEWat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 17:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727595AbfLEWas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 17:30:48 -0500
Received: from localhost (mobile-166-170-221-197.mycingular.net [166.170.221.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F6520707;
        Thu,  5 Dec 2019 22:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575585047;
        bh=rwc2W/J/V58JZoKOWg2doRruK6KWPbQgM5Sb2F/Ai60=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=cliOZcUxDWzGZ1UQTKJkPsD++s/EPrjyE7H/snJuA3uqE7NURH520sOnVje6nd0Ts
         Td38CmfeZyMBlRyr+Rypsepv/EG8hoAOa7B7sJiJzOVgMDkiBquX3yxdZnHzKOkS/c
         BBv+wew7DxEj2QDNBsIebdp/nYnu0CS5l8OPwMaM=
Date:   Thu, 5 Dec 2019 16:30:44 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.con>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, kexec@lists.infradead.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH v4 7/8] linux/log2.h: Fix 64bit calculations in
 roundup/down_pow_two()
Message-ID: <20191205223044.GA250573@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203114743.1294-8-nsaenzjulienne@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You got the "n" on "down" in the subject, but still missing "of" ;)

On Tue, Dec 03, 2019 at 12:47:40PM +0100, Nicolas Saenz Julienne wrote:
> Some users need to make sure their rounding function accepts and returns
> 64bit long variables regardless of the architecture. Sadly
> roundup/rounddown_pow_two() takes and returns unsigned longs. It turns
> out ilog2() already handles 32/64bit calculations properly, and being
> the building block to the round functions we can rework them as a
> wrapper around it.

Missing "of" in the function names here.
s/a wrapper/wrappers/

IIUC the point of this is that roundup_pow_of_two() returned
"unsigned long", which can be either 32 or 64 bits (worth pointing
out, I think), and many callers need something that returns
"unsigned long long" (always 64 bits).

It's a nice simplification to remove the "__" variants.  Just as a
casual reader of this commit message, I'd like to know why we had both
the roundup and the __roundup versions in the first place, and why we
no longer need both.

> -#define roundup_pow_of_two(n)			\
> -(						\
> -	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 1 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> -				   ) :		\
> -	__roundup_pow_of_two(n)			\
> - )
> +#define roundup_pow_of_two(n)			  \
> +(						  \
> +	(__builtin_constant_p(n) && ((n) == 1)) ? \
> +	1 : (1ULL << (ilog2((n) - 1) + 1))        \
> +)

Should the resulting type of this expression always be a ULL, even
when n==1, i.e., should it be this?

  1ULL : (1ULL << (ilog2((n) - 1) + 1))        \

Or maybe there's no case where that makes a difference?

Bjorn
