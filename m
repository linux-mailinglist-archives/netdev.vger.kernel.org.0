Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEBB83E40
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfHGAXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:23:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39507 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfHGAXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:23:41 -0400
Received: by mail-lj1-f193.google.com with SMTP id v18so83709485ljh.6;
        Tue, 06 Aug 2019 17:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jgw5XL6Jgb9sIk37/4bnAwBoJ06VkKSpglKUxVGiVY=;
        b=N/vOi6tQWtSa4fZlL3F+40Kr7Xf0sYl6Q6p9uCxFxnOFsp1trDKakl+3pHN4qOs7Tk
         JnRXbIzU7HE5o0Fh1strGq1dmOCqkKhopwspverw9ucgg8UDY13m7qo2QrGOvAyyaDGC
         SR5FnHwSxdcqeDgc1/dOxo0cRpEGGcADfrEjhjV3wgK4bcQ8kUevU9IYwTdmWRSsFMvt
         yPV+eB6kjlQmX9FD8J+hMmhXVFZfgFuT1sqKC+N+B2FGYuH+GpCkSzjbJNLR6wK/TjG3
         le5MJtgqcIJ8QeGQ21tPQ7cyIAVeHGV587OUtej4m5pmtZklXlS/YNf3dXct3i7XrGJU
         MeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jgw5XL6Jgb9sIk37/4bnAwBoJ06VkKSpglKUxVGiVY=;
        b=nwd7RWXUbr30D+vEMnOFNUfdrG1FkEmDrDr4zk/bkbTWBpsiFJXRpGfELwyXV6xoIM
         FXBRE3EPqYH2Mpe/GSbI7uUIuY53jgjK9zMu1ML7SliPz1YxHrt2+bAS8fXR+emCFEGC
         QXHo/82lSBvvX8zgaowhZdryw49NH+p/uB4AkSRx64xnW1Ml6KQjH0DlDruwrE1ojQoy
         0ZpEHcOLOSf7Sxp5lPbzaUL3pCpYvxSWzAOOObRHQT2/g8psB6kB4B9GSy6gJZQC04bG
         B19Lk0KaNIqII8eVGHkS048rbsLYCiy9WV9g63+zkAQwKhYEUyY9z4VGFyRIOrsUG44m
         27vg==
X-Gm-Message-State: APjAAAW9wpNadXp+jjP1qdDJBh9pKOdvfoYedGIXxNqE1WnbLI71SBSD
        byhO+/RaE0zLlJycrzo1EnIpMRkqJx2NzV6iCbc=
X-Google-Smtp-Source: APXvYqw/nADFw0RL43Leb02ZvzV/xWNuKEtGZvvPH7/ZeKECHxmnyAyLo2cc35XPOwrZkGE3ZTDhiWSNyTA0ZkoPfiA=
X-Received: by 2002:a2e:a311:: with SMTP id l17mr3127974lje.214.1565137419207;
 Tue, 06 Aug 2019 17:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190806174529.8341-1-sdf@google.com>
In-Reply-To: <20190806174529.8341-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Aug 2019 17:23:27 -0700
Message-ID: <CAADnVQK-TK1T+MQj21HMxS9+9GDx3HnQmPLxWET0paoo+V_5dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/3] selftests/bpf: switch test_progs back to stdio
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 10:45 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> I was looking into converting test_sockops* to test_progs framework
> and that requires using cgroup_helpers.c which rely on stdio/stderr.
> Let's use open_memstream to override stdout into buffer during
> subtests instead of custom test_{v,}printf wrappers. That lets
> us continue to use stdio in the subtests and dump it on failure
> if required.
>
> That would also fix bpf_find_map which currently uses printf to
> signal failure (missed during test_printf conversion).

Applied. Thanks
