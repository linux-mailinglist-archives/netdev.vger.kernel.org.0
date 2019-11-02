Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA911ECFDF
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 18:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbfKBRMD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 13:12:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51174 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfKBRMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 13:12:03 -0400
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 287A24E92A
        for <netdev@vger.kernel.org>; Sat,  2 Nov 2019 17:12:03 +0000 (UTC)
Received: by mail-ot1-f69.google.com with SMTP id 88so7985178ots.1
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 10:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zl9fDks+mlVguzbhaExkNR5P4dBXCVz91rnRw1qkYoM=;
        b=cC2i79j4gBuUP99KLV80nG8PTG1ceYNbVULOn8bRVGhIEHuzoLYKD7/YgSUmzKyfpl
         0ffqlbvkAkOpRDaJOgQ7sSGooRzEDpvdZXSVsTyKHbL+YNPe1LdX1xC7QoS8NjOlJcw8
         VN1HKxjk0f8oUMpICb+21pYbYUHmpwANs+qxtSQGvjiUt2+zidTyPJJBMeD4ncsvUfa3
         sF+tvfsLfyj8WXuJj2mxGPhuEjKPLzDvr786d3NfAaxQyYoOd4HNuatD/ZGKQDs94kUp
         UAD3DKY4o1+X/caefTNfLj2JPlmOqs/Yafh6ky7aJr+dMjjT52QLQoNe2seT1zsorscj
         LagA==
X-Gm-Message-State: APjAAAWuUf3bWWpUwiJ0dgmAO603q/Xq1vVVfwPqHHgemGiUMZDIB/qq
        PpK9MQNj3DKp3yHTl3mmL3YKYTx64injR7RNjAyzm+Vmq3O8BAdZj/1UjeUZnYb1gZwCDBK3gNw
        UvomkoIENIjRWowIZqFLAZKpzKMsbNKYl
X-Received: by 2002:aca:b03:: with SMTP id 3mr8429421oil.24.1572714722651;
        Sat, 02 Nov 2019 10:12:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzBeIHHDezjGUM47ip6RrosGeU264dgnNDsmFABP4CYUabIN4mVl/m2b8xL3KrISyeUZ+KMCTs+c2qfLxq5oBI=
X-Received: by 2002:aca:b03:: with SMTP id 3mr8429400oil.24.1572714722376;
 Sat, 02 Nov 2019 10:12:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191031064741.4567-1-christophe.jaillet@wanadoo.fr>
 <c7a0b6b0-96cd-1fd3-3d98-94a3692bda38@cogentembedded.com> <1b33ca33-a02b-1923-cbee-814e520b9700@wanadoo.fr>
In-Reply-To: <1b33ca33-a02b-1923-cbee-814e520b9700@wanadoo.fr>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Sat, 2 Nov 2019 18:11:50 +0100
Message-ID: <CAGxU2F5wS9VnNu5ETFbbFcyaCx+UPD9jqjBPVp_rKKZ0-am1tQ@mail.gmail.com>
Subject: Re: [PATCH] vsock: Simplify '__vsock_release()'
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>, sunilmut@microsoft.com,
        Willem de Bruijn <willemb@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ytht.net@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, tglx@linutronix.de,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 10:49 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 31/10/2019 à 10:36, Sergei Shtylyov a écrit :
> > Hello!
> >
> > On 31.10.2019 9:47, Christophe JAILLET wrote:
> >
> >> Use '__skb_queue_purge()' instead of re-implementing it.
> >
> >    In don't see that double underscore below...
> This is a typo in the commit message.
>
> There is no need for __ because skb_dequeue was used.
>
> Could you fix it directly in the commit message (preferred solution for
> me) or should I send a V2?
>

I think is better if you send a v2 fixing this and including the R-b tags.
My R-b stays with that fixed :-)

Thanks,
Stefano
