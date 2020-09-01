Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2796125933C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgIAPXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:23:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42978 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729348AbgIAPXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:23:01 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0E0068EE187;
        Tue,  1 Sep 2020 08:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598973779;
        bh=oM6M8l0ba8Kwr86wVvWOr0ibc9GeoVF02RI3gdpRvZg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UvqMRf/V4bYGUnXRFYzHR0MoWszTvt72MUDJlkPgLVL7Z5C9ghIwUJJ5HYM5kfJ3n
         5VYFPt986TvN+zbqjMT6pkl+t9bvzRZjP81gXVEMiUig/anUDkmm0cM9tI1gLXtLCF
         UIwKWRUmpM4JixpLzQm9dVgj9tnlX6pm+UJWHqoc=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id U-JPs2CIcW43; Tue,  1 Sep 2020 08:22:58 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8B8B18EE0F5;
        Tue,  1 Sep 2020 08:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598973778;
        bh=oM6M8l0ba8Kwr86wVvWOr0ibc9GeoVF02RI3gdpRvZg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QlglmDYfmn+LUmPHNl9G1vxZ4WANgTGEDBcv3VoTq5jkCobGzHRwV7MDXP/8CkPRF
         DlnAvyJzmngr5D0/wC86DqyXRPVdp/OwUQc4zsVd3Mrk54apOxtDVbGKnBnOuqrFqS
         /e8+ps58Vp9230FkQlqzYQQbltdvuVP33ee7Vxcw=
Message-ID: <1598973776.4238.11.camel@HansenPartnership.com>
Subject: Re: [PATCH 07/28] 53c700: improve non-coherent DMA handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
Date:   Tue, 01 Sep 2020 08:22:56 -0700
In-Reply-To: <20200901150554.GN14765@casper.infradead.org>
References: <20200819065555.1802761-1-hch@lst.de>
         <20200819065555.1802761-8-hch@lst.de>
         <1598971960.4238.5.camel@HansenPartnership.com>
         <20200901150554.GN14765@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-09-01 at 16:05 +0100, Matthew Wilcox wrote:
> On Tue, Sep 01, 2020 at 07:52:40AM -0700, James Bottomley wrote:
> > I think this looks mostly OK, except for one misnamed parameter
> > below. Unfortunately, the last non-coherent parisc was the 700
> > series and I no longer own a box, so I can't test that part of it
> > (I can fire up the C360 to test it on a coherent arch).
> 
> I have a 715/50 that probably hasn't been powered on in 15 years if
> you need something that old to test on (I believe the 725/100 uses
> the 7100LC and so is coherent).  I'll need to set up a cross-compiler 
> ...

I'm not going to say no to actual testing, but it's going to be a world
of pain getting something so old going.  I do have a box of older
systems I keep for architectural testing that I need to rummage around
in ... I just have a vague memory that my 715 actually caught fire a
decade ago and had to be disposed of.

James

