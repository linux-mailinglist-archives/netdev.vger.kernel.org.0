Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541A520EEBE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730446AbgF3GqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730240AbgF3GqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:46:10 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1A6C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:46:10 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so21101710ljg.13
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=X9MGrfZtVO7eW1M5myYYf8xQwYxEzhP8JHPL+7M69ZU=;
        b=ZHLyh9ft8Ar/B8/fxQRdoihAS99G8WGmenIT+shRKEUc7PvIVYjhkIiQ7vs6SSMPVc
         IsS46BctWyJWCKCC3xx/tHEJwZ9nloMSbjyWBFC1nrUlmnboX/Xk6nO03nQkXUJxCfh4
         74COGcuRJLk3C0QKBJSAUYB4G7XWT/CtfGzvfmf8fuV/Xv1tOadJ+Mdf6F+NsNIe/+Og
         xoR633xFq4nFy2cPEwlZogJ114w1oDovLsOh7emOhh17WhfCGK9tZAbVpDT6sUPjsELC
         VKAU5SsZnhqJAeYpWqGgTt+rq1HN8fTcUpjnKIBSwzjdu+/oZ5ZWkC8T6pprwwixQLfU
         qnjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=X9MGrfZtVO7eW1M5myYYf8xQwYxEzhP8JHPL+7M69ZU=;
        b=mIdk7AYjTr6oKqt0e0zXJYQmcrrH9nZdNyV00Yl9KrCcUVu4JB4g64e2pY8fJf8JJL
         eW5OiPL7aN4JyGORbkQ3E4vebqbh6LPmnW9y2fm7qCuCR0o69Jb7e4WN8BY2PSdUMpWE
         jA2ahQRYuUYkoQIo9WvSzRu1yRaeYmlNggINyLWwMgkQMUFyzJ3ZuH+Gd2QQ3eA3xgZG
         swczkSFXqdbIBmpgzVu1ZCntmcv2FybSByImmg1clTI71O8cZJJAUdeK6qU4lSqMAlAj
         MZQyocqiWBNxDoZTd9/Qca2y59Ctpa9Y/SVsatRW7ouYaaiP7qngCpWctNZuxu7MlR6d
         GSkQ==
X-Gm-Message-State: AOAM533tX4H2pOBTPVHmFGo7EgkE8deyaMUxRKcoKoZFTbCxwK9QDrY5
        /3MNsBeUIFo6//pzKcDNRCQFj9g/1fw=
X-Google-Smtp-Source: ABdhPJwwyLbH6cpDaP/1kJvmZGptJeLbi1ZGPx+fUbw3qA5fTsVMGKDjC9jOGsIWX91OniHI0k9gjw==
X-Received: by 2002:a2e:95d3:: with SMTP id y19mr9195441ljh.60.1593499568087;
        Mon, 29 Jun 2020 23:46:08 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v20sm470940lfe.46.2020.06.29.23.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 23:46:07 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "David Miller" <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <fugang.duan@nxp.com>
Subject: Re: [PATCH net] net: ethernet: fec: prevent tx starvation under
 high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Tue, 30 Jun 2020 08:39:58 +0200
Message-Id: <C3U8BLV1WZ9R.1SDRQTA6XXRPB@wkz-x280>
In-Reply-To: <20200629.130731.932623918439489841.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon Jun 29, 2020 at 3:07 PM CEST, David Miller wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> Date: Mon, 29 Jun 2020 21:16:01 +0200
>
> > In the ISR, we poll the event register for the queues in need of
> > service and then enter polled mode. After this point, the event
> > register will never be read again until we exit polled mode.
> >=20
> > In a scenario where a UDP flow is routed back out through the same
> > interface, i.e. "router-on-a-stick" we'll typically only see an rx
> > queue event initially. Once we start to process the incoming flow
> > we'll be locked polled mode, but we'll never clean the tx rings since
> > that event is never caught.
> >=20
> > Eventually the netdev watchdog will trip, causing all buffers to be
> > dropped and then the process starts over again.
> >=20
> > By adding a poll of the active events at each NAPI call, we avoid the
> > starvation.
> >=20
> > Fixes: 4d494cdc92b3 ("net: fec: change data structure to support multiq=
ueue")
> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>
> I don't see how this can happen since you process the TX queue
> unconditionally every NAPI pass, regardless of what bits you see
> set in the IEVENT register.
>
> Or don't you? Oh, I see, you don't:
>
> for_each_set_bit(queue_id, &fep->work_tx, FEC_ENET_MAX_TX_QS) {
>
> That's the problem. Just unconditionally process the TX work regardless
> of what is in IEVENT. That whole ->tx_work member and the code that
> uses it can just be deleted. fec_enet_collect_events() can just return
> a boolean saying whether there is any RX or TX work at all.

Maybe Andy could chime in here, but I think the ->tx_work construction
is load bearing. It seems to me like that is the only thing stopping
us from trying to process non-existing queues on older versions of the
silicon which only has a single queue.
