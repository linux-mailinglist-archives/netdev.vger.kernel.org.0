Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B70561F04
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbiF3PRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiF3PRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:17:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB01C31DEC;
        Thu, 30 Jun 2022 08:17:37 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id pk21so39709593ejb.2;
        Thu, 30 Jun 2022 08:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/i5OyXrdHIl03uJMvczX531K/3M39oSh861kA9eYkbU=;
        b=aUnaDEQf/6DZiB9+2W4JNMnceVSAaQP7P20qDaIlYU2rIgQd30pZyBI6JIDqFCXbQT
         vocFA2dds+c2iYSC2f6DEc3scWLcnYg/SOVK8wY2xZFqSwCVI/yA2xxj35Q5P7QtLFng
         ucHahq3keTH8wpoKTw23IaNHyTsk5TE2HMSiFGDuHUkaH3uB1vdtsfO6q7tGCe/nwB3E
         OseqyINdZv01zFtHRxOHMZhbOzneyJycUpWgxEzx2fPBTjbMtiZgS5zaB3ec/WHv4suM
         7OD4FaSoA3XafBUR2QRUNH2ncTdRB6oN+7eUs+kgdaoIKUJtMnqOiIYBEG1cIpwouPaA
         F4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/i5OyXrdHIl03uJMvczX531K/3M39oSh861kA9eYkbU=;
        b=vE/NdBlQoMo/34URFcm3PaIcnFdG2OSSP+jBFapIOsjk2fYm88DbEPQySc59Buc2tB
         vOOPUJvv85SMz/dSyLlDUu/FjNfiJnPOzdYcnJ9w4Ufv9NqunUI+kQvmfzcXZzQ6jlk4
         koGjny5LIVu6ZQvVnva+aGQDGDaN0WYWD5z5hmJ8JGuYL2+Zc3Az9V2cHdKlEFUnIeOP
         8NnX76k0I14RrTzFMk7j6dvh83hquMFZaksHdztoIuw3nOjbxPOKShX2+LvtPQQM3yER
         FnTVI0I23PeUUwTEjwJn1H0Aum6Tn0e2xRZR10oJukNV6h9QIViUkxb9ZUrqpYMtGToG
         fPow==
X-Gm-Message-State: AJIora8dJv7bu+jKdC10I5rFxej/mcAoAPvYsBHuFdvwntmEXtHeIj6d
        UGG83cqGcoW6MTyKcNMCREUpBMPoQB0tnTyI5bs=
X-Google-Smtp-Source: AGRyM1tvD9r7R4DWPYKzvMjniTP8BJWTjA3b1PCNh5lkp3ELl7rkW3gZcKAFb2vPPOb58pKNUph5HCPHGh8p2YQF/DA=
X-Received: by 2002:a17:907:16a6:b0:726:574d:d31f with SMTP id
 hc38-20020a17090716a600b00726574dd31fmr9240954ejc.514.1656602256279; Thu, 30
 Jun 2022 08:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220629085836.18042-1-fmdefrancesco@gmail.com> <Yr12jl1nEqqVI3TT@boxer>
In-Reply-To: <Yr12jl1nEqqVI3TT@boxer>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 30 Jun 2022 08:17:24 -0700
Message-ID: <CAKgT0UfGM8nCZnnYjWPKT+JXOwVJx1xj6n7ssGi41vH4GrUy0Q@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ixgbe: Use kmap_local_page in ixgbe_check_lbtest_frame()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 3:10 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Jun 29, 2022 at 10:58:36AM +0200, Fabio M. De Francesco wrote:
> > The use of kmap() is being deprecated in favor of kmap_local_page().
> >
> > With kmap_local_page(), the mapping is per thread, CPU local and not
> > globally visible. Furthermore, the mapping can be acquired from any context
> > (including interrupts).
> >
> > Therefore, use kmap_local_page() in ixgbe_check_lbtest_frame() because
> > this mapping is per thread, CPU local, and not globally visible.
>
> Hi,
>
> I'd like to ask why kmap was there in the first place and not plain
> page_address() ?
>
> Alex?

The page_address function only works on architectures that have access
to all of physical memory via virtual memory addresses. The kmap
function is meant to take care of highmem which will need to be mapped
before it can be accessed.

For non-highmem pages kmap just calls the page_address function.
https://elixir.bootlin.com/linux/latest/source/include/linux/highmem-internal.h#L40

Thanks,

- Alex
