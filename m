Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2EFDE19D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfJUAvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:51:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39591 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfJUAvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:51:50 -0400
Received: by mail-qt1-f193.google.com with SMTP id t8so808442qtc.6;
        Sun, 20 Oct 2019 17:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10Dm177ZDhI3P55sy48A8XPpM+UskdZhqRH8mUYgQDM=;
        b=cryspLkUgMwuLEUSIqpSYCyIDDd7hWef3QX/zVGmPgUBdC1wZsFEp3+xoXUHsX3zG3
         ByR1Td0/gKIyf8cBcESR1DdhEptbrbQ36bZoDPcmyQ/ibIKLTr2OTVsEFOOa2XGhoEeE
         IPING4PQEPXYKl06AdgNxH0J3pyg6uZH1V0slgZh4fkhAtRJRogCKo24R5C7X5ZG+qUk
         so72KosL3PRdW90BNa4UPyzo1hWOuMjSeXZ95eXcAMABHzMgk55iEhLOSlP/DddfJn1i
         sVDz/T7G69tfsTNl8TT4e+HXsHA/K9ZbApWd0Ygk7B6ECpU5g8/XJY+4S7e+eIN7QwWc
         H/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=10Dm177ZDhI3P55sy48A8XPpM+UskdZhqRH8mUYgQDM=;
        b=lsgvS6OgDIsVHQrIgEmuhE0nAZw3JmceJ4u62WtYDcnNh9Sr68gDot2j2xsSI1HREG
         tJB7ROZpeMzdanB6vpiWQvDFvIfUMgY33sKUKhZj43FOSUb+8987uSgQ250Cy1/EV/9A
         75uBg7Yf8Bb1Jf6NurwdbrEVOXeN6gTb/JkvrW7S/SU6k3k2ppDl+LbBjEEUT65lr8Si
         XJCVadWo6sSmadGmrSQnGz+1DxjE4eCuyhw9rRu5KjijHpk6uvogVTiiCxjcfzPlzfa4
         bKxGU9E5gz73vstvLc5ljYi/3xAvPp8CvgWCanHiVtHgXUDicIQIELAQDLxRihRTt+aC
         uGAg==
X-Gm-Message-State: APjAAAVMbttwnYSg7dxZp4zy/uj90wXbzJPqrSdLfBsFPuo/OFY+TKnu
        H4Bt1hUWHxeCXHYgw2n8Lz4cefRaojesDXqyDuE=
X-Google-Smtp-Source: APXvYqzRaohYYn8y7+WX+b2yLD1acBiHN+DkLnkzD9+1cP/YUERNFdEoalRdJ0Ag+oN0vFIQ2vxtW3EzKgspOH35Hbs=
X-Received: by 2002:ac8:379d:: with SMTP id d29mr20981832qtc.93.1571619108740;
 Sun, 20 Oct 2019 17:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20191020112344.19395-1-jakub@cloudflare.com>
In-Reply-To: <20191020112344.19395-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 20 Oct 2019 17:51:37 -0700
Message-ID: <CAEf4Bzap3PxBuwm+Ew+hgm0bEHa4W0ZhoLTMeo04qW1w=NZSEw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] scripts/bpf: Print an error when known types
 list needs updating
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 4:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Don't generate a broken bpf_helper_defs.h header if the helper script needs
> updating because it doesn't recognize a newly added type. Instead print an
> error that explains why the build is failing, clean up the partially
> generated header and stop.
>
> v1->v2:
> - Switched from temporary file to .DELETE_ON_ERROR.
>
> Fixes: 456a513bb5d4 ("scripts/bpf: Emit an #error directive known types list needs updating")
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

LGTM, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  scripts/bpf_helpers_doc.py | 4 ++--
>  tools/lib/bpf/Makefile     | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)
>

[...]
