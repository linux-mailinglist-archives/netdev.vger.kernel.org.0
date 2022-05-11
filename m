Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918E0522C77
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241597AbiEKGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiEKGkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C49CC2;
        Tue, 10 May 2022 23:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 978CC617D1;
        Wed, 11 May 2022 06:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E7DC385DB;
        Wed, 11 May 2022 06:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652251242;
        bh=Ok4I4d6UPMWBLK8/vZSBofRO2QXJr3omzfy9qCojrao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mq3MQE7yeRxv0bDnByvR5T+drbpTtu06XJI0mPI4G2XLoiUf0/NCzDQU7F0cOuS0/
         7ttK8d+w8AS48DEDIqLhc8wtey/E0CtPMeZNnMDfyxZMQ3Gc16ial8s66K+udpn12L
         /wOvOFEjt943zqPqD0NCknRYGrqA97/QyNbPSgy4tgkiHc6nHy8xD1IZzTtyBXzWoj
         GLlqB3IqKek35dIbknBlssL1cx475TIq1RHuObq+iQhhAnDl7hXB8nO+HNzqHKNrjr
         szGHOWotHe8XCnjXvRjD8+WtxEBcRExkx56IzXYaDRcLYrwMNuC1xLwPOTJV8EkbWd
         Bk8fe3TbOqOQg==
Date:   Wed, 11 May 2022 09:40:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 mlx5-next 0/4] Improve mlx5 live migration driver
Message-ID: <YntaZcd+Qv5UiQRN@unreal>
References: <20220510090206.90374-1-yishaih@nvidia.com>
 <YnploMZRI9jXMXAi@unreal>
 <20220510090053.56efd550.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510090053.56efd550.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 09:00:53AM -0600, Alex Williamson wrote:
> On Tue, 10 May 2022 16:16:16 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > On Tue, May 10, 2022 at 12:02:02PM +0300, Yishai Hadas wrote:
> > > This series improves mlx5 live migration driver in few aspects as of
> > > below.
> > > 
> > > Refactor to enable running migration commands in parallel over the PF
> > > command interface.
> > > 
> > > To achieve that we exposed from mlx5_core an API to let the VF be
> > > notified before that the PF command interface goes down/up. (e.g. PF
> > > reload upon health recovery).
> > > 
> > > Once having the above functionality in place mlx5 vfio doesn't need any
> > > more to obtain the global PF lock upon using the command interface but
> > > can rely on the above mechanism to be in sync with the PF.
> > > 
> > > This can enable parallel VFs migration over the PF command interface
> > > from kernel driver point of view.
> > > 
> > > In addition,
> > > Moved to use the PF async command mode for the SAVE state command.
> > > This enables returning earlier to user space upon issuing successfully
> > > the command and improve latency by let things run in parallel.
> > > 
> > > Alex, as this series touches mlx5_core we may need to send this in a
> > > pull request format to VFIO to avoid conflicts before acceptance.  
> > 
> > The PR was sent.
> > https://lore.kernel.org/netdev/20220510131236.1039430-1-leon@kernel.org/T/#u
> 
> For patches 2-4, please add:
> 
> Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Done, I force pushed same branch and tag, so previous PR is still valid
to be pulled.
https://lore.kernel.org/kvm/20220510131236.1039430-1-leon@kernel.org/T/#u

Thanks

> 
> Thanks,
> Alex
> 
