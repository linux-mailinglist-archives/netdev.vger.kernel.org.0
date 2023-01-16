Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2362566BB22
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjAPKDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjAPKDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:03:14 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBCE14EA3
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:03:14 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id t15so29668947ybq.4
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aGGp1jbEnlaRx03rdEtCV/ox9PDgavBR6B4c+u+w/DE=;
        b=AoFQrEeVJImfvfzz963yponPKBBC3hvPMuQ/rgS5KxPbHmx1H4FUpJ1RslCHqRWTFW
         wt4xfTycaxwEVPFPEwcUZRb+3bbIDjeSf30WKBBqsBcvBu5pVD7YHus6aESUqLBcGy1i
         Cmwp8nVIIrm6pwXQJH+YIapgp7eLXT+6KBFqg48T+UOIoGZdgpKGMcbdBxVnMTLPOZbV
         GY+1V8ntETvDAh2zZul9EcA5DNVZANIaZclYdOG5swQTtSM5vLUltpYDKwi6sDrrCzSA
         IMM8Tmb2pq4osxHVRa4qzYL9DAcT7gDKV4+vAUVpOpyte28XFvC+82X4K7BpSAhXODMf
         lGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGGp1jbEnlaRx03rdEtCV/ox9PDgavBR6B4c+u+w/DE=;
        b=OL8BQ6jPVrs+pkLBrh4IMURN+p7U7iqwkgVepQVetZg9RXvP4W324eywVQWcghSXV/
         3It2Jz4i+1LXFT3tmwEjd6nMulasEeyLjzoER/IOLyd0kUNUrG1k1z/U9ATA3msnTDgS
         DK/M6HWXixl4vS7kXmi6BaNu7jMS240fho4JDXUN2eAU7+pp3C3tjarquMPsZl/UfLnu
         sFyl0DQEB8ytKrRiKWi6FyIPAXNIXscN6un2PjGbEgj9JLYLbbJGBvgxR4WeThvxlRJ7
         7QANr1ccMy0QP8nnDrcM5T740YZZSnVrHa7FjqAvolExtUpg/budi3zQIRtJ3DSW6WoA
         5FpA==
X-Gm-Message-State: AFqh2krvM/mBVWEVp8IJbmFtWX4v0KzCHyqpuV4PbKyhft7QMeRyFE9u
        hBjQfSGwAoshLYE3NNaG4eoap+pLgr+JSzlAiFZCUg==
X-Google-Smtp-Source: AMrXdXvijUVK8/h+ttxa/vCRy+VHf5S7pXSALIizxXa8NjPtaoj6oxMzvCu1or4raw7T52xYWJh0j+G5QPRMsfdDgiQ=
X-Received: by 2002:a25:32d7:0:b0:7d5:dc31:81ed with SMTP id
 y206-20020a2532d7000000b007d5dc3181edmr762585yby.407.1673863393184; Mon, 16
 Jan 2023 02:03:13 -0800 (PST)
MIME-Version: 1.0
References: <20230113164849.4004848-1-edumazet@google.com> <871qny9f4l.fsf@intel.com>
In-Reply-To: <871qny9f4l.fsf@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 11:03:02 +0100
Message-ID: <CANn89iJUJpmeo+SHYbwitQ3A97Sm86P7Yi4TGdkquedxKiO_wQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 12:41 AM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi,
>
> From the commit message, I got the impression that only the one
> qdisc_synchronize() in taprio_destroy() would be needed.
>

This could be, but then why having hrtimer_cancel(&q->advance_timer);
in taprio_reset(), since it is already in taprio_destroy() ?
