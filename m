Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F46E579FCC
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbiGSNiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbiGSNiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:38:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 872E5F2859
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TYVq4WjdOQMHhc5px4YCUTqr6DUNRdDOEbVtXRDK/f8=;
        b=KdPQSz+zgnt+ng130VvTcFmbdrxgShtQj8fijy2ZAvzjQkR18U8ZdYGwv/osLK7Igc/ZZf
        +pKYzKTud74ErJlfesedw1q0dCVUEVJZBwSofI7yVTUkra9JgAC9khVs3AhPiYxENz/DIj
        js7Z5BUjOelpDUqEue/WgSvAR2eVAmE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-HvTZOUG1OQ-HotBujGPjag-1; Tue, 19 Jul 2022 08:52:38 -0400
X-MC-Unique: HvTZOUG1OQ-HotBujGPjag-1
Received: by mail-qk1-f197.google.com with SMTP id f20-20020a05620a409400b006b5fc740485so1707985qko.12
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TYVq4WjdOQMHhc5px4YCUTqr6DUNRdDOEbVtXRDK/f8=;
        b=imB32ZhJzkdm72U8FP/hmWf2SgYPQEk/UK1cgqvcGg6nk+OJynCQHZB/fzdJQsTuBv
         D1IXu2bnbbMt0y53Rm6ATPp86z8jzTjrGOAcwtPys7aEpY+ZWDlOxJePIqpwqqotXf9k
         H6XIzkQ5bcsi5bcgkV3Gv9d6xKyOKXtZC+mWa8aznIman+m2uJw0tRyXstZ13PyVhux5
         HgEjMhu90AFpCZhE7YNXscTDRJoK8CK5pxGqS2oukVYSX+oxP/12SdaGbK3xzRc3cNEN
         tnwxW3VGYxXFCWQhwIPuJ13YErAnKSa0drAtGYd4TfEYo3D2f7qJYU8ClcDv7CzNHa/5
         vYPw==
X-Gm-Message-State: AJIora9ny9PeNpBIAbFLgm5ncFWFLGPET8xEhDUu2zhmUTJzYop+3iGZ
        hGz1JESDA3LxQIksTqBDPMUzotx5rdtHACDr03c7ZoIE7NwHDyZ+VQPCAyv5yCjrqWqPNtbSUnq
        1McA2yX71om2qarKn
X-Received: by 2002:a37:614:0:b0:6b5:cda7:694b with SMTP id 20-20020a370614000000b006b5cda7694bmr13081910qkg.532.1658235157517;
        Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9pkG+DbLrrLN376mRVwAbaPHBtJQ48OByRq4neWnlpWQY9teeIXv+aG4MfOrc28E2dEFUWw==
X-Received: by 2002:a37:614:0:b0:6b5:cda7:694b with SMTP id 20-20020a370614000000b006b5cda7694bmr13081889qkg.532.1658235157281;
        Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id c26-20020a05620a269a00b006b5ba7b9a6fsm13373178qkp.35.2022.07.19.05.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:52:36 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:52:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Message-ID: <20220719125227.bktosg3yboeaeoo5@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:19:06AM +0000, Arseniy Krasnov wrote:
>This adds test to check, that when poll() returns POLLIN and
>POLLRDNORM bits, next read call won't block.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 90 ++++++++++++++++++++++++++++++++
> 1 file changed, 90 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index dc577461afc2..8e394443eaf6 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -18,6 +18,7 @@
> #include <sys/socket.h>
> #include <time.h>
> #include <sys/mman.h>
>+#include <poll.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -596,6 +597,90 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
> 	close(fd);
> }
>
>+static void test_stream_poll_rcvlowat_server(const struct test_opts *opts)
>+{
>+#define RCVLOWAT_BUF_SIZE 128
>+	int fd;
>+	int i;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send 1 byte. */
>+	send_byte(fd, 1, 0);
>+
>+	control_writeln("SRVSENT");
>+
>+	/* Just empirically delay value. */
>+	sleep(4);

Why we need this sleep()?

