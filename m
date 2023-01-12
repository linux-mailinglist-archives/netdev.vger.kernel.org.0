Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EF7667142
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjALLvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjALLun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:50:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB6D5E664
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673523546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qp7LxUOhP/zffa2I1gllxS81D7dtXmGujohyvT79haU=;
        b=T+HBN4cGaXSR/lWONp4yoxTgZuX9iLyyGQBf/7e7MRFaMxTtdDF/G+W6dPWvPRoFRADASL
        EfflA8jrRjtBKoYzWlv/eDegdUUOsQFXiuNTrea5QVBzuRiTlNB83lQ0EJT2tbwjud1j6K
        wf/HyVTdoNQSLMkNhwgJ1sld8gxIZhE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-tnOgOSLNPNKgHb6JCB5z7w-1; Thu, 12 Jan 2023 06:39:05 -0500
X-MC-Unique: tnOgOSLNPNKgHb6JCB5z7w-1
Received: by mail-wm1-f69.google.com with SMTP id t24-20020a1c7718000000b003d1fd0b866fso4179546wmi.3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:39:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qp7LxUOhP/zffa2I1gllxS81D7dtXmGujohyvT79haU=;
        b=sZN1HlD4oB6E29yGJoPFCjgzL81g8GNA+6Mz9O+AK90pP9nx5wmKdR9voy+8aLeWqk
         DmSEJJc3kNk6vkLklwtkxMUIgTC4CfTMkUZHRGr9jHDJTDjB6a4uXXvb4aPGrqlwc3uZ
         vxlU4S15Y7TkDmwGX86KmFkPKTdNGceuqdT7hFgxn9UL5dWgtbI+MFMThqkfTe2TQGDY
         E+B20oLvpzlP16KwxYi3invp+Rgtzvz0XwVTrQoeJ9ewb7WOny2lGXmr2KSRwnQrHj3O
         7oXCD+2KFK0KgS0xslA1DD4Ap3jB4rwG2VSYWs6Jb4oayQ9umtukRGgqEnpy0YfMm6Um
         xVnw==
X-Gm-Message-State: AFqh2kqieEyVCeXKHqczynfkLDAOIRK3Ea5s8eIp40yzSZGuY44kEi7G
        P1efo0kLlRmz6o9uo9RCp50vMRQ2Ytyw/JML6eZvUtBh8AkKxd81lAGaovorgUQHEm3paxm2bIa
        XDyTlC4m1iss85xWH
X-Received: by 2002:a05:600c:2844:b0:3da:4e:8dfe with SMTP id r4-20020a05600c284400b003da004e8dfemr5984312wmb.38.1673523544124;
        Thu, 12 Jan 2023 03:39:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs5aW12cvHZEeONEsMIAQmSNDKTa6MrdMvBThl9kh/VmqT3fUCrb1IjlsK8Uei4YamC+1lCrw==
X-Received: by 2002:a05:600c:2844:b0:3da:4e:8dfe with SMTP id r4-20020a05600c284400b003da004e8dfemr5984299wmb.38.1673523543855;
        Thu, 12 Jan 2023 03:39:03 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id s7-20020a1cf207000000b003d98438a43asm20239891wmc.34.2023.01.12.03.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 03:39:03 -0800 (PST)
Message-ID: <4c48269962dafbb641d5b0c38ec5b7bf951f3b4d.camel@redhat.com>
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Thu, 12 Jan 2023 12:39:01 +0100
In-Reply-To: <20230112105137.7b09e70b@donnerap.cambridge.arm.com>
References: <20230111133228.190801-1-andre.przywara@arm.com>
         <20230111213143.71f2ad7e@kernel.org>
         <20230112105137.7b09e70b@donnerap.cambridge.arm.com>
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

On Thu, 2023-01-12 at 10:51 +0000, Andre Przywara wrote:
> On Wed, 11 Jan 2023 21:31:43 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> > Hm, we have a patch in net-next which reformats the entries:
> > ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
> > 
> > Would you like this ID to be also added in stable? We could just 
> > apply it to net, and deal with the conflict locally. But if you 
> > don't care about older kernels then better if you rebase.
> 
> Stable would be nice, but only to v6.1. I think I don't care
> about older kernels.
> So what about if I resend this one here, based on top of the reformat
> patch, with a:
> Cc: <stable@vger.kernel.org> # 6.1.x
> line in there, and then reply to the email that the automatic backport
> failed, with a tailored patch for v6.1?
> Alternatively I can send an explicit stable backport email once this one
> is merged.

Note that we can merge this kind of changes via the -net tree. No
repost will be needed. We can merge it as is on -net and you can follow
the option 2 from the stable kernel rules doc, with no repost nor
additional mangling for stable will be needed.

If you are ok with the above let me know.

Thanks,

Paolo

