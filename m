Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3E046363
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfFNPvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:51:46 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45526 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfFNPvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 11:51:46 -0400
Received: by mail-yw1-f68.google.com with SMTP id m16so1267585ywh.12
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rmSFmNkxkdutblBF4nfv/FPx6xLmobVG8p088ta4ck0=;
        b=iDPmhW5RgAGCEpcKLC3ltY+btEId/3FHt4RKDKod0xODrdjP/0RT109iLSVA56rgDq
         K6hK8Ngf7Y6R3I97clhiD7v+qg6XLSY0y0I3h5+hY+lvaPFVNyEozJXyehokPzib9Jti
         82LSMs8egVajPZvAS6YKDvhyN/W0NgYQyK4JIoQQFyY6o1YxbdkvL8/WRr8WzD6Be1CM
         qzHm7Tl+IKByNuCDKLWqAkNqCj1ff01GWm2FQUOQylhxP1Om9V/AAR3MPNMADjFSEBhx
         Lg6S5m+/YAAe0XBIO3oLlW0pKp3DgbIupu+U3qXcNCJLUE+5GvGn8n3upQjqEa1Wt4BD
         tMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rmSFmNkxkdutblBF4nfv/FPx6xLmobVG8p088ta4ck0=;
        b=bXVD7RJwZO1qTCimDfXjm9nxxSD4dbYt4x4lHZzgmiy3nO0/cFvUj7TanrtQgQ3L/J
         eHz1tPtkO2GZa5KDF0SCxH9cBibH/IvjwKBZmcrKP78hgkKUpD4UJROwDNQ2irhxM7Jf
         c2BZ/TeUYqQ8Zegj3uBC94rcFec0FvhgFdA5GzlmjDRCzfPWMPvWsrr4OhUlcDZElzPQ
         Dr/M6Dpl/bvvaLrSM/7ofH9xoOHGzHbiJXai5ZZOZ6jtLuBn81b7SliM6mWTOzwfK2gu
         o28J8+Ry7D46T8FZNafhWeL6BqcF5wThxXhZCnYC+avOnncKCM3S/HW+BB603AzSiq/r
         xD/g==
X-Gm-Message-State: APjAAAVwTIx/PRWUHkPWy13kwccqZtNI4hrzTyGtTe6DA9eC+GYbBhOo
        bZMjumblga4M9zRIfItmdYIXhQYOxPeoJ2D0bxZbwQ==
X-Google-Smtp-Source: APXvYqwWTd58Je8czU4JBtOH9SKl1U0nCrCgT6B26s4+OBGhGae+5cjR9z9bABLNUOUjCRdeStZI8eDUCIEY2PRMOCk=
X-Received: by 2002:a81:2e93:: with SMTP id u141mr40026081ywu.21.1560527504985;
 Fri, 14 Jun 2019 08:51:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
 <CANn89iKP2fQ6Tc0jBW_WdLq3kYQx7NsdVDB5S3y453T+6yp86g@mail.gmail.com> <dcae85a5-9782-ab4c-c079-1d06675ea4b7@akamai.com>
In-Reply-To: <dcae85a5-9782-ab4c-c079-1d06675ea4b7@akamai.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jun 2019 08:51:33 -0700
Message-ID: <CANn89iKUtN3gO1rndW-2yNsOZian4OngnLUxLWqfo4VRb73-kA@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Jason Baron <jbaron@akamai.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        David Miller <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 8:44 AM Jason Baron <jbaron@akamai.com> wrote:
>
>
>
>
> The inconsistencies coming from kernel version skew with some servers
> being on the old hash and some on the newer one? Or is there another
> source for the inconsistency you are referring to?
>

The servers still using the old crypto hash, and the new servers using
the new siphash,
will generate different fastopen cookies, even if fed with the same
key (shared secret
among all the server farm)
