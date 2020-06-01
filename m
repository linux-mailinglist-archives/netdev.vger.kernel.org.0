Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA71EA131
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgFAJsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFAJsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 05:48:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B53206C3;
        Mon,  1 Jun 2020 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591004885;
        bh=t58s93YEjg685z8DSWWCBbOs5EB6tH/ebWHiYN4Wr8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vw6iMKZoMGkvhHzqZvOc5GnWU1yuK8WeZ7NQpTyJiJkvtgtzqC9LB0+Xsfthu9oOP
         QaYbERmzIj/NZUX3TWU36u8uw4gsQPacwZ8lLQhxexqcXFFveEuZZJRB+InpLq9I2H
         Lwadj8BbmWSx2ROq9Y4XcUk/wxfctjukLWM6bJpI=
Date:   Mon, 1 Jun 2020 11:48:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        bgolaszewski@baylibre.com, mika.westerberg@linux.intel.com,
        efremov@linux.com, ztuowen@gmail.com,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] devres: keep both device name and resource name in
 pretty name
Message-ID: <20200601094802.GA1824038@kroah.com>
References: <20200531180758.1426455-1-olteanv@gmail.com>
 <39107d25-f6e6-6670-0df6-8ae6421e7f9a@cogentembedded.com>
 <CA+h21hq4tah3EAdFaLdxTR1JtEaSiZfOFuinwHq-p0AZ+ENesw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hq4tah3EAdFaLdxTR1JtEaSiZfOFuinwHq-p0AZ+ENesw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 12:36:08PM +0300, Vladimir Oltean wrote:
> Hi Sergei,
> 
> On Mon, 1 Jun 2020 at 10:51, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
> >
> > Hello!
> >
> > On 31.05.2020 21:07, Vladimir Oltean wrote:
> >
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > Sometimes debugging a device is easiest using devmem on its register
> > > map, and that can be seen with /proc/iomem. But some device drivers have
> > > many memory regions. Take for example a networking switch. Its memory
> > > map used to look like this in /proc/iomem:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >    1fc000000-1fc3fffff : 0000:00:00.5
> > >      1fc010000-1fc01ffff : sys
> > >      1fc030000-1fc03ffff : rew
> > >      1fc060000-1fc0603ff : s2
> > >      1fc070000-1fc0701ff : devcpu_gcb
> > >      1fc080000-1fc0800ff : qs
> > >      1fc090000-1fc0900cb : ptp
> > >      1fc100000-1fc10ffff : port0
> > >      1fc110000-1fc11ffff : port1
> > >      1fc120000-1fc12ffff : port2
> > >      1fc130000-1fc13ffff : port3
> > >      1fc140000-1fc14ffff : port4
> > >      1fc150000-1fc15ffff : port5
> > >      1fc200000-1fc21ffff : qsys
> > >      1fc280000-1fc28ffff : ana
> > >
> > > But after the patch in Fixes: was applied, the information is now
> > > presented in a much more opaque way:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >    1fc000000-1fc3fffff : 0000:00:00.5
> > >      1fc010000-1fc01ffff : 0000:00:00.5
> > >      1fc030000-1fc03ffff : 0000:00:00.5
> > >      1fc060000-1fc0603ff : 0000:00:00.5
> > >      1fc070000-1fc0701ff : 0000:00:00.5
> > >      1fc080000-1fc0800ff : 0000:00:00.5
> > >      1fc090000-1fc0900cb : 0000:00:00.5
> > >      1fc100000-1fc10ffff : 0000:00:00.5
> > >      1fc110000-1fc11ffff : 0000:00:00.5
> > >      1fc120000-1fc12ffff : 0000:00:00.5
> > >      1fc130000-1fc13ffff : 0000:00:00.5
> > >      1fc140000-1fc14ffff : 0000:00:00.5
> > >      1fc150000-1fc15ffff : 0000:00:00.5
> > >      1fc200000-1fc21ffff : 0000:00:00.5
> > >      1fc280000-1fc28ffff : 0000:00:00.5
> > >
> > > That patch made a fair comment that /proc/iomem might be confusing when
> > > it shows resources without an associated device, but we can do better
> > > than just hide the resource name altogether. Namely, we can print the
> > > device name _and_ the resource name. Like this:
> > >
> > > 1fc000000-1fc3fffff : pcie@1f0000000
> > >    1fc000000-1fc3fffff : 0000:00:00.5
> > >      1fc010000-1fc01ffff : 0000:00:00.5 sys
> > >      1fc030000-1fc03ffff : 0000:00:00.5 rew
> > >      1fc060000-1fc0603ff : 0000:00:00.5 s2
> > >      1fc070000-1fc0701ff : 0000:00:00.5 devcpu_gcb
> > >      1fc080000-1fc0800ff : 0000:00:00.5 qs
> > >      1fc090000-1fc0900cb : 0000:00:00.5 ptp
> > >      1fc100000-1fc10ffff : 0000:00:00.5 port0
> > >      1fc110000-1fc11ffff : 0000:00:00.5 port1
> > >      1fc120000-1fc12ffff : 0000:00:00.5 port2
> > >      1fc130000-1fc13ffff : 0000:00:00.5 port3
> > >      1fc140000-1fc14ffff : 0000:00:00.5 port4
> > >      1fc150000-1fc15ffff : 0000:00:00.5 port5
> > >      1fc200000-1fc21ffff : 0000:00:00.5 qsys
> > >      1fc280000-1fc28ffff : 0000:00:00.5 ana
> > >
> > > Fixes: 8d84b18f5678 ("devres: always use dev_name() in devm_ioremap_resource()")
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > [...]
> >
> >     You didn't write the version log -- what changed since v1?
> >
> > MBR, Sergei
> 
> The changes in v2 are that I'm checking for memory allocation errors.

You always need to mention that below the --- line, as the
documentation says to.

Please send a v3 with that fixed up.

thanks,

greg k-h
