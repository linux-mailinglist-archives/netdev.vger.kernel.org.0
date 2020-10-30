Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76B2A0F07
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgJ3UB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3UB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 16:01:58 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131E2C0613CF;
        Fri, 30 Oct 2020 13:01:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c20so6232212pfr.8;
        Fri, 30 Oct 2020 13:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1dUGsv5L8Yx4WdRQrViS7Xoa92fK64EgHaBplfQmptg=;
        b=oIKKfOgJcc1F1MKCz7xkeX4jAT5GxTHezJlW/wSufBFzUbD1z/6/jR7WAkKprooqLQ
         28FZBE91CUuIKQ+K1j9lCwnwMd6UFVe1YNKhr4sYEl8kXp+PVrrLKOCJHDp5SdkYVAM6
         Lyw8TYHvZWADvjyLn5qyO210fY+W2DxDszjtLrQJ8TLwfS8y0DnVuP/HHRkymfqvTHfn
         ZdVEn5LLmLHYGqfjLib+yMidNLqrEnCoBr/jeIzImmkZq3EWiLg5Awg6PFvRKfD+tPDm
         e6KiBxmR7vpa2nK89is7akxpFqC/1ePQSzDdLQMn3HZUEkkMmDMItkRKASx1hi1mrZSv
         1CaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1dUGsv5L8Yx4WdRQrViS7Xoa92fK64EgHaBplfQmptg=;
        b=BEalDqm07OErTTH8XOTAhDy/iHQexb3CFSJYYLgjJtpv1x0753/OZkRaH2SQM/YC3g
         Cwxvg1WCMzfDFEqfmiezTxoADj5CGqVW36bnI68LDaJV9hbcowqEIqcCcVzyzGY99hh/
         9Orm1+SfhkuxGpDET2WPtJczHkgUokucjvqcltPrvXsFbmQ/SHHTSFBBPEs1xw2ahcv8
         w4Bk5a43cihWWwIqxtsAoiNoFwPZFqKBYCP/3kVUTNH3kdqkacHGTP7dHvdF9PC48MSC
         4aEcEFqCql1AQnnwI3EM2nLkjxSJD253+cXf1hzUxA6KKnfpcvZuroqzgfF6ubbInwxo
         YOTw==
X-Gm-Message-State: AOAM530BFrFg0Xdhocs8FrKmF9fhuUDyjnKl1vkCAeLWyGzeWv2Q1JdO
        VKsaVOfwsY8w0aVvYjHKm6666kpTjQCOm9PwBrI=
X-Google-Smtp-Source: ABdhPJzMsp0Spz0J3/bvpKhI0/HNtpInc5afmAg0SzOs3QgWW5J9sP1zo3iaQ+MlqfWjuhcesIJHcq4FoyHZKnH90lw=
X-Received: by 2002:a17:90a:e615:: with SMTP id j21mr4890142pjy.66.1604088116548;
 Fri, 30 Oct 2020 13:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201030022839.438135-1-xie.he.0141@gmail.com>
 <20201030022839.438135-2-xie.he.0141@gmail.com> <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
In-Reply-To: <CA+FuTSdeP7n1eQU2L2qSCEdJVc=Ezs+PvCof+YJfDjiEFZeH_w@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 30 Oct 2020 13:01:45 -0700
Message-ID: <CAJht_EMdbGQdXhYJ7xa_R-j-73fbsEjSUeavov40W52aGvQ21g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 9:35 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> In general we try to avoid changing counter behavior like that, as
> existing users
> may depend on current behavior, e.g., in dashboards or automated monitoring.
>
> I don't know how realistic that is in this specific case, no strong
> objections. Use
> good judgment.

Originally this function only increases stats.rx_dropped only when
there's a memory squeeze. I don't know the specification for the
meaning of stats.rx_dropped, but as I understand it indicates a frame
is dropped. This is why I wanted to increase it whenever we drop a
frame.

Originally this function drops a frame silently if the PVC virtual
device that corresponds to the DLCI number and the protocol type
doesn't exist. I think we may at least need some way to note this.
Originally this function drops a frame with a kernel info message
printed if the protocol type is not supported. I think this is a bad
way because if the other end continuously sends us a lot of frames
with unsupported protocol types, our kernel message log will be
overwhelmed.

I don't know how important it is to keep backwards compatibility. I
usually don't consider this too much. But I can drop this change if we
really want to keep the counter behavior unchanged. I think changing
it is better if we don't consider backwards compatibility.
