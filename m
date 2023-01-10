Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDD66438B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbjAJOqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbjAJOq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:46:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1747B1788C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673361940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HEPL9QhdiHtl81dbBjJ+8ZxqD3DaFE7xqIq6L14Xhs8=;
        b=N+wSH+3p1HzsIeUmChH3I/Ls8VI4bGwHLcKTA44agrBVCleqX+z8hAjboVvQfQCHEmVZBk
        BgI/bUnQomr993gwGprO2cP/apqBZV6b9vG6c/LA/A7oPRw1l6q4SFWmSPIB6l87554rGh
        LX3rw+80LeVG9z73xFW4sMZpEkYiShM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-wF9HIrrPN1WsByDOJXXpMg-1; Tue, 10 Jan 2023 09:45:38 -0500
X-MC-Unique: wF9HIrrPN1WsByDOJXXpMg-1
Received: by mail-qk1-f197.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so8887324qkn.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEPL9QhdiHtl81dbBjJ+8ZxqD3DaFE7xqIq6L14Xhs8=;
        b=QwQS4QRwcjPXD7Pp9e3pA5YIhqbIc/32cUH0tbp0pkibmcMrnHYjpsgSSpZCKwYAlG
         Z7HRKPrFwebAzFRawc4C/QjhEYZtbuhx5TOEIkMsfC6hEEi0348d3WILpkhCgKjwS+oA
         K2FAzLy9A3/HXrJryP/0Rr7hczU/adkvxPAtvFGRTzqKUJIVJtQ2O+KPfOkHunfIx8AF
         L2PDCPrNV9SctWSVdN6sH51yoPFHWv1dRVynr2vOSJFJ1MVcYgkTvteIBgTiwzQv7WI2
         VviyBKRpYv0/CSYeD5ZocNBvuzc0jcJJWeFbx1OqQJievrGBNJDrIXFt2JcQqrFM8sCN
         ezXw==
X-Gm-Message-State: AFqh2krVBv4fwjGw6LKQzrFFHG7qwQWTgdYBuIaLtOQ+rQYJlyHd704m
        zeYwX4MITUef9I9oFmjndHxFadozSY0T98FHhwiK37oWT/NGqPUtdcnf41b8eOBP9DMVoBuy74P
        sJ4aCwMwN3+gMfsRu
X-Received: by 2002:ac8:6ec2:0:b0:3ad:8c10:593b with SMTP id f2-20020ac86ec2000000b003ad8c10593bmr9867764qtv.24.1673361937200;
        Tue, 10 Jan 2023 06:45:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvc9OrhHN3k+CZGP5U3fDQ1GYsd6lcDLuDFqR7M320N5BIicIHK21UGYcRCxL800iX3rtAQ+w==
X-Received: by 2002:ac8:6ec2:0:b0:3ad:8c10:593b with SMTP id f2-20020ac86ec2000000b003ad8c10593bmr9867721qtv.24.1673361936919;
        Tue, 10 Jan 2023 06:45:36 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id z13-20020ac875cd000000b003aef9d97465sm1259788qtq.43.2023.01.10.06.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 06:45:36 -0800 (PST)
Message-ID: <5042e5c6e57a3f99895616c891512e482bf6ed28.camel@redhat.com>
Subject: Re: [PATCH net-next v9] virtio/vsock: replace virtio_vsock_pkt with
 sk_buff
From:   Paolo Abeni <pabeni@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 10 Jan 2023 15:45:32 +0100
In-Reply-To: <91593e9c8a475a26a465369f6caff86ac5d662e3.camel@redhat.com>
References: <20230107002937.899605-1-bobby.eshleman@bytedance.com>
         <91593e9c8a475a26a465369f6caff86ac5d662e3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
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

On Tue, 2023-01-10 at 09:36 +0100, Paolo Abeni wrote:
> On Sat, 2023-01-07 at 00:29 +0000, Bobby Eshleman wrote:
> > This commit changes virtio/vsock to use sk_buff instead of
> > virtio_vsock_pkt. Beyond better conforming to other net code, using
> > sk_buff allows vsock to use sk_buff-dependent features in the future
> > (such as sockmap) and improves throughput.
> > 
> > This patch introduces the following performance changes:
> > 
> > Tool/Config: uperf w/ 64 threads, SOCK_STREAM
> > Test Runs: 5, mean of results
> > Before: commit 95ec6bce2a0b ("Merge branch 'net-ipa-more-endpoints'")
> > 
> > Test: 64KB, g2h
> > Before: 21.63 Gb/s
> > After: 25.59 Gb/s (+18%)
> > 
> > Test: 16B, g2h
> > Before: 11.86 Mb/s
> > After: 17.41 Mb/s (+46%)
> > 
> > Test: 64KB, h2g
> > Before: 2.15 Gb/s
> > After: 3.6 Gb/s (+67%)
> > 
> > Test: 16B, h2g
> > Before: 14.38 Mb/s
> > After: 18.43 Mb/s (+28%)
> > 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > Acked-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > 
> > Tested using vsock_test g2h and h2g.  I'm not sure if it is standard
> > practice here to carry Acks and Reviews forward to future versions, but
> > I'm doing that here to hopefully make life easier for maintainers.
> > Please let me know if it is not standard practice.
> 
> As Jakub noted, there is no clear rule for tag passing across different
> patch revisions.
> 
> Here, given the complexity of the patch and the not trivial list of
> changes, I would have preferred you would have dropped my tag.
> 
> > Changes in v9:
> > - check length in rx header
> > - guard alloactor from small requests
> > - squashed fix for v8 bug reported by syzbot:
> >     syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com
> 
> It's not clear to me what/where is the fix exactly, could you please
> clarify?

Reading the syzkaller report, it looks like iov_length() in
vhost_vsock_alloc_pkt() can not be trusted to carry a reasonable value.

As such, don't you additionally need to ensure/check that iov_length()
is greater or equal to sizeof(virtio_vsock_hdr) ?

Thanks.

Paolo

