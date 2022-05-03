Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00D6518D25
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbiECT17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240872AbiECT16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:27:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7EC2CC98
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 12:24:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD8E6194C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 19:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F121C385A9;
        Tue,  3 May 2022 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651605865;
        bh=ouEjsiSkMeu2RzXOgWW54Q+EMZUFu8mAk9IauxcLeeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=As57BJBLe2Lsco0367vcPjxp7yn7gyWQ+Ul7iaw28Qb8Sx6AAKIhVQpL27TlN4mGW
         t6RWsiLaNbiraKwRC7uyBYAGECh6Us4aUC9I7LioEuOAVYxECtj9HwzgulSnZe4IA4
         u0wKbdjju8SJI5Q54gep9QMhCxwEuqc5rxdf03MViXQKM+lCHKparX9ovc1Ua3gUDO
         t2V8mrvYy067zD+/Y6sTx61al3CtXERuSaByB1v7VNWzUT58qhSvK3uEfAhyWO7DpR
         uMPNZux2VzQigTTMPIgB6urTpgm2MlBNptabUs6WUZd+7FLEwVN1dcoFQK1Xg+zlW0
         eErGovkpYHgVA==
Date:   Tue, 3 May 2022 12:24:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Message-ID: <20220503122423.29f48b61@kernel.org>
In-Reply-To: <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
References: <20220427175048.225235-1-maximmi@nvidia.com>
        <20220428151142.3f0ccd83@kernel.org>
        <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
        <20220429121117.21bf7490@kernel.org>
        <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
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

On Tue, 3 May 2022 21:56:48 +0300 Maxim Mikityanskiy wrote:
> >> Yes, I agree that if the application opted in, it should work properly
> >> regardless of whether the optimization actually did turn on. However,
> >> the indication could be useful, for example, for diagnostic purposes, to
> >> show the user whether zerocopy mode was enabled, if someone is trying to
> >> debug some performance issue. If you insist, though, I can make
> >> setsockopt succeed and getsockopt return 1. What do you think?  
> > 
> > I'd say "whether the optimization is applicable" rather than "whether
> > the optimization is turned on". User can check whether the connection
> > is using SW or HW TLS if they want to make sure it's taken advantage of.
> > 
> > Speaking of which, should we report the state of this knob via socket
> > diag?  
> 
> That sounds like an option, I'll take a look. TLS doesn't expose 
> anything via diag yet, does it? The only option to distinguish SW/HW TLS 
> is ethtool, and there is no per-socket check, right? Cause a HW TLS 
> socket can downgrade to SW after tls_device_down, and ethtool won't show it.

It does - look for tls_get_info()
