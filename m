Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA63349E773
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243692AbiA0QZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243690AbiA0QZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FC0C061714;
        Thu, 27 Jan 2022 08:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A386FB803F6;
        Thu, 27 Jan 2022 16:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CA0C340E4;
        Thu, 27 Jan 2022 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643300719;
        bh=pF7kw3/tUBe2qDEKYIHJG6832skQUBXDz81kmFkASmU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YgdLtqSj23XX0RwAdGMAY7I407WAOdwoQZKruWIDxWfA+/9l9wkReNAXpYlehPN4e
         KyrPwxt0FAFxDvoJzWw0uL1yc7f3iYW0meqeGEQ+gxOw2L6RGwVP4s0TTN5N+TBn+u
         wd/lrfay21uml/TXhhF9loJsN5gP5/pBPrxmm6Kl3pRDl46+4KOR9//gWXIem7hV3s
         ivpMrbzjM4hd5uGCs10l0it8Mjd5xkV+7Ki9jznA8+tnHnWAm+i4Hh9Ick18fjdcx7
         To/qCYp203HUMUmizs9mEW3w64DSg5Ie6ZnxIte/t3eKGWpKZHgV7ItkHBqcr1yqFK
         J/WNvgCVVrEYw==
Date:   Thu, 27 Jan 2022 08:25:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: remove unused static inlines
Message-ID: <20220127082517.1b1bd7e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQ+nn4m8HWpBM0KNC5Z6tpc_QCLk0SjpYKWyQNfTCmLndA@mail.gmail.com>
References: <20220126185412.2776254-1-kuba@kernel.org>
        <61f22a5863695_57f03208a8@john.notmuch>
        <CAADnVQ+nn4m8HWpBM0KNC5Z6tpc_QCLk0SjpYKWyQNfTCmLndA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 21:22:03 -0800 Alexei Starovoitov wrote:
> On Wed, Jan 26, 2022 at 9:15 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Jakub Kicinski wrote:  
> > > Remove two dead stubs, sk_msg_clear_meta() was never
> > > used, use of xskq_cons_is_full() got replaced by
> > > xsk_tx_writeable() in v5.10.
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---  
> >
> > Acked-by: John Fastabend <john.fastabend@gmail.com>  
> 
> Applied.
> How did you find them?

regex and some bash:

for f in $(sed -n '/static inline [^(]*$/N;s@static inline.*[^_a-z0-9A-Z]\([_a-z0-9A-Z]*\)([a-z_].*@\1@p' $(find include/ -type f) ); do cnt=$(git grep $f | wc -l); [ $cnt -le 1 ] && echo $f >> single; done

takes too long to run to put it in a CI directly, unfortunately, 
more intelligence would be needed. Luckily there isn't that many
instances throughout netdev and bpf so perhaps not even worth 
the hassle.
