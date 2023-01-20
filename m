Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EBF675106
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjATJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjATJ1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:27:13 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 055A0A19A5;
        Fri, 20 Jan 2023 01:26:42 -0800 (PST)
Received: from 8bytes.org (p200300c27714bc0086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:7714:bc00:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id E12D62626D1;
        Fri, 20 Jan 2023 10:24:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1674206697;
        bh=N0Ez9jlBhYWiOK7+xYABfIe0+VmfRPgpACpzUje2F4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOLKVLD4dyMYfuGfszt0Aqi18MMtbwUvgwVbHoDO6hE/pu3jlsoFnfOvfV2sSJ6i8
         k3lOBgDA7x9bkKbnD+qVSk6qrzEVOc/9/JS99/CzblV3IjUWMNUsDLegoejr0hYkyT
         NIAGgbjvSNtqhO8clUAYjH7vWYcGoTKi2kDTgKFmFcsSDinl9Vo2l2M2oUTe7UNJh3
         4hHtdAX4so62XBRGFWlRKgCJW94p/lPduMMBp2SCZ238xwGOe1m0xh9F5SouN8x7NO
         06U5w+umYu9ogUcIQK1YpQ4ciXMhW+H2quzpMMrP7f3cTLkb2U0hf6Ab3xk/GMJY5E
         1P63Vv4/HChRw==
Date:   Fri, 20 Jan 2023 10:24:55 +0100
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
Message-ID: <Y8pd50mdNShTyVRX@8bytes.org>
References: <1-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <4fd1b194-29ef-621d-4059-a8336058f217@arm.com>
 <Y7hZOwerwljDKoQq@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7hZOwerwljDKoQq@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 01:24:11PM -0400, Jason Gunthorpe wrote:
> I think it is just better to follow kernel convention and have
> allocation functions include the GFP because it is a clear signal to
> the user that there is an allocation hidden inside the API. The whole
> point of gfp is not to have multitudes of every function for every
> allocation mode.

Well, having GFP parameters is not a strict kernel convention. There are
places doing it differently and have sleeping and atomic variants of
APIs. I have to say I like the latter more. But given that this leads to
an invasion of API functions here which all do the same under the hood, I
agree it is better to go with a GFP parameter here.

Regards,

	Joerg
