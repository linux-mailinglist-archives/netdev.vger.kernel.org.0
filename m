Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025404DB698
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357539AbiCPQrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357608AbiCPQqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:46:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227512DABE
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 09:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26175617A1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 16:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29257C340EC;
        Wed, 16 Mar 2022 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647449129;
        bh=q8HrFFKmOYza9BhbCgNRK0WyF5ImavvVw1urR0TeurU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kTFLoKdjNVGnokAjvq9g/+5A9dg8cvu5nl/7G81LY8uZI2rjqCZsgZwFZMj8I8T6X
         fRLxEgyvZOv4GBPC3Z5enP7Zp9W0zHEPjW9xufTL5uM2Jf3ZC8vUYoSP04pn6zNsq8
         LVdBQQysW75gT9o3SZBHOM21M5qUrZioj6sMAM46LoGseeKrjfDCPX3an9q2LjgauI
         Xk7zPcJrTGrZna7OCr0fEF2TWjHZO8rp8VvURG8ktEvcsGXMnhqRevfJPxMWpUc0zX
         +eqjeX1I1SMsTObQ+4Elr78AK8NVutEodawfCjsgXf/qEMD2oXswh4GpyPOm6/DKWH
         hXMya/+LaC4tA==
Date:   Wed, 16 Mar 2022 09:45:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        louis.peens@corigine.com
Subject: Re: [PATCH net-next 3/6] eth: nfp: replace driver's "pf" lock with
 devlink instance lock
Message-ID: <20220316094527.16377adc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjGhF2AYAq/XNh+F@unreal>
References: <20220315060009.1028519-1-kuba@kernel.org>
        <20220315060009.1028519-4-kuba@kernel.org>
        <YjGhF2AYAq/XNh+F@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 10:34:31 +0200 Leon Romanovsky wrote:
> > -#define nfp_app_is_locked(app)	lockdep_is_held(&(app)->pf->lock)
> > +static inline bool nfp_app_is_locked(struct nfp_app *app)
> > +{
> > +	return devl_lock_is_held(priv_to_devlink(app->pf));
> > +}  
> 
> Does it compile if you set CONFIG_LOCKDEP=n?

Yes, it's exactly the same as lockdep_is_held(). PTAL at lockdep.h, 
the extern int lockdep_is_held(const void *); is under LOCKDEP=n.
There is no definition for it.
