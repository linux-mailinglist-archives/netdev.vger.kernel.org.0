Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA496C1B9E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjCTQaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjCTQaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:30:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF1AC646
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679329269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4L6DVT+Pk28ITSy1tgi6rl1jBkKGjMU3pOGcr32oZA=;
        b=OhGnmU8SSy/YfyNNGyOMe8PZPvN9XtCfQm1ewrlZJNk0w9PS2ilRxtZjRPCgKX+HnWBzlY
        hp7ro9PqcMIs9POqn9IlAxjXyY5Ylf5P09130ZDTqbMFXH5hw0DTmKLjNPY2iw+y9cTCyg
        fvcfyPXTCoW8AuuCr8uDbvvVHs2Quqw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-NTfKerRkNUe53zzrFU5VAg-1; Mon, 20 Mar 2023 12:20:59 -0400
X-MC-Unique: NTfKerRkNUe53zzrFU5VAg-1
Received: by mail-io1-f72.google.com with SMTP id bk9-20020a056602400900b007530180bc25so6278091iob.5
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679329258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E4L6DVT+Pk28ITSy1tgi6rl1jBkKGjMU3pOGcr32oZA=;
        b=DNyzNJ+Jjhyyw1HtgsXWkMDzwDpWZYwVSlh2fL3fC6U4LJ9zT4j080GM8BnXnd8YOk
         OTr13HRcgE/ONrzRT5I4ueAF2sTLcJ7sC6Iu1H7HfVSK4jiblvByAmMSoc7hfnfDS/Wq
         eCCI8zfGq3s19wxmhaoyoAwj1tuWd1G0vSKzRo2w/Y53m+Cvx581c3vOYB6zDVjghOZX
         rjLGJK2qqM8hlsz3f+p+7OzGs0sDdgrG7d8+o5yYhprMWCtfxP8Za1YUF4VNCpQww0tq
         B0dxvs9buyFxkXVaNbkDiO7o6kg03FXUCk1+ktErOODa27Wpts03qAEph1VhHI6iaeW+
         n4gA==
X-Gm-Message-State: AO0yUKXkMtMN5stR3pkXFZalo1KoxkL1DR9blmbed3tMivWqTepArRDZ
        co9Y16jBS5Z2h1H70qBMJ63rYejv4EiZFj/Rwa3R53EDccubfbOmAkDPsEw4f8i8vcKqxIUGQaH
        9xYeB9ZlsdNmR1fus
X-Received: by 2002:a6b:5b10:0:b0:74c:c47e:e338 with SMTP id v16-20020a6b5b10000000b0074cc47ee338mr128170ioh.1.1679329258342;
        Mon, 20 Mar 2023 09:20:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set97GHkYl2layDS31jJOAtlRGfxngf7zDEp2X1/Dqkij6Q0vtlnDp1hQ4qhoR9DYj5Ifg0fn+w==
X-Received: by 2002:a6b:5b10:0:b0:74c:c47e:e338 with SMTP id v16-20020a6b5b10000000b0074cc47ee338mr128146ioh.1.1679329258095;
        Mon, 20 Mar 2023 09:20:58 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 124-20020a021182000000b00404b939d865sm3373857jaf.147.2023.03.20.09.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 09:20:57 -0700 (PDT)
Date:   Mon, 20 Mar 2023 10:20:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Lizhe <sensor1010@163.com>, wintera@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/iucv: Remove redundant driver match function
Message-ID: <20230320102056.1be1fcf7.alex.williamson@redhat.com>
In-Reply-To: <ZBdtn0wFunrkvml9@osiris>
References: <20230319050840.377727-1-sensor1010@163.com>
        <ZBdtn0wFunrkvml9@osiris>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 21:16:31 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Sun, Mar 19, 2023 at 01:08:40PM +0800, Lizhe wrote:
> > If there is no driver match function, the driver core assumes that each
> > candidate pair (driver, device) matches, see driver_match_device().
> > 
> > Drop the bus's match function that always returned 1 and so
> > implements the same behaviour as when there is no match function  
> ...
> > 
> > Signed-off-by: Lizhe <sensor1010@163.com>
> > ---
> >  net/iucv/iucv.c | 6 ------
> >  1 file changed, 6 deletions(-)  
> ...
> > -static int iucv_bus_match(struct device *dev, struct device_driver *drv)
> > -{
> > -	return 0;  
>         ^^^^^^^^
> 
> If I'm not wrong then 0 != 1.
> 

Seems like an unchecked patch bot, proposed an identical bad patch for
vfio/mdev.  Thanks,

Alex

