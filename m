Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E875266B4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381625AbiEMQCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381602AbiEMQCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 12:02:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAEFE92
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 09:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 041F0B83030
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 16:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564BEC34100;
        Fri, 13 May 2022 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652457735;
        bh=macZkdUsTyeTMdBi+oK0k3KP7kO6hhL+rVEL55QGPAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=auoeTBQjpG3VYmBra65M+OlmDpYjIoY+MF7MTZoisJfWNV3CrnU41H+/QOAVwrbrY
         j4WLSMTCdxXXf07v1btVRYJBBaKzoyRo9K01JgLMD7i/NMIpOjddJ4RKLksBDVG21X
         B8VOB+y2a3IMRXcQTZ1pcle+g4+r275h8v/LeaOgPLOmEyR99ws2afNPTkLkKQrUAs
         H/9SQ6CHGL22/9OFMmDwywyRKdiw15QOpnqKgpgmYyHwRlNZg+RmeNSlqpM8J4puom
         M/qUWt90iwEnuoPgLcDRh+QdQyV4iJgN6Z9sukG/n1YeDFBrUUJUrYiYkIFHnoTmeU
         9aoN06DCfezcA==
Date:   Fri, 13 May 2022 09:02:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220513090213.2d1ca3c8@kernel.org>
In-Reply-To: <507d2140-1f22-174d-f55e-16ebcf03f249@nvidia.com>
References: <20220511121525.624059-1-maximmi@nvidia.com>
        <20220512163458.31ae2d13@kernel.org>
        <507d2140-1f22-174d-f55e-16ebcf03f249@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 May 2022 10:57:06 +0300 Maxim Mikityanskiy wrote:
> > What about the reporting via sock diag? Am I misremembering something?  
> 
> I recall we discussed that "zerocopy is active" can be restored as 
> "hardware offload && setsockopt flag requested", and I saw that 
> tls_get_info exposes the hardware offload state for the socket, so I 
> thought the existing information in sock_diag was enough.
> 
> If you think, though, that it will be better to have an explicit 
> indication of the zerocopy flag to sock_diag, I can add it, it's not a 
> problem.

Yeah, my thinking is that if a user reports problems to me I'd like to
be able to log in to the box and see what they have configured on the
socket. ss is quick and easy to type. I'm not aware of tooling that'd
grab descriptors for sockets and do getsockopt() (even tho technically
it is doable), are there any? I'm not feeling strong about sock_diag
specifically being the way but for such a potentially correctness-
-impacting optimization we should give admins an easy way to
interrogate if it's enabled or not.

> Does the rest of the patch look good to you?

Yup!
