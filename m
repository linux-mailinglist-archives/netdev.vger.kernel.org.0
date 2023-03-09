Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2456B2177
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjCIKcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCIKcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:32:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3E64B803
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678357878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n68uNgs6PpJkrH3hTHjafe5p54xSC0RPGEH/q+n6tt8=;
        b=hLDMmapYuU9ASRtysu5jiBLtHBIXbqjKGGCx3xf+Zn4q+VMdzjxESMJbyuy4Yza0+dV4Rr
        dO5cOaNjXXZUMCq8p6r1BnDrc8SGicjXxd+YypYfrXYFO5bA9a+642IG0O+fija+a5S7Bw
        WmAOel8hD9+J96m73XFyQ2M35B47aC4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-OmCvcovIMx-eK-d7SS9-2g-1; Thu, 09 Mar 2023 05:31:15 -0500
X-MC-Unique: OmCvcovIMx-eK-d7SS9-2g-1
Received: by mail-wr1-f69.google.com with SMTP id i18-20020a05600011d200b002c94d861113so311643wrx.16
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 02:31:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678357874;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n68uNgs6PpJkrH3hTHjafe5p54xSC0RPGEH/q+n6tt8=;
        b=wUGsQSgRPWAhbaJ5lkcskvzfXOKt+wFodkwDvMzTG0OVgamVCRz7RRTXo7BwJCJdmp
         v/EcvuF3YsETknlMNzcZSuL3qkiBPPTYjIuZa7/Z97DNE0l0QQpGIh6pTRKL0DSjxXu3
         aA0Q9KH/5g5EsD6lHS8wEBt1NvDxPVecMJPz/rXgqUrogkznaE5g6K99/joK9a3qKPRM
         BdTWMI0tsE+0eWmujPxrDDwAGrryqDSw/lMN3SQa5CGDZ05Tqt9h6Mxm+X+Spck+DTgR
         BKTHT+FE5/ZDMN2LRcHjzJMWKBBBxt8REuisW9YrBQ0KsGy/bjAWmptBVVKBH+0iLcRf
         n8rw==
X-Gm-Message-State: AO0yUKXgnxjNrrV4dFRmUKa1jqsbhJEf9NJG9TWlLpUrrtbZ6PEJU/Sm
        IRLrv6nGHRpZ6axb5S7jiM+2fXbK5J2MWXpb+j6H9+eQnq/+KP/S9cfERIWifCUzgqRANL4F+He
        QvR3izfk+2XhtQ4LI
X-Received: by 2002:a05:600c:4f50:b0:3eb:42f6:ac55 with SMTP id m16-20020a05600c4f5000b003eb42f6ac55mr17914616wmq.1.1678357873940;
        Thu, 09 Mar 2023 02:31:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+UNKRTpKJwy/t8WZ8m3LFA6MnUeFm4+Nupc8WNJb6zQWAODikVHRL0uNPM96EPioeOKFXiKQ==
X-Received: by 2002:a05:600c:4f50:b0:3eb:42f6:ac55 with SMTP id m16-20020a05600c4f5000b003eb42f6ac55mr17914599wmq.1.1678357873693;
        Thu, 09 Mar 2023 02:31:13 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm17744677wrt.56.2023.03.09.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 02:31:13 -0800 (PST)
Message-ID: <09cdc1990818a26fd0e3514b7619261ebc0da50f.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] sctp: add fair capacity stream scheduler
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Date:   Thu, 09 Mar 2023 11:31:12 +0100
In-Reply-To: <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
References: <cover.1678224012.git.lucien.xin@gmail.com>
         <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-07 at 16:23 -0500, Xin Long wrote:
> diff --git a/net/sctp/stream_sched_fc.c b/net/sctp/stream_sched_fc.c
> new file mode 100644
> index 000000000000..b336c2f5486b
> --- /dev/null
> +++ b/net/sctp/stream_sched_fc.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* SCTP kernel implementation
> + * (C) Copyright Red Hat Inc. 2022
> + *
> + * This file is part of the SCTP kernel implementation
> + *
> + * These functions manipulate sctp stream queue/scheduling.
> + *
> + * Please send any bug reports or fixes you make to the
> + * email addresched(es):
> + *    lksctp developers <linux-sctp@vger.kernel.org>
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <linux/list.h>
> +#include <net/sctp/sctp.h>

Note that the above introduces a new compile warning:

../net/sctp/stream_sched_fc.c: note: in included file (through ../include/n=
et/sctp/sctp.h):
../include/net/sctp/structs.h:335:41: warning: array of flexible structures

that is not really a fault of the new code, it's due to:

	struct sctp_init_chunk peer_init[];

struct sctp_init_chunk {
        struct sctp_chunkhdr chunk_hdr;
        struct sctp_inithdr init_hdr;
};

struct sctp_inithdr {
        __be32 init_tag;
        __be32 a_rwnd;
        __be16 num_outbound_streams;
        __be16 num_inbound_streams;
        __be32 initial_tsn;
        __u8  params[]; // <- this!
};

Any chance a future patch could remove the 'params' field from the
struct included by sctp_init_chunk?

e.g.=20

struct sctp_inithdr_base {
        __be32 init_tag;
        __be32 a_rwnd;
        __be16 num_outbound_streams;
        __be16 num_inbound_streams;
        __be32 initial_tsn;
};

struct sctp_init_chunk {
        struct sctp_chunkhdr chunk_hdr;
        struct sctp_inithdr_base init_hdr;
};

and then cast 'init_hdr' to 'struct sctp_inithdr' if/where needed.

In any case, the above is not blocking this series.

Cheers,

Paolo

