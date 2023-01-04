Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0964E65D3B9
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbjADNE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 08:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239114AbjADNEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 08:04:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F619030
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 05:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672837447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qox/oCIKrJgN89xrHJUvG+swnnlfN7DPV4U9vLlEgHk=;
        b=T164K/udNfLL3MHRvqoM9xWudo1b6jZvyCK7ugALKhfH/o0PIVa8XselgTWUwdz2l6VmPX
        dohisYVXSYg3fOnjQi+FLv4W/MZ1GjNLeGnRChsdIUBKbL9VQyWPzWUQ1YIG0lK8cNtKSK
        TgIXhjNOXpKnrINi+njdW1DWZ+lGpFU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-164-S-JNDzhTN0OC5KI8y19ckg-1; Wed, 04 Jan 2023 08:04:06 -0500
X-MC-Unique: S-JNDzhTN0OC5KI8y19ckg-1
Received: by mail-wr1-f72.google.com with SMTP id s3-20020adf9783000000b002ab389f64c1so74770wrb.22
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 05:04:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qox/oCIKrJgN89xrHJUvG+swnnlfN7DPV4U9vLlEgHk=;
        b=LpVH5qRXGy2g0noBlNKAYChQKBNcufrU61fsuTGc2rxi1w2apeKUNf5sfaEbI0Zfmd
         sdt9k08Nd0RlqDJyMeUAiLX5YJmIgxzXEb0nIbz7zndVR8zDKJJGkqLiwRZqt6CjjwVS
         vBG1ac3eE0LwGHyd/UjrE+stJs0U51fd+DJ7lJ/y/OFoztfgK8hdXGi3YwuzB/YoLFLQ
         EXp8CygYJelwFXprLw/QEgzT2Awzx4LqUBvi6L+d4xGBN9oCLBPrWHJZUkIe3APvckEU
         obc+1cu25n8mhdP2sJytbLg7kCIBpi5d8b4+q2ohbpJh0xPh/6dRa+nGw6ihCOTAP9iJ
         e17Q==
X-Gm-Message-State: AFqh2kpXNDyeDbkPeSN3F2MqY/0d5twXa3vm15bRinXcTnW5PLJPgyUW
        2WbvAC3XqDlKdW1lhc+OIazWPFhy2xwTUgwLFtjBXvKqTXMjUjACN3AJs7JMoVbl2KJQHJ8W6vX
        FkHKvQBTx0o7rqO/O
X-Received: by 2002:a05:6000:18c3:b0:288:ca2e:7d74 with SMTP id w3-20020a05600018c300b00288ca2e7d74mr14295783wrq.14.1672837444934;
        Wed, 04 Jan 2023 05:04:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtlcfpal455TLuLVy79Kxfe58vG4oN1jPIOPsIFNn4IYhDNS4aZnX9DtEvIz+VUUb8U5/RbTg==
X-Received: by 2002:a05:6000:18c3:b0:288:ca2e:7d74 with SMTP id w3-20020a05600018c300b00288ca2e7d74mr14295762wrq.14.1672837444627;
        Wed, 04 Jan 2023 05:04:04 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id j1-20020adfff81000000b0024cb961b6aesm33027899wrr.104.2023.01.04.05.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 05:04:03 -0800 (PST)
Date:   Wed, 4 Jan 2023 08:03:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sgarzare@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, bobby.eshleman@gmail.com
Subject: Re: [syzbot] kernel BUG in vhost_vsock_handle_tx_kick
Message-ID: <20230104074613-mutt-send-email-mst@kernel.org>
References: <0000000000003a68dc05f164fd69@google.com>
 <Y7T+xTIq2izSlHHE@pop-os.localdomain>
 <Y6A/Yyoh2uZSR0xj@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6A/Yyoh2uZSR0xj@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 10:46:47AM +0000, Bobby Eshleman wrote:
> On Tue, Jan 03, 2023 at 08:21:25PM -0800, Cong Wang wrote:
> > On Tue, Jan 03, 2023 at 04:08:51PM -0800, syzbot wrote:
> > > Hello,
> > > 
> > > syzbot found the following issue on:
> > > 
> > > HEAD commit:    c76083fac3ba Add linux-next specific files for 20221226
> > > git tree:       linux-next
> > > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1723da42480000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c217c755f1884ab6
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=30b72abaa17c07fe39dd
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fc414c480000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1604b20a480000
> > > 
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/e388f26357fd/disk-c76083fa.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/e24f0bae36d5/vmlinux-c76083fa.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/a5a69a059716/bzImage-c76083fa.xz
> > > 
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+30b72abaa17c07fe39dd@syzkaller.appspotmail.com
> > 
> > +bobby.eshleman@gmail.com
> > 
> > Bobby, please take a look.
> > 
> > Thanks.
> 
> Roger that, I'll take a gander asap.

I'll going to revert commit f169a9538803469418d9ba2c42a0236fc43cd876 unless
I hear from you soon, we need linux-next testable.

-- 
MST

