Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F697651ED6
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiLTKcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiLTKcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:32:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460F21583A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671532279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ymr7dvYm0bPIMGfQN+EFR1KRA6011TA++6Gv0jSwMRI=;
        b=ZNMOnTgftsysAiTrYdiH5JR6qEJIYBpnUqyO6xKrzw/iIjpMiHDKqVOeDnvIuEo6a/K9CV
        t103u8FEFZjIww08ksHmP6kt1Ng0JQNjIYSq90BNWq7MEuF62X6IlctnW3ResRrdB/ms9l
        d2U6ievO0DIy2fViYtFcW37GwZmcOVg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-ttphs7-hPYilEvOqq_exXQ-1; Tue, 20 Dec 2022 05:31:18 -0500
X-MC-Unique: ttphs7-hPYilEvOqq_exXQ-1
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c510500b003cfca1a327fso6360811wms.8
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 02:31:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ymr7dvYm0bPIMGfQN+EFR1KRA6011TA++6Gv0jSwMRI=;
        b=40iL/Ajk0QWabqFN4HQ9USG0jgVQGHV+LH5bpC1fHdyg1NW8O73Zw/RHIebYexNxlo
         PkF+zgPXE224eepgMPdYh6Jh2UHeuDF7UrV0fcTNSKqdAsvZ1w+VYgDvnRFg3+9RRDu5
         O9NBy0UZ2UKgwcJkFy3e+KAO7bzLYXMKVFZS2AfgzHw6ed8lWFvvjGEbC2vM9LHn7E20
         spWTD0nnPDydDFljJ4FBvcBzhlMM9eqx9iEH/eAwAQPG9C96lwvZkuY3IWwhhviqPDJf
         oErHPgWpCph99rmuzOZVbZc5FLGGylHGgZFuYCSXwla6yZb49yKoc9PEhUPZrLhSKk/C
         Px+Q==
X-Gm-Message-State: ANoB5pnj1nTtGngMY0E8hA25zCInN9LgwCS31Oa8OwoGGGmBjDLR8ecX
        Nn7v18RToN+27seoBtteL8KoyrnHxCAQM5xOrDzbqAhDS0XHhfcaABNeE6sW7YAF1EUtwmvCRo/
        Oc5nbf+/zkQHp13pK
X-Received: by 2002:a05:600c:6549:b0:3c7:1359:783b with SMTP id dn9-20020a05600c654900b003c71359783bmr37201623wmb.1.1671532276955;
        Tue, 20 Dec 2022 02:31:16 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5x1TeapVDCTlsoX2XzG7CqIUw11/Yk6M+YURbcyrD4F7TcwGxHCWM4JyoUR/l0n84xqNGPTg==
X-Received: by 2002:a05:600c:6549:b0:3c7:1359:783b with SMTP id dn9-20020a05600c654900b003c71359783bmr37201614wmb.1.1671532276748;
        Tue, 20 Dec 2022 02:31:16 -0800 (PST)
Received: from sgarzare-redhat (host-87-11-6-51.retail.telecomitalia.it. [87.11.6.51])
        by smtp.gmail.com with ESMTPSA id r8-20020a05600c35c800b003a2f2bb72d5sm30909143wmq.45.2022.12.20.02.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 02:31:16 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:31:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 1/4] vsock: return errors other than -ENOMEM to
 socket
Message-ID: <20221220103105.njugghpvvjusfjrs@sgarzare-redhat>
References: <e04f749e-f1a7-9a1d-8213-c633ffcc0a69@sberdevices.ru>
 <c22a2ad3-1670-169b-7184-8f4a6d90ba06@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c22a2ad3-1670-169b-7184-8f4a6d90ba06@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 07:18:48AM +0000, Arseniy Krasnov wrote:
>This removes behaviour, where error code returned from any transport
>was always switched to ENOMEM. For example when user tries to send too
>big message via SEQPACKET socket, transport layers return EMSGSIZE, but
>this error code was always replaced with ENOMEM and returned to user.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d593d5b6d4b1..19aea7cba26e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1861,8 +1861,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			written = transport->stream_enqueue(vsk,
> 					msg, len - total_written);
> 		}
>+
> 		if (written < 0) {
>-			err = -ENOMEM;
>+			err = written;
> 			goto out_err;
> 		}
>
>-- 
>2.25.1

