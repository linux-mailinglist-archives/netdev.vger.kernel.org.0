Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12116CFD0A
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjC3Hle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjC3Hld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:41:33 -0400
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85EE24213
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:41:31 -0700 (PDT)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 311C0243C43;
        Thu, 30 Mar 2023 09:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1680162090;
        bh=U2dhbk+MyoG6YPxg5I8ip0UprpdXdWKYB2+fAQ+jVQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sqeq0MoTGwR/eEPXKGYcOifZM9/bVfenzz6EO605vjSNphVGp1oTsO6fcgB+87ZQB
         XTgst9C2x20Ahc/OVqNo6SmanWmP81ltxX3qYRjxo7tYNV0QLThOqtn+SbZmy6ZXPf
         J6pliFw+MsHLEUHxUj+tU+dMyYSwZrtK0J5odGFAy93vhyihC/LCGGhc1ZjJV+Jblc
         wwzDsmJAl3myJuqSnSrWU6Ftlp2PZUGfWE7VMs7u1uUDCwD/1VAw794NY4zLPDXu63
         RGYO6vZKbIVHv9ADiD8PoiKs92+nM6HmTq3a6TGaxRtUvFqz+M0aUMj8o8wSwAGvpY
         Psh8mmRGCdpTw==
Date:   Thu, 30 Mar 2023 09:41:29 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: AMD IOMMU problem after NIC uses multi-page allocation
Message-ID: <ZCU9KZMlGMWb2ezZ@8bytes.org>
References: <20230329181407.3eed7378@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329181407.3eed7378@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also adding Vasant and Robin.

Vasant, Robin, any idea?

On Wed, Mar 29, 2023 at 06:14:07PM -0700, Jakub Kicinski wrote:
> Hi Joerg, Suravee,
> 
> I see an odd NIC behavior with AMD IOMMU in lazy mode (on 5.19).
> 
> The NIC allocates a buffer for Rx packets which is MTU rounded up 
> to page size. If I run it with 1500B MTU or 9000 MTU everything is
> fine, slight but manageable perf hit.
> 
> But if I flip the MTU to 9k, run some traffic and then go back to 1.5k 
> - 70%+ of CPU cycles are spent in alloc_iova (and children).
> 
> Does this ring any bells?
