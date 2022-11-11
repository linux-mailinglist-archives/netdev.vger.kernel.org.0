Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFE6626539
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 00:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbiKKXQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 18:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbiKKXQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 18:16:08 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF8C1006E;
        Fri, 11 Nov 2022 15:16:07 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id j15so8219800wrq.3;
        Fri, 11 Nov 2022 15:16:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ML0RbCqbrCyj8dh7iybZeA9vXEsm9tqKolIzFc77JSI=;
        b=fmk2xIc6jMoGi+fm0sWwW6UeXcnrhRldIpyAyWEna3L9KVyPpqrviVJNNKppLFyy++
         IL1I8epJi5piDgujHTHT84ZkjkCF5Xtx6akqoapuoPFC5Or389QFXIfjKNrXpFcrORCu
         k8DBIn7b4IMg9CVzXwpl6tjTivcNZY7djWnVKnndFU9G68aNlzGxvRuBT69fpLn1cgnZ
         sgRYDIc7K0jWB/Ea9wqlbT8ASgphuDwya1Zx6VSlkmjqC8Mgg8qsszvm835zWTex3SLp
         NwWTsepcOsoh0iD+Nm7uEFiNcRyl+aIShYNXgHmu5kw0Ke0ajQ68twKvVqS048GUQ898
         CwYQ==
X-Gm-Message-State: ANoB5pmvKh4iEQ14s1wU7bYjP5LJuVWoouT0Va9AIZTmYs5xqWNNFB6c
        mC/ZlV+Zw4EmRS3Qu6yI43c=
X-Google-Smtp-Source: AA0mqf7ZPoTb7TZ7vc2ApkuO6Q5VrxJgANuw8sRi7qmBR1m0pF2mXHBjTNBZVzTEOEMmWntExjnjlQ==
X-Received: by 2002:adf:f952:0:b0:241:71fc:3b3d with SMTP id q18-20020adff952000000b0024171fc3b3dmr2317948wrr.268.1668208566495;
        Fri, 11 Nov 2022 15:16:06 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id e1-20020a5d5001000000b002368424f89esm2900908wrt.67.2022.11.11.15.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 15:16:06 -0800 (PST)
Date:   Fri, 11 Nov 2022 23:16:03 +0000
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
Message-ID: <Y27XsybzcgCQ3fzD@liuwe-devbox-debian-v2>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-11-gpiccoli@igalia.com>
 <BYAPR21MB16880251FC59B60542D2D996D75A9@BYAPR21MB1688.namprd21.prod.outlook.com>
 <ae0a1017-7ec6-9615-7154-ea34c7bd2248@igalia.com>
 <SN6PR2101MB1693BC627B22432BA42EEBC2D7299@SN6PR2101MB1693.namprd21.prod.outlook.com>
 <efdaf27e-753e-e84f-dd7d-965101563679@igalia.com>
 <Y27Q9SSM6WkGFwf5@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y27Q9SSM6WkGFwf5@liuwe-devbox-debian-v2>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 10:47:17PM +0000, Wei Liu wrote:
> On Thu, Nov 10, 2022 at 06:32:54PM -0300, Guilherme G. Piccoli wrote:
> > [Trimming long CC list]
> > 
> > Hi Wei / Michael, just out of curiosity, did this (and patch 9) ended-up
> > being queued in hyperv-next?
> > 
> 
> No. They are not queued.
> 
> I didn't notice Michael's email and thought they would be picked up by
> someone else while dealing with the whole series.
> 
> I will pick them up later.

They are now queued to hyperv-next. Thanks.
