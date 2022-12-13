Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC8D64B37F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 11:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbiLMKrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 05:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbiLMKqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 05:46:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6EB5F90
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670928348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ng1wd9XMGqm8kfTwHIk/MN0YdretQ2zd7KrLEZThTl8=;
        b=TD1gazDlq1yl0A4XBIKZ2x3Pmp6ZXR9CpvKnPMFTN4nGr7YMnhYt+2veFkGIh5wmlcDIjT
        WPBUOeZ6g/h2C8yYOja8OVcCP4KRQnNdbUa3FHKrWByH7I1TTSvP/W5lZvzdvsWGr1A/Mg
        +cmzCOenZzXuxoXIM9VNZXUeq7DV73g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-tMVXKfnmMhCpRqJAFRiYsg-1; Tue, 13 Dec 2022 05:45:46 -0500
X-MC-Unique: tMVXKfnmMhCpRqJAFRiYsg-1
Received: by mail-wr1-f71.google.com with SMTP id o8-20020adfba08000000b00241e80f08e0so2829063wrg.12
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 02:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ng1wd9XMGqm8kfTwHIk/MN0YdretQ2zd7KrLEZThTl8=;
        b=Q7SED4KtRG00oNv0gaO8IQjvG4KR3uPJmSXb2kOMXoYdHjovn1gLThjjXf+mHi076d
         YdP+/MQ5fLAJeSjqxfUadIfBsDhJZuteuSkgI9+3dnGA7YRJyMhIKakUZiH6I2INFgOo
         ZveGTG+9yhAogBh1Dt1tYCqOIHhDgGj/70HgCJTP21cwb5CYi8fBPQkU7QV56NfTybEt
         VuNfN4my5O1cRdhfrveppxl2XHSHhWWQ90i3AlSV9f+v2BfUMA0dR+ND3kwEiuZ0YCEZ
         6kOtmb/n+sNEAnneFOxh5aCIjQ7GvXnlbX2L8XHXTW/AxQS/dvE0sDGS9jmTMqyudaF2
         Afgg==
X-Gm-Message-State: ANoB5plMeT0RvGPuwbgxVdlJkW+R5leMzPniHBQbJCDcr06dJFClmZjG
        Wh4Q46DHqOlzZ/crUCM1vN21LWjJGcryJydhlxCfUb4ndbdn0l7zOsIRmBUc8Qy/8paz7vsFyPq
        3x4XIaX4KANt2HBb8
X-Received: by 2002:a5d:4747:0:b0:242:1f8d:999 with SMTP id o7-20020a5d4747000000b002421f8d0999mr12652332wrs.14.1670928345341;
        Tue, 13 Dec 2022 02:45:45 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ztoklTJqIwHxoPbA5x2OKUpO2qh4VDozvm8AXd41GT3ej8DL4wCxvlY2h7af0pfy4ekABUA==
X-Received: by 2002:a5d:4747:0:b0:242:1f8d:999 with SMTP id o7-20020a5d4747000000b002421f8d0999mr12652317wrs.14.1670928345137;
        Tue, 13 Dec 2022 02:45:45 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id i8-20020adfefc8000000b0022cdeba3f83sm11389245wrp.84.2022.12.13.02.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 02:45:44 -0800 (PST)
Date:   Tue, 13 Dec 2022 11:45:42 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v4 2/4] test/vsock: rework message bounds test
Message-ID: <20221213104542.o2fzurh3fsrkgod4@sgarzare-redhat>
References: <6be11122-7cf2-641f-abd8-6e379ee1b88f@sberdevices.ru>
 <44a15b4f-5769-7ed8-f4d1-04abbca6f379@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <44a15b4f-5769-7ed8-f4d1-04abbca6f379@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 08:50:55PM +0000, Arseniy Krasnov wrote:
>This updates message bound test making it more complex. Instead of
>sending 1 bytes messages with one MSG_EOR bit, it sends messages of
>random length(one half of messages are smaller than page size, second
>half are bigger) with random number of MSG_EOR bits set. Receiver
>also don't know total number of messages.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/control.c    |  28 +++++++
> tools/testing/vsock/control.h    |   2 +
> tools/testing/vsock/util.c       |  13 ++++
> tools/testing/vsock/util.h       |   1 +
> tools/testing/vsock/vsock_test.c | 128 +++++++++++++++++++++++++++----
> 5 files changed, 157 insertions(+), 15 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

