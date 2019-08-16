Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F88FA3A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHPFIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:08:55 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35111 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPFIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:08:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id p197so3212661lfa.2;
        Thu, 15 Aug 2019 22:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6SC2HE4Qz0atBAfBNgG9UkV/smYkL/54apM6Bm++F0=;
        b=XstnF5PgUy7tEU9ReAhktiwVFaI18nlnGNzByJ+tiL2JZpfwqH+mkeqmLOp+A+sLfr
         ru9PVvfk60NJgdzGJ9fSJ7YYMNCt3OdZG7VWXGNYOjj0vYKknF4ZUmTwDwKfEvmRH1t3
         0pYMaO0090/Ti7t5uhFMlKSCLMkhV/UYVZey++Hsypd4ULOutTOl26GDE+nl9E6EP44U
         ANMf4DVc5B/hCop6+q92g3JGbzKUZTdxoecfK+QTjFVUUE3j9O2AhsDE5wkZU87SLbWp
         AYPpuJhMM1z2nVb7ByQacEKZ9vv8WzXG24/kR1YGcG1RT6eI3hKPoBkxKBe0cS5hwCi/
         t+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6SC2HE4Qz0atBAfBNgG9UkV/smYkL/54apM6Bm++F0=;
        b=mfm9w/1a0xmKTzSGvRI7K3eqS26XIuqGXWKl+UiDVKyxxmj7g8mAt44R8WLEwGNPHK
         ewfsIy9mS+1q0anLvjH2Bkwkm/Wc7/zHjauSeTejGrkq/TnJbnEDW9ecJyuRhX6C1ykT
         jiQKIz2gMmE9DLPGe75kRcNUwplWEV2qBWOFH+9b2KffLbcps4pETMiVj70cthREx2p6
         FFkvRhWJz//XLoLSDXp7rAd/6EN2Gr4J4CoPsOv+0Tp9+z4xXWhwWK3kLgIUr5qtoz3u
         3lcEKO0tJdZXQEiPI67TpFwz6b9xMzD1jWaqh1WkWiYq9yXyJ8iot1Lj6t0VXcWlh/Yd
         yg9Q==
X-Gm-Message-State: APjAAAUHeS7a9m1ZQlz+2GefiZMi9W5eQnoneagfe0y37n43/9B0yigx
        wT40iKPkcUUV4ARmxlroAQwUwZsGy03O8jOGL0I=
X-Google-Smtp-Source: APXvYqxhR3jp1qxnjxWEituGs+YrlqRegjMDIbYm+FXE5251atPUMkQAC9byLbOehFgPRUuDxu3WLavNR4aoAtcB+00=
X-Received: by 2002:a19:6450:: with SMTP id b16mr4302290lfj.15.1565932132520;
 Thu, 15 Aug 2019 22:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 22:08:41 -0700
Message-ID: <CAADnVQKpPaZ3wJJwSn=JPML9pWzwy_8G9c0H=ToaaxZEJ8isnQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/6] tools: bpftool: fix printf()-like functions
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 7:32 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> Hi,
> Because the "__printf()" attributes were used only where the functions are
> implemented, and not in header files, the checks have not been enforced on
> all the calls to printf()-like functions, and a number of errors slipped in
> bpftool over time.
>
> This set cleans up such errors, and then moves the "__printf()" attributes
> to header files, so that the checks are performed at all locations.

Applied. Thanks
