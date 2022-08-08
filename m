Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6C58C760
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 13:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiHHLO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 07:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbiHHLO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 07:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 475B05595
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 04:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659957265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yY0JFPsIeaqtqI4iFArqAoOxJZBsLvWKUrWCsvYe/Bc=;
        b=g5INBvX+6CvKAqjWw2DupmWSeLQhrfClfnREWRG+f5r64a4dVFAIFqEeJ71jRvItmTqlWz
        6ZI1n/LaDmtHQij4QY0n6vdF46VILNDzhHeAaDasqvJtHMkfbh/va1a+2c2A9gNBgPwG8n
        vQ7HYvUsRJIvtubc2cunhBPo7YpCmr4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-0SCb6C81OWO2POO23rJpkg-1; Mon, 08 Aug 2022 07:14:24 -0400
X-MC-Unique: 0SCb6C81OWO2POO23rJpkg-1
Received: by mail-qk1-f199.google.com with SMTP id v13-20020a05620a0f0d00b006b5f0ec742eso7581686qkl.2
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 04:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=yY0JFPsIeaqtqI4iFArqAoOxJZBsLvWKUrWCsvYe/Bc=;
        b=tv7wYWH2rEzEvnImQLR72eWqpZa6Su3CkXbgnA9oASsNL2f9o8b+DfBVgoLu01602h
         Xi2kcP/JJ6tENeMZBUVFYh8iofkfNN4oOKnLZxPBXnbbB1ef2V4k7X1jar21qjvSH56K
         cc273JfTg28PVFxzsyit2UXJFHhkTK8U9McOK1lh99vOsbZId9arwI2/YCnWWNcJc6dJ
         Km6cDsKQdTiaptX77YAF2kDaIT9sj2+dxlyLvTvUCygRCBCV/NHlJvQzxgIGIfRWtkF+
         QO47Ut/LyeOTE5pbJCxcQEMmWFHcbSBMeoRzD27iFrMc4Wz3BkMHvnBIQ7Sh9v0TZ8bh
         UsZw==
X-Gm-Message-State: ACgBeo02vqPPH0jKkACFENdtI0sCOHVTNozFNU4xkPW2sw1tS3197h74
        oWiMLlg1oEGKHGo4oPHtaO0jrJAUFRm7RHINkI1QyKltHWgntoT4OUhtxfAPzlCjDvvgfyIt/zV
        Xyqh38ejT68L4NqKA
X-Received: by 2002:a37:9602:0:b0:6b8:753c:729d with SMTP id y2-20020a379602000000b006b8753c729dmr13647136qkd.83.1659957263905;
        Mon, 08 Aug 2022 04:14:23 -0700 (PDT)
X-Google-Smtp-Source: AA6agR639ZIMRG4InAc+BbR2p/NP4CtcHRuLRLUW7+Hgtww1NkwTDOVGrJ0yy9vLlJVxPTxPb1lKOQ==
X-Received: by 2002:a37:9602:0:b0:6b8:753c:729d with SMTP id y2-20020a379602000000b006b8753c729dmr13647106qkd.83.1659957263654;
        Mon, 08 Aug 2022 04:14:23 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id n1-20020ac86741000000b00342f932c47csm1906952qtp.46.2022.08.08.04.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 04:14:22 -0700 (PDT)
Date:   Mon, 8 Aug 2022 13:14:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 9/9] vsock_test: POLLIN + SO_RCVLOWAT test
Message-ID: <20220808111412.iywihoyszvswomlb@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <1f50d595-cd37-ad61-f165-5632162dc682@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1f50d595-cd37-ad61-f165-5632162dc682@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 03, 2022 at 02:07:58PM +0000, Arseniy Krasnov wrote:
>This adds test to check,that when poll() returns POLLIN,POLLRDNORM bits,
>next read call won't block.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 107 +++++++++++++++++++++++++++++++
> 1 file changed, 107 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index dc577461afc2..920dc5d5d979 100644
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
>@@ -596,6 +597,107 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
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
>+	/* Wait until client is ready to receive rest of data. */
>+	control_expectln("CLNSENT");
>+
>+	for (i = 0; i < RCVLOWAT_BUF_SIZE - 1; i++)
>+		send_byte(fd, 1, 0);
>+
>+	/* Keep socket in active state. */
>+	control_expectln("POLLDONE");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
>+{
>+	unsigned long lowat_val = RCVLOWAT_BUF_SIZE;
>+	char buf[RCVLOWAT_BUF_SIZE];
>+	struct pollfd fds;
>+	ssize_t read_res;
>+	short poll_flags;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>+			&lowat_val, sizeof(lowat_val))) {

A small checkpatch warning that you can fix since you have to resend:

CHECK: Alignment should match open parenthesis
#76: FILE: tools/testing/vsock/vsock_test.c:645:
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
+			&lowat_val, sizeof(lowat_val))) {

total: 0 errors, 0 warnings, 1 checks, 125 lines checked

Thanks,
Stefano

