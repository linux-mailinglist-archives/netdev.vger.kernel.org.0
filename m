Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0ADE650C
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 20:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfJ0TRa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Oct 2019 15:17:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfJ0TR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 15:17:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8280614BE8BB7;
        Sun, 27 Oct 2019 12:17:28 -0700 (PDT)
Date:   Sun, 27 Oct 2019 12:17:27 -0700 (PDT)
Message-Id: <20191027.121727.1776345635168200501.davem@davemloft.net>
To:     toke@redhat.com
Cc:     toshiaki.makita1@gmail.com, john.fastabend@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, jakub.kicinski@netronome.com,
        hawk@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, pshelar@ovn.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, u9012063@gmail.com, sdf@fomichev.me
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87wocqrz2v.fsf@toke.dk>
References: <87h840oese.fsf@toke.dk>
        <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
        <87wocqrz2v.fsf@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 27 Oct 2019 12:17:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Sun, 27 Oct 2019 16:24:24 +0100

> The results in the paper also shows somewhat disappointing performance
> for the eBPF implementation, but that is not too surprising given that
> it's implemented as a TC eBPF hook, not an XDP program. I seem to recall
> that this was also one of the things puzzling to me back when this was
> presented...

Also, no attempt was made to dyanamically optimize the data structures
and code generated in response to features actually used.

That's the big error.

The full OVS key is huge, OVS is really quite a monster.

But people don't use the entire key, nor do they use the totality of
the data paths.

So just doing a 1-to-1 translation of the OVS datapath into BPF makes
absolutely no sense whatsoever and it is guaranteed to have worse
performance.
