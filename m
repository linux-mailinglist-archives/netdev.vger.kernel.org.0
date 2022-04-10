Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD1A4FAC9E
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiDJIAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbiDJIAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:00:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BA1110;
        Sun, 10 Apr 2022 00:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EC64B80AF9;
        Sun, 10 Apr 2022 07:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB21C385A4;
        Sun, 10 Apr 2022 07:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649577500;
        bh=fzlsv5Dv4TCHvk6X1qKI3Q05UZcZnevWvPuhtyh68b4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tK7Ffd1mNoUbFDzuWcg0yTNJt1gEmxW3kufoMcQ25ae1hZxq1Gr8zHwdcVhKzxUtR
         MugRZwlucQcazfuBH9+UEm4T45bvp39aPcbsFNB4/A+LTlJ3U2MHmXLsHpnT1fJSmX
         XzImqAM+3Nwxhu3DufaCoJunjTqA6oOjNDaFeUFe48CiBhzrHK2Gp/Lbb4E2T7Ruk8
         6lT1uf24tF96xPmodhLdq8u53Wt0eQUuSbTP2Vr+WgOaq9hLazROnng+vT1pu1oedA
         4mxSIxhXOV1pF/aqsvtJavWPo53yQuuYelGJHfhhEJTFWWmLLuQSXmWGRwiDMbNYQ1
         Yd+7ufyRaG0KQ==
Date:   Sun, 10 Apr 2022 10:58:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Nullify eq->dbg and qp->dbg
 pointers post destruction
Message-ID: <YlKOGMw7vemdPn/a@unreal>
References: <cover.1649139915.git.leonro@nvidia.com>
 <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
 <20220405194845.c443x4gf522c2kgv@sx1>
 <Yk1Hc8l5bs25wEcE@unreal>
 <20220408193035.2uplgfjnfjo4s4f2@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408193035.2uplgfjnfjo4s4f2@sx1>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 12:30:35PM -0700, Saeed Mahameed wrote:
> On 06 Apr 10:55, Leon Romanovsky wrote:
> > On Tue, Apr 05, 2022 at 12:48:45PM -0700, Saeed Mahameed wrote:
> > > On 05 Apr 11:12, Leon Romanovsky wrote:
> > > > From: Patrisious Haddad <phaddad@nvidia.com>
> > > >
> > > > Prior to this patch in the case that destroy_unmap_eq()
> > > > failed and was called again, it triggered an additional call of
> > > 
> > > Where is it being failed and called again ? this shouldn't even be an
> > > option, we try to keep mlx5 symmetrical, constructors and destructors are
> > > supposed to be called only once in their respective positions.
> > > the callers must be fixed to avoid re-entry, or change destructors to clear
> > > up all resources even on failures, no matter what do not invent a reentry
> > > protocols to mlx5 destructors.
> > 
> > It can happen when QP is exposed through DEVX interface. In that flow,
> > only FW knows about it and reference count all users. This means that
> > attempt to destroy such QP will fail, but mlx5_core is structured in
> > such way that all cleanup was done before calling to FW to get
> > success/fail response.
> 
> I wasn't talking about destroy_qp, actually destroy_qp is implemented the
> way i am asking you to implement destroy_eq(); remove debugfs on first call
> to destroy EQ, and drop the reentry logic from from mlx5_eq_destroy_generic
> and destroy_async_eq.
> 
> EQ is a core/mlx5_ib resources, it's not exposed to user nor DEVX, it
> shouldn't be subject to DEVX limitations.

I tend to agree with you. I'll take another look on it and resubmit.

> 
> Also looking at the destroy_qp implementation, it removes the debugfs
> unconditionally even if the QP has ref count and removal will fail in FW.
> just FYI.

Right, we don't care about debugfs.

> 
> For EQ I don't even understand why devx can cause ODP EQ removal to fail..
> you must fix this at mlx5_ib layer, but for this patch, please drop the
> re-entry and remove debugfs in destroy_eq, unconditionally.

The reason to complexity is not debugfs, but an existence of
"mlx5_frag_buf_free(dev, &eq->frag_buf);" line, after FW command is
executed.

We need to separate to two flows: the one that can tolerate FW cmd failures
and the one that can't. If you don't add "reentry" flag, you can (theoretically)
find yourself leaking ->frag_buf in the flows that don't know how to reentry.

I'll resubmit.

Thanks
