Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF54F136689
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgAJFVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:21:39 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38485 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgAJFVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:21:38 -0500
Received: by mail-lf1-f65.google.com with SMTP id r14so499965lfm.5;
        Thu, 09 Jan 2020 21:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eR5y3a3f3BPZsiatf03/jVe40cjOfydQRG1w0tgstds=;
        b=mL6fX4VbQ9AT2OvUpmn/xF6Pcy8oGO1g5nB9Dlef6P1VqWSThvNqlckEZwaEiFiRJF
         SUksoFZnrlpVnuou38VKOi6LVBKuPsm9KNdbYDhTEUblmgxlSpsFK8f8Ggvp2JSmVyg8
         gCo3z/NzF0fddG97IxqGMH8HGj63S4YOMQsqt0hTYh7f0OFj+uDOtQYK2e9QR8ZyLwaM
         F60aDw/Gkw6d+moK9Rx7sTRnCx7b+QVwhZVNMzSwWqB2aAcYas1oRHMmc4uirjgVCWA4
         NTkUtM7ScLKaExv2N5b3HsbVmWFt1WoSoMFtoSsk83p/q3fArxxBkxXe2kmgK3/88RCR
         msOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eR5y3a3f3BPZsiatf03/jVe40cjOfydQRG1w0tgstds=;
        b=a54ot/ohaZt5x1cLdgGwOJ9T5W13NsIN/YfHAgnV6RJ5/QyInSXxAmSbQzlNDB/je6
         DlrZi0EeuUu+5Qvy4LdCgNsTiqTRLrHeXBatKoeQfUjecWpp1kawXEBVIULAaiivuPUy
         tz02FcCGfjhWAgx12kJ0rudGobfqgmKuasK6AOoM+xCnVmqe+rpEsw3yr2RJDnMoTJYj
         nT2O4W+A4Pb60oBQ3P0wBal0iGNdZ/JBIfU7mKmRYzeMr3xHi0sFi8y1MtpdbGuB5sZX
         jR4ra8nzkO9iby8R+yJhfJRbtmhD2dYIA6VfnT8o7Ycaq18o2/bry4FsCLdil9FwSzTD
         woIA==
X-Gm-Message-State: APjAAAUSCmQ37dI0vadbED/tuHQMSYUY02twu+TpliORcaMs1xC4IIci
        QZ4W9fXK6ZT2U7yo4zRW/egGpseiuTYa77i+DQU=
X-Google-Smtp-Source: APXvYqxEo5ZLuiz8LGWn/f/QaQgj1iHRAq0+9hlBk//ELuOo8rHVV5wkJdZM+b9t8AqpPkZXEK5pLm7wcS5aLnfc/9A=
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr942142lfp.162.1578633696633;
 Thu, 09 Jan 2020 21:21:36 -0800 (PST)
MIME-Version: 1.0
References: <20200110034247.1220142-1-andriin@fb.com>
In-Reply-To: <20200110034247.1220142-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jan 2020 21:21:24 -0800
Message-ID: <CAADnVQJYw=_arNNWc_PBHK=WL9KwgHZqZ-92sH6RPA0sgr_wKw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: make bpf_map order and indices stable
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 7:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Currently, libbpf re-sorts bpf_map structs after all the maps are added and
> initialized, which might change their relative order and invalidate any
> bpf_map pointer or index taken before that. This is inconvenient and
> error-prone. For instance, it can cause .kconfig map index to point to a wrong
> map.
>
> Furthermore, libbpf itself doesn't rely on any specific ordering of bpf_maps,
> so it's just an unnecessary complication right now. This patch drops sorting
> of maps and makes their relative positions fixed. If efficient index is ever
> needed, it's better to have a separate array of pointers as a search index,
> instead of reordering bpf_map struct in-place. This will be less error-prone
> and will allow multiple independent orderings, if necessary (e.g., either by
> section index or by name).
>
> Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
> Reported-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
