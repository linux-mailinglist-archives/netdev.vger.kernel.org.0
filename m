Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD5F6B98D0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCNPRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCNPRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:17:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F40A568C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678806931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VgkxugB9reX7J4QpFAjTsnqheTguVhFZG2CD7KYUIAQ=;
        b=LQdv3odIuhhAUPywuprV2/JVZrHNzyV6t8ZjH8ZfrFP2D0jIBmJTKbLy4XTEboCA8mhtw0
        +AtIg/ZXTupOJeD5K/6ISRStSXKlfgKHRHiY5nqbVloitM+OhvtjGY2btNq88iTMa7pG3f
        PgbXszuM60+kUr9MEx1PwVm3wdqau7k=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-Dh5JNH-FNyi2tfMMK0pvFg-1; Tue, 14 Mar 2023 11:15:30 -0400
X-MC-Unique: Dh5JNH-FNyi2tfMMK0pvFg-1
Received: by mail-qv1-f72.google.com with SMTP id o101-20020a0c906e000000b005ab9fa335c8so1765379qvo.19
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678806925;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgkxugB9reX7J4QpFAjTsnqheTguVhFZG2CD7KYUIAQ=;
        b=6T5SJmuQlrW6ElMoG2rh5HdR6VeURwmvK5RBlDsrETc+RXbnbjLdolPxuMrfhCIKMD
         kg1l/nMuJ+ZTgEm/I9P8eqoZinoZCKRD8IBTgrpCFeLb4rDF0YB7WXS8Pz/0kx8UDSOy
         5TzWGGY/+bdAnnOmh4clo4t1/8GroFKWES15xgouE0N+a7VoyZA+Ujkkoj3QE8KmWast
         qf4qz8D5nZZWLkOuSp8wvwfJNd+6tNIY0BW6Qm8K+FoWVMuhbNcJ8kbK0v3MgDjLjJZO
         m8gTbWqafC41awxpZe8p6vOB22OQroO/e2OGNj+0KxVMlY77XhF3ofUroGovKpUOj8of
         rdeA==
X-Gm-Message-State: AO0yUKWU2U7aaIIjktJxcq90Xn5hoXWF0kYUJMRGChOlOaS6ZgBkJ5d+
        /TjvPNCwWC9L4ni9FWU1t92ay9sa1xteRI8GNIJKKcu9PKpKcFdf5jX+mOyZl/c5vh8+CHft+iT
        WxjYX4v3R+Td8RopM
X-Received: by 2002:ac8:57cd:0:b0:3bf:d9a9:25f7 with SMTP id w13-20020ac857cd000000b003bfd9a925f7mr28826214qta.6.1678806925215;
        Tue, 14 Mar 2023 08:15:25 -0700 (PDT)
X-Google-Smtp-Source: AK7set+hcdQ4dWKcJiP6KEhP4hKJGQe0JipDL7RtfbnIkpQ05JJLVVWxTv9hZ6H3g8oEWFAyMVzFKA==
X-Received: by 2002:ac8:57cd:0:b0:3bf:d9a9:25f7 with SMTP id w13-20020ac857cd000000b003bfd9a925f7mr28826166qta.6.1678806924886;
        Tue, 14 Mar 2023 08:15:24 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id s6-20020a05622a1a8600b003b6382f66b1sm1989455qtc.29.2023.03.14.08.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:15:24 -0700 (PDT)
Message-ID: <eeac1baa-f15e-fbb2-4278-f8f4438199bf@redhat.com>
Date:   Tue, 14 Mar 2023 11:15:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 0/4] bonding: properly restore flags when bond
 changes ether type
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     monis@voltaire.com, syoshida@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
References: <20230314111426.1254998-1-razor@blackwall.org>
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20230314111426.1254998-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/23 07:14, Nikolay Aleksandrov wrote:
> Hi,
> A bug was reported by syzbot[1] that causes a warning and a myriad of
> other potential issues if a bond, that is also a slave, fails to enslave a
> non-eth device. While fixing that bug I found that we have the same
> issues when such enslave passes and after that the bond changes back to
> ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
> extracting the ether_setup() sequence in a helper which does the right
> thing about bond flags when it needs to change back to ARPHRD_ETHER. It
> also adds selftests for these cases.
> 
> Patch 01 adds the new bond_ether_setup helper that is used in the
> following patches to fix the bond dev flag issues. Patch 02 fixes the
> issues when a bond device changes its ether type due to successful
> enslave. Patch 03 fixes the issues when it changes its ether type due to
> an unsuccessful enslave. Note we need two patches because the bugs were
> introduced by different commits. Patch 04 adds the new selftests.
> 
> v2: new set, all patches are new due to new approach of fixing these bugs
> 
> Thanks,
>   Nik
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> 
> Nikolay Aleksandrov (4):
>    bonding: add bond_ether_setup helper
>    bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
>      change
>    bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
>    selftests: bonding: add tests for ether type changes
> 
>   drivers/net/bonding/bond_main.c               | 22 +++--
>   .../selftests/drivers/net/bonding/Makefile    |  3 +-
>   .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
>   3 files changed, 102 insertions(+), 8 deletions(-)
>   create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> 

For the series.
Acked-by: Jonathan Toppins <jtoppins@redhat.com>

