Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE67B6E5121
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjDQToy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDQTox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE3CD2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 402D4622FF
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDAEC433EF;
        Mon, 17 Apr 2023 19:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681760691;
        bh=svMfUAt141lYrszWOJJWBsLzcqpHYA4DdKxj1axITBg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=spFPNrtjPBq1cBbWVEIPC3MQuF9ksNCZTGqXwjwNsdrWu2D2rqCW3Q18ZPyF/S3BE
         tNiNuGpGkJxhklPTJNJrmGyCO1djdpOmR0ma2RV6ZN1lTKRCYeEaTZO0YxcuT2ssoJ
         J36yfzKNaMyPbRI44+GZOgsPVRUUXGDiqopONEzql5DsCtCR2C28LdobF1aSwT0V/s
         Rvs0q9iqKyJzogj2P8VKO9Cw7MguKbscZJdUtgVFryc6eahJwFnAKBEiaS5lrx2zVs
         F1mXBSkd+R+D3rSfIlKc0y4wUh4z4RAhudm1UiUr10QHC1zKvgKPg9C6Fmq8oAKeaE
         a+U5R5bneymDQ==
Date:   Mon, 17 Apr 2023 12:44:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com
Subject: Re: [PATCH net-next] eth: mlx5: avoid iterator use outside of a
 loop
Message-ID: <20230417124450.6a06686e@kernel.org>
In-Reply-To: <20230416101753.GB15386@unreal>
References: <20230414180729.198284-1-kuba@kernel.org>
        <20230416101753.GB15386@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Apr 2023 13:17:53 +0300 Leon Romanovsky wrote:
> > -	return mlx5_irq_get_affinity_mask(eq->core.irq);
> > +	WARN_ON_ONCE(1);
> > +	return 0; =20
>=20
> I would do it without changing last return, but "return ERR_PTR(0);"
> will do the trick too.

Hm, I've not seen ERR_PTR(0) used before. I'll return NULL.=20
Looks like callers pass the value to cpumask_first() without checking=20
so either way the warning will be followed by a crash =F0=9F=A4=B7=EF=B8=8F
