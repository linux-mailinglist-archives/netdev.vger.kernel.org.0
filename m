Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B379CB2547
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 20:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389820AbfIMSlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 14:41:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37610 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387802AbfIMSlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 14:41:03 -0400
Received: by mail-qt1-f196.google.com with SMTP id g13so34692056qtj.4
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 11:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wh+w7HgX9nxjLf4671PMhWCJkWLAHupq957XQXqNUtA=;
        b=BZiDbSsw1XvrB3P9xalp77dpfyUiY8QY/+O1x2sf67xF4ArvzKU+DJUQE9s4k9CtW6
         KHj7qyHll/la1Ol5bWDW9itSgzI3Q7ZCwkJOPK4vqAh4v8l86e4rg+CSraqv7z2ivVfX
         ++gqIgD6AQsqFFjqXVn3xeWjLfSXUOdqCkUJRWP2fTWGKzwbEVYPJKNK1EhFLUG/LGlm
         zrNFK8LU9yPE8LzAcumDv3ihyMdpzYPFtBC+6+CO7xnZ6nluhLJW633X93zNR/oYZI2x
         0NRfStCGluhmZsQdsalpTV5FkJh6gMATHzj6Igl7TzRa2Mccyi1e9/GPsZ9W3CcsRLIv
         vzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wh+w7HgX9nxjLf4671PMhWCJkWLAHupq957XQXqNUtA=;
        b=ozFmtbVqAd3+RxBzCpSKND2v9iWjVSpqA3aXbn9Uxj7uyUyYQEybEpUDvq0sVhiXNE
         ng2g160Pc3Lgy+IwQdwfZxNOA/pHaeoYtPsW2Bj0b929ABC5yMqntKcS3f2dZJl9z7EW
         rOFl5jRAT2kFNznMI4Y/1o9nrhpcAxFPRa5KVmBq9T42iNMfQgijS2u8Ird8C1QC2Jso
         vxP0PpcrymsF3VvCjQFy7hCF9PGFs/h9asjV3FFm0BY9pCC7+nibb1jKjO33h+mH8w2r
         5D+NhOeRJKItfi41RJbszrkYQvG7pw3Rv2uS5maddNm98OVGReEFaRJptoNTI+9ZU7XE
         NIAA==
X-Gm-Message-State: APjAAAWVs+1E6LsBs8ZwBYUG3b+53H+EbSexwDrH1YhcmmSrTrHp8pmc
        LeDQbEVglOdWByNVasdlsQxmMRNGvRHVEj+esedKLw==
X-Google-Smtp-Source: APXvYqxOWLdbCMRQE/FUYPQjzBl2tDZ6VKNCufOP85RsUty8AG+Lbc4hZOAo9Js/YemzjZ/4IozHJdDriODRCLFsnsE=
X-Received: by 2002:ac8:1e1a:: with SMTP id n26mr4782786qtl.357.1568400062373;
 Fri, 13 Sep 2019 11:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20190913011639.55895-1-willemdebruijn.kernel@gmail.com>
From:   Craig Gallek <kraig@google.com>
Date:   Fri, 13 Sep 2019 14:40:51 -0400
Message-ID: <CAEfhGiyMC18_46PyxCQ2GTpaRZ2qbJwtZ0AGaSa3rj3HMO-P1A@mail.gmail.com>
Subject: Re: [PATCH net] udp: correct reuseport selection with connected sockets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, zabele@comcast.net,
        Paolo Abeni <pabeni@redhat.com>, mark.keaton@raytheon.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 9:16 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> UDP reuseport groups can hold a mix unconnected and connected sockets.
> Ensure that connections only receive all traffic to their 4-tuple.
>
> Fast reuseport returns on the first reuseport match on the assumption
> that all matches are equal. Only if connections are present, return to
> the previous behavior of scoring all sockets.
>
> Record if connections are present and if so (1) treat such connected
> sockets as an independent match from the group, (2) only return
> 2-tuple matches from reuseport and (3) do not return on the first
> 2-tuple reuseport match to allow for a higher scoring match later.
>
> New field has_conns is set without locks. No other fields in the
> bitmap are modified at runtime and the field is only ever set
> unconditionally, so an RMW cannot miss a change.
>
> Fixes: e32ea7e74727 ("soreuseport: fast reuseport UDP socket selection")
> Link: http://lkml.kernel.org/r/CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Slick, no additional cost for the BPF case and just a single branch
for the unconnected udp, tcp listener case!

Acked-by: Craig Gallek <kraig@google.com>
