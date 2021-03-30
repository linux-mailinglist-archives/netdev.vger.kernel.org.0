Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7534E9B8
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhC3N5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhC3N5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:57:41 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97157C061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:57:40 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id i9so15896205qka.2
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iaN7hqGH3bUfzSvOTqCy+oA56jvK+RCe6WobEzTMl/4=;
        b=kdI5Fsj1r/LOTJ0/wa/H6rP0/CoqjOs39HfVLetB/M+8+AJKLsBlxkC6uKnjkgwIBC
         CJY404iyQImlsQCntBlHlxzfZ1xV+r1OMJ9JPyLDJcTS/Sa1fWr7P0B7637Aio60zoRh
         oTFowe5A4LeCMeCbuPSF18vXgLC5wdnr/IMPqD+64XMSEDRtaVtT4jOtpz/GzHpM29zi
         +AJxziNaNrkAaP+dL6PRg6Buzbb7IksBKaxI29oK0V++UnBk/617S0+DHcb4+Wib8TQj
         A4H179N7MgI2PkLJKoS5GZQr1CWVgoQn2DBI1jR99Y5u0guiSbA4+I5Fh1sz8kzdfnk8
         d6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iaN7hqGH3bUfzSvOTqCy+oA56jvK+RCe6WobEzTMl/4=;
        b=rWeznxLJY1Euj8asZ3XMzCNinT5Ysz2YpDaxpa93Pw6ViHYGUZHG87GeIhV1tEd082
         niIYFfomj5bIQ+cfH4uPwYYL9H0Lq9xmuqX8KoFfLOE1p/iQd9iL2NQiyD3iEUowEYaw
         bFyLtRspbY1lblY0Ss4WlGb5HLTFEAtcWSHT7cX+uET828ijenO09DV1WsC9k+sQ/4b+
         K8d70yRg2GAckFiD8JvXUJz2+k8Vu2kiBSGuGO3jRciS59a79NYjYBHn8yP2G4JVCKZg
         0oUlRncaf0ndXkqYYuQjvnHrmw2kTMNsGue6lkvzblWxNAasXFuurlJOaW68IKb6gGbz
         +JUw==
X-Gm-Message-State: AOAM531n7zzkPOl7whu9JqeX8VuoCk0nOUr3LkHhXB1XlbSWInEi3S0C
        /OnNudx5WOFJUb4xtIJ7u2JSaw==
X-Google-Smtp-Source: ABdhPJzZqMx0yRhhuDqRDFDocq/SrKvQ38msuYEO+gROsxPm4SyIIqoU6Ky+5toLCj6o4cY4EXw3wQ==
X-Received: by 2002:a37:850:: with SMTP id 77mr29916859qki.289.1617112659623;
        Tue, 30 Mar 2021 06:57:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id w12sm4566621qto.2.2021.03.30.06.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 06:57:39 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lREsE-005tuN-EP; Tue, 30 Mar 2021 10:57:38 -0300
Date:   Tue, 30 Mar 2021 10:57:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210330135738.GU2710221@ziepe.ca>
References: <20210326190148.GN2710221@ziepe.ca>
 <20210330012949.GA1205505@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330012949.GA1205505@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:

> I think I misunderstood Greg's subdirectory comment.  We already have
> directories like this:

Yes, IIRC, Greg's remark applies if you have to start creating
directories with manual kobjects.

> and aspm_ctrl_attr_group (for "link") is nicely done with static
> attributes.  So I think we could do something like this:
> 
>   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
>     sriov/                             # SR-IOV related stuff
>       vf_total_msix
>       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
>       ...
>       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF

It looks a bit odd that it isn't a subdirectory, but this seems
reasonable.

> For NVMe, a write to vf_msix_count_* would have to auto-offline the VF
> before asking the PF to assign the vectors, as Jason suggests above.

It is also not awful if it returns EBUSY if the admin hasn't done
some device-specific offline sequence.

I'm just worried adding the idea of offline here is going to open a
huge can of worms in terms of defining what it means, and the very
next ask will be to start all VFs in offline mode. This would be some
weird overlap with the no-driver-autoprobing sysfs. We've been
thinking about this alot here and there are not easy answers.

mlx5 sort of has an offline concept too, but we have been modeling it
in devlink, which is kind of like nvme-cli for networking.

Jason
