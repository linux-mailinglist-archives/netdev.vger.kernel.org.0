Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF069C606
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjBTHbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:31:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBTHbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:31:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109A5F77E
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 23:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676878259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WSQ5Ei3Zvz9A/QACc0nBE3Xi0KTGh3+qsOVF5MllOJg=;
        b=TkNoWa9qNbhGJtCPAGquKXoq220zTKoiqUnfrTm3Hpt8V6cPJrQoOkE/d+GFzlUfvwcWOl
        iTIStnE8QU75ERSRc3W2hYSy3dRpiwsMbtz/xn55QIqtew+PmkJGZoQ+M0Pu4D6K5QqWtO
        rnS+rEo0uCkLO6EmV+qFwC3Sy8Ykggs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-324-l8FE1fsTOdC8duhFGt37GA-1; Mon, 20 Feb 2023 02:30:58 -0500
X-MC-Unique: l8FE1fsTOdC8duhFGt37GA-1
Received: by mail-wm1-f69.google.com with SMTP id x18-20020a1c7c12000000b003e1e7d3cf9fso291573wmc.3
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 23:30:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676878257;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WSQ5Ei3Zvz9A/QACc0nBE3Xi0KTGh3+qsOVF5MllOJg=;
        b=rplAXUcXRDCPVr7znsWgGbclgZUo15cAEoHc1NDbYy3drRKk+n05grhb6S5BWy6tmz
         5zXeWnLBN1l4zmNZO7l8s+0GpaiWMNPAfWhxYEWq4M/vmB11zwNcj3EW2DBPSHew2lZe
         7L16tOn8IJ1gDR5uI18Nn4208kDc+FKIrl5m4ouhDXIIEG4FQo+oBcGAWNQxGW3Qb/xi
         AihjJkx7N7BJga2HR8GmpnDcQg0ImjnykkJaY9Md9XFV2y9cAY2jIda6UxdzPkO0TF6x
         V9W5x969FGduDk44YgM/YteTt7iFKa9LiGILmM0CL8kuzJMOyIFBTXiaV/5CbKjEyRhf
         ugdg==
X-Gm-Message-State: AO0yUKXWNwRuzHkN2tk/4k0zMnX0ufE+5fXPyll7kM1Ph7niKlIKpquD
        aNE+k12oLs2FPstJF6JicNKrhrXP3heXYQTvy7kyi+StsHOW67xvLhTjYAnxV8TDL5hYvuXfxmb
        IE9vicrLSj2yUi3l3
X-Received: by 2002:a5d:5646:0:b0:2c6:3cec:944f with SMTP id j6-20020a5d5646000000b002c63cec944fmr305970wrw.1.1676878257298;
        Sun, 19 Feb 2023 23:30:57 -0800 (PST)
X-Google-Smtp-Source: AK7set8Hkb2K6ybIPCNlb5y3Oo877yE49uQduXHsl4jNdg2MI8oLixugt2CWr0pfNP8vKiNjBhr4zQ==
X-Received: by 2002:a5d:5646:0:b0:2c6:3cec:944f with SMTP id j6-20020a5d5646000000b002c63cec944fmr305959wrw.1.1676878256983;
        Sun, 19 Feb 2023 23:30:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d654e000000b002c5801aa9b0sm1095103wrv.40.2023.02.19.23.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 23:30:56 -0800 (PST)
Message-ID: <744a8737ce7dc2f149c82738e4ab15233d0b35d9.camel@redhat.com>
Subject: Re: [PATCH net] sctp: add a refcnt in sctp_stream_priorities to
 avoid a nested loop
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Date:   Mon, 20 Feb 2023 08:30:54 +0100
In-Reply-To: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
References: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2023-02-15 at 15:04 -0500, Xin Long wrote:
> With this refcnt added in sctp_stream_priorities, we don't need to
> traverse all streams to check if the prio is used by other streams
> when freeing one stream's prio in sctp_sched_prio_free_sid(). This
> can avoid a nested loop (up to 65535 * 65535), which may cause a
> stuck as Ying reported:
>=20
>     watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
>     Call Trace:
>      <TASK>
>      sctp_sched_prio_free_sid+0xab/0x100 [sctp]
>      sctp_stream_free_ext+0x64/0xa0 [sctp]
>      sctp_stream_free+0x31/0x50 [sctp]
>      sctp_association_free+0xa5/0x200 [sctp]
>=20
> Note that it doesn't need to use refcount_t type for this counter,
> as its accessing is always protected under the sock lock.
>=20
> Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()=
")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/structs.h   |  1 +
>  net/sctp/stream_sched_prio.c | 47 +++++++++++++-----------------------
>  2 files changed, 18 insertions(+), 30 deletions(-)
>=20
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index afa3781e3ca2..e1f6e7fc2b11 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -1412,6 +1412,7 @@ struct sctp_stream_priorities {
>  	/* The next stream in line */
>  	struct sctp_stream_out_ext *next;
>  	__u16 prio;
> +	__u16 users;

I'm sorry for the late feedback. Reading the commit message, it looks
like this counter could reach at least 64K. Is a __u16 integer wide
enough?

Thanks!

Paolo

