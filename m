Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30992276AF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgGUD0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGUD0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:26:04 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A363DC061794;
        Mon, 20 Jul 2020 20:26:04 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x62so15161571qtd.3;
        Mon, 20 Jul 2020 20:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfnGMyKYW+BUBT0er2/ds3h94uyXvk6uP4Na6Sd7dqM=;
        b=ZgGnhjHmN9X0QxRYGPySZ4XrjQkySTF9w/mrFp5Jk7IsNUf9wXbkQX5sm7kZvHwMyJ
         rDjh48MTvZEJulXUuE01aw2X9O3/0RKmFi3utnGSKfE7HgZxCdrDDrkX8PiEd8MGLkQi
         /ZWwi9cGHXPHwc/sGYv++lxmTLl67yHqgMXAGxKRfdIJHw4v3WaFrfGA/gU22FGrvK9u
         u+ZHRsctgayQto7BA2cBIJzYbeWhaYCW17KWAwNYcB6dZcuh6YS+TSDPrxFH/H3Op8RC
         sfYwe/9MnQBOv84jXL4ovN3PZ01lpO51UsehoapnyqmPd9zmWV1/dae2dlOznD9Rxl7P
         ACUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfnGMyKYW+BUBT0er2/ds3h94uyXvk6uP4Na6Sd7dqM=;
        b=CJQHepA2do727/HQ/bI8yZV3ZRgO+MAtSq2a9sE6hfAy1e4YrPAcnGlvweTsx9twAk
         YKvK60mj6gQ/xic7K0Sl4XDIfz8zLo3jcH9Q0cq2TpxWxxBeyeliOL6FGWwma6nTWtIE
         UFGT8+DpI4e7OuvnZh8n2fC2CjTgdn5bBv1579I8R7K7DFJDR+5b6y+6csZjDY22PFUd
         1V+sXoZhqziu/Nq8Zzwxo2B8Q5xJYyg6ANRLuLdo+8mlT/A0pHbLlKB6yREQWmHkTI17
         YLICw+tEMXfWrIvvK8TdGdQbazEBaPifkTsAnXRF6ZJzxHiWFVUxFi0yD2T3re16bRif
         DNdA==
X-Gm-Message-State: AOAM5327CnY3sPlPDgYK8PiSpOUxrMWJ6pm9oFNn4cXEQxAVhQyT7j6/
        x0pCBqXaFxdzNbTCIOiPerogCzLWqlzxMpUaS1ndbDnEu1A=
X-Google-Smtp-Source: ABdhPJwVup9ahUCuS5au2cnPlERX94DercWol9ASY1FYi6G7v1dnlDbbscj8P67iA+0+6uZhE9IPB+eGbrY3Yloi9wc=
X-Received: by 2002:ac8:2f7b:: with SMTP id k56mr27412775qta.239.1595301963949;
 Mon, 20 Jul 2020 20:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQHRfAC9me4hGA+=+wcOpx+TAzqS723-kr_Y_Ej8dnWHp2fTw@mail.gmail.com>
 <bf3dff0c9e2d4affa7044a882317144b@AcuMS.aculab.com>
In-Reply-To: <bf3dff0c9e2d4affa7044a882317144b@AcuMS.aculab.com>
From:   lebon zhou <lebon.zhou@gmail.com>
Date:   Tue, 21 Jul 2020 04:23:03 +0000
Message-ID: <CAEQHRfAE5pNCXko_HOamH-ffLe9fzSxvAh-yOnJe7OcPkFkV4A@mail.gmail.com>
Subject: [PATCH] Fix memory overwriting issue when copy an address to user space
To:     David Laight <David.Laight@aculab.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:12 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: lebon zhou
> > Sent: 20 July 2020 05:35
> > To: davem@davemloft.net; kuba@kernel.org
> > Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: [PATCH] Fix memory overwriting issue when copy an address to user space
> >
> > When application provided buffer size less than sockaddr_storage, then
> > kernel will overwrite some memory area which may cause memory corruption,
> > e.g.: in recvmsg case, let msg_name=malloc(8) and msg_namelen=8, then
> > usually application can call recvmsg successful but actually application
> > memory get corrupted.
>
> Where?
> The copy_to_user() uses the short length provided by the user.
> There is even a comment saying that if the address is truncated
> the length returned to the user is the full length.
>
> Maybe the application is reusing the msg without re-initialising
> it properly.

It is not related with copy_to_user(), it is about move_addr_to_user()
implementation itself,
there is comment /*After copying the data up to the limit the user
specifies...*/, but the fact
is when (ulen < klen), this function will copy more content to user
buffer over than user
specifies in @ulen, this will cause the user buffer to corrupt, this
patch fixes this issue.
