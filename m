Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1EC677814
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjAWKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjAWKAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:00:21 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F5178A72;
        Mon, 23 Jan 2023 01:59:53 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 9A316262C2B;
        Mon, 23 Jan 2023 10:59:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674467975;
        bh=0KQBObUcnpg5GrqXq3hC5RyjGf2zS6TIXg2zcVgFWn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tr3JGNsZMXVI480xgKW5iIBnC2CS9vyEqh9gWSstha079Y/cRMHa9gi+uxnReHb5d
         fwek2sY7wwUJnFwFFwIvWemH12HdN0YbgdSZ2RWwC0269UqDUwGwB35CRDyXhq60AT
         USyIwI3wP05/5oGtUOpS94M53A08jNcPckKA5ZXpZIPRaNJ96Q+BFkTkmpgSNGCPm5
         YogHT95t/tBdYhxC9Y35A2TokJihCUBd4VwOl8Pa35zfKfyCatWPy6AY7P+apvfw5a
         T/W6TQnG+GLz390G6KRQWUX8KnoKg77Sxn7JUzcugID6/sS1m397rjmidCEXxQK2Lj
         1j8HX1fY4eNAw==
Date:   Mon, 23 Jan 2023 10:59:32 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/8] iommu: Add a gfp parameter to iommu_map()
Message-ID: <Y85ahCk3sRTVAU8O@8bytes.org>
References: <1-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
 <Y7hZOwerwljDKoQq@nvidia.com>
 <Y8pd50mdNShTyVRX@8bytes.org>
 <Y8rVJGyTKAjXjLwV@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8rVJGyTKAjXjLwV@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 01:53:40PM -0400, Jason Gunthorpe wrote:
> > Well, having GFP parameters is not a strict kernel convention. There are
> > places doing it differently and have sleeping and atomic variants of
> > APIs. I have to say I like the latter more. But given that this leads to
> > an invasion of API functions here which all do the same under the hood, I
> > agree it is better to go with a GFP parameter here.
> 
> Ok, I think we are done with this series, I'll stick it in linux-next
> for a bit and send you a PR so the trees stay in sync

This series mostly touches parts outside of IOMMUFD, so we should follow
the process here and let this reach linux-next via the IOMMU tree.
Please send me a new version and I will put it into a separate branch
where you can pull it from.

Regards,

	Joerg
