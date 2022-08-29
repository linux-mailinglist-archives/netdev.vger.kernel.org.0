Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B8E5A4E98
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiH2Nwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 09:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiH2Nwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 09:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C935C94EE8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661781161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iyHeN9+d/43uz8k3pFTHk3cYxNwEdqT76Jr80vsE+YA=;
        b=HzHHA6mAuksHYMJ58+0VW66C6d6SOrAAnqPhFOmEc6dSENlcNJ1vtslbYRWkE4dbeDuPGi
        BnsolgERoNB6XvH22DBM8MS7hYsO2DobtLfjhqc/5YFYY7ZB/sEOmls0xtQf15QPI3vCVY
        6nYEgQkeeiyT+w9EZoPuEwwple7YZPk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-462-8bf63ViBN4KwyLzoudjnuw-1; Mon, 29 Aug 2022 09:52:40 -0400
X-MC-Unique: 8bf63ViBN4KwyLzoudjnuw-1
Received: by mail-wm1-f72.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so5090498wma.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 06:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iyHeN9+d/43uz8k3pFTHk3cYxNwEdqT76Jr80vsE+YA=;
        b=bXtseXM/doWy4nv45i/tQxL0d4gsuBmL2foZzzrjUbJU29wAnQNGlmkMo8kMlF0l6w
         AexxXgPvqpt/Ge9lEhgqG0jhJOXjhc/yyXDsjtp0IljWeNx/XqwUsJ9IQTu4qQUkp4Jo
         IDdTY1hptXGWjYoI+OKKfhyoep63nyTnG8zFJpuD7F0XhH+NLnJE9D9SC0Y+nM7ICkRK
         ZRUdvB55p5lLPkHTENpgpzICZQOEqHjRp47sWNjXMUoT1rFnAv3PFT3oAtR6FC6OXnjt
         M2gPGX+4leGlyIVR2V9UxrPdUfFUM2xapWg5zunk/24X46J49xA1sprN1mOTaDY3RieG
         DoYg==
X-Gm-Message-State: ACgBeo00X8EZAvR5ax4TGPfb7lZpCiXWnvyb2B7moee9AlR95+l728Sm
        dyIcufFsEO1jE+7RaVpYKulSa4k5Hjx7Vla93ivFtxKzrYEHKQ0ZJKrkgueq2g2UXemxyzN6WUe
        jKQPBTHDuu+2tGN0O
X-Received: by 2002:a05:600c:4fcd:b0:3a6:2694:e3ba with SMTP id o13-20020a05600c4fcd00b003a62694e3bamr7190899wmq.160.1661781158965;
        Mon, 29 Aug 2022 06:52:38 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xbddiyuXZsWvO+FPWILzn4jZoImEslyYwS/WpzMw1kUYVPH1Nn8dBrnVo9BLMC4eze3xuOw==
X-Received: by 2002:a05:600c:4fcd:b0:3a6:2694:e3ba with SMTP id o13-20020a05600c4fcd00b003a62694e3bamr7190887wmq.160.1661781158752;
        Mon, 29 Aug 2022 06:52:38 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.88.130])
        by smtp.gmail.com with ESMTPSA id p18-20020a056000019200b00226d13a25c7sm6869906wrx.17.2022.08.29.06.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 06:52:37 -0700 (PDT)
Date:   Mon, 29 Aug 2022 15:52:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH net-next v4 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220829135229.rcyefaabajt3btqt@sgarzare-redhat>
References: <de41de4c-0345-34d7-7c36-4345258b7ba8@sberdevices.ru>
 <YwUnAhWauSFSJX+g@fedora>
 <20220823121852.1fde7917@kernel.org>
 <YwU443jzc/N4fV3A@fedora>
 <5174d4ef7fe3928472d5a575c87ee627bfb4c129.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5174d4ef7fe3928472d5a575c87ee627bfb4c129.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 10:57:01PM +0200, Paolo Abeni wrote:
>On Tue, 2022-08-23 at 16:30 -0400, Stefan Hajnoczi wrote:
>> On Tue, Aug 23, 2022 at 12:18:52PM -0700, Jakub Kicinski wrote:
>> > On Tue, 23 Aug 2022 15:14:10 -0400 Stefan Hajnoczi wrote:
>> > > Stefano will be online again on Monday. I suggest we wait for him to
>> > > review this series. If it's urgent, please let me know and I'll take a
>> > > look.
>> >
>> > It was already applied, sorry about that. But please continue with
>> > review as if it wasn't. We'll just revert based on Stefano's feedback
>> > as needed.

Just back, and I'm fine with this version, so thanks for merging!
I also run tests with virtio-vsock and everything is fine.

>>
>> Okay, no problem.
>
>For the records, I applied the series since it looked to me Arseniy
>addressed all the feedback from Stefano on the first patch (the only
>one still lacking an acked-by/reviewed-by tag) and I thought it would
>be better avoiding such delay.

Yep, from v3 I asked some changes on the first patch that Arseniy 
addressed in this version, and we were waiting an ack for VMCI changes 
(thanks Vishnu for giving it).

So, it should be fine.

Thanks,
Stefano

