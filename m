Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65D958F8DB
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiHKILg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbiHKILf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:11:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B89541D1A
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660205490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=88brHzPZ6c8Q6vxkn2ZMmOq0N/l0h2/0PF0qkGV+51Y=;
        b=HBoekunNh6JxV+RO7F7SoMMa01HCG1VQv3lWI+uO5eES07xTDSVcRPA88rIYCy6VTr9yfK
        1WXFc+bG3WmGp2UsP83epEoaVjk2pvHFHXc0OAIncAfGduJffCZVDod3Oi/YZmGYm4q6e2
        dbLGQeIe6iSfn+W635MYzDfd3q89z6E=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-cXoY1unjNfK2Nc2e78_UCA-1; Thu, 11 Aug 2022 04:11:28 -0400
X-MC-Unique: cXoY1unjNfK2Nc2e78_UCA-1
Received: by mail-wm1-f70.google.com with SMTP id h62-20020a1c2141000000b003a4f57eaeaaso3156717wmh.8
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 01:11:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=88brHzPZ6c8Q6vxkn2ZMmOq0N/l0h2/0PF0qkGV+51Y=;
        b=s9gqlfDcb6Olgpgcqfd5m98L9ipIDf0jphevq1wNmoMT40PRq1jL6E5oelnvZO6hzq
         OxhVvesPWNXPusOpV6ZaniWjzNjxkOpwcDRhRaIqqJeKCaUoY+wT36mofg4XmlfZiO5l
         b3lkaeUk/O16fXgRb+gwWjYsQCRSuZvuxlZUP4c6fnvQkfTWW+oCmGmEwDKJL6PKmRI3
         3sQwFMmAxKs2UXPDf+qaV1Hdk6sAwAxmTUcWKiqjR+BKAsAN00ITu1EAffAosb0S0fFq
         xx4v4zWjr/xGU3+7/iOtNZikHXJmOR5lHtfMN9CvaJv9xJd0nsWeBTfCRuRY12WyMXCz
         ZQOA==
X-Gm-Message-State: ACgBeo3Df+KDfVbYrdWRDxBcnUpXD9xM+uO5pNcqDlyTmRAnSWaBYjs8
        OEcy+TVbSkkkq/qZArk+1bP/TXpD5e6K40PiheDjLJtRso0d6R/XJFjpQRf10jsJrsa4xAE3MmP
        4joAnD4Ar1l79Sjv4
X-Received: by 2002:a5d:684a:0:b0:220:7b23:a980 with SMTP id o10-20020a5d684a000000b002207b23a980mr20077591wrw.597.1660205487400;
        Thu, 11 Aug 2022 01:11:27 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xc/42oHie17kmauy1EJXfhqEj0LSLA+uazBJPCNi2fmb0OwQ0ToWaIHHZc2CplPLpkPQTRw==
X-Received: by 2002:a5d:684a:0:b0:220:7b23:a980 with SMTP id o10-20020a5d684a000000b002207b23a980mr20077579wrw.597.1660205487181;
        Thu, 11 Aug 2022 01:11:27 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id t19-20020a05600c199300b003a31c4f6f74sm5513744wmq.32.2022.08.11.01.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 01:11:26 -0700 (PDT)
Date:   Thu, 11 Aug 2022 04:11:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH vhost 0/2] virtio_net: fix for stuck when change ring
 size with dev down
Message-ID: <20220811041041-mutt-send-email-mst@kernel.org>
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 04:02:56PM +0800, Xuan Zhuo wrote:
> When dev is set to DOWN state, napi has been disabled, if we modify the
> ring size at this time, we should not call napi_disable() again, which
> will cause stuck.
> 
> And all operations are under the protection of rtnl_lock, so there is no
> need to consider concurrency issues.
> 
> PS.
> Hi Michael, I don't know which way is more convenient for you, so I split the
> commit into two commits, so you can fixup to my previous commit:
> 
>     virtio_net: support tx queue resize
> 	virtio_net: support rx queue resize
> 
> Xuan Zhuo (2):
>   virtio_net: fix for stuck when change rx ring size with dev down
>   virtio_net: fix for stuck when change tx ring size with dev down
> 
>  drivers/net/virtio_net.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)


Which patches does this fix?
Maybe I should squash.

> --
> 2.31.0

