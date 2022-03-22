Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136074E3B8C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiCVJQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbiCVJQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:16:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4C7F30F42
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647940525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmhepZpNoMhFjymrVWQUWcEooZC4Ac4AFImCN6bnAxo=;
        b=c0uJvhIcKSLOcZ7xPld/lFuGXKXqiG3xVIbhBmkXf0MpbQkWeI9DQq/3ThDTLNmUDItjNk
        rot7B/RI2QdQDZGLeYl0Tp+GVj3e7lbDGCuuXkhQ5vDdr8cArEAuOoyQyXOyp4HZOZmhv/
        hLrkI7SjMUJf0soZ9k5n/UrPQVOFCfA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-j9LK070rMTqg3_LK3S3OtQ-1; Tue, 22 Mar 2022 05:15:24 -0400
X-MC-Unique: j9LK070rMTqg3_LK3S3OtQ-1
Received: by mail-wm1-f71.google.com with SMTP id h127-20020a1c2185000000b0038c6f7e22a4so759216wmh.9
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FmhepZpNoMhFjymrVWQUWcEooZC4Ac4AFImCN6bnAxo=;
        b=Sgc43BVGyIwF1maHP4rMJHQBNU+bxPsDI7XFF9E7NiQQXA1uI5pKL6r9vTEpy+lrBw
         ylBt4MUElT2yBgGAyTwS9b3WZ7aPpc3ye3EPSrjZVneToeEcZrtLlbbDW/+bO3+aC6Wz
         809jgBJOFPlVQTH8PUkVNYRL5H03+CrPfcccYOrTcBd3O2BGIw/KsLAf5JNwaaww0IBw
         1B80VWoMcjWEFoVBjaLi1ArkyjF6ZrKCKe9SiULrmIADRoW+E5zqXL6Kq7z0FCYfoay6
         0Vx136t7xUF8gAbudRHsKrk8O2NelA4dHYgkOFFmRKbJzayZ5sfwcLWtbD7l+EgJ+bfW
         rruQ==
X-Gm-Message-State: AOAM531NgVhL45g/C9aZuCeQP7qrm/c9uiofodESGMLAd1AZm7x90rcy
        iHypL5MJSWlZWDJffFdmBF6D92bFmtGndGCQ1R8efFdVgIEov+M8YLraPVXT+6rwStEC+KAirdq
        B+HxYAzj/jCcfatqp
X-Received: by 2002:a05:6000:1807:b0:203:fa3c:8556 with SMTP id m7-20020a056000180700b00203fa3c8556mr14751938wrh.111.1647940523032;
        Tue, 22 Mar 2022 02:15:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPaHlIFn/rp1+V6Idtk6EeRqqqGrcrjxgsYn2qBRDu/+hhScaZwqzM0pzQDnwKJ9naT/G2QA==
X-Received: by 2002:a05:6000:1807:b0:203:fa3c:8556 with SMTP id m7-20020a056000180700b00203fa3c8556mr14751914wrh.111.1647940522744;
        Tue, 22 Mar 2022 02:15:22 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id u12-20020a5d6dac000000b00204119d37d0sm4914900wrs.26.2022.03.22.02.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 02:15:22 -0700 (PDT)
Message-ID: <9e2b850b81c44e41c3cc8dbd8c4ab61e516b85b8.camel@redhat.com>
Subject: Re: [PATCH net-next v3 0/3] net: ipvlan: fix potential UAF problem
 for phy_dev
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     edumazet@google.com, brianvv@google.com,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Mar 2022 10:15:21 +0100
In-Reply-To: <cover.1647664114.git.william.xuanziyang@huawei.com>
References: <cover.1647664114.git.william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-03-19 at 17:52 +0800, Ziyang Xuan wrote:
> There is a known scenario can trigger UAF problem for lower
> netdevice as following:
> 
> Someone module puts the NETDEV_UNREGISTER event handler to a
> work, and lower netdevice is accessed in the work handler. But
> when the work is excuted, lower netdevice has been destroyed
> because upper netdevice did not get reference to lower netdevice
> correctly.
> 
> Although it can not happen for ipvlan now because there is no
> way to access phy_dev outside ipvlan. But it is necessary to
> add the reference operation to phy_dev to avoid the potential
> UAF problem in the future.
> 
> In addition, add net device refcount tracker to ipvlan and
> fix some error comments for ipvtap module.

This is pure net-next material, and we are now into the merge window -
only fixes allowed. Please repost in 2w, thanks!

Paolo


