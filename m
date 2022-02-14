Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69AC4B4178
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 06:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240615AbiBNFiY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Feb 2022 00:38:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbiBNFiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 00:38:20 -0500
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08604EA35;
        Sun, 13 Feb 2022 21:37:59 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id v63so15703655ybv.10;
        Sun, 13 Feb 2022 21:37:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jEgZ6GmqRhZBMojpPVJrw/T5Gy02CzZqktPSEaMETYI=;
        b=TYHQaicWQVtXL0oVAAXmREcFS6Oa6lM497q9SOEp+M0jmfYGFbYaedXte9EirP/AmB
         psNlwYzbwQ8cO6vCsbpn2WCa3ApzZyh8P8U7kEf1Q63p4V9Q1PjL5qrEootJegrlTUzw
         ROXyWqyzXs8xl/sbLgwQXts/a5v3uA+THOBFix6FSQQH57uT35oFe5+p/Lhe5RyZcT6s
         JheABDneul63s4likovC78/jDFkuGhrNsCKV8RaAGFJmx7SD/4a43gphblyCED+WoSf/
         IDGuySvCax50Ly9EmCBkPj7OD/HLAr4icm48yCeM+pcfho3OnhIJfq8z704KxCHCvzoa
         TRGw==
X-Gm-Message-State: AOAM531QLj+jlvvZzT6QM+s/f/DXT5dtwhIAr0ANKZxgvdWFG1tVGi5d
        9vlVMCl1PDD+Aq3SubamUPYLD+2aw1jesGGERsg=
X-Google-Smtp-Source: ABdhPJwT9LeVyo7ELrQjBzT9qys6P+zvjwFN9aeUKagYf2l52HMYPtsYyROhNZojg2Nz2hiPZjWF8nug0GwPDO5+IvQ=
X-Received: by 2002:a81:c648:: with SMTP id q8mr12154026ywj.518.1644817079052;
 Sun, 13 Feb 2022 21:37:59 -0800 (PST)
MIME-Version: 1.0
References: <20220212112713.577957-1-mailhol.vincent@wanadoo.fr> <20220212155733.gfwkcs7xcwlqzi6r@pengutronix.de>
In-Reply-To: <20220212155733.gfwkcs7xcwlqzi6r@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 14 Feb 2022 14:37:47 +0900
Message-ID: <CAMZ6Rq+sHpiw34ijPsmp7vbUpDtJwvVtdV7CvRZJsLixjAFfrg@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: change opened_channel_cnt's type from
 atomic_t to u8
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 13 Feb 2022 at 00:57, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 12.02.2022 20:27:13, Vincent Mailhol wrote:
> > The driver uses an atomic_t variable: es58x_device:opened_channel_cnt
> > to keep track of the number of opened channels in order to only
> > allocate memory for the URBs when this count changes from zero to one.
> >
> > While the intent was to prevent race conditions, the choice of an
> > atomic_t turns out to be a bad idea for several reasons:
> >
> >   - implementation is incorrect and fails to decrement
> >     opened_channel_cnt when the URB allocation fails as reported in
> >     [1].
> >
> >   - even if opened_channel_cnt were to be correctly decremented,
> >     atomic_t is insufficient to cover edge cases: there can be a race
> >     condition in which 1/ a first process fails to allocate URBs
> >     memory 2/ a second process enters es58x_open() before the first
> >     process does its cleanup and decrements opened_channed_cnt. In
> >     which case, the second process would successfully return despite
> >     the URBs memory not being allocated.
> >
> >   - actually, any kind of locking mechanism was useless here because
> >     it is redundant with the network stack big kernel lock
> >     (a.k.a. rtnl_lock) which is being hold by all the callers of
> >     net_device_ops:ndo_open() and net_device_ops:ndo_close(). c.f. the
> >     ASSERST_RTNL() calls in __dev_open() [2] and __dev_close_many()
> >     [3].
> >
> > The atmomic_t is thus replaced by a simple u8 type and the logic to
> > increment and decrement es58x_device:opened_channel_cnt is simplified
> > accordingly fixing the bug reported in [1]. We do not check again for
> > ASSERST_RTNL() as this is already done by the callers.
> >
> > [1] https://lore.kernel.org/linux-can/20220201140351.GA2548@kili/T/#u
> > [2] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1463
> > [3] https://elixir.bootlin.com/linux/v5.16/source/net/core/dev.c#L1541
> >
> > Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X
> > CAN USB interfaces")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>
> Applied to can/testing.
>
> I you (or someone else) wants to increase their patch count feel free to
> convert the other USB CAN drivers from atomic_t to u8, too.

Actually, not so many drivers are impacted:

| $ grep -R atomic_t drivers/net/can/
| drivers/net/can/c_can/c_can.h:  atomic_t sie_pending;
| drivers/net/can/usb/esd_usb2.c: atomic_t active_tx_jobs;
| drivers/net/can/usb/ems_usb.c:  atomic_t active_tx_urbs;
| drivers/net/can/usb/gs_usb.c:   atomic_t active_tx_urbs;
| drivers/net/can/usb/gs_usb.c:   atomic_t active_channels;
| drivers/net/can/usb/mcba_usb.c: atomic_t free_ctx_cnt;
| drivers/net/can/usb/usb_8dev.c: atomic_t active_tx_urbs;
| drivers/net/can/usb/peak_usb/pcan_usb_core.h:   atomic_t active_tx_urbs;
| drivers/net/can/usb/etas_es58x/es58x_core.h:    atomic_t tx_urbs_idle_cnt;
| drivers/net/can/usb/etas_es58x/es58x_core.c:    atomic_t *idle_cnt =
&es58x_dev->tx_urbs_idle_cnt;

The only relevant one seems to be the gs_usb with its atomic_t
active_channels. I looked at the code, the change to u8 shouldn’t
be too hard. But aside from that, I am also concerned by the
absence of an exit path in gs_can_open() to free the allocated
URB memory when an error occurs.

I will send a patch to change the active_channels from
atomic_t to u8, however, I will not rework the error path to
free the allocated URB memory.

Also, we need to double check that none of the drivers uses a
spinlock or mutex in their open() or close() functions. I gave it
a first glance and didn't find anything outstanding but I will
need to spend a bit of extra time on that to confirm.


Yours sincerely,
Vincent Mailhol
