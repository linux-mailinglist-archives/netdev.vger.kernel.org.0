Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106AB6A5DB9
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjB1QzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjB1Qys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:54:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B1334F41
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677603140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uZikqzZIkDbGi1O4pYDEQeFbbNJeZAINLFAEHIXoh3c=;
        b=inbZP98akHA3pwdghtRHgwZFmP4SOQW6xDr3pn4motCeb0YqaWsosutDqzJMudNg7aJ0BF
        sOuN+hHLSOTDQlgygT1kVqCXCIygActpvSUqIhoiRffNtvbrdMahONNePcayzRwzBgzV9B
        owz15HTyCajrZftM8QvVFfuNh6BFMSA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103-EknTg4JGPpW2sRKZHB7vNA-1; Tue, 28 Feb 2023 11:52:19 -0500
X-MC-Unique: EknTg4JGPpW2sRKZHB7vNA-1
Received: by mail-pg1-f199.google.com with SMTP id n66-20020a634045000000b004e8c27fa528so3575785pga.17
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:52:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677603138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uZikqzZIkDbGi1O4pYDEQeFbbNJeZAINLFAEHIXoh3c=;
        b=IrwPphqEgY/f96KP3uItTSpbKGIG4CnyE5as6f+gPK8p2nivFtgVMxe5hrbLFdqvva
         PcAeGP/L6AGchPhslVpFUJPa0wJ/uQwt/FJiZC1kCi00gHHouWxwFM9iUWC4LLvSYkpH
         vNtk+/vKF9BDU+eJ3OhRE2AihiGQ6oUfPf3LuTfvMkQxt7r8lezou11mhV1EiM+JK4yf
         qCh351vcBES5vTMzfzFSxLpZkmQqbs5zXVbStCKA3rzYhb8Iw0m5ilR2eFGWWNQXTLzw
         lm7Ic5x1c8OTC3PGPQotA2CAMRGgvW7b10d74y0w+gxmXuK2k4AKshP6sI4aauJFpZr7
         DXcA==
X-Gm-Message-State: AO0yUKWgPbBfN0yy4YeKmDcT3iR7FqM4jaMQmpM/Pk3HsegYjiSAGsJi
        1ENLYUUV57ByQDy2d0ky4Wy99e7AjtcwM15UE7iZ8fGd4hONsJ/DjEMIXHPv8ya7TWzWWdlyRMT
        piMITXX8NweHWwJy7
X-Received: by 2002:a05:6a20:6903:b0:c7:164c:edf7 with SMTP id q3-20020a056a20690300b000c7164cedf7mr3802638pzj.36.1677603138520;
        Tue, 28 Feb 2023 08:52:18 -0800 (PST)
X-Google-Smtp-Source: AK7set96tFfE/DyE8/J9QYLTy3Y4VmaD8BB4CdDfyRG/rfxWoIeZLabIq1dp5aLI+BWFJOcvwmTCbA==
X-Received: by 2002:a05:6a20:6903:b0:c7:164c:edf7 with SMTP id q3-20020a056a20690300b000c7164cedf7mr3802620pzj.36.1677603138119;
        Tue, 28 Feb 2023 08:52:18 -0800 (PST)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id i194-20020a636dcb000000b004f1e73b073bsm5886962pgc.26.2023.02.28.08.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 08:52:17 -0800 (PST)
Date:   Wed, 1 Mar 2023 01:52:13 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: caif: Fix use-after-free in
 cfusbl_device_notify()
Message-ID: <Y/4xPYHjl4X1D30L@kernel-devel>
References: <20230225182820.4048336-1-syoshida@redhat.com>
 <20230227182800.02ddf83f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227182800.02ddf83f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 06:28:00PM -0800, Jakub Kicinski wrote:
> On Sun, 26 Feb 2023 03:28:20 +0900 Shigeru Yoshida wrote:
> > syzbot reported use-after-free in cfusbl_device_notify() [1].  This
> > causes a stack trace like below:
> 
> Please repost with the correct fixes tag, presumably:
> 
> Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")
> 
> Please make sure you CC the authors of that commit.

Sorry, I'll be more careful.  I'll prepare v2 patch.

Thanks,
Shigeru

> 

