Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9525B817
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 11:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbfGAJei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 05:34:38 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33947 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfGAJeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 05:34:37 -0400
Received: by mail-oi1-f195.google.com with SMTP id l12so9423926oil.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 02:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yBOQL4AlA49bjQlqErsbDODVihHA5ZvWVTU0xteZNjM=;
        b=sqgTYLC0jS+FvL1gHtpbAGC/SFNLb8Khi0zbul2zM9QIHbNFwew/u471bowmYEHrJl
         h9EbSGIU/HYDlTleHv41zX4llIzx9RUen1vqGxeiNDKti/EDzikPP22JI2xXk05nNpqv
         tdPXvDg2eEbYU9oP7lzvuB6AxCWLwVOrkGvHk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yBOQL4AlA49bjQlqErsbDODVihHA5ZvWVTU0xteZNjM=;
        b=ENSWOxXOUq5P4OcgNPQFf+gtmmi3CCYUTefXNjsvnuChRF7tVywVwAseRhpaTnJyCr
         AEqVsHCwCxNB+ZloZLEAnaDpkkmvWQ0ECdrMiO3nGSLGMfDbZkSnYPEIcWqbcm1n/VaC
         t4m568+FnRzNgJD8+dd3NHBzpKM08luPkkKlkMNz1pYO/MUmbPEc8GEdtPC/U0fED++U
         eJqZHMUWTiTOJ8VRCYb/VTqoUvdv/C2D5HBA/u3Ce2O/XPZa1dJ0sD4+F0ScS8GQ5Ce8
         yaniTRIGvHAE2int1QDYxlke/E1fud8u1OnWm+xMc5ayIN/GrCUl+i2Z9zsDEy7XsFse
         ddmA==
X-Gm-Message-State: APjAAAUUJsOZLx/Ge6TRHzPgsmT05TH65wW6QbwwXJ7cQddZsuOmDSFR
        JzAdGppGmfjvwXsqR/6EyGv2WkU/gCWHQOsAOAIyqhnqHuA=
X-Google-Smtp-Source: APXvYqwskeJabbHvnBxy9OrHFkf4zReo8vmmZTHqVVBtlsOL5J/ywx6cEEt9fZgNZ8oR/IU09XbV7Jctvx2AUgd5TkQ=
X-Received: by 2002:aca:ea0b:: with SMTP id i11mr5961615oih.102.1561973676792;
 Mon, 01 Jul 2019 02:34:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <CACAyw98RvDc+i3gpgnAtnM0ojAfQ-mHvzRXFRUcgkEPr3K4G-g@mail.gmail.com>
 <91C99EC0-C441-410E-A96F-D990045E4987@fb.com>
In-Reply-To: <91C99EC0-C441-410E-A96F-D990045E4987@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 1 Jul 2019 10:34:25 +0100
Message-ID: <CACAyw98VyM8a-h_8jtsNdF0KfK69-AxzRR4K28HVsyUecb0a5Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jann Horn <jannh@google.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 at 20:10, Song Liu <songliubraving@fb.com> wrote:
> There should be a master thread, no? Can we do that from the master threa=
d at
> the beginning of the execution?

Unfortunately, no. The Go runtime has no such concept. This is all
that is defined about program start up:

  https://golang.org/ref/spec#Program_initialization_and_execution

Salient section:

  Package initialization=E2=80=94variable initialization and the invocation=
 of init
  functions=E2=80=94happens in a single goroutine, sequentially, one packag=
e at
  a time. An init function may launch other goroutines, which can run
  concurrently with the initialization code. However, initialization always
  sequences the init functions: it will not invoke the next one until the
  previous one has returned.

This means that at the earliest possible moment for Go code to run,
the scheduler is already active with at least GOMAXPROCS threads.

--=20
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
