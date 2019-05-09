Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC818EAF
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfEIRIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 13:08:19 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45964 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfEIRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 13:08:18 -0400
Received: by mail-yw1-f68.google.com with SMTP id w18so2415282ywa.12
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b0YgvKc1FKSQAKutGz1ddhc/r2X8IBTSv/GN6Agiuaw=;
        b=bmwb3DlHojJ6cJWN0Lbib9/DWSxeXhrsrUZmjvTuFTURSqc+kdqjrUqFhZrGMQrXTf
         SIF+JQ2mQqJAcql/3oZXDKoHCO3JPGlNIktu7QItDDScfKNvKXUOPdqb8JOQJ+iRhtFw
         DPDtQwwrSfh8I2bD9q/vLao2y4mGS6nKrrgZ0J6A0Rr+o47K+v6uG+XgfG1tXjiAG9hm
         o4bElZC4QowVfr503Fuf1IR12+qHF5ezb777uvAIuOTyY5nky7438jwJs1Ac3ib0uLrC
         mb8LF+6SKchrqyHT1kPbKTskDv3YtW4kXVkvVXKQ0UNKkiknnOo3AOJoUaILcogKerST
         W6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b0YgvKc1FKSQAKutGz1ddhc/r2X8IBTSv/GN6Agiuaw=;
        b=CWAkm1j/VF5HbQuqVb0DxyNX7dHDi/B+oNBr0hY4AcL8cRouGej6FVzGuBVLrr2+TR
         ++wV6ykje69KHe7dUlk1aZGcs32hGD7uZFzteHmwy/kSyvQ708zQDmeAa177BmfhlN7i
         JgKKbL9wH13e2C6eLyOhDnkL9edkuLymeANy1TvvxmdAy1Vq/TA1fzCloPlpoSe2xMox
         G5FTGa9pRsyegDGb8FBXC92yMgAuma4K7Aq0ls9e3aAq9BA0gfOYdg76xFfH1nhg1a3E
         Wxfip+ukw1ZeljWlDEJcCeO9BMFBUzNgrNUcwETmGZABKyur2mNwIxBM6Xycu8gOgA49
         mGrQ==
X-Gm-Message-State: APjAAAXyUBD24yZ4REj8ljxaFW5Hg7DI3QybGMGeVdachGASbtoo2ncN
        u3ajH5X+GK3KrLwHZrW2OjMeHN3hewCvJwsZq3ysWQ==
X-Google-Smtp-Source: APXvYqwwTvLZb51ht4tMiqil24IKAfYfBO/yMm4bah85AOdD2cq4dvs705FdaZWYILhXZAWaU9S8cBQo9CWXWNGfOzU=
X-Received: by 2002:a0d:f346:: with SMTP id c67mr2840360ywf.37.1557421697775;
 Thu, 09 May 2019 10:08:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190508234614.7751-1-jakub.kicinski@netronome.com> <20190509.094619.2211366094183779478.davem@davemloft.net>
In-Reply-To: <20190509.094619.2211366094183779478.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 May 2019 10:08:05 -0700
Message-ID: <CANn89i+cL3KsFveBFr=aCorCPY4xovDF4ZCFXz9kF5B0qO37Cw@mail.gmail.com>
Subject: Re: [PATCH net] net/tcp: use deferred jump label for TCP acked data hook
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com, netdev <netdev@vger.kernel.org>,
        simon.horman@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 9:46 AM David Miller <davem@davemloft.net> wrote:
>
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed,  8 May 2019 16:46:14 -0700
>
> > User space can flip the clean_acked_data_enabled static branch
> > on and off with TLS offload when CONFIG_TLS_DEVICE is enabled.
> > jump_label.h suggests we use the delayed version in this case.
> >
> > Deferred branches now also don't take the branch mutex on
> > decrement, so we avoid potential locking issues.
> >
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>
>
> Eric, please review.

This looks fine (and nice), thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
