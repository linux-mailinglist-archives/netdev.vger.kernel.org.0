Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5450A237BC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfETNFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:05:37 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37450 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbfETNFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:05:37 -0400
Received: by mail-ot1-f66.google.com with SMTP id r10so12889691otd.4
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fAVIxDknqx6ca1SyGV6216ZOHWrFYpKDeFFRW/cro7o=;
        b=RA1VoWG2C3gZVfCeTyuP3z+JEUQURQI/pwSyzxkVYHVGngwJWsGeyhgxTKMHO4zOrw
         guO3xI1JMRZSCfNrueYq1D34wrlhAikUrdUSH7a+M5Vmanuj5Wtp6EfRSu+su/GQKTEZ
         etTt1qS3YtKdFPTY5baTx0SyS9CSz2vJ5a+5bU+mn0BDgur8Z/hnJFQPJxP4AfkQYMOz
         Kv8tckDR44KoxnP01hYSmmV+psWx/UFT9JZ9sN6Gr7h2z63lxjCF05TarqyN8YzjzIMK
         Zy0bkFOfdWfFW9zrwUf+GJvKUR53Q6B3lOoDxshSPGB9WimIjhptJ/J7fz31FOb0D9PW
         WemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fAVIxDknqx6ca1SyGV6216ZOHWrFYpKDeFFRW/cro7o=;
        b=jKyGpuIRISqqIfz8Um2tEurUOlPpMwF/DFK4pSi0zvjR0HcW/GnZJ9lSvrGxSB9pwE
         MDweza+68u92AvyuHXZT51SRchmkDdwj6gXeBQ9nWiJq4gUkBlJNAjwAmPMk8jV1x6FS
         f+n8URLnznRXVJd/tXHXK3OkaStz4noFgThqAvFaU/5GHiSB7Hh/szZqj0Gr+ENQT/nX
         HO4F7l1GVHHJhbNc/Hw/kHbT4hgVq/gm4P84OK09hKZwyJzVfjUO2vGyg+V9IXOJGZnp
         osv6611lC9Ly9sMlpTkcIxxTxSnrW2RLVS/EHs7Wq3Px2pX4LvgTFa9W/TSBw3N1NqHt
         /rFg==
X-Gm-Message-State: APjAAAV1gs4cJ4B6h11Bcy2e41agPMduSpeFmhM9TeAtR7F9fUm/hpiz
        SMJycU84i6ZGhi2eMySppvJtXw8qND8f0dDUNnmwPg==
X-Google-Smtp-Source: APXvYqyVj8BUxJtjK0mPxlPktuJUTwAcAX+YEsilYKJ6pUWWizmQyhHZYbQOrH71foLS0JKkMzAiBXBUdtr9cGJkWP0=
X-Received: by 2002:a9d:6a4e:: with SMTP id h14mr26998000otn.216.1558357536823;
 Mon, 20 May 2019 06:05:36 -0700 (PDT)
MIME-Version: 1.0
References: <fb92be6e671450d181f552c883feae849f840283.1558345901.git.pabeni@redhat.com>
In-Reply-To: <fb92be6e671450d181f552c883feae849f840283.1558345901.git.pabeni@redhat.com>
From:   Roman Mashak <mrv@mojatatu.com>
Date:   Mon, 20 May 2019 09:05:28 -0400
Message-ID: <CAHvchGmJCh7uzzqhHbPZH5A2r_H1PaX_OxxgAoTvqDNPKk3Z-A@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2] m_mirred: don't bail if the control action is missing
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Phil Sutter <phil@nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 5:58 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> The mirred act admits an optional control action, defaulting
> to TC_ACT_PIPE. The parsing code currently emits an error message
> if the control action is not provided on the command line, even
> if the command itself completes with no error.
>
> This change shuts down the error message, using the appropriate
> parsing helper.
>

[...]

Paolo, could you also update the relevant tdc mirred test once this
patch is accepted? Thank you.
