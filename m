Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A411366717B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbjALMAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjALL7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:59:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E521DDE9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673524397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lyJSmAogOeE+1RjDXK5+T0HTt5s0oNcRZLZKfpmWmn0=;
        b=h883HAO7HNzAGfQ1VaByB6foDATEhq4flpli3Pa+LtFxjlCMZ/3eHqLF0RQFzfAm9hgcYz
        ePWoOAfBPXO4ydOlzwGL1dObM0Bq2sO4znGywkDwIh7mnYGfMJCinhBF8Zwz3y0+dsKhBi
        xqYMNOdVEQXk+WLvxEwV1FHo99nzh9Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-572-Ks23_sKvMrCuLn4AtKJ9tg-1; Thu, 12 Jan 2023 06:53:16 -0500
X-MC-Unique: Ks23_sKvMrCuLn4AtKJ9tg-1
Received: by mail-wm1-f70.google.com with SMTP id a6-20020a05600c224600b003d1f3ed49adso4189796wmm.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 03:53:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lyJSmAogOeE+1RjDXK5+T0HTt5s0oNcRZLZKfpmWmn0=;
        b=0eimHC57Fwvy9m+gdAulwQpfVdLDv/mZVthUVyuG6hIpThbu1ltu2wHyXPeB8MOF7F
         9Vv/jjX0NcDE2viz0ZFkMYXtrg9tu9XtUkY53YSoyufWDK85Uzzw/yp8r/s5ELVvTMOe
         ziFr1FvDdM4wCCbtRFSubeGzivXxSaxTVozED1eJKwTtvBv8nIO5TZ14Y3omZ74DTIfb
         kopJgeiRSysT0dzh8PO8qPrkhirdCRN9NNCsweeG2Aqk+EAocp8HPEgJjm/J1nXSkcXA
         T+kJEP5XrJNkkJm1hAGm6VovKKSsO2mj2Gp1HF2JnoxQpqhk1iKHN8XrwSk9sz5e4KM2
         aT4Q==
X-Gm-Message-State: AFqh2kqSx50V8Bow5cGdH65jGFBFPVK2tKZ4sptIK0KeW/vpuhkAfLNc
        IZC5qjtNp7/YumfalsyUfyDfGdn//Fu+M0P3vhRDSq0OvqFJ5hk2aSpX7wJhsZ/TBKflsAFzsJn
        6GmN/BDe3VLNAmxhB
X-Received: by 2002:a05:600c:3509:b0:3c6:e60f:3f6f with SMTP id h9-20020a05600c350900b003c6e60f3f6fmr54279412wmq.38.1673524394387;
        Thu, 12 Jan 2023 03:53:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv1gWBXnztIeY5tQuHUJyJiOwiORB6jFEhumLrrLcD/6LIUNVgj0usCCc1/aMThJhAKnz2ybA==
X-Received: by 2002:a05:600c:3509:b0:3c6:e60f:3f6f with SMTP id h9-20020a05600c350900b003c6e60f3f6fmr54279395wmq.38.1673524394071;
        Thu, 12 Jan 2023 03:53:14 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c1d2400b003d9fb59c16fsm9261122wms.11.2023.01.12.03.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 03:53:13 -0800 (PST)
Message-ID: <455b49a98c98edb1512ba2365adc76ac78a2b71b.camel@redhat.com>
Subject: Re: [PATCH net-next v7 4/4] test/vsock: vsock_perf utility
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kernel <kernel@sberdevices.ru>
Date:   Thu, 12 Jan 2023 12:53:12 +0100
In-Reply-To: <0a9464eb-ad31-426b-1f30-c19d77281308@sberdevices.ru>
References: <0a9464eb-ad31-426b-1f30-c19d77281308@sberdevices.ru>
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

On Tue, 2023-01-10 at 10:18 +0000, Arseniy Krasnov wrote:
> This adds utility to check vsock rx/tx performance.
> 
> Usage as sender:
> ./vsock_perf --sender <cid> --port <port> --bytes <bytes to send>
> Usage as receiver:
> ./vsock_perf --port <port> --rcvlowat <SO_RCVLOWAT>
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  tools/testing/vsock/Makefile     |   3 +-
>  tools/testing/vsock/README       |  34 +++
>  tools/testing/vsock/vsock_perf.c | 427 +++++++++++++++++++++++++++++++
>  3 files changed, 463 insertions(+), 1 deletion(-)
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
> index 000000000000..a72520338f84
> --- /dev/null
> +++ b/tools/testing/vsock/vsock_perf.c
> @@ -0,0 +1,427 @@
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
> +static void error(const char *s)
> +{
> +	perror(s);
> +	exit(EXIT_FAILURE);
> +}

For the records, I suggested to use the existing error() libcall, see
man 3 error.

Not a big deal. This can be merged as-is, and you can follow-up, it you
find it useful.

Cheers,

Paolo

