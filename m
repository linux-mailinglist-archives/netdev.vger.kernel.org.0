Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0103B7554B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfGYRUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:20:15 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33828 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfGYRUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:20:15 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so48766366ljg.1;
        Thu, 25 Jul 2019 10:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H6ajxMgP/KB6V6r/vP7tn1rq4CeSerukowp5flf1iu4=;
        b=rKutcTOdq+wY0CZz2oEGgs8ubO4+JO+jgIYGUXcOoBq92E6MdV7w+1xu2ltYDVYIPx
         FdQ+Vb2o8P4wbHXRWrrm+UfwMWexo3QEqP7HcqUXBd4sJB9cuyBJZM2Hj8BU/RPUoBg9
         iAxKTyMeZFX4MJXYpOd+CYRHXAVD7QDWXs8ixuh+WzhwF149MmE/uCUT0brQJv1pXjAa
         W1OaistkMweFRzm4qdztl4/XAoDwG2naGAsFdlyM53JXr9Jr1c/bvASI9VyiUmpT1BsJ
         bFDa34yOe9DSDO5tXAjD1RgEPkn8bcRSqH3zI0lMxn6X3Z57YrWojq4J1VAJgTWoUyct
         S8tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H6ajxMgP/KB6V6r/vP7tn1rq4CeSerukowp5flf1iu4=;
        b=N7zzB795uwHxzgKDiw8UJltS6vw3cLM+2QgHmNOzDRpxSO+Fkaq/meW6VO9EtmMIlv
         o3yucOU9T3cU2kwcrw2qExrEjIxNYJIUgh4YBAIHgG2j4uciY1ndM23f7EqRSaQr/kzG
         ZyvPIOCWTF4OAcjuPk1Gt7QReZfcAJMXM09pROip/jnMNzJ+ES6+RCCySxzF9L2nZkGl
         PJMShdyr2kRx31NhokTElUmVI8YXZImq82oqv8Ofb8KuvIthQmriCMs8icm2d41ZEi+D
         6hid8nyKWXVTDCXOTfGZAh9oUAR04iONfwD5c5mdqhCt1/pOQEsjvn+WOUVzaoUTRg+b
         x2mg==
X-Gm-Message-State: APjAAAVygoSPqdqExlsqRdkm/gTK/k11Qpjo9msdhv81pDjcaPVeBIxC
        p9B1EqE16EOA48R9YOUrxrwIQLGamzfHsYd13Eo=
X-Google-Smtp-Source: APXvYqxGyXSBO+lC4bS6En4vU1YXIJJrXrJFXDtr1NH9WQ/Yi/uFGAf4JOFnB/OfqIY7dPyMSgdmlM/NCfxDf1Hkp1Q=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr46046019ljj.17.1564074910356;
 Thu, 25 Jul 2019 10:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190724214753.1816451-1-andriin@fb.com>
In-Reply-To: <20190724214753.1816451-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Jul 2019 10:14:59 -0700
Message-ID: <CAADnVQKeWVZNVTGCfpn=-hOvkwbStxb14hNANi5O_eet5MuU2A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf] libbpf: silence GCC8 warning about string truncation
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Despite a proper NULL-termination after strncpy(..., ..., IFNAMSIZ - 1),
> GCC8 still complains about *expected* string truncation:
>
>   xsk.c:330:2: error: 'strncpy' output may be truncated copying 15 bytes
>   from a string of length 15 [-Werror=stringop-truncation]
>     strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>
> This patch gets rid of the issue altogether by using memcpy instead.
> There is no performance regression, as strncpy will still copy and fill
> all of the bytes anyway.
>
> v1->v2:
> - rebase against bpf tree.
>
> Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Applied. Thanks
