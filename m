Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90435B4CC5
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 10:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiIKIyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 04:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiIKIyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 04:54:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812571A05E;
        Sun, 11 Sep 2022 01:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0544F60F55;
        Sun, 11 Sep 2022 08:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D41CC433C1;
        Sun, 11 Sep 2022 08:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662886447;
        bh=ujluxeiT3c2OGxu4l/l7j+XTjYxGswqiFskBqi2T4V8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D855hvAIVC3T2H6Or0sdVmyzE1AS25KRlHRflYf9tYBfJ/aBm2RajP5fhs51y5Y+u
         YdMKBBfwvNJiSox/cm7oJu3kRutkyCVVJsI9P0AmLhxMOSzFQe+T1zvsWP00VrZtze
         yDpVUpqVNlRHVuMwMblYUbdKRIkKXJLHOxzWssa8fFO5z0CO1ysTYNIMZv0FQ/oPeW
         +yPNqTr7H2cc4zefc4yDnvTwWmk10hFqFHkdONgdn3ySijjmGKzB011x36G+NOaSpA
         piEyP1Q4WPQIpdL55N9QubhbJJLSavKYM26xNJbBEUh2DJ3ig1eDSVd6FkVExlTZNl
         WpKF17YdG6COg==
Date:   Sun, 11 Sep 2022 01:54:04 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Raed Salem <raeds@nvidia.com>
Cc:     Tom Rix <trix@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH net-next] net/mlx5e: Ensure macsec_rule is always
 initiailized in macsec_fs_{r,t}x_add_rule()
Message-ID: <Yx2iLJafMDKYZ0jL@dev-arch.thelio-3990X>
References: <20220908153207.4048871-1-nathan@kernel.org>
 <43471538-22b3-b80e-a1c6-7f3e24bc414a@redhat.com>
 <DM4PR12MB53570DA53F0DA74F132698EAC9459@DM4PR12MB5357.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR12MB53570DA53F0DA74F132698EAC9459@DM4PR12MB5357.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 05:37:26AM +0000, Raed Salem wrote:
> On 9/8/22 8:32 AM, Nathan Chancellor wrote:
> >> Clang warns:
> >>
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> >>            if (err)
> >>                ^~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:598:9: note: uninitialized use occurs here
> >>            return macsec_rule;
> >>                  ^~~~~~~~~~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:2: note: remove the 'if' if its condition is always false
> >>            if (err)
> >>            ^~~~~~~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:523:38: note: initialize the variable 'macsec_rule' to silence this warning
> >>            union mlx5e_macsec_rule *macsec_rule;
> >>                                                ^
> >>                                                = NULL
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> >>            if (err)
> >>                ^~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1215:9: note: uninitialized use occurs here
> >>            return macsec_rule;
> >>                  ^~~~~~~~~~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:2: note: remove the 'if' if its condition is always false
> >>            if (err)
> >>            ^~~~~~~~
> >>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1118:38: note: initialize the variable 'macsec_rule' to silence this warning
> >>            union mlx5e_macsec_rule *macsec_rule;
> >>                                                ^
> >>                                                = NULL
> Why not do as suggested and initialize the macsec_rule to NULL (and change placement to comply with reversed Christmas tree parameters order) ?
> it is cleaner and adhering to similar error paths in the mlx5 driver, thanks for the catch.

No particular reason. I tend to avoid initializing variables at the top
when they might be used in error paths because it will hide warnings if
the variable needs to be set to something different (for example, error
codes). That is not too relevant here from what I can tell so I can just
initialize it at the top as you suggested. I will send a v2 shortly.
Thanks for the input!

Cheers,
Nathan

> >>    2 errors generated.
> >>
> >> If macsec_fs_{r,t}x_ft_get() fail, macsec_rule will be uninitialized.
> >> Use the existing initialization to NULL in the existing error path to 
> >> ensure macsec_rule is always initialized.
> >>
> >> Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
> >> Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
> >> Link: https://github.com/ClangBuiltLinux/linux/issues/1706
> >> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >Reviewed-by: Tom Rix <trix@redhat.com>
> >> ---
> >>
> >> The other fix I considered was shuffling the two if statements so that 
> >> the allocation of macsec_rule came before the call to
> >> macsec_fs_{r,t}x_ft_get() but I was not sure what the implications of 
> >> that change were.
> >>
> >> Also, I thought netdev was doing testing with clang so that new 
> >> warnings do not show up. Did something break or stop working since 
> >> this is the second time in two weeks that new warnings have appeared in -next?
> >>
> >>   .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c    | 6 ++++--
> >>   1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git 
> >> a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c 
> >> b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> >> index 608fbbaa5a58..4467e88d7e7f 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
> >> @@ -537,7 +537,7 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs 
> >> *macsec_fs,
> >>
> >>      err = macsec_fs_tx_ft_get(macsec_fs);
> >>       if (err)
> >> -             goto out_spec;
> >> +             goto out_spec_no_rule;
> >>
> >>       macsec_rule = kzalloc(sizeof(*macsec_rule), GFP_KERNEL);
> >>       if (!macsec_rule) {
> >> @@ -591,6 +591,7 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs 
> >> *macsec_fs,
> >>
> >>   err:
> >>       macsec_fs_tx_del_rule(macsec_fs, tx_rule);
> >> +out_spec_no_rule:
> >>       macsec_rule = NULL;
> >>   out_spec:
> >>       kvfree(spec);
> >> @@ -1129,7 +1130,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs 
> >> *macsec_fs,
> >>
> >>       err = macsec_fs_rx_ft_get(macsec_fs);
> >>       if (err)
> >> -             goto out_spec;
> >> +             goto out_spec_no_rule;
> >>
> >>       macsec_rule = kzalloc(sizeof(*macsec_rule), GFP_KERNEL);
> >>       if (!macsec_rule) {
> >> @@ -1209,6 +1210,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs 
> >> *macsec_fs,
> >>
> >>   err:
> >>       macsec_fs_rx_del_rule(macsec_fs, rx_rule);
> >> +out_spec_no_rule:
> >>       macsec_rule = NULL;
> >>   out_spec:
> >>       kvfree(spec);
> >>
> >> base-commit: 75554fe00f941c3c3d9344e88708093a14d2b4b8
