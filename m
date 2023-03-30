Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BDD6CF89B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 03:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjC3BOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 21:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjC3BOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 21:14:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131419B3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B111261E9C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56DDC433EF;
        Thu, 30 Mar 2023 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680138849;
        bh=FFWdFB2zI6gVwnEprnMCPpcJkq040yxf+K1pV1kS8y0=;
        h=Date:From:To:Cc:Subject:From;
        b=tbsjd8YmKRFVJzHSLXUv5UFhpKKrDJArVE+bxCIkfED6Ol1+L5kWKhkToD0PWR3Cm
         dhfkjHXwp6LtSGs81ieODh/eZYW7vxjYQL3QzBTG3COitoi95Yjk7uSaUYfR3F5sv9
         74UJ1CyoWxd2ClQ8EtUGP+NXs4No7J3jVzHF1ArhJjNFAgSjJggN4P4x3i3w91L8z2
         puvamb1UVtIwq7T5N3EH/xL7w4fS4ChwIfRxuKlfnH/bpJTICJhf3GrRF7TPAjrGQe
         NW4O6gnErYCOaY+R5cmuES42Gw0J+2SD7q9qIQ8N2nkHkoTl6gIvVNM7xUzuDXaMOk
         Qhf9fIQLspAaw==
Date:   Wed, 29 Mar 2023 18:14:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     iommu@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: AMD IOMMU problem after NIC uses multi-page allocation
Message-ID: <20230329181407.3eed7378@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joerg, Suravee,

I see an odd NIC behavior with AMD IOMMU in lazy mode (on 5.19).

The NIC allocates a buffer for Rx packets which is MTU rounded up 
to page size. If I run it with 1500B MTU or 9000 MTU everything is
fine, slight but manageable perf hit.

But if I flip the MTU to 9k, run some traffic and then go back to 1.5k 
- 70%+ of CPU cycles are spent in alloc_iova (and children).

Does this ring any bells?
