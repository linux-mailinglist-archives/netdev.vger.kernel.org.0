Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82CC663D0F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbjAJJi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238160AbjAJJhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:37:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE2C45641
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673343425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3IoltaMTP/SoP1SsfQmBngAKvER3lkKce2svsoNj6DA=;
        b=FNU/A4NkYgo//Ix/EpzK4USPU8CGrZKonhsj7SsSuliRwgORm9LDmsA5eO4uEKsqaLdfRv
        /vMIvfFE6NIi9nJtRJ6uEyaNHNrqrjugpODknWDpvue4lDkTRg8qm4UfAmZ1dMwpkm5pO+
        iaBoFlaVUzFaxL8YeNbHR4ctO5S5XxQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-lJZJHJ47M5yWfZyDADrUrA-1; Tue, 10 Jan 2023 04:37:02 -0500
X-MC-Unique: lJZJHJ47M5yWfZyDADrUrA-1
Received: by mail-qv1-f71.google.com with SMTP id od14-20020a0562142f0e00b0051a47174c4eso6611634qvb.10
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:37:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3IoltaMTP/SoP1SsfQmBngAKvER3lkKce2svsoNj6DA=;
        b=1Cy/O1DcpitC5Q+IJQ8RN1E0Igk70B4wQ0N8Mv6MCklARg4fgRkjSCyzF4jnesZCVK
         HCsz/ihcidOJUqemW7Q2KRGKTq/BkFEL2pNVyTG2NgtXRRQMfTtIWXg+nfv5W/bscCO6
         J8FUX97H9cu8n1DX7Dv7zvkUHyPxKHNcSMjeYxFe/68N7U5wB2lreksvLAVZPaCklZv9
         HNXe59JN1Sq4WS+TG1qIvAusLyyw02EnaIfA77yCpS5WGyIDJqoRZgBYigBpPalTVrmd
         cSRSog64eJ9FGNV3MBFtx0+lH293sYBXh8bu98dfB96m8gDODSYO50hsxac4ZC33tQfg
         cdpA==
X-Gm-Message-State: AFqh2kqMYWI+5bdGe6PVKvSVCDalP2f4dISgRQs63vFpAgXygwAwpr6M
        y+BZQrEjziHWZvmYaw4zMg6F/o6S4igmUmZaorcerGBYUHxHG0diq4EsTOvc0mXZwmX5V7Dy8hK
        ITuY41KNmHnTVcrMG
X-Received: by 2002:ac8:541a:0:b0:3a7:e809:1fe3 with SMTP id b26-20020ac8541a000000b003a7e8091fe3mr93226481qtq.49.1673343421731;
        Tue, 10 Jan 2023 01:37:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsR1BdhvAmGlOEi2PUL/5w7kE1LT1nDkO0+hG84MErLiDislP8Se/e0fBns75Zu9jlSfYhxjg==
X-Received: by 2002:ac8:541a:0:b0:3a7:e809:1fe3 with SMTP id b26-20020ac8541a000000b003a7e8091fe3mr93226466qtq.49.1673343421423;
        Tue, 10 Jan 2023 01:37:01 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id d13-20020ac8668d000000b003a6a4744432sm5830178qtp.87.2023.01.10.01.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:37:00 -0800 (PST)
Message-ID: <5c8b538bcc9ac75027f41c21e810d3707a2e1ec7.camel@redhat.com>
Subject: Re: [PATCH net-next v6 4/4] test/vsock: vsock_perf utility
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Tue, 10 Jan 2023 10:36:58 +0100
In-Reply-To: <eaf9598f-27eb-8df0-1dea-b4c5623adba1@sberdevices.ru>
References: <eaf9598f-27eb-8df0-1dea-b4c5623adba1@sberdevices.ru>
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

Hi,

sorry for the late feedback, a couple of notes below...

