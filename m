Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176DB6A0CB0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjBWPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbjBWPRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:17:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7A4FC8F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677165393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHNMILSu2gh+0ZNjvJdl/zHkMml7P+Yk5v5IpKXTRLs=;
        b=GS5vQybAfgqGCe7W9IWK/S2T10d52YHIjA9ybmZqWZe5kUYcpQw2O+DqKCubhWgqqN/Ky8
        2orm8mApELVhuwqTE/ZkHdHEc+aJT//MRa4laUFPnH1OmpJGuZ2282WeVLTTzEMiofS8Bv
        cjWV7amqDSdKKpAe6kTq8gyYGZfWuG0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-386-F-3ttdlqOmWcECHHjZylzA-1; Thu, 23 Feb 2023 10:16:32 -0500
X-MC-Unique: F-3ttdlqOmWcECHHjZylzA-1
Received: by mail-ed1-f71.google.com with SMTP id da15-20020a056402176f00b004ace822b750so15541430edb.20
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NHNMILSu2gh+0ZNjvJdl/zHkMml7P+Yk5v5IpKXTRLs=;
        b=RFy4i273H8LY/qWSgVzhexUyOybjQYZ2vjkRx0UlR1LEB+tqza0rtWb5BbzVb4oOKI
         D/0gD17Ikv/iP4gr1CnVhh8p72TO9g51YM6eviw9t0W08qBNbPSnOUQNzRhsbLmZzkls
         xksEibiQxR1rtp7oikqIBWGcTMpPAUzcVTNg6N0P9kKE8gOHtl5eJlxozk+iGNmswbHJ
         bzx7zXbtyhNN+PA3Igk5SLxUSGxbQUDIZWS0razX1XZgKIrRRsHHQUuuK5J8F5srSAGt
         Ljm6n1XCZ+sNXI374/I9YrjjPZrdnWlzD61v53avRkHfZZ+KrAR/g2cE/1inJrQA7nUj
         MAFg==
X-Gm-Message-State: AO0yUKV1y7Y88NQvwNrcRYfZcfUY7YKf92hOBOKdwuTapDjc7Hr3IT8R
        P+QB+4lNF5hlYikGMKKIkd4l+B5ExTZravHKZlCivXyPLf7vJdSilBt7a5VpDcpC2Xx912YvOFh
        6wtTBKGu13AxkvjS4kCDiCPQv7YEKrDhT
X-Received: by 2002:a50:935b:0:b0:4ae:f648:950b with SMTP id n27-20020a50935b000000b004aef648950bmr6428820eda.7.1677165391478;
        Thu, 23 Feb 2023 07:16:31 -0800 (PST)
X-Google-Smtp-Source: AK7set9bl/bgJWuLQyrwtx8szz2F6g37LHO2Y+hMZadqHccrzNcYXqW9sshlmlKXVksj3IyPGr9ZDHTslgWcY3fMLMY=
X-Received: by 2002:a50:935b:0:b0:4ae:f648:950b with SMTP id
 n27-20020a50935b000000b004aef648950bmr6428810eda.7.1677165391247; Thu, 23 Feb
 2023 07:16:31 -0800 (PST)
MIME-Version: 1.0
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
 <20220802122356.6f163a79@kernel.org> <CA+QYu4ob4cbh3Vnh9DWgaPpyw8nTLFG__TbBpBsYg1tWJPxygg@mail.gmail.com>
 <20220803083751.40b6ee93@kernel.org> <CA+QYu4poBJgXZ=RLTpQVxMeTX3HUSenWA7WZCcw45dzdGeyecg@mail.gmail.com>
 <20220818085106.73aabac2@kernel.org> <BY3PR18MB4612295606F0C22A1863FF44AB6D9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CA+QYu4pe47eYEUyEMC3n5iF2+qx30ff_duokWq-2z9b=UcpWzQ@mail.gmail.com> <20230222133433.7b4b0e67@kernel.org>
In-Reply-To: <20230222133433.7b4b0e67@kernel.org>
From:   Bruno Goncalves <bgoncalv@redhat.com>
Date:   Thu, 23 Feb 2023 16:16:19 +0100
Message-ID: <CA+QYu4qtGSiC_vUFq3gynMWYbZQN=c7Bnp7HvpLJObg7ndcxNw@mail.gmail.com>
Subject: Re: [EXT] Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manish Chopra <manishc@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Alok Prasad <palok@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Feb 2023 at 22:34, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 19 Aug 2022 09:36:54 +0200 Bruno Goncalves wrote:
> > We hit the panic by booting up the machine with a kernel 5.19.0 with
> > debug flags enabled.
>
> Hi Bruno,
>
> Was this ever fixed?

It looks like it got fixed, I haven't seen this failure on 6.2.0 kernels.

Bruno

