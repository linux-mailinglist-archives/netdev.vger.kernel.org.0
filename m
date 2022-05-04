Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2650551AEE7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377963AbiEDUXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiEDUXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:23:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48E754EDC7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651695565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqBORo7onRNJucbq9ImW1EUZjcDVqkZ0T4Mz45yXwXM=;
        b=BPimHeIxqw/Jc525YIbmgoIAE0mPH6Bj1MK8Pv9035W+JdfvvHnj109An+lvcP6nO9Bmnu
        2U6rpsqfd44mULLOGuIHAmd2Zx15YnntAfGCnWzzdC4CJbyKG3//sAMzPRn6VCZ7iP6ghv
        5AgXu9Z7LmnlQwU7ee+0KgjM0NNvnb4=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-0rFnyLmnOg6KlsZ-Qnvv6Q-1; Wed, 04 May 2022 16:19:22 -0400
X-MC-Unique: 0rFnyLmnOg6KlsZ-Qnvv6Q-1
Received: by mail-il1-f200.google.com with SMTP id v14-20020a056e020f8e00b002caa6a5d918so1278580ilo.15
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 13:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nqBORo7onRNJucbq9ImW1EUZjcDVqkZ0T4Mz45yXwXM=;
        b=ZCMeQtAEZafNPc5pbk+AYzWREOs4ouxbb7re9ESqRU8f1rgTnpIrqdzLSoZFI4jptp
         /w3zrQZfhmYYo9R5owRq7UhQ7QSBiZZH31xBxH1/1pkTXXnrm6FU4iKqBZaM7yqKuKW6
         MvtZxO3Vt1wKwH3UvsRCnLLhFiZ2Wfv273bVh6lnKgTrUCSrqKKeD0tRWo8fDdqddM0+
         V6zRNNUyFIycBLGzRH86+sJnWmNHDVsFRsjGFRIm5KqsMZGsEa5H6q5600zVCsV2x/MR
         mqzeCSEy6pSGZ7hKDWzJFSYEYM/+0eTNiUGHRKdeObhLehCcz0aLIGKHbu6S/Ow8OaTo
         we5w==
X-Gm-Message-State: AOAM5329+9pXtTLX7GKdzEGv7p3lWlQMamp8+XyKFHFyYc/MHXAf851c
        06IM9iNGkxpdngVz5H5YypVuFeGhw1v9LT2nUI8tA5j8R6hc0sQvpazKeP0wkiZHAoWFygtAl4C
        h6osf7Gbcd0rkT05w
X-Received: by 2002:a5d:9947:0:b0:654:b989:699f with SMTP id v7-20020a5d9947000000b00654b989699fmr8551404ios.170.1651695561412;
        Wed, 04 May 2022 13:19:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3JjSwvrEGkbnQFW5PZeCbiSWsUpDLMslxiX9NWUOort19bOk8Alhk71p1krSvTBDG/zQQcQ==
X-Received: by 2002:a5d:9947:0:b0:654:b989:699f with SMTP id v7-20020a5d9947000000b00654b989699fmr8551381ios.170.1651695560807;
        Wed, 04 May 2022 13:19:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w9-20020a056638030900b0032b3a7817d1sm4946014jap.149.2022.05.04.13.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 13:19:20 -0700 (PDT)
Date:   Wed, 4 May 2022 14:19:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Message-ID: <20220504141919.3bb4ee76.alex.williamson@redhat.com>
In-Reply-To: <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
        <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 May 2022 16:29:37 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 27/04/2022 12:31, Yishai Hadas wrote:
> > This series improves mlx5 live migration driver in few aspects as of
> > below.
> >
> > Refactor to enable running migration commands in parallel over the PF
> > command interface.
> >
> > To achieve that we exposed from mlx5_core an API to let the VF be
> > notified before that the PF command interface goes down/up. (e.g. PF
> > reload upon health recovery).
> >
> > Once having the above functionality in place mlx5 vfio doesn't need any
> > more to obtain the global PF lock upon using the command interface but
> > can rely on the above mechanism to be in sync with the PF.
> >
> > This can enable parallel VFs migration over the PF command interface
> > from kernel driver point of view.
> >
> > In addition,
> > Moved to use the PF async command mode for the SAVE state command.
> > This enables returning earlier to user space upon issuing successfully
> > the command and improve latency by let things run in parallel.
> >
> > Alex, as this series touches mlx5_core we may need to send this in a
> > pull request format to VFIO to avoid conflicts before acceptance.
> >
> > Yishai
> >
> > Yishai Hadas (5):
> >    vfio/mlx5: Reorganize the VF is migratable code
> >    net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister
> >      APIs
> >    vfio/mlx5: Manage the VF attach/detach callback from the PF
> >    vfio/mlx5: Refactor to enable VFs migration in parallel
> >    vfio/mlx5: Run the SAVE state command in an async mode
> >
> >   .../net/ethernet/mellanox/mlx5/core/sriov.c   |  65 ++++-
> >   drivers/vfio/pci/mlx5/cmd.c                   | 229 +++++++++++++-----
> >   drivers/vfio/pci/mlx5/cmd.h                   |  50 +++-
> >   drivers/vfio/pci/mlx5/main.c                  | 133 +++++-----
> >   include/linux/mlx5/driver.h                   |  12 +
> >   5 files changed, 358 insertions(+), 131 deletions(-)
> >  
> Hi Alex,
> 
> Did you have the chance to look at the series ? It touches mlx5 code 
> (vfio, net), no core changes.
> 
> This may go apparently via your tree as a PR from mlx5-next once you'll 
> be fine with.

As Jason noted, the net/mlx5 changes seem confined to the 2nd patch,
which has no other dependencies in this series.  Is there something
else blocking committing that via the mlx tree and providing a branch
for the remainder to go in through the vfio tree?  Thanks,

Alex

