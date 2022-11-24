Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE21637486
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKXIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiKXIy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:54:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92D010AD0C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669280040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uiwYY0ArmcwNEs3ZnhJIxu5/iohIROkA/VLDy8Y5Zqg=;
        b=QupdLMR1Na2GDTUyLgbBqI8z3++qqPhSx5IJ/J2sllhu984KgONvOzMEAJauSq4C4E+hoi
        uDLinO9Ia9SpqJVzneczExIoEjYXi39jeCn7e82mVD/2cHzNMpTELHXYRFu9QmK443Hk8E
        zGP5ivTv2vWzxqgj94PMlbZc6FI44Kw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-hg6biz1mNva83GovjZjUnA-1; Thu, 24 Nov 2022 03:53:58 -0500
X-MC-Unique: hg6biz1mNva83GovjZjUnA-1
Received: by mail-wr1-f70.google.com with SMTP id h2-20020adfa4c2000000b00241cf936619so208603wrb.9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uiwYY0ArmcwNEs3ZnhJIxu5/iohIROkA/VLDy8Y5Zqg=;
        b=wyfzSC6WXeRNNZqv0akI2bF4mrHFrsKkGCTF0IgF9FAVoNrC21RjyH27/7LS1LTleU
         RSkpJ5fWjvuee5bdKPzjK/826FpuQdUjRd1UcUjuT9Knr1xUOxQEpcjMN56Ll3/Ig90o
         na40LIWZNLTBL8R7ZSJsvDehrR+xlkunpP2w4EO7OFjre67CDo3tqE1RCqVDTZE+MPZ5
         Bym8MkAqDdvTmd2jKvvb9rqCrdRuFyJLUrY0u7W/xTBvj+xOGvVD02bvPmAOc5/CH7oh
         JkpcCdKrWpAVxLg3Tdmi2wFwj+AkJlnX3cFenyF3E564BeSA5R6L+0LiViNRcy5cI3jL
         Uf3A==
X-Gm-Message-State: ANoB5pngD6bLDN7Pu8kgIKSwf4uU0j7V6HGUsp+/GIL/zpTKQDS3p4Wx
        SrGAVjIBwuess+I5NozPALk3QJR/1CqTF3ETtB/gPyC8Ojw10qOqxN8I5e0fH+kVkI12FNehFov
        KGSXNEictMbI0iIJu
X-Received: by 2002:adf:eb8a:0:b0:22e:31b2:ecb9 with SMTP id t10-20020adfeb8a000000b0022e31b2ecb9mr19913572wrn.693.1669280037227;
        Thu, 24 Nov 2022 00:53:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Q3UK1gtwV9Cl6cT5+gn6Q35c0U9XtUClfYgVPHs0+t78TenmzqkMgjcKnXNrJF1yXjR6ieg==
X-Received: by 2002:adf:eb8a:0:b0:22e:31b2:ecb9 with SMTP id t10-20020adfeb8a000000b0022e31b2ecb9mr19913554wrn.693.1669280036964;
        Thu, 24 Nov 2022 00:53:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id n6-20020a1ca406000000b003d005aab31asm4802235wme.40.2022.11.24.00.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:53:56 -0800 (PST)
Message-ID: <cf297dd17750f988128df88c824f956f2a4bb719.camel@redhat.com>
Subject: Re: [PATCH net] net: hsr: Fix potential use-after-free
From:   Paolo Abeni <pabeni@redhat.com>
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, arvid.brodin@alten.se
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 24 Nov 2022 09:53:55 +0100
In-Reply-To: <20221123063057.25952-1-yuehaibing@huawei.com>
References: <20221123063057.25952-1-yuehaibing@huawei.com>
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

Hello,

On Wed, 2022-11-23 at 14:30 +0800, YueHaibing wrote:
> The skb is delivered to netif_rx() which may free it, after calling this,
> dereferencing skb may trigger use-after-free.
> 
> Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

The code looks good, but the above is not the commit introducing the
issue, it just move the netif_rx() and later skb access from somewhere
else.

Please go deeper in git history and find the change that originated the
issue.

Thanks,

Paolo

