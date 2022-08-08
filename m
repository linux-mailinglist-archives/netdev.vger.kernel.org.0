Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE358C776
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbiHHLW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242754AbiHHLWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 54252643D
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 04:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659957770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URbW2eSWd9Zk4XsSgq7TMx84SxxtNx0WE1Teja98lDs=;
        b=Meln5ggVtFtV7fMXRCk93yxBCAC0N3HI5JzgFdrHH+8PwgA+CFEqp8SuwdfiT3P9OJBiF+
        RaYhEYxaiEuG4nHD443rdfDrFEEov299f6XdF8ZrtJnh6pL+Yzst1AZ7575G4/vZULMPh3
        GW8PvilMYKdQbQ1YXT2PLjsJ+1yBjnU=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-JLFbXXS9MA2TZ9bECrS8xw-1; Mon, 08 Aug 2022 07:22:49 -0400
X-MC-Unique: JLFbXXS9MA2TZ9bECrS8xw-1
Received: by mail-qt1-f200.google.com with SMTP id d29-20020ac8615d000000b0033d168124e9so6575148qtm.19
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 04:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=URbW2eSWd9Zk4XsSgq7TMx84SxxtNx0WE1Teja98lDs=;
        b=tzI2iIjXVyZRcyKkfZ2d6lw432Yaih1pD/a40qBMqTUMZNnBFSlPCvhcMIt2clG7gg
         zc3Y5iNvuOOpOMlsXy+ZCEqQlWJgRucgBF8YGQPqfEaxzAoPNt/9vc2JlRmD90f5ctCc
         NJEg5itAjAOd0TD2IQw9+GWomuaOuyWmhbDKUwC1yPUoUO99YpquDBYDFBJqTDBRlqez
         Ds6g/g1+N3w0evCAVNmq8vLyyXAXQIPCPynhzAB8hOcxPk0Ozq6c+CmQkpULgII3ZQjl
         eRKLCt+bR+HLTXb+fq8vBdmtdLc6E5Df+bQu7XVq8cKpz/d56uYkI+E73QuRdjCWy4br
         GlOw==
X-Gm-Message-State: ACgBeo0cBjR2moFnF631ohdxk0PiK+VYmD5TocL0Gq9+Fi4CRMdpOCLz
        DyQ/F0I4Eh1qxq/HpVsDIgdk0mxR3eT2Nd1NW0//A/jGxK8wT6+1R5bVU0ERDqfgDoEZ+7Od4R+
        Rr3MR2Re56OryzDRH
X-Received: by 2002:ac8:7d4c:0:b0:31f:344c:d843 with SMTP id h12-20020ac87d4c000000b0031f344cd843mr15965562qtb.391.1659957769093;
        Mon, 08 Aug 2022 04:22:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Y11HcDyoSXw2Ny4GAR0UM/JIRPfgg4DREbcZuxzaq//Kny6tPDJul5MmPL+netL0Z9mFe1A==
X-Received: by 2002:ac8:7d4c:0:b0:31f:344c:d843 with SMTP id h12-20020ac87d4c000000b0031f344cd843mr15965542qtb.391.1659957768859;
        Mon, 08 Aug 2022 04:22:48 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id g3-20020a05620a40c300b006b919c6749esm7398094qko.91.2022.08.08.04.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:22:48 -0700 (PDT)
Date:   Mon, 8 Aug 2022 13:22:39 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Message-ID: <20220808112239.jwzrp7krsyk6za5s@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseniy,

On Wed, Aug 03, 2022 at 01:48:06PM +0000, Arseniy Krasnov wrote:
>Hello,
>
>This patchset includes some updates for SO_RCVLOWAT:

I have reviewed all the patches, run tests and everything seems okay :-)

I left some minor comments and asked Bryan and Vishnu to take a better 
look at VMCI patches.

In general I ask you to revisit the patch descriptions a bit (for 
example adding a space after punctuation). The next version I think can 
be without RFC.

Remember to send it with the net-next tag.
Note: net-next is closed for now since we are in the merge window.
It should re-open in a week (you can check here: 
http://vger.kernel.org/~davem/net-next.html).

I'll be on vacation the next 2 weeks (Aug 15 - 28), but I'll try to 
check out your patches!

Thanks,
Stefano

