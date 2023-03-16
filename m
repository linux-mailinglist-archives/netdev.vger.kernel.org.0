Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A462E6BC985
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCPInk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjCPIni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D4E4D2AA
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678956175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNIt6/EC2fPTtrcmtD4NvPKR+xt/u6QnYqo+DbsIIYU=;
        b=eSAELSJOcz1Kt89EymhhhmK0us+MyT8vh2Dr2tQiWdrQEyFkKSGS8adxwZuoSLKxvtfTo8
        KXXjqeOvy9UUaGoyfPtUaeqMRjBg1HFypib3KtdgmBeEiLb9NL8BaMIF0je2YmHO9qMQly
        JFgAlXvLRwhSZFzdYYV2HiZAcklxezo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-M0lW5s8jMFCjjU_qgkcYnQ-1; Thu, 16 Mar 2023 04:42:53 -0400
X-MC-Unique: M0lW5s8jMFCjjU_qgkcYnQ-1
Received: by mail-wm1-f70.google.com with SMTP id o42-20020a05600c512a00b003ed26fa6ebdso336523wms.7
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678956172;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNIt6/EC2fPTtrcmtD4NvPKR+xt/u6QnYqo+DbsIIYU=;
        b=6CgQRoDh+9NtlqtUqdj+2Dj0Z835VVcquw5BGTiHJ98RuGsmPXh+blabHPNYydsh8Q
         W0+oY8KfAiUMRlsk1CU+dHUXdaGE+BOS5Y1m+4I+pbf/qGibBFp0BpwtwJlTH5FZJPsX
         fQQO1VD28OjSn/mTowVt5d9GkKhYaBsg16m3l8J4lesTWl3Xq/ZSWOEAZcwVtsvmMYEp
         rLep1I5+syjubP8pHx+sA6AHo1zC42qfgDdOK1waXLbb/Ww2ZKHYpQYcvBXZKbQhd5pS
         UJ2vIkFE5danQfjqAUrdOOHlp/qqFuUemj4gFwwCInuXOh/ivXVYfvzQKKIiMIozHZdk
         4ecA==
X-Gm-Message-State: AO0yUKVJvEkRUCsxEze5pGw7mU8bgUrS0h0WFkjp5ElBbz4WPN3ErcK2
        j8fSCmReKarA3St68r5OU+yZzcW9AuSw552Oc0iZPC7EGMHD09PGOAFU0NWGJMJWiUvldJX3oZ6
        BcnMCWuswD/BP/XAc
X-Received: by 2002:a05:600c:450b:b0:3eb:2de9:8aed with SMTP id t11-20020a05600c450b00b003eb2de98aedmr19691725wmo.41.1678956172846;
        Thu, 16 Mar 2023 01:42:52 -0700 (PDT)
X-Google-Smtp-Source: AK7set+StsW8ItLxY7viETFKNcN8XIJEpkb0A6sN2+0X6h0DH3Cm81PlzHGjafdM1NdabSKvBVlFOQ==
X-Received: by 2002:a05:600c:450b:b0:3eb:2de9:8aed with SMTP id t11-20020a05600c450b00b003eb2de98aedmr19691708wmo.41.1678956172618;
        Thu, 16 Mar 2023 01:42:52 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d4a8d000000b002c5534db60bsm6673269wrq.71.2023.03.16.01.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:42:51 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:42:48 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/8] vdpa_sim: replace the spinlock with a mutex to
 protect the state
Message-ID: <20230316084248.woh6dksgpu2ycn64@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-8-sgarzare@redhat.com>
 <CACGkMEuCUBQeg0gLUjBXff=zMf-=qJqhMpdeUvTDk55Gz6tAVA@mail.gmail.com>
 <CACGkMEv=MkGUUP_xv9V5q+gneLm41yKqJXoWp4cYLK8Cf95oUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEv=MkGUUP_xv9V5q+gneLm41yKqJXoWp4cYLK8Cf95oUw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:31:25PM +0800, Jason Wang wrote:
>On Tue, Mar 14, 2023 at 1:29 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Thu, Mar 2, 2023 at 7:35 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> >
>> > The spinlock we use to protect the state of the simulator is sometimes
>> > held for a long time (for example, when devices handle requests).
>> >
>> > This also prevents us from calling functions that might sleep (such as
>> > kthread_flush_work() in the next patch), and thus having to release
>> > and retake the lock.
>> >
>> > For these reasons, let's replace the spinlock with a mutex that gives
>> > us more flexibility.
>> >
>> > Suggested-by: Jason Wang <jasowang@redhat.com>
>> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> Acked-by: Jason Wang <jasowang@redhat.com>
>>
>> Thanks
>
>Btw, though it looks fine but we'd better double confirm virtio_vdpa works well.

I tested it, but I will do it more carefully to make sure everything
is okay.

>
>(I think so since there's transport that might sleep).

I see.

Thanks,
Stefano

