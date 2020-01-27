Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B089314A45E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgA0NBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:01:07 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35848 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0NBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:01:07 -0500
Received: by mail-lf1-f65.google.com with SMTP id f24so6131346lfh.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=56+J5cIzO/HEZ3g1vNJEnErUzmgJTqUDxjwesQXEzIo=;
        b=ttIP3YTpDOShSPys4IVs5UuwfuFi3dWkUO7TodM8qjGCE1nYcl3cFaV2URAFD+JOo2
         pOnpBdqcT7+5fBg5NheUdlj5iWxB8c6eF2ugBLLlfk2jEct69UEZ6wHi3ZOVevX7UH/m
         u3HS+Oi/U3b+GthBxBzAmjLt8o+vB17r+y8lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=56+J5cIzO/HEZ3g1vNJEnErUzmgJTqUDxjwesQXEzIo=;
        b=FhMO+PGd3c+V5x7UX4tLenkGA6Uk4RXDVzihKm158fKKnU2jf0jWRUUszmpRMqJueL
         c6oAYHjJZZPQI6B23KgZ1laEO5mE2iSa3ypLgpfAzAt/wzOblxfx7Be52JuU32FtaCnw
         vN0dyn7eJqeCXcZZwUhFZZOPuxugWI0KaI9UgTxE7LywC+vrRtKNZSKaiEXg9cmP3kNC
         90GRh47uMDnUAEtcUoFVSeRw4zRucUNMWoX4dvKumBQItZoxJNSZFb4KPyN7Biv6cFqR
         rtqef4na6NGrPqXv7hVYB5NYPyp0/YVTUBiPE3Ovs9TMzIacNIk4WMl/NSu9fWMdiEHh
         d5JA==
X-Gm-Message-State: APjAAAX8/xuzWAq6sVA0pTnD5VWsw0hRFB7OP9VXqK2bfwkpZbyckUSq
        Ix2aKZf17PpgWugAXBVjRGb/8g==
X-Google-Smtp-Source: APXvYqyMOJ6I4Hs85xIkf63tqrdh/5Q9W43SnodSZMkHn+4BfKchKgqmW5fkqZPgflReNenTVB5NtA==
X-Received: by 2002:a19:ca59:: with SMTP id h25mr8011595lfj.27.1580130065573;
        Mon, 27 Jan 2020 05:01:05 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i1sm8099259lji.71.2020.01.27.05.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:01:05 -0800 (PST)
References: <20200127125534.137492-1-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v5 00/12] Extend SOCKMAP to store listening sockets
In-reply-to: <20200127125534.137492-1-jakub@cloudflare.com>
Date:   Mon, 27 Jan 2020 14:01:03 +0100
Message-ID: <87eevlcauo.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 01:55 PM CET, Jakub Sitnicki wrote:
> Make SOCKMAP a generic collection for listening as well as established
> sockets. This lets us use SOCKMAP BPF maps with reuseport BPF programs.
>
> The biggest advantage of SOCKMAP over REUSEPORT_SOCKARRAY is that the
> former allows the socket can be in more than one map at the same time.
> However, until SOCKMAP gets extended to work with UDP, it is not a drop in
> replacement for REUSEPORT_SOCKARRAY.
>
> Having a BPF map type that can hold listening sockets, and can gracefully
> co-exist with reuseport BPF is important if, in the future, we want to have
> BPF programs that run at socket lookup time [0]. Cover letter for v1 of
> this series tells the full background story of how we got here [1].
>
> v5 is a rebase onto recent bpf-next. Patches 1 & 2 has conflicts. I carried
> over the Acks.

Should be: "Patches 1 & 2 *had* conflicts". Sorry for the typo :-)

[...]
