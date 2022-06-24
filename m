Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222DB5593BA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiFXGtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFXGtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:49:50 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80FD4F9DE;
        Thu, 23 Jun 2022 23:49:48 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeb79.dynamic.kabel-deutschland.de [95.90.235.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9D46A61EA1929;
        Fri, 24 Jun 2022 08:49:45 +0200 (CEST)
Message-ID: <9ee7f8de-ba70-c930-6f4b-d3c066ac88bc@molgen.mpg.de>
Date:   Fri, 24 Jun 2022 08:49:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 1/2] Bluetooth: Add support for devcoredump
Content-Language: en-US
To:     Manish Mandlik <mmandlik@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220623123549.v2.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220623123549.v2.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Manish, dear Abhishek,


Thank you for the patch.

Am 23.06.22 um 21:37 schrieb Manish Mandlik:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Add devcoredump APIs to hci core so that drivers only have to provide
> the dump skbs instead of managing the synchronization and timeouts.
> 
> The devcoredump APIs should be used in the following manner:
>   - hci_devcoredump_init is called to allocate the dump.
>   - hci_devcoredump_append is called to append any skbs with dump data
>     OR hci_devcoredump_append_pattern is called to insert a pattern.
>   - hci_devcoredump_complete is called when all dump packets have been
>     sent OR hci_devcoredump_abort is called to indicate an error and
>     cancel an ongoing dump collection.
> 
> The high level APIs just prepare some skbs with the appropriate data and
> queue it for the dump to process. Packets part of the crashdump can be
> intercepted in the driver in interrupt context and forwarded directly to
> the devcoredump APIs.
> 
> Internally, there are 5 states for the dump: idle, active, complete,
> abort and timeout. A devcoredump will only be in active state after it
> has been initialized. Once active, it accepts data to be appended,
> patterns to be inserted (i.e. memset) and a completion event or an abort
> event to generate a devcoredump. The timeout is initialized at the same
> time the dump is initialized (defaulting to 10s) and will be cleared
> either when the timeout occurs or the dump is complete or aborted.

Do you have a usage example, how this can be used fro userspace?

> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v2:
> - Move hci devcoredump implementation to new files
> - Move dump queue and dump work to hci_devcoredump struct
> - Add CONFIG_DEV_COREDUMP conditional compile
> 
>   include/net/bluetooth/coredump.h | 109 +++++++
>   include/net/bluetooth/hci_core.h |   5 +
>   net/bluetooth/Makefile           |   2 +
>   net/bluetooth/coredump.c         | 504 +++++++++++++++++++++++++++++++
>   net/bluetooth/hci_core.c         |   9 +
>   net/bluetooth/hci_sync.c         |   2 +
>   6 files changed, 631 insertions(+)
>   create mode 100644 include/net/bluetooth/coredump.h
>   create mode 100644 net/bluetooth/coredump.c
> 
> diff --git a/include/net/bluetooth/coredump.h b/include/net/bluetooth/coredump.h
> new file mode 100644
> index 000000000000..73601c409c6e
> --- /dev/null
> +++ b/include/net/bluetooth/coredump.h
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Google Corporation
> + */
> +
> +#ifndef __COREDUMP_H
> +#define __COREDUMP_H
> +
> +#define DEVCOREDUMP_TIMEOUT	msecs_to_jiffies(10000)	/* 10 sec */
> +
> +typedef int  (*dmp_hdr_t)(struct hci_dev *hdev, char *buf, size_t size);
> +typedef void (*notify_change_t)(struct hci_dev *hdev, int state);
> +
> +/* struct hci_devcoredump - Devcoredump state
> + *
> + * @supported: Indicates if FW dump collection is supported by driver
> + * @state: Current state of dump collection
> + * @alloc_size: Total size of the dump
> + * @head: Start of the dump
> + * @tail: Pointer to current end of dump
> + * @end: head + alloc_size for easy comparisons
> + *
> + * @dump_q: Dump queue for state machine to process
> + * @dump_rx: Devcoredump state machine work
> + * @dump_timeout: Devcoredump timeout work
> + *
> + * @dmp_hdr: Create a dump header to identify controller/fw/driver info
> + * @notify_change: Notify driver when devcoredump state has changed
> + */
> +struct hci_devcoredump {
> +	bool		supported;
> +
> +	enum devcoredump_state {
> +		HCI_DEVCOREDUMP_IDLE,
> +		HCI_DEVCOREDUMP_ACTIVE,
> +		HCI_DEVCOREDUMP_DONE,
> +		HCI_DEVCOREDUMP_ABORT,
> +		HCI_DEVCOREDUMP_TIMEOUT
> +	} state;
> +
> +	u32		alloc_size;

As it’s not packed, why specify the length? Just use size_t or `unsigned 
int`?

[…]


Kind regards,

Paul
