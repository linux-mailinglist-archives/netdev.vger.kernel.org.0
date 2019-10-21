Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589B6DF587
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbfJUTBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:01:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43498 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729839AbfJUTBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:01:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id 21so2041539lft.10
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 12:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PLOcZ03vS2EwYkFJj8DRoXWrjJmTGUnZtnTzndssys4=;
        b=XSrQi1vIm6ZFvXVRDwjxjlYFZBuGk6dczFvD8d2rnmL8q8A5UYHDLKiCZQ2Llm4fIM
         d9nFK/VVOyJKOa1ZRlqnOgXlUme68evtUG2Eq20ZqfZ9N3RQOnDdyi0Gla3vcDlC7IzV
         6ojlHpjsTyElAC3AovaNCWMxCdTw+UsHzERuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PLOcZ03vS2EwYkFJj8DRoXWrjJmTGUnZtnTzndssys4=;
        b=neGGWMV9SPAdz7gfgu7Sr+Wmg52lpe70Hw5ruJE5iT7gSMsL1k56Nh3/lXP3Nqi5xO
         NIBn/VrSX+jtJGeu/aAXePGITr4aRjXdmsUiIEU6Zd0crWwNF2/z+nMwkk9eL0gb5xQK
         XfDvSKwHxetZ13w0AoyaSgF4hGVDq2BEiuNAwMhoFYuBf33XBgbl1fBvjwXbRHjEVICU
         UQ52l5GmLqKW9gmXNk4Lf3jQOOGaD2Y+q7mf684OMNhBvb8X7FnRmC+3ZwzRhl9MeEbl
         vgJViLxnLhLZAqD/N1LZDNS3K6T0ZVPslhtwAAzdDCNCDlIRMP7Eb7TZCjw2EsLuLHMV
         oI3g==
X-Gm-Message-State: APjAAAVF0tJ/aM6L402EQKczIIta0u10hvQm8Ic3i42jX9Sy11Ew+D2o
        R/6V9UwAQPHREofbOUtdYUJ2BA==
X-Google-Smtp-Source: APXvYqzA4yZnkeOQZqaobJL8WRSpadsYX3l+ahOhwgyEZK7fcdaoJbDqbV7TVda5soiN2pat/pzsVQ==
X-Received: by 2002:ac2:55b4:: with SMTP id y20mr16013272lfg.173.1571684508959;
        Mon, 21 Oct 2019 12:01:48 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q16sm6847947lfb.74.2019.10.21.12.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 12:01:48 -0700 (PDT)
References: <20191021165744.2116648-1-andriin@fb.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a variable declaration
In-reply-to: <20191021165744.2116648-1-andriin@fb.com>
Date:   Mon, 21 Oct 2019 21:01:47 +0200
Message-ID: <87mudtdisk.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 06:57 PM CEST, Andrii Nakryiko wrote:
> LIBBPF_OPTS is implemented as a mix of field declaration and memset
> + assignment. This makes it neither variable declaration nor purely
> statements, which is a problem, because you can't mix it with either
> other variable declarations nor other function statements, because C90
> compiler mode emits warning on mixing all that together.
>
> This patch changes LIBBPF_OPTS into a strictly declaration of variable
> and solves this problem, as can be seen in case of bpftool, which
> previously would emit compiler warning, if done this way (LIBBPF_OPTS as
> part of function variables declaration block).
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Just a suggestion - macro helpers like this usually have DECLARE in
their name. At least in the kernel. For instance DECLARE_COMPLETION.

-Jakub
