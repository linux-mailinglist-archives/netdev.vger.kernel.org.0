Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D05847204
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFOUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:25:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34097 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:25:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so3476455pfc.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 13:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fTWgvB8I+HVGjWoTHEhKJ/+zcG7F0gFzWP79C5G4/0M=;
        b=GsKVoDsQqMfOmpjUk+NOWe4YzlSNKiLGGs6QaVWJ/Vk1rx2V4AN+ohcgmGDJBOlqiF
         mWWLZsS0C0SUxLs4RkCm6NCn6Ayifck54ZN9/RlF14trxAMwQ5l7t1a9gVH7DKOXv174
         pyPo1UCwPQEffC5uv/YZpm+rp7DnXuG4/3YD/SDoVeS6gO/y3l6rV+p9QgaDnWSEyZ15
         Q7hqBYiE3gxZoog1IKKtGv7J3ZVbPiAif6ClRdu2nPt1CypxJG4gdg2k8GhBWGgHf/dI
         JwE/vWVTV42n7MtKf6e4U5bRZIgjcFLqhLlnMMXmhDRtUPdARKp6PtfNI6yMOVdQA9S3
         VJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fTWgvB8I+HVGjWoTHEhKJ/+zcG7F0gFzWP79C5G4/0M=;
        b=l127jlBv5kgkx791ktASsIwUok1mhhhQ30wCCKi9lnaQe9KKmLHSr8o6rj6CdJPGqU
         X6nEmmUx0xr67D/6qcYREWUWqkj/dzyKL+003Tx52Woz3NTT37055QptFOUmKzSuGD/K
         6IHrH7YLltkR1vJhTx0lmHuFcuA15IUQnbB+/hHibhWPbo+n2ukwva8oU2zeimfZ/GtO
         5k0fPHexwxS6cs3T2Ey854Ruu4YeDhtoIQvHui9BTLiEI8u88iiqwmjX2BVr022NCQwl
         wJKvjNSAZWsm7rUU59kJZuDLrrUnP9KMv3BgW9FiG2lBeStWnAIOLR7TvZHyNhhsJfbR
         HvUQ==
X-Gm-Message-State: APjAAAXbfJ0tamxnyYW11iBzyL9v0OSa9654/BJ6gN4/cuMQ0Kcm2Mlr
        Wq4DkrLLecg0mFL42A7y+YBoLQ==
X-Google-Smtp-Source: APXvYqzIJgWGNgUSSnX7qpz8eKoDaWAzt9luC4Y9DHsMPkxpqFdjMylVnwAeZcZirg84lwiW75gENg==
X-Received: by 2002:a65:5347:: with SMTP id w7mr41597040pgr.375.1560630311386;
        Sat, 15 Jun 2019 13:25:11 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id c26sm5375170pfr.71.2019.06.15.13.25.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 13:25:11 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:25:07 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, edumazet@google.com, posk@google.com
Subject: Re: [PATCH net] net: netem: fix use after free and double free with
 packet corruption
Message-ID: <20190615132507.49589073@cakuba.netronome.com>
In-Reply-To: <20190614.190808.2204923376726716417.davem@davemloft.net>
References: <20190612185121.4175-1-jakub.kicinski@netronome.com>
        <20190614.190808.2204923376726716417.davem@davemloft.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 19:08:08 -0700 (PDT), David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed, 12 Jun 2019 11:51:21 -0700
>=20
> > Brendan reports that the use of netem's packet corruption capability
> > leads to strange crashes.  This seems to be caused by
> > commit d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> > which uses skb->next pointer to construct a fast-path queue of
> > in-order skbs.
> >=20
> > Packet corruption code has to invoke skb_gso_segment() in case
> > of skbs in need of GSO.  skb_gso_segment() returns a list of
> > skbs.  If next pointers of the skbs on that list do not get cleared
> > fast path list goes into the weeds and tries to access the next
> > segment skb multiple times.
> >=20
> > Reported-by: Brendan Galloway <brendan.galloway@netronome.com>
> > Fixes: d66280b12bd7 ("net: netem: use a list in addition to rbtree")
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com> =20
>=20
> Please rework the commit message a bit to make things cleared, your
> ascii diagrams would be great. :)

In process of rewriting the commit message I found a memory leak,
and the backlog accounting is also buggy in the segmentation path

qdisc netem 8001: root refcnt 64 limit 100 delay 19us corrupt 1%
 Sent 30237896 bytes 19895 pkt (dropped 1885, overlimits 0 requeues 287)
 backlog 0b 99p requeues 287
         ^^^^^^
         99 packets but 0 bytes

I need an internal review, and will repost soon.  I need to stop looking
for bugs here =F0=9F=99=88
