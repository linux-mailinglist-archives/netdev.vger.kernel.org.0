Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD3267DEFA
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 09:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjA0IUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 03:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjA0IUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 03:20:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0A838B6D
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 00:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674807576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MXfiZZetQqbi14d70Q9u+6V0Ixs67udoBCY1/+PVet8=;
        b=bqmM2j0CQiv9PkcRn97EJlHrt/Bk41Jxo0SYxkS2CNr+MYMzISHWPuNoKJj4LjfFPb+9Pa
        jPB7/YZ0lYmFFcX3Psx7V9Go9oyNs8UJO5lS6qpaix8+T3JNKfKojHy9JdQkm4dJ9WEBXr
        ASNAWZFcSgl/3bzRsggKZpku8vRvz6I=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-534-VV3ph9aJNDKOeuZJBEVjDQ-1; Fri, 27 Jan 2023 03:19:32 -0500
X-MC-Unique: VV3ph9aJNDKOeuZJBEVjDQ-1
Received: by mail-vk1-f199.google.com with SMTP id m123-20020a1f2681000000b003e1a5d83657so1673735vkm.20
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 00:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXfiZZetQqbi14d70Q9u+6V0Ixs67udoBCY1/+PVet8=;
        b=nImfcy/HFoqxTqjrdOVjEpSP+XGZ7mVQMgcLiHLfqHwXJl72C7kpXSpfdgJiLeyfHQ
         MRII8xKh/U8oqpR/C2pPbXPenqXlw8+DAo0bGv127UvNKdAQjS0ZXirgOG9VtASuyRbw
         S8TVhYl4dS4GWJJ+4otChVqt+mpWd/68ngzwEZHqpR98ls2Jigb6L2JCnB3fhu8x9rZC
         2PZkI7LiNElyC0tllXRl1r56cf0OHlVnaj8M85+GD2tfLb4gdCQUYli8/EyoOVjbc0YE
         LTGBIC7C6zFEvKgqjKTlM2GtZKGTylq+DGEKnI5g67cDVfhlEUd+zEqIKGsXb09xA0g/
         UBvQ==
X-Gm-Message-State: AO0yUKX/htFmCgVz/xFVgpTUXVoBLdMG2BXgFtPloIZ9tFfTFTHpVt9Y
        a1v9dBufbg03PVDiUkfjQPfZqbkSasdDvcN1vFh1TromHjzKPE8v/U9Ek3x/85AXzl1cUrMxdyD
        ZkrIrVByz5y2bpdut
X-Received: by 2002:a1f:2ccd:0:b0:3b8:7586:c194 with SMTP id s196-20020a1f2ccd000000b003b87586c194mr2334878vks.3.1674807572332;
        Fri, 27 Jan 2023 00:19:32 -0800 (PST)
X-Google-Smtp-Source: AK7set8Wc4OoB+LOFJqQ4iS00UuEdhQhclYGMSUuPr4eiyJbnbW7Trc5XIZqA0yh/DrCh1g7rmzsOQ==
X-Received: by 2002:a1f:2ccd:0:b0:3b8:7586:c194 with SMTP id s196-20020a1f2ccd000000b003b87586c194mr2334872vks.3.1674807572100;
        Fri, 27 Jan 2023 00:19:32 -0800 (PST)
Received: from redhat.com ([37.19.199.113])
        by smtp.gmail.com with ESMTPSA id 4-20020a056122084400b003a31fd43853sm259702vkk.3.2023.01.27.00.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 00:19:31 -0800 (PST)
Date:   Fri, 27 Jan 2023 03:19:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andrey Smetanin <asmetanin@yandex-team.ru>
Cc:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
Message-ID: <20230127031904-mutt-send-email-mst@kernel.org>
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
 <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com>
 <20221219023900-mutt-send-email-mst@kernel.org>
 <62621671437948@mail.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62621671437948@mail.yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 11:24:26AM +0300, Andrey Smetanin wrote:
> Sorry for the delay.
> I will send update on this week after some tests.
> 19.12.2022, 10:39, "Michael S. Tsirkin" <mst@redhat.com>:

Do you still plan to send something? Dropping this for now.

