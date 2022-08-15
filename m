Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E3594E26
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiHPBrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245302AbiHPBqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:46:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CCC0356DC
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660599556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e2Hg6grA0aMUmuL4rEa0v8OvN+G77+vUxp19mNa37p4=;
        b=enVrrMK0rucjJuLwOAd1IqnWoH0tMH4eaJfVVZFRpUqp1rtNO48M2PRHOy6gejCqYmP0mg
        Vw4veI3b7g4Prtfp4Hq0oIN50VjBs7eNYr9Yg5ST6HBr99wkHFkay3wLdYfYWevkUvOHBV
        togAPUQlUI5NWkRTpilHNnyKL0gfGNA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-59-KMlyxw0ON6ivk1jPWp_New-1; Mon, 15 Aug 2022 17:39:15 -0400
X-MC-Unique: KMlyxw0ON6ivk1jPWp_New-1
Received: by mail-wr1-f71.google.com with SMTP id v20-20020adf8b54000000b002216d3e3d5dso1482555wra.12
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=e2Hg6grA0aMUmuL4rEa0v8OvN+G77+vUxp19mNa37p4=;
        b=KBhYz2YNJRzhDkm4bouVIalO/3XRB7SKgl2EO0GVlMj0bwnJspC4YI4c+ZsUZ0DKc2
         a7mmNCFs7XwMsuykEEfIe6RRzltnqkc3W6hvgtxBmMH/C/QccxrbfZ1usR2Cmy/+LGzP
         Y4LohIOzjrtPjql13pM+a39pkizcecleW5HrSJbNyHnjQYPhiMEcvh+Cq6jqM3dKLgQa
         z9TKmC+AOusC6DPRszc9st/3UruBetgbw+AlEMwRNAIKjkdZCSK6aRSW42im4bJWn53m
         qTOCMojGKr1rjNokpb36AB1SJXoTj7Z0ow5K8EQqLeJu76bbsx8vjgaOC2rWMmUff732
         7AWw==
X-Gm-Message-State: ACgBeo2iag9+CAKO2gZvpGcmXux12G+hfVrFdfpRFdQJAiUyycO8sjHo
        SlIULsGD4Z02BW93D54ZmeFNfSMZe+HgvPhV9RCoQfMUQvf17+u1UaL1gqDgf3H7FaBdjX7vKhS
        6yk6bNY1m/xtwV3CR
X-Received: by 2002:a05:600c:1e8d:b0:3a5:e37f:6fd2 with SMTP id be13-20020a05600c1e8d00b003a5e37f6fd2mr6889429wmb.33.1660599553674;
        Mon, 15 Aug 2022 14:39:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5OPTU7ZmWCtVBzowlE4TRPIvtXzHuep1+lrOGeKpN4aAF6Aj1ToJOY72dVoYDK4Ke/fClJcg==
X-Received: by 2002:a05:600c:1e8d:b0:3a5:e37f:6fd2 with SMTP id be13-20020a05600c1e8d00b003a5e37f6fd2mr6889413wmb.33.1660599553427;
        Mon, 15 Aug 2022 14:39:13 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id e14-20020a05600c4e4e00b003a31ca9dfb6sm13814387wmq.32.2022.08.15.14.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:39:12 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:39:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, c@redhat.com
Subject: Re: [PATCH] virtio_net: Revert "virtio_net: set the default max ring
 size by find_vqs()"
Message-ID: <20220815173256-mutt-send-email-mst@kernel.org>
References: <20220815090521.127607-1-mst@redhat.com>
 <20220815203426.GA509309@roeck-us.net>
 <20220815164013-mutt-send-email-mst@kernel.org>
 <20220815205053.GD509309@roeck-us.net>
 <20220815165608-mutt-send-email-mst@kernel.org>
 <20220815212839.aop6wwx4fkngihbf@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815212839.aop6wwx4fkngihbf@awork3.anarazel.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 02:28:39PM -0700, Andres Freund wrote:
> Hi,
> 
> On 2022-08-15 17:04:10 -0400, Michael S. Tsirkin wrote:
> > So virtio has a queue_size register. When read, it will give you
> > originally the maximum queue size. Normally we just read it and
> > use it as queue size.
> > 
> > However, when queue memory allocation fails, and unconditionally with a
> > network device with the problematic patch, driver is asking the
> > hypervisor to make the ring smaller by writing a smaller value into this
> > register.
> > 
> > I suspect that what happens is hypervisor still uses the original value
> > somewhere.
> 
> It looks more like the host is never told about the changed size for legacy
> devices...
> 
> Indeed, adding a vp_legacy_set_queue_size() & call to it to setup_vq(), makes
> 5.19 + restricting queue sizes to 1024 boot again.

Interesting, the register is RO in the legacy interface.
And to be frank I can't find where is vp_legacy_set_queue_size
even implemented. It's midnight here too ...

>  I'd bet that it also would
> fix 6.0rc1, but I'm running out of time to test that.
> 
> Greetings,
> 
> Andres Freund

Yes I figured this out too. And I was able to reproduce on qemu now.

Andres thanks a lot for the help!

I'm posting a new patchset reverting all the handing of resize
restrictions, I think we should rethink it for the next release.

Thanks everyone for the help!

-- 
MST

