Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E786CB8B0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbjC1HvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbjC1Huz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B02A4682
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679989758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8slMBXaX5tKJuNxDkb5aHuL3vFrJ6coZs8pJFAMGiK0=;
        b=V7LWccux2wuj7RZlNiZ4WwARAz/I7GqU8e5VCzcoD8h2bYM6JBXtRihTQYFv7V8FOXwoTx
        d/M2RQxGFt0UvaBbON5wpcp8JnAvCFn6eVWqeuCMXQiSRZkLOacns0Xw+bBKQ+HifT1pwV
        vC3CPftcf71+ryiYoF107w41pQ6GKHU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-FA8JZldOM4mJChCdpAjkXA-1; Tue, 28 Mar 2023 03:49:16 -0400
X-MC-Unique: FA8JZldOM4mJChCdpAjkXA-1
Received: by mail-qk1-f200.google.com with SMTP id 206-20020a370cd7000000b007467b5765d2so5285044qkm.0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 00:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679989756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8slMBXaX5tKJuNxDkb5aHuL3vFrJ6coZs8pJFAMGiK0=;
        b=XmhVtT+spm2Y6MnHywqYIZuc101ck5jfM86zty71aVgsR6VQVqdHx9C6CwVEjMp6ta
         78+rUlOtZusoyRXxlUL26LXLWsNoErYcL775RbBqMEk74p8kZBMTbivf5n+syWyfyn3E
         hMv82vIsh/gnpeqoB5RbZ1RRoG37bDimjUyhfCqSi5VhrBlfevmcQIvUU0I9iftuJkhh
         LSIyzFUn7/m8DLF+kuvM+m0TF+KFR7vmp/AvSZujPe8t6yzZwKFREubNALNpOkxgbgNn
         bp46f2LGsUsl7I5IRAr9VB11NoThAWNhSR0a/NTs72SohC3zGt6KmozsvHl92to/tI+P
         /yUA==
X-Gm-Message-State: AAQBX9dUI14jSRzH5muGnsn5Bpb6FLwjsRKvI/HbHn3WiELFi9vke2i4
        YFxdhIo/nHQWR7HWHnburdeQwSrQBh7J37YzC/O19gcNPXIWG8r9IPJrLMraKfO3JfiqKhBfOVi
        tgdVOOGRZAu8Dmpmy
X-Received: by 2002:a05:622a:2c1:b0:3e4:e8be:c3a4 with SMTP id a1-20020a05622a02c100b003e4e8bec3a4mr11464853qtx.56.1679989756322;
        Tue, 28 Mar 2023 00:49:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350ail0lTX7WFSmqdfltJySh8ck2FEvfITqls1VGpUAH8boD39DgywjVABQBk7ihF++gBl2ur+A==
X-Received: by 2002:a05:622a:2c1:b0:3e4:e8be:c3a4 with SMTP id a1-20020a05622a02c100b003e4e8bec3a4mr11464840qtx.56.1679989756097;
        Tue, 28 Mar 2023 00:49:16 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id x6-20020ac86b46000000b003e4e7e89828sm1491267qts.20.2023.03.28.00.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 00:49:15 -0700 (PDT)
Date:   Tue, 28 Mar 2023 09:49:10 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] testing/vsock: add vsock_perf to gitignore
Message-ID: <w5lm46kj3wfxzscga6333b6bw26lgzqmlkb675px6ya23ysym4@mqt33kghsp7z>
References: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:16:06PM +0000, Bobby Eshleman wrote:
>This adds the vsock_perf binary to the gitignore file.
>
>Fixes: 8abbffd27ced ("test/vsock: vsock_perf utility")
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> tools/testing/vsock/.gitignore | 1 +
> 1 file changed, 1 insertion(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
>index 87ca2731cff9..a8adcfdc292b 100644
>--- a/tools/testing/vsock/.gitignore
>+++ b/tools/testing/vsock/.gitignore
>@@ -2,3 +2,4 @@
> *.d
> vsock_test
> vsock_diag_test
>+vsock_perf
>
>---
>base-commit: e5b42483ccce50d5b957f474fd332afd4ef0c27b
>change-id: 20230327-vsock-add-vsock-perf-to-ignore-82b46b1f3f6f
>
>Best regards,
>-- 
>Bobby Eshleman <bobby.eshleman@bytedance.com>
>

