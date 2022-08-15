Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5E8593226
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiHOPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiHOPlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 11:41:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DBA36563
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660578068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpOQ0S8xTyMJHmMY1t7J4us9+LjsWwhrGGsgao9tXgo=;
        b=G4MBLOMk8R9vNqqr+pwIRgrCwrglo0twW0J57jyjUpGZ3nHa9sh5qXIJeSkzo12bMBddb9
        +T+svhcI/xvn8Dg/cxpKg7h3lsEZV2Ab9UzhvFiGrkLhUv3EYyZOBTCAP/qM7/VeaZJBHw
        FboBBveih6+/W89RjB7x+4H7+GPvXJc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-616-fHvLt8jHN0OCuLG78K7d_A-1; Mon, 15 Aug 2022 11:41:07 -0400
X-MC-Unique: fHvLt8jHN0OCuLG78K7d_A-1
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a05640242c500b0043e50334109so4950975edc.1
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 08:41:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc;
        bh=UpOQ0S8xTyMJHmMY1t7J4us9+LjsWwhrGGsgao9tXgo=;
        b=yMeRO8ZgW+TMK2MzepujDvvfF1awr3YGfk8YywFpiwI2gAMfKNEU6W618cB8G6xEBv
         cFc0/EQn1fsAwhwWVcYu0UfNs7yMd0bQXmzZqAyGnrwrVjhjddFBxR9v7B/ulGJ4lHP+
         CY2DSdeWmdH6qlb2tBXwmedAU1kIgfDFJVguh3rFF3x7ZufEo1OmETVi4wq6cqAWoyOx
         /MCV+K1a6+9Usv2wNgc1/GAAlVS6oj5xF7GKCTuXWuHd/F1dWIClN3mdH04RLSblBDs0
         j8Fdq6iBNg1CKkJUaZd2420OxBRdFpgXRk3QxK+C2UE1X2jOYZ2pme+A1oMJnVSVF58H
         1a/Q==
X-Gm-Message-State: ACgBeo1ZbPyVSy7gWHEFwMWQG4DcFpyVZm1hPEB4bwujC8bc+ZJzUCRv
        L48HQU11m8MQcyFHiae6AsiCf/AXZCsIgNYXpxvojPgQ7JgzCXglNlL8JliAFmC5+oALaVQCxKh
        YYHLYudhcs6vTDBwT
X-Received: by 2002:a05:6402:254b:b0:43e:7c6a:f431 with SMTP id l11-20020a056402254b00b0043e7c6af431mr15419052edb.305.1660578066091;
        Mon, 15 Aug 2022 08:41:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4PVgA9J2ZpHf31hYsuilIOkpf6wHT/MluCqOW9wn/BsA1BgRyyci7rxYWXC1uVkVknxAuBDQ==
X-Received: by 2002:a05:6402:254b:b0:43e:7c6a:f431 with SMTP id l11-20020a056402254b00b0043e7c6af431mr15419032edb.305.1660578065916;
        Mon, 15 Aug 2022 08:41:05 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id kd1-20020a17090798c100b007262a1c8d20sm4248334ejc.19.2022.08.15.08.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 08:41:05 -0700 (PDT)
Date:   Mon, 15 Aug 2022 11:40:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        Andres Freund <andres@anarazel.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815113729-mutt-send-email-mst@kernel.org>
References: <20220814223743.26ebsbnrvrjien4f@awork3.anarazel.de>
 <CAHk-=wi6raoJE-1cyRU0YxJ+9ReO1eXmOAq0FwKAyZS7nhvk9w@mail.gmail.com>
 <1c057afa-92df-ee3c-5978-3731d3db9345@kernel.dk>
 <20220815013651.mrm7qgklk6sgpkbb@awork3.anarazel.de>
 <CAHk-=wikzU4402P-FpJRK_QwfVOS+t-3p1Wx5awGHTvr-s_0Ew@mail.gmail.com>
 <20220815071143.n2t5xsmifnigttq2@awork3.anarazel.de>
 <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 01:34:41AM -0700, Andres Freund wrote:
> Hi, 
> 
> On August 15, 2022 1:28:29 AM PDT, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >On Mon, Aug 15, 2022 at 01:15:27AM -0700, Andres Freund wrote:
> >> Hi,
> >> 
> >> On 2022-08-15 03:51:34 -0400, Michael S. Tsirkin wrote:
> >> > It is possible that GCP gets confused if ring size is smaller than the
> >> > device maximum simply because no one did it in the past.
> >> > 
> >> > So I pushed just the revert of 762faee5a267 to the test branch.
> >> > Could you give it a spin?
> >> 
> >> Seems to fix the issue, at least to the extent I can determine at 1am... :)
> >> 
> >> Greetings,
> >> 
> >> Andres Freund
> >
> >So you tested this:
> >
> >commit 13df5a7eaeb22561d39354b576bc98a7e2c389f9 (HEAD, kernel.org/test)
> >Author: Michael S. Tsirkin <mst@redhat.com>
> >Date:   Mon Aug 15 03:44:38 2022 -0400
> >
> >    Revert "virtio_net: set the default max ring size by find_vqs()"
> >    
> >    This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.
> >    
> >    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> >and it fixes both issues right? No crashes no networking issue?
> 
> Correct. I only did limited testing, but it's survived far longer / more reboots than anything since the commit.
> 
> Andres
> -- 
> Sent from my Android device with K-9 Mail. Please excuse my brevity.


OK so this gives us a quick revert as a solution for now.
Next, I would appreciate it if you just try this simple hack.
If it crashes we either have a long standing problem in virtio
code or more likely a gcp bug where it can't handle smaller
rings than what device requestes.
Thanks!

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index f7965c5dd36b..bdd5f481570b 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -314,6 +314,9 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	if (!size || size > num)
 		size = num;
 
+	if (size > 1024)
+		size = 1024;
+
 	if (size & (size - 1)) {
 		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", size);
 		return ERR_PTR(-EINVAL);


-- 
MST

