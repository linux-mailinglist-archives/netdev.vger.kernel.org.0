Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712C7ABCAF
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405777AbfIFPhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:37:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37465 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404930AbfIFPhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:37:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id r195so7614373wme.2
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 08:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AnKf/b8ee3mcAVBO1c6RnVhhFNnCiIgdGoebUkrMPHw=;
        b=cpyKrOrAp86fXvUem/SwUx/ci5f3UWAbcADuzo5XRFv2NxWNOwih5oxTAmXeewdsoo
         5aUbqqKdAQ1A7gVyb4CROVViH3fh7Rxm8FQ1xxUEpCub+TMPnLDUh896l5nrXCYRa824
         QyWa51NTLVAQF5tdB3y2aap0qcP2tFagdNIx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AnKf/b8ee3mcAVBO1c6RnVhhFNnCiIgdGoebUkrMPHw=;
        b=MdAaat0TfVVwd1TH/MBG7IRIXDoLVffCYCxupcxpAx7OBzER+amHcInOejXF1qaeym
         R6KfPeD+SH8IVJ/XIkiArPE31Awah8xlhc+S85BJgDGXDp+JFE/MXztHCmwhv1QSG745
         JNyH1Nsj/z+Tv+ZVXpO4J2joozZ1QxeIyDpTx3t/T6dvxKnJSnbFrlBcPfgvJGXWhBud
         LsLykfs7Q8GV0WqDrhY9nfDfbi17RMl0ncma5/DklZLi5QilSPKRPZQqZPu5tgcma9zb
         BAT2HiySKqI8Tq20BYZO69MEjhJFaaYtyRxFlVAouBBTIyRHtVm+N9AthXM7sIULq7/N
         R92A==
X-Gm-Message-State: APjAAAWo+UVY24I52OoyBwkzKgzQVQ7pWv90aB+Id4O6U/xsACBN+kbm
        /noYf16g7puAIcbBxXMhJyhewA==
X-Google-Smtp-Source: APXvYqwNeBDemGAupkBrwZ3cL+VpkGLAVMGcUD/WjAQMWaBUjLbTfTXophz8coDKGG0HHx17nIcMkQ==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr8166477wml.169.1567784230439;
        Fri, 06 Sep 2019 08:37:10 -0700 (PDT)
Received: from pixies ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id r9sm9006432wra.19.2019.09.06.08.37.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Sep 2019 08:37:09 -0700 (PDT)
Date:   Fri, 6 Sep 2019 18:37:07 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
Message-ID: <20190906183707.3eaacd79@pixies>
In-Reply-To: <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
        <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
        <20190906094744.345d9442@pixies>
        <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Sep 2019 10:49:55 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> But I wonder whether it is a given that head_skb has headlen.

This is what I observed for GRO packets that do have headlen frag_list
members: the 'head_skb' itself had a headlen too, and its head was
built using the original gso_size (similar to the frag_list members).

Maybe Eric can comment better.

> Btw, it seems slightly odd to me tot test head_frag before testing
> headlen in the v2 patch.

Requested by Alexander. I'm fine either way.

Thanks
Shmulik
