Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E248FA41
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfHPFLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:11:31 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33312 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfHPFLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:11:31 -0400
Received: by mail-lj1-f194.google.com with SMTP id z17so4226332ljz.0;
        Thu, 15 Aug 2019 22:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9OS0YFkHTlYgwgwLqbVPSNI5bzxaRSqGXAgtTQALTPs=;
        b=Kbf7NFyvxyuyfhCHFzZ+BHYtHQDZRCmcG0moHuzHD74FrbVgeCHI6zx9vJs1XG14N1
         j+2JF/E3RFqfLSbBGTYG0iPlfay0X1KkpLslHUIkRFoEn4igrlwciSLuG0zEkTLXuHRi
         gtds5rDZcMiBcdqR55bmU/4GJaF4HDrL66IpxtOflmpggCXAPH0lcMQmzfNgckiVSnWP
         OUHn6TtHICf128w02hCEDiILcpzaUX0uhEMKX6VW2ErxuJ7gqdffmKAjYYrvrZlImBef
         k9LwU4mjjGbhBzqXY1QqpN6Vg28LS+2uRnA9qt8mFAKckIqt2Cp3YLleURaAazz23f+R
         WuwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9OS0YFkHTlYgwgwLqbVPSNI5bzxaRSqGXAgtTQALTPs=;
        b=bWYuRDHv9HTo+1aXFJ1ZUXUxziX1oCKxGK7Ivvn7XzEbeCq5nM1404dv1qxQRDupSL
         uw3SCxhFS2v54vCNl51zsLGV9QdR9KoFXMSW1zSmFYxa2sQfwntJMC7Z6lw9tSk4/k0R
         zjYlSUGEqnV00Av1jDeYDnLgr8JlIfyhj70df4CSl5cblSW+W3gWWFVG/w4zpIG6B+/n
         RVSaJZN6YSYI8nJex3Q5MFrdeOdUOMqdWWBz4ijigzBAHSlhQb9CTxtB/W9dESIfKjEf
         snwuerrnUXsCYVDDGWyFT4PKL+fkpt4KI0FqW3E08Re7up7lrngSfKCUfdJ2mlO1frC3
         wyYg==
X-Gm-Message-State: APjAAAVDPacgj4ppBccIvsjXlcQNbnWO7y1jSt+ObkF7tzIhvAC8TdQC
        zjhEd+zZbLY5ACELpVN1hr9QMN55ehhsmjvZ50s=
X-Google-Smtp-Source: APXvYqwFUAv5CSR0zV3W0OETfHmtP4grYRaoGqW5YqbisbH0Dk24aD4Ni/zaVeWZj6yKwb2+D6Jw+16iiFXmPO/THzU=
X-Received: by 2002:a2e:89da:: with SMTP id c26mr3870169ljk.214.1565932288928;
 Thu, 15 Aug 2019 22:11:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190815142223.2203-1-quentin.monnet@netronome.com>
In-Reply-To: <20190815142223.2203-1-quentin.monnet@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Aug 2019 22:11:17 -0700
Message-ID: <CAADnVQL=cLxe5kniYkUarHKPGZxrM3cstaiqAXqnifOGAsgX8w@mail.gmail.com>
Subject: Re: [PATCH bpf] tools: bpftool: close prog FD before exit on showing
 a single program
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

On Thu, Aug 15, 2019 at 7:22 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> When showing metadata about a single program by invoking
> "bpftool prog show PROG", the file descriptor referring to the program
> is not closed before returning from the function. Let's close it.
>
> Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied. Thanks
