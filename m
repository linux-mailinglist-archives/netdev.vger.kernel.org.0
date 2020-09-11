Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EE32661E4
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIKPNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgIKPKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:10:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A8F20855;
        Fri, 11 Sep 2020 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599836905;
        bh=ZvCNwDB58Wh92osqcGUGnbAHqj30EkbXBpA324c6N+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B4sj/Lsai9RCmjyvAKubPcJVjkQo9xZLUrSSENDgWOJkpao/gaxkv2hny+2EaqRkB
         Ew9AhS81v9nFhwPA9SYheVfBvvUHMZYYxqqElDHqc79exWRmRgPdvnQGw7OyuxFV/L
         Cwpl7QeFnm8KixK9vUFzc0d4BydWg6VeVE1Tb6bo=
Date:   Fri, 11 Sep 2020 08:08:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brady, Alan" <alan.brady@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 01/15] virtchnl: Extend AVF ops
Message-ID: <20200911080822.333f79b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MW3PR11MB4522BCE8D08A318E2EF2DF5E8F270@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
        <20200824173306.3178343-2-anthony.l.nguyen@intel.com>
        <20200824124231.61c1a04f@kicinski-fedora-PC1C0HJN>
        <MW3PR11MB4522EDF96406226D06C05CFF8F550@MW3PR11MB4522.namprd11.prod.outlook.com>
        <MW3PR11MB4522BCE8D08A318E2EF2DF5E8F270@MW3PR11MB4522.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 21:06:05 +0000 Brady, Alan wrote:
> > It seems like these are triggering on old messages too, curious why this wasn't
> > caught sooner.  Will fix, thanks.
> > 
> I managed to get a 32-bit build environment setup and found that we
> do indeed have alignment issues there on 32 bit systems for some of
> the new ops we added with the series.  However, I think I'm still
> missing something as it looks like you have errors triggering on much
> more than I found and I'm suspecting there might be a compile option
> I'm missing or perhaps my GCC version is older than yours.  E.g., I
> found issues in virtchnl_txq_info_v2, virtchnl_rxq_info_v2,
> virtchnl_config_rx_queues, and virtchnl_rss_hash.  It appears you
> have compile issues in virtchnl_get_capabilities (among others)
> however which did not trigger on mine.  Manual inspection indicates
> that it _should_ be triggering a failure and that your setup is more
> correct than mine.  I'm guessing some extra padding is getting
> included in some places and causing a false positive on the other
> alignment issues.  Are there any hints you can provide me that might
> help me more accurately reproduce this?

Hm. I build like this:

make CC="ccache gcc" O=build32/ ARCH=i386 allmodconfig
make CC="ccache gcc" O=build32/ ARCH=i386 -j 64 W=1 C=1

My GCC is:
Target: x86_64-pc-linux-gnu
Configured with: ../gcc-10.1.0/configure --enable-languages=c,c++
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 10.1.0 (GCC) 
