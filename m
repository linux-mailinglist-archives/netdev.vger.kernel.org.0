Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D24653D96
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 10:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiLVJkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 04:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiLVJkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 04:40:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402FE2791C
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671702001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1EtQK28+n0f7JhqoeVuBwxA0olYueRLMpqpd1Fq3dw=;
        b=Fo8cyjS//u0EXTnwgYlJNT/hwTI3KJBksiA2b8HIy5krwN+sQfwE7DCa50hixt/C8fYFHE
        xQiaXT9WWhrahSv/96BARN3WIbbv3gJ3FKh3yGzeGgE1u4w0Z+rvjCCOJ/jJZoMlLLyO+H
        YYHWOBygcbpwYvjK2dR25GfO59NDVpY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-rNdWbMTzPNeG7E-n5sJF1Q-1; Thu, 22 Dec 2022 04:39:59 -0500
X-MC-Unique: rNdWbMTzPNeG7E-n5sJF1Q-1
Received: by mail-qv1-f69.google.com with SMTP id kl19-20020a056214519300b004e174020eebso692890qvb.23
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 01:39:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q1EtQK28+n0f7JhqoeVuBwxA0olYueRLMpqpd1Fq3dw=;
        b=cmzOdTVdjHem7o6KTfSAyS0hywGLov11TUkpeLEp5nhqeSTnQszyw9InTM38Fi4Tfc
         PqNaFtB23M/FdnOQfBuK7kpeRktJ4Rx8sr5pRMNsIa/PAxKEyURx6OL13btTvRxQiI/H
         gXHotj8ohTs8FbIs4ZRIduJUDYkdTU+PQp5z20RDl5xQnAYLN7bhHtxygtE5gI7d9UPR
         TXfYu3lAVD6kQFM/uaVQ0mqvEhtt6HUXh3GY+M2GzIbDdMectWrbwVNVct9HqHGAIAoI
         tEG1PNKxfn++hZxyLPVwXHaqGJUuNzdlS3H9YV1G0CAsRYbNX/fu4meEtohhG1DXAqcc
         O6aA==
X-Gm-Message-State: AFqh2kq5FDbMaej5fdoYP8St7Vqn5dRlYn9aq8h2Cq6s/qaqtFmsVHR8
        UwxGjzOqYklENAG0zHtUWZ0oaYlh8ysy968OcmIZhEZMNbqYkxUGSXU67bd/SO2BVfiSoBWKhCC
        56pIdbWrsFNPKxDkP
X-Received: by 2002:ac8:4808:0:b0:3a8:16c0:d9c9 with SMTP id g8-20020ac84808000000b003a816c0d9c9mr6373826qtq.7.1671701999092;
        Thu, 22 Dec 2022 01:39:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv2aHKtkylmQiioTiKDRnqh15TkYPkVxxJ8h9MMkmg+mXkB1M2uAD+m1yllwReafT0wCCcmTg==
X-Received: by 2002:ac8:4808:0:b0:3a8:16c0:d9c9 with SMTP id g8-20020ac84808000000b003a816c0d9c9mr6373809qtq.7.1671701998693;
        Thu, 22 Dec 2022 01:39:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id x20-20020a05620a449400b006eef13ef4c8sm12700255qkp.94.2022.12.22.01.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 01:39:57 -0800 (PST)
Message-ID: <3cbea18a661e9e8dee7ba1d50452bab8d12c54f3.camel@redhat.com>
Subject: Re: [PATCH net] bonding: fix lockdep splat in bond_miimon_commit()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Date:   Thu, 22 Dec 2022 10:39:54 +0100
In-Reply-To: <Y6J+pOX5hAupkge2@Laptop-X1>
References: <20221220130831.1480888-1-edumazet@google.com>
         <Y6J+pOX5hAupkge2@Laptop-X1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-12-21 at 11:33 +0800, Hangbin Liu wrote:
> Another questions is, I'm still a little confused with the mixing usage of
> rcu_access_pointer() and rtnl_dereference() under RTNL. e.g.
> 
> In bond_miimon_commit() we use rcu_access_pointer() to check the pointers.
>                 case BOND_LINK_DOWN:
>                         if (slave == rcu_access_pointer(bond->curr_active_slave))
>                                 do_failover = true;
> 
> In bond_ab_arp_commit() we use rtnl_dereference() to check the pointer
> 
>                 case BOND_LINK_DOWN:
>                         if (slave == rtnl_dereference(bond->curr_active_slave)) {
>                                 RCU_INIT_POINTER(bond->current_arp_slave, NULL);
>                                 do_failover = true;
>                         }
>                 case BOND_LINK_FAIL:
>                         if (rtnl_dereference(bond->curr_active_slave))
>                                 RCU_INIT_POINTER(bond->current_arp_slave, NULL);
> 
> Does it matter to use which one? Should we change to rcu_access_pointer()
> if there is no dereference?

You can use rcu_access_pointer() every time the code does not actually
use the RCU pointer, just checks for NULL value.

rtnl_dereference() needs stronger guarantees (the caller must hold the
RTNL lock at call time). As such it adds additional lockdep-safety, and
should be preferred _when_ the call site meets the requirement.

In the above bond_miimon_commit() example the rcu_access_pointer()
could be replaced with rtnl_dereference() for extra safety and
consistency, but it will be mostly a cosmetic change.

Cheers,

Paolo

