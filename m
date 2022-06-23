Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399F3558996
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFWTv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiFWTv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:51:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E1CE6A;
        Thu, 23 Jun 2022 12:51:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33E4EB824D6;
        Thu, 23 Jun 2022 19:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA66C341C0;
        Thu, 23 Jun 2022 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656013883;
        bh=VLyBp5Co68HkeVuGaxmyXwHAeDZdj1CEZJbovhRG/j4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HavezG7o7tE5X6T1K09XV+bgeG1QWXJo90zYp6Z4Kid+4cpRMIKHw1exq32Btxp5m
         qC5GO7Bwd2Z0v5l2dEAQ4o/wHxmv6AkjV5xyWEzDg3JSwSAJXNMagqv7yR1IjZZCEy
         +QKblGmtyDfXhW2SwTr1bX0QHdF6lhHXItOphKqQ0GgxLLSKaVA/KL9ivjMuql4CxO
         2vnU1yg/WvhfScR+Z9M07GPzR3ZtrcR+aHkS8R8LcmRIxOpqNmArPDft0fFLNaXkt/
         0rO4mlTNWmKWDkE/GwuAuVqbXl6Hw+l3spk6Vq/p2oBkiJijyYhlwoCILDEZ5hmry8
         ry34p7MwgGZEw==
Date:   Thu, 23 Jun 2022 12:51:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        Max Krummenacher <max.oss.09@gmail.com>,
        max.krummenacher@toradex.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] Revert "Bluetooth: core: Fix missing power_on work
 cancel on HCI close"
Message-ID: <20220623125113.214fac0b@kernel.org>
In-Reply-To: <20220621115514.GA75773@francesco-nb.int.toradex.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
        <20220621115514.GA75773@francesco-nb.int.toradex.com>
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

On Tue, 21 Jun 2022 13:55:14 +0200 Francesco Dolcini wrote:
> Marcel, Vasyl,
> any comment on this?

+1 is there an ETA on the fix getting into net?

> On Tue, Jun 14, 2022 at 08:17:06PM +0200, Max Krummenacher wrote:
> > From: Max Krummenacher <max.krummenacher@toradex.com>
> > 
> > This reverts commit ff7f2926114d3a50f5ffe461a9bce8d761748da5.
> > 
> > The commit ff7f2926114d ("Bluetooth: core: Fix missing power_on work
> > cancel on HCI close") introduced between v5.18 and v5.19-rc1 makes
> > going to suspend freeze. v5.19-rc2 is equally affected.
> > 
> > This has been seen on a Colibri iMX6ULL WB which has a Marvell 8997
> > based WiFi / Bluetooth module connected over SDIO.
> > 
> > With 'v5.18' or 'v5.19-rc1 with said commit reverted' a suspend/resume
> > cycle looks as follows and the device is functional after the resume:
