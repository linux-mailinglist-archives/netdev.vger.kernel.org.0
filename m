Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA73553B97
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 22:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353923AbiFUU0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 16:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiFUU0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 16:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED03C2A73B;
        Tue, 21 Jun 2022 13:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87A0B6177B;
        Tue, 21 Jun 2022 20:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494B9C3411C;
        Tue, 21 Jun 2022 20:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655843206;
        bh=Iv7WrPExU3s0MnkfQxFXTcvrqffkxEjLNITUpV9WDZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QjAH+6v+BLZOFXyeSbf34WfglSewe50UzYMMuRcB/g8L0KNuhl/q7DA/TTgb/+w2v
         2VS9z2dCQYWQZUm6Mm+cQlYqQsYKgd8PzSGqMakjTQhPGdiDlkIGm84MWNpElAlLBy
         muSZF/Gcl4hVPDFEDSjjJXs5WcGOI0owEcZLc92A=
Date:   Tue, 21 Jun 2022 22:26:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of CQE_RX_TRUNCATED
Message-ID: <YrIpgssFaIYu1EN3@kroah.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
 <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
 <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
 <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM5PR21MB17494B8D4472F74198C88FE7CAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB17494B8D4472F74198C88FE7CAB39@DM5PR21MB1749.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 07:55:26PM +0000, Haiyang Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Monday, February 7, 2022 12:12 PM
> > To: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; Dexuan Cui
> > <decui@microsoft.com>; KY Srinivasan <kys@microsoft.com>; Stephen
> > Hemminger <sthemmin@microsoft.com>; Paul Rosswurm
> > <paulros@microsoft.com>; Shachar Raindel <shacharr@microsoft.com>;
> > olaf@aepfle.de; vkuznets <vkuznets@redhat.com>; davem@davemloft.net;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of
> > CQE_RX_TRUNCATED
> > 
> > On Sat, 5 Feb 2022 22:32:41 +0000 Haiyang Zhang wrote:
> > > Since the proper handling of CQE_RX_TRUNCATED type is important, could
> > any
> > > of you backport this patch to the stable branches: 5.16 & 5.15?
> > 
> > Only patches which are in Linus's tree can be backported to stable.
> > You sent this change for -next so no, it can't be backported now.
> > You need to wait until 5.17 final is released and then ask Greg KH
> > to backport it.
> 
> @Greg KH <gregkh@linuxfoundation.org>
> 
> Hi Greg,
> 
> This patch is on 5.18 now:
> 	net: mana: Add handling of CQE_RX_TRUNCATED
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.18.5&id=e4b7621982d29f26ff4d39af389e5e675a4ffed4
> 
> Could you backport it to 5.15?


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
