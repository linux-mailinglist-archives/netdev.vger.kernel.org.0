Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7402553253
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350162AbiFUMmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349291AbiFUMmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:42:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8C55237C2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655815319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D51ySMqUt+OtPgHRzK4zwmbmYvoRpZLy/XslPr4tuJY=;
        b=g83yl6U4EvPO9OYMEgSqzlyF8K9bYM9VdDQ/MCtnWAYI6NogdmYEHux5wjHAF8Hwt4M6hH
        Vh5JCF8/sHKIOJ3A+kyFiVkT1yME9L2v3m5SsL1Vl+iF2T05BWSZ0kVROB1asdATPkfNRf
        i6giti43ZF9QvUONFrhE+HVZNrIKL3s=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-BuBS9p7kP8q6jGIcNjwtHw-1; Tue, 21 Jun 2022 08:41:58 -0400
X-MC-Unique: BuBS9p7kP8q6jGIcNjwtHw-1
Received: by mail-qk1-f197.google.com with SMTP id r6-20020a05620a298600b006a98e988ba4so16254748qkp.3
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:41:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=D51ySMqUt+OtPgHRzK4zwmbmYvoRpZLy/XslPr4tuJY=;
        b=uBIN9yBrXipS/GjLGHMl8EeSbwXkruR0q3Hzk1VPt/YeJnXm1rRsOxwlBGCIFYW4yR
         SzY6Z6LLfhcxbCVqxwIerqOd2RmeR4IEVG683aZcWqe4gj9StJUVHojhSvvBbT8JKCAY
         hTDAhI3/03HWoQApXbw877hu0Pek67U3iAfHhpmCFePPEuXheht/r0jSIc7dhJVYnnYp
         FlIuq57Lfk4o0KDzjElxNGok6E+mAqmdeSlo/EpwJSeE3Mubz5BOaHsIJHGGGxpovEaI
         xe6yIh40WMlku8jCDp6euXv07kQ2mx6TXEL3Vz0jk9ph5TQe8h/NVW3Wjj/OglkVNqWS
         0+OQ==
X-Gm-Message-State: AJIora+hdiC8O2Db7/Zo44bIzlMzuFcGgXXw1+lBJtk6gm8ths+AtmZ/
        f3dJnizFKco6M+o0Y9SZgRBV4HRuMD43xBnOe65yJKj9o9SvpKE0QuzWyy+GWbjLP4IBupQCPNS
        BqG9hcXoH9/fdMRvr
X-Received: by 2002:ac8:5dce:0:b0:305:300e:146d with SMTP id e14-20020ac85dce000000b00305300e146dmr24196870qtx.546.1655815318252;
        Tue, 21 Jun 2022 05:41:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v263mucAGrBtYxWqr26aM5ULfwh5a2/GKtxMiunFsvZGbaewuySbgMh2qjE7WUIycUHI3NUA==
X-Received: by 2002:ac8:5dce:0:b0:305:300e:146d with SMTP id e14-20020ac85dce000000b00305300e146dmr24196824qtx.546.1655815317820;
        Tue, 21 Jun 2022 05:41:57 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id q4-20020ac87344000000b00304e5839734sm12169130qtp.55.2022.06.21.05.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 05:41:57 -0700 (PDT)
Message-ID: <2a4f812a-a97f-4ff7-c2da-a7e1acebe92d@redhat.com>
Date:   Tue, 21 Jun 2022 08:41:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv3 net-next 1/2] bonding: add slave_dev field for
 bond_opt_value
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
 <20220621074919.2636622-2-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220621074919.2636622-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/22 03:49, Hangbin Liu wrote:
> Currently, bond_opt_value are mostly used for bonding option settings. If
> we want to set a value for slave, we need to re-alloc a string to store
> both slave name and vlaue, like bond_option_queue_id_set() does, which
> is complex and dumb.
> 
> As Jon suggested, let's add a union field slave_dev for bond_opt_value,
> which will be benefit for future slave option setting. In function
> __bond_opt_init(), we will always check the extra field and set it
> if it's not NULL.
> 
> Suggested-by: Jonathan Toppins <jtoppins@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

