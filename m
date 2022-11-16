Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD462B322
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiKPGLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiKPGLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:11:13 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5D963CF;
        Tue, 15 Nov 2022 22:11:11 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CFEBC68AA6; Wed, 16 Nov 2022 07:11:06 +0100 (CET)
Date:   Wed, 16 Nov 2022 07:11:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/7] dma-mapping: reject __GFP_COMP in dma_alloc_attrs
Message-ID: <20221116061106.GA19118@lst.de>
References: <20221113163535.884299-1-hch@lst.de> <20221113163535.884299-8-hch@lst.de> <Y3H4RobK/pmDd3xG@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3H4RobK/pmDd3xG@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 10:11:50AM +0200, Leon Romanovsky wrote:
> In RDMA patches, you wrote that GFP_USER is not legal flag either. So it
> is better to WARN here for everything that is not allowed.

So __GFP_COMP is actually problematic and changes behavior, and I plan
to lift an optimization from the arm code to the generic one that
only rounds up allocations to the next page size instead of the next
power of two, so I need this check now.  Other flags including
GFP_USER are pretty bogus to, but I actually need to do a full audit
before rejecting them, which I've only done for GFP_COMP so far.
