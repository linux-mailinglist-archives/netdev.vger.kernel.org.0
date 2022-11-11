Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A67A6264C0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 23:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiKKWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 17:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbiKKWrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 17:47:23 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE4A60EA6;
        Fri, 11 Nov 2022 14:47:21 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id j15so8161265wrq.3;
        Fri, 11 Nov 2022 14:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sI4P7tfn9C8Un92zwS2OcYROGExNgeJbwEJVmkULolM=;
        b=XhD9vvYH+0A8XgIo3xEu28sS3RYiZt8c3x39NDhAgaTc51GRszbvVCQmcVXJz+8GxI
         vihszEro12fqF+FIqacabpCIg8J66LAR6Wg9OW4mvLbXmAiC7uMWhTwteTVlEyxLGVDN
         vouGz/t4j0FZzUhupFruHFNrExTEhHA7ok0Q7XvNk5ZOyXEpvdUAQS9kQ2PIxZLP2h82
         3WMuNHYb6fp0lOk86KVDHn3WIVRQrBqTHsU/18bcMiWZoiaZnB42rN3Lz73TtTsE0dxk
         FkyNHy0H/FhHy8eSCWkzrlB7sU0fIDzPnb3KNz72orhavZrcYLK/inGbmGmmxsxR0BiT
         lPOQ==
X-Gm-Message-State: ANoB5pldBuYJ4FFd4c5eMv6yDSx1a4dk0MFhvmBUsmao8vUKtZ6gdXmN
        8igT2ZHRcGw8Fcsgky4+RHU=
X-Google-Smtp-Source: AA0mqf6jNKhQiD8pjAi1gZTWIGN2qsj7oY8uWm+3nogLtkHYw6XIWtDQu8FwrItLC8AxrYbf6gCIKw==
X-Received: by 2002:adf:f3d0:0:b0:22e:37c1:b225 with SMTP id g16-20020adff3d0000000b0022e37c1b225mr2221431wrp.428.1668206840092;
        Fri, 11 Nov 2022 14:47:20 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id s21-20020a1cf215000000b003a6a3595edasm4191067wmc.27.2022.11.11.14.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 14:47:19 -0800 (PST)
Date:   Fri, 11 Nov 2022 22:47:17 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: Re: [PATCH V3 10/11] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Message-ID: <Y27Q9SSM6WkGFwf5@liuwe-devbox-debian-v2>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-11-gpiccoli@igalia.com>
 <BYAPR21MB16880251FC59B60542D2D996D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <ae0a1017-7ec6-9615-7154-ea34c7bd2248@igalia.com>
 <SN6PR2101MB1693BC627B22432BA42EEBC2D7299@SN6PR2101MB1693.namprd21.prod.outlook.com>
 <efdaf27e-753e-e84f-dd7d-965101563679@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efdaf27e-753e-e84f-dd7d-965101563679@igalia.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 06:32:54PM -0300, Guilherme G. Piccoli wrote:
> [Trimming long CC list]
> 
> Hi Wei / Michael, just out of curiosity, did this (and patch 9) ended-up
> being queued in hyperv-next?
> 

No. They are not queued.

I didn't notice Michael's email and thought they would be picked up by
someone else while dealing with the whole series.

I will pick them up later.

Thanks,
Wei.

> Thanks in advance,
> 
> 
> Guilherme
> 
> On 17/10/2022 12:26, Michael Kelley (LINUX) wrote:
> > From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Tuesday, October 4, 2022 10:20 AM
> >>
> >> On 04/10/2022 13:24, Michael Kelley (LINUX) wrote:
> >>> [...]
> >>>
> >>> Tested this patch in combination with Patch 9 in this series.  Verified
> >>> that both the panic and die paths work correctly with notification to
> >>> Hyper-V via hyperv_report_panic() or via hv_kmsg_dump().  Hyper-V
> >>> framebuffer is updated as expected, though I did not reproduce
> >>> a case where the ring buffer lock is held.  vmbus_initiate_unload() runs
> >>> as expected.
> >>>
> >>> Tested-by: Michael Kelley <mikelley@microsoft.com>
> >>>
> >>
> >> Thanks a lot for the tests/review Michael!
> >>
> >> Do you think Hyper-V folks could add both patches in hv tree? If you
> >> prefer, I can re-send them individually.
> >>
> > 
> > Wei Liu:  Could you pick up Patch 9 and Patch 10 from this series in the
> > hyperv-next tree?
> > 
> > Michael
> > 