On Sun, 2023-01-08 at 20:43 +0000, Arseniy Krasnov wrote:
> This adds utility to check vsock rx/tx performance.
> 
> Usage as sender:
> ./vsock_perf --sender <cid> --port <port> --bytes <bytes to send>
> Usage as receiver:
> ./vsock_perf --port <port> --rcvlowat <SO_RCVLOWAT>
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  tools/testing/vsock/Makefile     |   3 +-
>  tools/testing/vsock/README       |  34 +++
>  tools/testing/vsock/vsock_perf.c | 441 +++++++++++++++++++++++++++++++
>  3 files changed, 477 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/vsock/vsock_perf.c
> 
> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
> index f8293c6910c9..43a254f0e14d 100644
> --- a/tools/testing/vsock/Makefile
> +++ b/tools/testing/vsock/Makefile
> @@ -1,8 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -all: test
> +all: test vsock_perf
>  test: vsock_test vsock_diag_test
>  vsock_test: vsock_test.o timeout.o control.o util.o
>  vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> +vsock_perf: vsock_perf.o
>  
>  CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
>  .PHONY: all test clean
> diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
> index 4d5045e7d2c3..84ee217ba8ee 100644
> --- a/tools/testing/vsock/README
> +++ b/tools/testing/vsock/README
> @@ -35,3 +35,37 @@ Invoke test binaries in both directions as follows:
>                         --control-port=$GUEST_IP \
>                         --control-port=1234 \
>                         --peer-cid=3
> +
> +vsock_perf utility
> +-------------------
> +'vsock_perf' is a simple tool to measure vsock performance. It works in
> +sender/receiver modes: sender connect to peer at the specified port and
> +starts data transmission to the receiver. After data processing is done,
> +it prints several metrics(see below).
> +
> +Usage:
> +# run as sender
> +# connect to CID 2, port 1234, send 1G of data, tx buf size is 1M
> +./vsock_perf --sender 2 --port 1234 --bytes 1G --buf-size 1M
> +
> +Output:
> +tx performance: A Gbits/s
> +
> +Output explanation:
> +A is calculated as "number of bits to send" / "time in tx loop"
> +
> +# run as receiver
> +# listen port 1234, rx buf size is 1M, socket buf size is 1G, SO_RCVLOWAT is 64K
> +./vsock_perf --port 1234 --buf-size 1M --vsk-size 1G --rcvlowat 64K
> +
> +Output:
> +rx performance: A Gbits/s
> +total in 'read()': B sec
> +POLLIN wakeups: C
> +average in 'read()': D ns
> +
> +Output explanation:
> +A is calculated as "number of received bits" / "time in rx loop".
> +B is time, spent in 'read()' system call(excluding 'poll()')
> +C is number of 'poll()' wake ups with POLLIN bit set.
> +D is B / C, e.g. average amount of time, spent in single 'read()'.
> diff --git a/tools/testing/vsock/vsock_perf.c b/tools/testing/vsock/vsock_perf.c
> new file mode 100644
> index 000000000000..ccd595462b40
> --- /dev/null
> +++ b/tools/testing/vsock/vsock_perf.c
> @@ -0,0 +1,441 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * vsock_perf - benchmark utility for vsock.
> + *
> + * Copyright (C) 2022 SberDevices.
> + *
> + * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> + */
> +#include <getopt.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <unistd.h>
> +#include <time.h>
> +#include <stdint.h>
> +#include <poll.h>
> +#include <sys/socket.h>
> +#include <linux/vm_sockets.h>
> +
> +#define DEFAULT_BUF_SIZE_BYTES	(128 * 1024)
> +#define DEFAULT_TO_SEND_BYTES	(64 * 1024)
> +#define DEFAULT_VSOCK_BUF_BYTES (256 * 1024)
> +#define DEFAULT_RCVLOWAT_BYTES	1
> +#define DEFAULT_PORT		1234
> +
> +#define BYTES_PER_GB		(1024 * 1024 * 1024ULL)
> +#define NSEC_PER_SEC		(1000000000ULL)
> +
> +static unsigned int port = DEFAULT_PORT;
> +static unsigned long buf_size_bytes = DEFAULT_BUF_SIZE_BYTES;
> +static unsigned long vsock_buf_bytes = DEFAULT_VSOCK_BUF_BYTES;
> +
> +static inline time_t current_nsec(void)

Minor nit: you should avoid 'static inline' functions in c files,
'static' would suffice and will allow the compiler to do a better job.

> +{
> +	struct timespec ts;
> +
> +	if (clock_gettime(CLOCK_REALTIME, &ts)) {
> +		perror("clock_gettime");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	return (ts.tv_sec * NSEC_PER_SEC) + ts.tv_nsec;
> +}
> +
> +/* From lib/cmdline.c. */
> +static unsigned long memparse(const char *ptr)
> +{
> +	char *endptr;
> +
> +	unsigned long long ret = strtoull(ptr, &endptr, 0);
> +
> +	switch (*endptr) {
> +	case 'E':
> +	case 'e':
> +		ret <<= 10;
> +	case 'P':
> +	case 'p':
> +		ret <<= 10;
> +	case 'T':
> +	case 't':
> +		ret <<= 10;
> +	case 'G':
> +	case 'g':
> +		ret <<= 10;
> +	case 'M':
> +	case 'm':
> +		ret <<= 10;
> +	case 'K':
> +	case 'k':
> +		ret <<= 10;
> +		endptr++;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static void vsock_increase_buf_size(int fd)
> +{
> +	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
> +		       &vsock_buf_bytes, sizeof(vsock_buf_bytes))) {
> +		perror("setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
> +		       &vsock_buf_bytes, sizeof(vsock_buf_bytes))) {
> +		perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
> +		exit(EXIT_FAILURE);

You use the above pattern frequently, but you could replace both
libcall with a single error() call.

Thanks,

Paolo

